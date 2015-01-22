From: akpm@linux-foundation.org
Subject: +
 mm-gup-add-get_user_pages_locked-and-get_user_pages_unlocked.patch added to -mm tree
Date: Thu, 22 Jan 2015 15:12:10 -0800
Message-ID: <54c183ca.NIIPPk6tu4LytdyF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbbAVXM2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jan 2015 18:12:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, pfeiner@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: gup: add get_user_pages_locked and get_user_pages_unlocked
has been added to the -mm tree.  Its filename is
     mm-gup-add-get_user_pages_locked-and-get_user_pages_unlocked.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-add-get_user_pages_locked-and-get_user_pages_unlocked.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-add-get_user_pages_locked-and-get_user_pages_unlocked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: gup: add get_user_pages_locked and get_user_pages_unlocked

FAULT_FOLL_ALLOW_RETRY allows the page fault to drop the mmap_sem for
reading to reduce the mmap_sem contention (for writing), like while
waiting for I/O completion.  The problem is that right now practically no
get_user_pages call uses FAULT_FOLL_ALLOW_RETRY, so we're not leveraging
that nifty feature.

Andres fixed it for the KVM page fault.  However get_user_pages_fast
remains uncovered, and 99% of other get_user_pages aren't using it either
(the only exception being FOLL_NOWAIT in KVM which is really nonblocking
and in fact it doesn't even release the mmap_sem).

So this patchsets extends the optimization Andres did in the KVM page
fault to the whole kernel.  It makes most important places (including
gup_fast) to use FAULT_FOLL_ALLOW_RETRY to reduce the mmap_sem hold times
during I/O.

The only few places that remains uncovered are drivers like v4l and other
exceptions that tends to work on their own memory and they're not working
on random user memory (for example like O_DIRECT that uses gup_fast and is
fully covered by this patch).

A follow up patch should probably also add a printk_once warning to
get_user_pages that should go obsolete and be phased out eventually.  The
"vmas" parameter of get_user_pages makes it fundamentally incompatible
with FAULT_FOLL_ALLOW_RETRY (vmas array becomes meaningless the moment the
mmap_sem is released).  

While this is just an optimization, this becomes an absolute requirement
for the userfaultfd feature http://lwn.net/Articles/615086/ .

The userfaultfd allows to block the page fault, and in order to do so I
need to drop the mmap_sem first.  So this patch also ensures that all
memory where userfaultfd could be registered by KVM, the very first fault
(no matter if it is a regular page fault, or a get_user_pages) always has
FAULT_FOLL_ALLOW_RETRY set.  Then the userfaultfd blocks and it is waken
only when the pagetable is already mapped.  The second fault attempt after
the wakeup doesn't need FAULT_FOLL_ALLOW_RETRY, so it's ok to retry
without it.



This patch (of 5):

We can leverage the VM_FAULT_RETRY functionality in the page fault paths
better by using either get_user_pages_locked or get_user_pages_unlocked.

The former allows conversion of get_user_pages invocations that will have
to pass a "&locked" parameter to know if the mmap_sem was dropped during
the call.  Example from:

    down_read(&mm->mmap_sem);
    do_something()
    get_user_pages(tsk, mm, ..., pages, NULL);
    up_read(&mm->mmap_sem);

to:

    int locked = 1;
    down_read(&mm->mmap_sem);
    do_something()
    get_user_pages_locked(tsk, mm, ..., pages, &locked);
    if (locked)
        up_read(&mm->mmap_sem);

The latter is suitable only as a drop in replacement of the form:

    down_read(&mm->mmap_sem);
    get_user_pages(tsk, mm, ..., pages, NULL);
    up_read(&mm->mmap_sem);

into:

    get_user_pages_unlocked(tsk, mm, ..., pages);

Where tsk, mm, the intermediate "..." paramters and "pages" can be any
value as before.  Just the last parameter of get_user_pages (vmas) must be
NULL for get_user_pages_locked|unlocked to be usable (the latter original
form wouldn't have been safe anyway if vmas wasn't null, for the former we
just make it explicit by dropping the parameter).

If vmas is not NULL these two methods cannot be used.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Andres Lagar-Cavilla <andreslc@google.com>
Reviewed-by: Peter Feiner <pfeiner@google.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    7 +
 mm/gup.c           |  177 ++++++++++++++++++++++++++++++++++++++++---
 mm/nommu.c         |   23 +++++
 3 files changed, 196 insertions(+), 11 deletions(-)

diff -puN include/linux/mm.h~mm-gup-add-get_user_pages_locked-and-get_user_pages_unlocked include/linux/mm.h
--- a/include/linux/mm.h~mm-gup-add-get_user_pages_locked-and-get_user_pages_unlocked
+++ a/include/linux/mm.h
@@ -1252,6 +1252,13 @@ long get_user_pages(struct task_struct *
 		    unsigned long start, unsigned long nr_pages,
 		    int write, int force, struct page **pages,
 		    struct vm_area_struct **vmas);
+long get_user_pages_locked(struct task_struct *tsk, struct mm_struct *mm,
+		    unsigned long start, unsigned long nr_pages,
+		    int write, int force, struct page **pages,
+		    int *locked);
+long get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
+		    unsigned long start, unsigned long nr_pages,
+		    int write, int force, struct page **pages);
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
 struct kvec;
diff -puN mm/gup.c~mm-gup-add-get_user_pages_locked-and-get_user_pages_unlocked mm/gup.c
--- a/mm/gup.c~mm-gup-add-get_user_pages_locked-and-get_user_pages_unlocked
+++ a/mm/gup.c
@@ -575,6 +575,165 @@ int fixup_user_fault(struct task_struct
 	return 0;
 }
 
+static __always_inline long __get_user_pages_locked(struct task_struct *tsk,
+						struct mm_struct *mm,
+						unsigned long start,
+						unsigned long nr_pages,
+						int write, int force,
+						struct page **pages,
+						struct vm_area_struct **vmas,
+						int *locked, bool notify_drop)
+{
+	int flags = FOLL_TOUCH;
+	long ret, pages_done;
+	bool lock_dropped;
+
+	if (locked) {
+		/* if VM_FAULT_RETRY can be returned, vmas become invalid */
+		BUG_ON(vmas);
+		/* check caller initialized locked */
+		BUG_ON(*locked != 1);
+	}
+
+	if (pages)
+		flags |= FOLL_GET;
+	if (write)
+		flags |= FOLL_WRITE;
+	if (force)
+		flags |= FOLL_FORCE;
+
+	pages_done = 0;
+	lock_dropped = false;
+	for (;;) {
+		ret = __get_user_pages(tsk, mm, start, nr_pages, flags, pages,
+				       vmas, locked);
+		if (!locked)
+			/* VM_FAULT_RETRY couldn't trigger, bypass */
+			return ret;
+
+		/* VM_FAULT_RETRY cannot return errors */
+		if (!*locked) {
+			BUG_ON(ret < 0);
+			BUG_ON(ret >= nr_pages);
+		}
+
+		if (!pages)
+			/* If it's a prefault don't insist harder */
+			return ret;
+
+		if (ret > 0) {
+			nr_pages -= ret;
+			pages_done += ret;
+			if (!nr_pages)
+				break;
+		}
+		if (*locked) {
+			/* VM_FAULT_RETRY didn't trigger */
+			if (!pages_done)
+				pages_done = ret;
+			break;
+		}
+		/* VM_FAULT_RETRY triggered, so seek to the faulting offset */
+		pages += ret;
+		start += ret << PAGE_SHIFT;
+
+		/*
+		 * Repeat on the address that fired VM_FAULT_RETRY
+		 * without FAULT_FLAG_ALLOW_RETRY but with
+		 * FAULT_FLAG_TRIED.
+		 */
+		*locked = 1;
+		lock_dropped = true;
+		down_read(&mm->mmap_sem);
+		ret = __get_user_pages(tsk, mm, start, 1, flags | FOLL_TRIED,
+				       pages, NULL, NULL);
+		if (ret != 1) {
+			BUG_ON(ret > 1);
+			if (!pages_done)
+				pages_done = ret;
+			break;
+		}
+		nr_pages--;
+		pages_done++;
+		if (!nr_pages)
+			break;
+		pages++;
+		start += PAGE_SIZE;
+	}
+	if (notify_drop && lock_dropped && *locked) {
+		/*
+		 * We must let the caller know we temporarily dropped the lock
+		 * and so the critical section protected by it was lost.
+		 */
+		up_read(&mm->mmap_sem);
+		*locked = 0;
+	}
+	return pages_done;
+}
+
+/*
+ * We can leverage the VM_FAULT_RETRY functionality in the page fault
+ * paths better by using either get_user_pages_locked() or
+ * get_user_pages_unlocked().
+ *
+ * get_user_pages_locked() is suitable to replace the form:
+ *
+ *      down_read(&mm->mmap_sem);
+ *      do_something()
+ *      get_user_pages(tsk, mm, ..., pages, NULL);
+ *      up_read(&mm->mmap_sem);
+ *
+ *  to:
+ *
+ *      int locked = 1;
+ *      down_read(&mm->mmap_sem);
+ *      do_something()
+ *      get_user_pages_locked(tsk, mm, ..., pages, &locked);
+ *      if (locked)
+ *          up_read(&mm->mmap_sem);
+ */
+long get_user_pages_locked(struct task_struct *tsk, struct mm_struct *mm,
+			   unsigned long start, unsigned long nr_pages,
+			   int write, int force, struct page **pages,
+			   int *locked)
+{
+	return __get_user_pages_locked(tsk, mm, start, nr_pages, write, force,
+				       pages, NULL, locked, true);
+}
+EXPORT_SYMBOL(get_user_pages_locked);
+
+/*
+ * get_user_pages_unlocked() is suitable to replace the form:
+ *
+ *      down_read(&mm->mmap_sem);
+ *      get_user_pages(tsk, mm, ..., pages, NULL);
+ *      up_read(&mm->mmap_sem);
+ *
+ *  with:
+ *
+ *      get_user_pages_unlocked(tsk, mm, ..., pages);
+ *
+ * It is functionally equivalent to get_user_pages_fast so
+ * get_user_pages_fast should be used instead, if the two parameters
+ * "tsk" and "mm" are respectively equal to current and current->mm,
+ * or if "force" shall be set to 1 (get_user_pages_fast misses the
+ * "force" parameter).
+ */
+long get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
+			     unsigned long start, unsigned long nr_pages,
+			     int write, int force, struct page **pages)
+{
+	long ret;
+	int locked = 1;
+	down_read(&mm->mmap_sem);
+	ret = __get_user_pages_locked(tsk, mm, start, nr_pages, write, force,
+				      pages, NULL, &locked, false);
+	if (locked)
+		up_read(&mm->mmap_sem);
+	return ret;
+}
+EXPORT_SYMBOL(get_user_pages_unlocked);
+
 /*
  * get_user_pages() - pin user pages in memory
  * @tsk:	the task_struct to use for page fault accounting, or
@@ -624,22 +783,18 @@ int fixup_user_fault(struct task_struct
  * use the correct cache flushing APIs.
  *
  * See also get_user_pages_fast, for performance critical applications.
+ *
+ * get_user_pages should be phased out in favor of
+ * get_user_pages_locked|unlocked or get_user_pages_fast. Nothing
+ * should use get_user_pages because it cannot pass
+ * FAULT_FLAG_ALLOW_RETRY to handle_mm_fault.
  */
 long get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		unsigned long start, unsigned long nr_pages, int write,
 		int force, struct page **pages, struct vm_area_struct **vmas)
 {
-	int flags = FOLL_TOUCH;
-
-	if (pages)
-		flags |= FOLL_GET;
-	if (write)
-		flags |= FOLL_WRITE;
-	if (force)
-		flags |= FOLL_FORCE;
-
-	return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas,
-				NULL);
+	return __get_user_pages_locked(tsk, mm, start, nr_pages, write, force,
+				       pages, vmas, NULL, false);
 }
 EXPORT_SYMBOL(get_user_pages);
 
diff -puN mm/nommu.c~mm-gup-add-get_user_pages_locked-and-get_user_pages_unlocked mm/nommu.c
--- a/mm/nommu.c~mm-gup-add-get_user_pages_locked-and-get_user_pages_unlocked
+++ a/mm/nommu.c
@@ -213,6 +213,29 @@ long get_user_pages(struct task_struct *
 }
 EXPORT_SYMBOL(get_user_pages);
 
+long get_user_pages_locked(struct task_struct *tsk, struct mm_struct *mm,
+			   unsigned long start, unsigned long nr_pages,
+			   int write, int force, struct page **pages,
+			   int *locked)
+{
+	return get_user_pages(tsk, mm, start, nr_pages, write, force,
+			      pages, NULL);
+}
+EXPORT_SYMBOL(get_user_pages_locked);
+
+long get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
+			     unsigned long start, unsigned long nr_pages,
+			     int write, int force, struct page **pages)
+{
+	long ret;
+	down_read(&mm->mmap_sem);
+	ret = get_user_pages(tsk, mm, start, nr_pages, write, force,
+			     pages, NULL);
+	up_read(&mm->mmap_sem);
+	return ret;
+}
+EXPORT_SYMBOL(get_user_pages_unlocked);
+
 /**
  * follow_pfn - look up PFN at a user virtual address
  * @vma: memory mapping
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
mm-page_allocc-drop-dead-destroy_compound_page.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch
mm-thp-allocate-transparent-hugepages-on-local-node.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
mm-gup-add-get_user_pages_locked-and-get_user_pages_unlocked.patch
mm-gup-add-__get_user_pages_unlocked-to-customize-gup_flags.patch
mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast.patch
mm-gup-use-get_user_pages_unlocked.patch
mm-gup-kvm-use-get_user_pages_unlocked.patch


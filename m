From: akpm@linux-foundation.org
Subject: + mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young.patch added to -mm tree
Date: Thu, 21 Jul 2011 15:36:25 -0700
Message-ID: <201107212236.p6LMaPLx013347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382Ab1GUWgi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jul 2011 18:36:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, David.Laight@ACULAB.COM, a.p.zijlstra@chello.nl, darren.hart@intel.com, haishan.bai@gmail.com


The patch titled
     mm/futex: fix futex writes on archs with SW tracking of dirty & young
has been added to the -mm tree.  Its filename is
     mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/futex: fix futex writes on archs with SW tracking of dirty & young
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

The futex code currently attempts to write to user memory within a
pagefault disabled section, and if that fails, tries to fix it up using
get_user_pages().

This doesn't work on archs where the dirty and young bits are maintained
by software, since they will gate access permission in the TLB, and will
not be updated by gup().

In addition, there's an expectation on some archs that a spurious write
fault triggers a local TLB flush, and that is missing from the picture as
well.

I decided that adding those "features" to gup() would be too much for this
already too complex function, and instead added a new simpler
fixup_user_fault() which is essentially a wrapper around handle_mm_fault()
which the futex code can call.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reported-by: Shan Hai <haishan.bai@gmail.com>
Tested-by: Shan Hai <haishan.bai@gmail.com>
Cc: "David Laight" <David.Laight@ACULAB.COM>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Darren Hart <darren.hart@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +
 kernel/futex.c     |    4 +-
 mm/memory.c        |   59 ++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 62 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young include/linux/mm.h
--- a/include/linux/mm.h~mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young
+++ a/include/linux/mm.h
@@ -987,6 +987,8 @@ int get_user_pages(struct task_struct *t
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
 struct page *get_dump_page(unsigned long addr);
+extern int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
+			    unsigned long address, unsigned int fault_flags);
 
 extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
 extern void do_invalidatepage(struct page *page, unsigned long offset);
diff -puN kernel/futex.c~mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young kernel/futex.c
--- a/kernel/futex.c~mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young
+++ a/kernel/futex.c
@@ -355,8 +355,8 @@ static int fault_in_user_writeable(u32 _
 	int ret;
 
 	down_read(&mm->mmap_sem);
-	ret = get_user_pages(current, mm, (unsigned long)uaddr,
-			     1, 1, 0, NULL, NULL);
+	ret = fixup_user_fault(current, mm, (unsigned long)uaddr,
+			       FAULT_FLAG_WRITE);
 	up_read(&mm->mmap_sem);
 
 	return ret < 0 ? ret : 0;
diff -puN mm/memory.c~mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young mm/memory.c
--- a/mm/memory.c~mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young
+++ a/mm/memory.c
@@ -1805,7 +1805,64 @@ next_page:
 }
 EXPORT_SYMBOL(__get_user_pages);
 
-/**
+/*
+ * fixup_user_fault() - manually resolve a user page  fault
+ * @tsk:	the task_struct to use for page fault accounting, or
+ *		NULL if faults are not to be recorded.
+ * @mm:		mm_struct of target mm
+ * @address:	user address
+ * @fault_flags:flags to pass down to handle_mm_fault()
+ *
+ * This is meant to be called in the specific scenario where for
+ * locking reasons we try to access user memory in atomic context
+ * (within a pagefault_disable() section), this returns -EFAULT,
+ * and we want to resolve the user fault before trying again.
+ *
+ * Typically this is meant to be used by the futex code.
+ *
+ * The main difference with get_user_pages() is that this function
+ * will unconditionally call handle_mm_fault() which will in turn
+ * perform all the necessary SW fixup of the dirty and young bits
+ * in the PTE, while handle_mm_fault() only guarantees to update
+ * these in the struct page.
+ *
+ * This is important for some architectures where those bits also
+ * gate the access permission to the page because their are
+ * maintained in software. On such architecture, gup() will not
+ * be enough to make a subsequent access succeed.
+ *
+ * This should be called with the mm_sem held for read.
+ */
+int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
+		     unsigned long address, unsigned int fault_flags)
+{
+	struct vm_area_struct *vma;
+	int ret;
+
+	vma = find_extend_vma(mm, address);
+	if (!vma || address < vma->vm_start)
+		return -EFAULT;
+	
+	ret = handle_mm_fault(mm, vma, address, fault_flags);
+	if (ret & VM_FAULT_ERROR) {
+		if (ret & VM_FAULT_OOM)
+			return -ENOMEM;
+		if (ret & (VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE))
+			return -EHWPOISON;
+		if (ret & VM_FAULT_SIGBUS)
+			return -EFAULT;
+		BUG();
+	}
+	if (tsk) {
+		if (ret & VM_FAULT_MAJOR)
+			tsk->maj_flt++;
+		else
+			tsk->min_flt++;
+	}
+	return 0;
+}
+
+/*
  * get_user_pages() - pin user pages in memory
  * @tsk:	the task_struct to use for page fault accounting, or
  *		NULL if faults are not to be recorded.
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
linux-next.patch
cross-memory-attach-v3.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-checkpatch-fixes.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix.patch
fault-injection-notifier-error-injection.patch
cpu-cpu-notifier-error-injection.patch
pm-pm-notifier-error-injection.patch
memory-memory-notifier-error-injection.patch
powerpc-pseries-reconfig-notifier-error-injection.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


From: akpm@linux-foundation.org
Subject: [merged] mm-unexport-__get_user_pages_unlocked.patch removed from -mm tree
Date: Thu, 15 Dec 2016 10:47:12 -0800
Message-ID: <5852e530.U2Kias3qwMpQ4fDO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48932 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756325AbcLOSrN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:47:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lstoakes@gmail.com, dave.hansen@linux.intel.com, hughd@google.com, jack@suse.cz, mgorman@techsingularity.net, mhocko@suse.com, pbonzini@redhat.com, riel@redhat.com, rkrcmar@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unexport __get_user_pages_unlocked()
has been removed from the -mm tree.  Its filename was
     mm-unexport-__get_user_pages_unlocked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: unexport __get_user_pages_unlocked()

Unexport the low-level __get_user_pages_unlocked() function and replaces
invocations with calls to more appropriate higher-level functions.

In hva_to_pfn_slow() we are able to replace __get_user_pages_unlocked()
with get_user_pages_unlocked() since we can now pass gup_flags.

In async_pf_execute() and process_vm_rw_single_vec() we need to pass
different tsk, mm arguments so get_user_pages_remote() is the sane
replacement in these cases (having added manual acquisition and release of
mmap_sem.)

Additionally get_user_pages_remote() reintroduces use of the FOLL_TOUCH
flag.  However, this flag was originally silently dropped by 1e9877902dc7e
("mm/gup: Introduce get_user_pages_remote()"), so this appears to have
been unintentional and reintroducing it is therefore not an issue.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/20161027095141.2569-3-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krcmar <rkrcmar@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h     |    3 ---
 mm/gup.c               |    8 ++++----
 mm/nommu.c             |    8 ++++----
 mm/process_vm_access.c |   12 ++++++++----
 virt/kvm/async_pf.c    |   10 +++++++---
 virt/kvm/kvm_main.c    |    5 ++---
 6 files changed, 25 insertions(+), 21 deletions(-)

diff -puN include/linux/mm.h~mm-unexport-__get_user_pages_unlocked include/linux/mm.h
--- a/include/linux/mm.h~mm-unexport-__get_user_pages_unlocked
+++ a/include/linux/mm.h
@@ -1280,9 +1280,6 @@ long get_user_pages(unsigned long start,
 			    struct vm_area_struct **vmas);
 long get_user_pages_locked(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages, int *locked);
-long __get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
-			       unsigned long start, unsigned long nr_pages,
-			       struct page **pages, unsigned int gup_flags);
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 		    struct page **pages, unsigned int gup_flags);
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
diff -puN mm/gup.c~mm-unexport-__get_user_pages_unlocked mm/gup.c
--- a/mm/gup.c~mm-unexport-__get_user_pages_unlocked
+++ a/mm/gup.c
@@ -865,9 +865,10 @@ EXPORT_SYMBOL(get_user_pages_locked);
  * caller if required (just like with __get_user_pages). "FOLL_GET"
  * is set implicitly if "pages" is non-NULL.
  */
-__always_inline long __get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
-					       unsigned long start, unsigned long nr_pages,
-					       struct page **pages, unsigned int gup_flags)
+static __always_inline long __get_user_pages_unlocked(struct task_struct *tsk,
+		struct mm_struct *mm, unsigned long start,
+		unsigned long nr_pages, struct page **pages,
+		unsigned int gup_flags)
 {
 	long ret;
 	int locked = 1;
@@ -879,7 +880,6 @@ __always_inline long __get_user_pages_un
 		up_read(&mm->mmap_sem);
 	return ret;
 }
-EXPORT_SYMBOL(__get_user_pages_unlocked);
 
 /*
  * get_user_pages_unlocked() is suitable to replace the form:
diff -puN mm/nommu.c~mm-unexport-__get_user_pages_unlocked mm/nommu.c
--- a/mm/nommu.c~mm-unexport-__get_user_pages_unlocked
+++ a/mm/nommu.c
@@ -176,9 +176,10 @@ long get_user_pages_locked(unsigned long
 }
 EXPORT_SYMBOL(get_user_pages_locked);
 
-long __get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
-			       unsigned long start, unsigned long nr_pages,
-			       struct page **pages, unsigned int gup_flags)
+static long __get_user_pages_unlocked(struct task_struct *tsk,
+			struct mm_struct *mm, unsigned long start,
+			unsigned long nr_pages, struct page **pages,
+			unsigned int gup_flags)
 {
 	long ret;
 	down_read(&mm->mmap_sem);
@@ -187,7 +188,6 @@ long __get_user_pages_unlocked(struct ta
 	up_read(&mm->mmap_sem);
 	return ret;
 }
-EXPORT_SYMBOL(__get_user_pages_unlocked);
 
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 			     struct page **pages, unsigned int gup_flags)
diff -puN mm/process_vm_access.c~mm-unexport-__get_user_pages_unlocked mm/process_vm_access.c
--- a/mm/process_vm_access.c~mm-unexport-__get_user_pages_unlocked
+++ a/mm/process_vm_access.c
@@ -88,7 +88,7 @@ static int process_vm_rw_single_vec(unsi
 	ssize_t rc = 0;
 	unsigned long max_pages_per_loop = PVM_MAX_KMALLOC_PAGES
 		/ sizeof(struct pages *);
-	unsigned int flags = FOLL_REMOTE;
+	unsigned int flags = 0;
 
 	/* Work out address and page range required */
 	if (len == 0)
@@ -100,15 +100,19 @@ static int process_vm_rw_single_vec(unsi
 
 	while (!rc && nr_pages && iov_iter_count(iter)) {
 		int pages = min(nr_pages, max_pages_per_loop);
+		int locked = 1;
 		size_t bytes;
 
 		/*
 		 * Get the pages we're interested in.  We must
-		 * add FOLL_REMOTE because task/mm might not
+		 * access remotely because task/mm might not
 		 * current/current->mm
 		 */
-		pages = __get_user_pages_unlocked(task, mm, pa, pages,
-						  process_pages, flags);
+		down_read(&mm->mmap_sem);
+		pages = get_user_pages_remote(task, mm, pa, pages, flags,
+					      process_pages, NULL, &locked);
+		if (locked)
+			up_read(&mm->mmap_sem);
 		if (pages <= 0)
 			return -EFAULT;
 
diff -puN virt/kvm/async_pf.c~mm-unexport-__get_user_pages_unlocked virt/kvm/async_pf.c
--- a/virt/kvm/async_pf.c~mm-unexport-__get_user_pages_unlocked
+++ a/virt/kvm/async_pf.c
@@ -76,16 +76,20 @@ static void async_pf_execute(struct work
 	struct kvm_vcpu *vcpu = apf->vcpu;
 	unsigned long addr = apf->addr;
 	gva_t gva = apf->gva;
+	int locked = 1;
 
 	might_sleep();
 
 	/*
 	 * This work is run asynchromously to the task which owns
 	 * mm and might be done in another context, so we must
-	 * use FOLL_REMOTE.
+	 * access remotely.
 	 */
-	__get_user_pages_unlocked(NULL, mm, addr, 1, NULL,
-			FOLL_WRITE | FOLL_REMOTE);
+	down_read(&mm->mmap_sem);
+	get_user_pages_remote(NULL, mm, addr, 1, FOLL_WRITE, NULL, NULL,
+			&locked);
+	if (locked)
+		up_read(&mm->mmap_sem);
 
 	kvm_async_page_present_sync(vcpu, apf);
 
diff -puN virt/kvm/kvm_main.c~mm-unexport-__get_user_pages_unlocked virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~mm-unexport-__get_user_pages_unlocked
+++ a/virt/kvm/kvm_main.c
@@ -1418,13 +1418,12 @@ static int hva_to_pfn_slow(unsigned long
 		npages = get_user_page_nowait(addr, write_fault, page);
 		up_read(&current->mm->mmap_sem);
 	} else {
-		unsigned int flags = FOLL_TOUCH | FOLL_HWPOISON;
+		unsigned int flags = FOLL_HWPOISON;
 
 		if (write_fault)
 			flags |= FOLL_WRITE;
 
-		npages = __get_user_pages_unlocked(current, current->mm, addr, 1,
-						   page, flags);
+		npages = get_user_pages_unlocked(addr, 1, page, flags);
 	}
 	if (npages != 1)
 		return npages;
_

Patches currently in -mm which might be from lstoakes@gmail.com are



From: akpm@linux-foundation.org
Subject: [merged]
 describe-mmap_sem-rules-for-__lock_page_or_retry-and-callers.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:05:53 -0700
Message-ID: <53e3dc21.Gw5/8/pOu1ku8UL2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:61378 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaHGUFy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:54 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so609242qgd.0
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cassella@cray.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: describe mmap_sem rules for __lock_page_or_retry() and  callers
has been removed from the -mm tree.  Its filename was
     describe-mmap_sem-rules-for-__lock_page_or_retry-and-callers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Paul Cassella <cassella@cray.com>
Subject: mm: describe mmap_sem rules for __lock_page_or_retry() and  callers

Add a comment describing the circumstances in which __lock_page_or_retry()
will or will not release the mmap_sem when returning 0.

Add comments to lock_page_or_retry()'s callers (filemap_fault(),
do_swap_page()) noting the impact on VM_FAULT_RETRY returns.

Add comments on up the call tree, particularly replacing the false "We
return with mmap_sem still held" comments.

Signed-off-by: Paul Cassella <cassella@cray.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c     |    3 ++-
 include/linux/pagemap.h |    3 +++
 mm/filemap.c            |   23 +++++++++++++++++++++++
 mm/gup.c                |   18 +++++++++++++++---
 mm/memory.c             |   34 +++++++++++++++++++++++++++++++---
 mm/mlock.c              |    9 ++++++++-
 6 files changed, 82 insertions(+), 8 deletions(-)

diff -puN arch/x86/mm/fault.c~describe-mmap_sem-rules-for-__lock_page_or_retry-and-callers arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~describe-mmap_sem-rules-for-__lock_page_or_retry-and-callers
+++ a/arch/x86/mm/fault.c
@@ -1218,7 +1218,8 @@ good_area:
 	/*
 	 * If for any reason at all we couldn't handle the fault,
 	 * make sure we exit gracefully rather than endlessly redo
-	 * the fault:
+	 * the fault.  Since we never set FAULT_FLAG_RETRY_NOWAIT, if
+	 * we get VM_FAULT_RETRY back, the mmap_sem has been unlocked.
 	 */
 	fault = handle_mm_fault(mm, vma, address, flags);
 
diff -puN include/linux/pagemap.h~describe-mmap_sem-rules-for-__lock_page_or_retry-and-callers include/linux/pagemap.h
--- a/include/linux/pagemap.h~describe-mmap_sem-rules-for-__lock_page_or_retry-and-callers
+++ a/include/linux/pagemap.h
@@ -484,6 +484,9 @@ static inline int lock_page_killable(str
 /*
  * lock_page_or_retry - Lock the page, unless this would block and the
  * caller indicated that it can handle a retry.
+ *
+ * Return value and mmap_sem implications depend on flags; see
+ * __lock_page_or_retry().
  */
 static inline int lock_page_or_retry(struct page *page, struct mm_struct *mm,
 				     unsigned int flags)
diff -puN mm/filemap.c~describe-mmap_sem-rules-for-__lock_page_or_retry-and-callers mm/filemap.c
--- a/mm/filemap.c~describe-mmap_sem-rules-for-__lock_page_or_retry-and-callers
+++ a/mm/filemap.c
@@ -808,6 +808,17 @@ int __lock_page_killable(struct page *pa
 }
 EXPORT_SYMBOL_GPL(__lock_page_killable);
 
+/*
+ * Return values:
+ * 1 - page is locked; mmap_sem is still held.
+ * 0 - page is not locked.
+ *     mmap_sem has been released (up_read()), unless flags had both
+ *     FAULT_FLAG_ALLOW_RETRY and FAULT_FLAG_RETRY_NOWAIT set, in
+ *     which case mmap_sem is still held.
+ *
+ * If neither ALLOW_RETRY nor KILLABLE are set, will always return 1
+ * with the page locked and the mmap_sem unperturbed.
+ */
 int __lock_page_or_retry(struct page *page, struct mm_struct *mm,
 			 unsigned int flags)
 {
@@ -1827,6 +1838,18 @@ static void do_async_mmap_readahead(stru
  * The goto's are kind of ugly, but this streamlines the normal case of having
  * it in the page cache, and handles the special cases reasonably without
  * having a lot of duplicated code.
+ *
+ * vma->vm_mm->mmap_sem must be held on entry.
+ *
+ * If our return value has VM_FAULT_RETRY set, it's because
+ * lock_page_or_retry() returned 0.
+ * The mmap_sem has usually been released in this case.
+ * See __lock_page_or_retry() for the exception.
+ *
+ * If our return value does not have VM_FAULT_RETRY set, the mmap_sem
+ * has not been released.
+ *
+ * We never return with VM_FAULT_RETRY and a bit from VM_FAULT_ERROR set.
  */
 int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
diff -puN mm/gup.c~describe-mmap_sem-rules-for-__lock_page_or_retry-and-callers mm/gup.c
--- a/mm/gup.c~describe-mmap_sem-rules-for-__lock_page_or_retry-and-callers
+++ a/mm/gup.c
@@ -258,6 +258,11 @@ unmap:
 	return ret;
 }
 
+/*
+ * mmap_sem must be held on entry.  If @nonblocking != NULL and
+ * *@flags does not include FOLL_NOWAIT, the mmap_sem may be released.
+ * If it is, *@nonblocking will be set to 0 and -EBUSY returned.
+ */
 static int faultin_page(struct task_struct *tsk, struct vm_area_struct *vma,
 		unsigned long address, unsigned int *flags, int *nonblocking)
 {
@@ -373,7 +378,7 @@ static int check_vma_flags(struct vm_are
  * with a put_page() call when it is finished with. vmas will only
  * remain valid while mmap_sem is held.
  *
- * Must be called with mmap_sem held for read or write.
+ * Must be called with mmap_sem held.  It may be released.  See below.
  *
  * __get_user_pages walks a process's page tables and takes a reference to
  * each struct page that each user address corresponds to at a given
@@ -396,7 +401,14 @@ static int check_vma_flags(struct vm_are
  *
  * If @nonblocking != NULL, __get_user_pages will not wait for disk IO
  * or mmap_sem contention, and if waiting is needed to pin all pages,
- * *@nonblocking will be set to 0.
+ * *@nonblocking will be set to 0.  Further, if @gup_flags does not
+ * include FOLL_NOWAIT, the mmap_sem will be released via up_read() in
+ * this case.
+ *
+ * A caller using such a combination of @nonblocking and @gup_flags
+ * must therefore hold the mmap_sem for reading only, and recognize
+ * when it's been released.  Otherwise, it must be held for either
+ * reading or writing and will not be released.
  *
  * In most cases, get_user_pages or get_user_pages_fast should be used
  * instead of __get_user_pages. __get_user_pages should be used only if
@@ -528,7 +540,7 @@ EXPORT_SYMBOL(__get_user_pages);
  * such architectures, gup() will not be enough to make a subsequent access
  * succeed.
  *
- * This should be called with the mm_sem held for read.
+ * This has the same semantics wrt the @mm->mmap_sem as does filemap_fault().
  */
 int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
 		     unsigned long address, unsigned int fault_flags)
diff -puN mm/memory.c~describe-mmap_sem-rules-for-__lock_page_or_retry-and-callers mm/memory.c
--- a/mm/memory.c~describe-mmap_sem-rules-for-__lock_page_or_retry-and-callers
+++ a/mm/memory.c
@@ -2399,7 +2399,10 @@ EXPORT_SYMBOL(unmap_mapping_range);
 /*
  * We enter with non-exclusive mmap_sem (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
- * We return with mmap_sem still held, but pte unmapped and unlocked.
+ * We return with pte unmapped and unlocked.
+ *
+ * We return with the mmap_sem locked or unlocked in the same cases
+ * as does filemap_fault().
  */
 static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		unsigned long address, pte_t *page_table, pmd_t *pmd,
@@ -2688,6 +2691,11 @@ oom:
 	return VM_FAULT_OOM;
 }
 
+/*
+ * The mmap_sem must have been held on entry, and may have been
+ * released depending on flags and vma->vm_ops->fault() return value.
+ * See filemap_fault() and __lock_page_retry().
+ */
 static int __do_fault(struct vm_area_struct *vma, unsigned long address,
 		pgoff_t pgoff, unsigned int flags, struct page **page)
 {
@@ -3016,6 +3024,12 @@ static int do_shared_fault(struct mm_str
 	return ret;
 }
 
+/*
+ * We enter with non-exclusive mmap_sem (to exclude vma changes,
+ * but allow concurrent faults).
+ * The mmap_sem may have been released depending on flags and our
+ * return value.  See filemap_fault() and __lock_page_or_retry().
+ */
 static int do_linear_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		unsigned long address, pte_t *page_table, pmd_t *pmd,
 		unsigned int flags, pte_t orig_pte)
@@ -3040,7 +3054,9 @@ static int do_linear_fault(struct mm_str
  *
  * We enter with non-exclusive mmap_sem (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
- * We return with mmap_sem still held, but pte unmapped and unlocked.
+ * We return with pte unmapped and unlocked.
+ * The mmap_sem may have been released depending on flags and our
+ * return value.  See filemap_fault() and __lock_page_or_retry().
  */
 static int do_nonlinear_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		unsigned long address, pte_t *page_table, pmd_t *pmd,
@@ -3172,7 +3188,10 @@ out:
  *
  * We enter with non-exclusive mmap_sem (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
- * We return with mmap_sem still held, but pte unmapped and unlocked.
+ * We return with pte unmapped and unlocked.
+ *
+ * The mmap_sem may have been released depending on flags and our
+ * return value.  See filemap_fault() and __lock_page_or_retry().
  */
 static int handle_pte_fault(struct mm_struct *mm,
 		     struct vm_area_struct *vma, unsigned long address,
@@ -3232,6 +3251,9 @@ unlock:
 
 /*
  * By the time we get here, we already hold the mm semaphore
+ *
+ * The mmap_sem may have been released depending on flags and our
+ * return value.  See filemap_fault() and __lock_page_or_retry().
  */
 static int __handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			     unsigned long address, unsigned int flags)
@@ -3313,6 +3335,12 @@ static int __handle_mm_fault(struct mm_s
 	return handle_pte_fault(mm, vma, address, pte, pmd, flags);
 }
 
+/*
+ * By the time we get here, we already hold the mm semaphore
+ *
+ * The mmap_sem may have been released depending on flags and our
+ * return value.  See filemap_fault() and __lock_page_or_retry().
+ */
 int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		    unsigned long address, unsigned int flags)
 {
diff -puN mm/mlock.c~describe-mmap_sem-rules-for-__lock_page_or_retry-and-callers mm/mlock.c
--- a/mm/mlock.c~describe-mmap_sem-rules-for-__lock_page_or_retry-and-callers
+++ a/mm/mlock.c
@@ -210,12 +210,19 @@ out:
  * @vma:   target vma
  * @start: start address
  * @end:   end address
+ * @nonblocking:
  *
  * This takes care of making the pages present too.
  *
  * return 0 on success, negative error code on error.
  *
- * vma->vm_mm->mmap_sem must be held for at least read.
+ * vma->vm_mm->mmap_sem must be held.
+ *
+ * If @nonblocking is NULL, it may be held for read or write and will
+ * be unperturbed.
+ *
+ * If @nonblocking is non-NULL, it must held for read only and may be
+ * released.  If it's released, *@nonblocking will be set to 0.
  */
 long __mlock_vma_pages_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, int *nonblocking)
_

Patches currently in -mm which might be from cassella@cray.com are

origin.patch


From: akpm@linux-foundation.org
Subject: + mm-retry-page-fault-when-blocking-on-disk-transfer-update.patch added to -mm tree
Date: Mon, 11 Oct 2010 15:25:45 -0700
Message-ID: <201010112225.o9BMPj0S021667__39748.7259273932$1286835988$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756810Ab0JKW0N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Oct 2010 18:26:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, fengguang.wu@intel.com, hpa@zytor.com, linux-arch@vger.kernel.org, mingo@elte.hu, nickpiggin@yahoo.com.au, riel@redhat.com, tglx@linutronix.de, torvalds@linux-foundation.org, yinghan@google.com


The patch titled
     mm-retry-page-fault-when-blocking-on-disk-transfer-update
has been added to the -mm tree.  Its filename is
     mm-retry-page-fault-when-blocking-on-disk-transfer-update.patch

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
Subject: mm-retry-page-fault-when-blocking-on-disk-transfer-update
From: Michel Lespinasse <walken@google.com>

Second try on adding the VM_FAULT_RETRY functionality to the swap in path.

This proposal would replace [patch 2/3] of this series (the initial
version of it, which was approved by linus / rik / hpa).

Changes since the approved version:

- split lock_page_or_retry() into an inline function in  pagemap.h,
  handling the trylock_page() fast path, and __lock_page_or_retry() in
  filemap.c, handling the blocking path (with or without retry).

- make do_swap_page() call lock_page_or_retry() in place of lock_page(),
  and handle the retry case.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   13 +++++++++++++
 mm/filemap.c            |   35 ++++++++++++++---------------------
 mm/memory.c             |    7 ++++++-
 3 files changed, 33 insertions(+), 22 deletions(-)

diff -puN include/linux/pagemap.h~mm-retry-page-fault-when-blocking-on-disk-transfer-update include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-retry-page-fault-when-blocking-on-disk-transfer-update
+++ a/include/linux/pagemap.h
@@ -299,6 +299,8 @@ static inline pgoff_t linear_page_index(
 extern void __lock_page(struct page *page);
 extern int __lock_page_killable(struct page *page);
 extern void __lock_page_nosync(struct page *page);
+extern int __lock_page_or_retry(struct page *page, struct mm_struct *mm,
+				unsigned int flags);
 extern void unlock_page(struct page *page);
 
 static inline void __set_page_locked(struct page *page)
@@ -351,6 +353,17 @@ static inline void lock_page_nosync(stru
 }
 	
 /*
+ * lock_page_or_retry - Lock the page, unless this would block and the
+ * caller indicated that it can handle a retry.
+ */
+static inline int lock_page_or_retry(struct page *page, struct mm_struct *mm,
+				     unsigned int flags)
+{
+	might_sleep();
+	return trylock_page(page) || __lock_page_or_retry(page, mm, flags);
+}
+
+/*
  * This is exported only for wait_on_page_locked/wait_on_page_writeback.
  * Never use this directly!
  */
diff -puN mm/filemap.c~mm-retry-page-fault-when-blocking-on-disk-transfer-update mm/filemap.c
--- a/mm/filemap.c~mm-retry-page-fault-when-blocking-on-disk-transfer-update
+++ a/mm/filemap.c
@@ -623,6 +623,19 @@ void __lock_page_nosync(struct page *pag
 							TASK_UNINTERRUPTIBLE);
 }
 
+int __lock_page_or_retry(struct page *page, struct mm_struct *mm,
+			 unsigned int flags)
+{
+	if (!(flags & FAULT_FLAG_ALLOW_RETRY)) {
+		__lock_page(page);
+		return 1;
+	} else {
+		up_read(&mm->mmap_sem);
+		wait_on_page_locked(page);
+		return 0;
+	}
+}
+
 /**
  * find_get_page - find and get a page reference
  * @mapping: the address_space to search
@@ -1512,26 +1525,6 @@ static void do_async_mmap_readahead(stru
 					   page, offset, ra->ra_pages);
 }
 
-/*
- * Lock the page, unless this would block and the caller indicated that it
- * can handle a retry.
- */
-static int lock_page_or_retry(struct page *page,
-			      struct vm_area_struct *vma, struct vm_fault *vmf)
-{
-	if (trylock_page(page))
-		return 1;
-	if (!(vmf->flags & FAULT_FLAG_ALLOW_RETRY)) {
-		__lock_page(page);
-		return 1;
-	}
-
-	up_read(&vma->vm_mm->mmap_sem);
-	wait_on_page_locked(page);
-	page_cache_release(page);
-	return 0;
-}
-
 /**
  * filemap_fault - read in file data for page fault handling
  * @vma:	vma in which the fault was taken
@@ -1581,7 +1574,7 @@ retry_find:
 			goto no_cached_page;
 	}
 
-	if (!lock_page_or_retry(page, vma, vmf))
+	if (!lock_page_or_retry(page, &vma->vm_mm, vmf->flags))
 		return ret | VM_FAULT_RETRY;
 
 	/* Did it get truncated? */
diff -puN mm/memory.c~mm-retry-page-fault-when-blocking-on-disk-transfer-update mm/memory.c
--- a/mm/memory.c~mm-retry-page-fault-when-blocking-on-disk-transfer-update
+++ a/mm/memory.c
@@ -2627,6 +2627,7 @@ static int do_swap_page(struct mm_struct
 	struct page *page, *swapcache = NULL;
 	swp_entry_t entry;
 	pte_t pte;
+	int locked;
 	struct mem_cgroup *ptr = NULL;
 	int exclusive = 0;
 	int ret = 0;
@@ -2677,8 +2678,12 @@ static int do_swap_page(struct mm_struct
 		goto out_release;
 	}
 
-	lock_page(page);
+	locked = lock_page_or_retry(page, mm, flags);
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
+	if (!locked) {
+		ret |= VM_FAULT_RETRY;
+		goto out_release;
+	}
 
 	/*
 	 * Make sure try_to_free_swap or reuse_swap_page or swapoff did not
_

Patches currently in -mm which might be from walken@google.com are

mm-filemap_fault-unique-path-for-locking-page.patch
mm-retry-page-fault-when-blocking-on-disk-transfer.patch
mm-retry-page-fault-when-blocking-on-disk-transfer-update.patch
x86-access_error-api-cleanup.patch


From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 054/128] mm/gup.c: update the documentation
Date: Tue, 02 Jun 2020 13:13:07 -0700
Message-ID: <20200602201307.X0SMma3BK%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgFBUNK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 16:13:10 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jrdr.linux@gmail.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: mm/gup.c: update the documentation

This patch is an attempt to update the documentation.

* Add/ remove extra * based on type of function static/global.

* Add description for functions and their input arguments.

[akpm@linux-foundation.org: s@/*@/**@]
Link: http://lkml.kernel.org/r/1588013630-4497-1-git-send-email-jrdr.linux@gmail.com
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   57 ++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 18 deletions(-)

--- a/mm/gup.c~mm-gupc-updating-the-documentation
+++ a/mm/gup.c
@@ -1168,7 +1168,7 @@ static bool vma_permits_fault(struct vm_
 	return true;
 }
 
-/*
+/**
  * fixup_user_fault() - manually resolve a user page fault
  * @tsk:	the task_struct to use for page fault accounting, or
  *		NULL if faults are not to be recorded.
@@ -1839,7 +1839,7 @@ static long __get_user_pages_remote(stru
 				       gup_flags | FOLL_TOUCH | FOLL_REMOTE);
 }
 
-/*
+/**
  * get_user_pages_remote() - pin user pages in memory
  * @tsk:	the task_struct to use for page fault accounting, or
  *		NULL if faults are not to be recorded.
@@ -1870,13 +1870,13 @@ static long __get_user_pages_remote(stru
  *
  * Must be called with mmap_sem held for read or write.
  *
- * get_user_pages walks a process's page tables and takes a reference to
- * each struct page that each user address corresponds to at a given
+ * get_user_pages_remote walks a process's page tables and takes a reference
+ * to each struct page that each user address corresponds to at a given
  * instant. That is, it takes the page that would be accessed if a user
  * thread accesses the given user virtual address at that instant.
  *
  * This does not guarantee that the page exists in the user mappings when
- * get_user_pages returns, and there may even be a completely different
+ * get_user_pages_remote returns, and there may even be a completely different
  * page there in some cases (eg. if mmapped pagecache has been invalidated
  * and subsequently re faulted). However it does guarantee that the page
  * won't be freed completely. And mostly callers simply care that the page
@@ -1888,17 +1888,17 @@ static long __get_user_pages_remote(stru
  * is written to, set_page_dirty (or set_page_dirty_lock, as appropriate) must
  * be called after the page is finished with, and before put_page is called.
  *
- * get_user_pages is typically used for fewer-copy IO operations, to get a
- * handle on the memory by some means other than accesses via the user virtual
- * addresses. The pages may be submitted for DMA to devices or accessed via
- * their kernel linear mapping (via the kmap APIs). Care should be taken to
- * use the correct cache flushing APIs.
+ * get_user_pages_remote is typically used for fewer-copy IO operations,
+ * to get a handle on the memory by some means other than accesses
+ * via the user virtual addresses. The pages may be submitted for
+ * DMA to devices or accessed via their kernel linear mapping (via the
+ * kmap APIs). Care should be taken to use the correct cache flushing APIs.
  *
  * See also get_user_pages_fast, for performance critical applications.
  *
- * get_user_pages should be phased out in favor of
+ * get_user_pages_remote should be phased out in favor of
  * get_user_pages_locked|unlocked or get_user_pages_fast. Nothing
- * should use get_user_pages because it cannot pass
+ * should use get_user_pages_remote because it cannot pass
  * FAULT_FLAG_ALLOW_RETRY to handle_mm_fault.
  */
 long get_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
@@ -1937,7 +1937,17 @@ static long __get_user_pages_remote(stru
 }
 #endif /* !CONFIG_MMU */
 
-/*
+/**
+ * get_user_pages() - pin user pages in memory
+ * @start:      starting user address
+ * @nr_pages:   number of pages from start to pin
+ * @gup_flags:  flags modifying lookup behaviour
+ * @pages:      array that receives pointers to the pages pinned.
+ *              Should be at least nr_pages long. Or NULL, if caller
+ *              only intends to ensure the pages are faulted in.
+ * @vmas:       array of pointers to vmas corresponding to each page.
+ *              Or NULL if the caller does not require them.
+ *
  * This is the same as get_user_pages_remote(), just with a
  * less-flexible calling convention where we assume that the task
  * and mm being operated on are the current task's and don't allow
@@ -1960,11 +1970,7 @@ long get_user_pages(unsigned long start,
 }
 EXPORT_SYMBOL(get_user_pages);
 
-/*
- * We can leverage the VM_FAULT_RETRY functionality in the page fault
- * paths better by using either get_user_pages_locked() or
- * get_user_pages_unlocked().
- *
+/**
  * get_user_pages_locked() is suitable to replace the form:
  *
  *      down_read(&mm->mmap_sem);
@@ -1980,6 +1986,21 @@ EXPORT_SYMBOL(get_user_pages);
  *      get_user_pages_locked(tsk, mm, ..., pages, &locked);
  *      if (locked)
  *          up_read(&mm->mmap_sem);
+ *
+ * @start:      starting user address
+ * @nr_pages:   number of pages from start to pin
+ * @gup_flags:  flags modifying lookup behaviour
+ * @pages:      array that receives pointers to the pages pinned.
+ *              Should be at least nr_pages long. Or NULL, if caller
+ *              only intends to ensure the pages are faulted in.
+ * @locked:     pointer to lock flag indicating whether lock is held and
+ *              subsequently whether VM_FAULT_RETRY functionality can be
+ *              utilised. Lock must initially be held.
+ *
+ * We can leverage the VM_FAULT_RETRY functionality in the page fault
+ * paths better by using either get_user_pages_locked() or
+ * get_user_pages_unlocked().
+ *
  */
 long get_user_pages_locked(unsigned long start, unsigned long nr_pages,
 			   unsigned int gup_flags, struct page **pages,
_

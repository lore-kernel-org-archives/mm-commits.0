From: akpm@linux-foundation.org
Subject: [merged] mm-clean-up-get_user_pages_fast-documentation.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:33:09 -0700
Message-ID: <200906171833.n5HIX9AO031645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758252AbZFQSdm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:33:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickpiggin@yahoo.com.au, andy.grover@oracle.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: clean up get_user_pages_fast() documentation
has been removed from the -mm tree.  Its filename was
     mm-clean-up-get_user_pages_fast-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: clean up get_user_pages_fast() documentation
From: Nick Piggin <nickpiggin@yahoo.com.au>

Move more documentation for get_user_pages_fast into the new kerneldoc comment.
Add some comments for get_user_pages as well.

Also, move get_user_pages_fast declaration up to get_user_pages. It wasn't
there initially because it was once a static inline function.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Andy Grover <andy.grover@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   20 ++++-------------
 mm/memory.c        |   50 +++++++++++++++++++++++++++++++++++++++++++
 mm/util.c          |   16 ++++++++++---
 3 files changed, 67 insertions(+), 19 deletions(-)

diff -puN include/linux/mm.h~mm-clean-up-get_user_pages_fast-documentation include/linux/mm.h
--- a/include/linux/mm.h~mm-clean-up-get_user_pages_fast-documentation
+++ a/include/linux/mm.h
@@ -824,8 +824,11 @@ static inline int handle_mm_fault(struct
 extern int make_pages_present(unsigned long addr, unsigned long end);
 extern int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write);
 
-int get_user_pages(struct task_struct *tsk, struct mm_struct *mm, unsigned long start,
-		int len, int write, int force, struct page **pages, struct vm_area_struct **vmas);
+int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+			unsigned long start, int len, int write, int force,
+			struct page **pages, struct vm_area_struct **vmas);
+int get_user_pages_fast(unsigned long start, int nr_pages, int write,
+			struct page **pages);
 
 extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
 extern void do_invalidatepage(struct page *page, unsigned long offset);
@@ -850,19 +853,6 @@ extern int mprotect_fixup(struct vm_area
 			  unsigned long end, unsigned long newflags);
 
 /*
- * get_user_pages_fast provides equivalent functionality to get_user_pages,
- * operating on current and current->mm (force=0 and doesn't return any vmas).
- *
- * get_user_pages_fast may take mmap_sem and page tables, so no assumptions
- * can be made about locking. get_user_pages_fast is to be implemented in a
- * way that is advantageous (vs get_user_pages()) when the user memory area is
- * already faulted in and present in ptes. However if the pages have to be
- * faulted in, it may turn out to be slightly slower).
- */
-int get_user_pages_fast(unsigned long start, int nr_pages, int write,
-			struct page **pages);
-
-/*
  * A callback you can register to apply pressure to ageable caches.
  *
  * 'shrink' is passed a count 'nr_to_scan' and a 'gfpmask'.  It should
diff -puN mm/memory.c~mm-clean-up-get_user_pages_fast-documentation mm/memory.c
--- a/mm/memory.c~mm-clean-up-get_user_pages_fast-documentation
+++ a/mm/memory.c
@@ -1360,6 +1360,56 @@ int __get_user_pages(struct task_struct 
 	return i;
 }
 
+/**
+ * get_user_pages() - pin user pages in memory
+ * @tsk:	task_struct of target task
+ * @mm:		mm_struct of target mm
+ * @start:	starting user address
+ * @len:	number of pages from start to pin
+ * @write:	whether pages will be written to by the caller
+ * @force:	whether to force write access even if user mapping is
+ *		readonly. This will result in the page being COWed even
+ *		in MAP_SHARED mappings. You do not want this.
+ * @pages:	array that receives pointers to the pages pinned.
+ *		Should be at least nr_pages long. Or NULL, if caller
+ *		only intends to ensure the pages are faulted in.
+ * @vmas:	array of pointers to vmas corresponding to each page.
+ *		Or NULL if the caller does not require them.
+ *
+ * Returns number of pages pinned. This may be fewer than the number
+ * requested. If len is 0 or negative, returns 0. If no pages
+ * were pinned, returns -errno. Each page returned must be released
+ * with a put_page() call when it is finished with. vmas will only
+ * remain valid while mmap_sem is held.
+ *
+ * Must be called with mmap_sem held for read or write.
+ *
+ * get_user_pages walks a process's page tables and takes a reference to
+ * each struct page that each user address corresponds to at a given
+ * instant. That is, it takes the page that would be accessed if a user
+ * thread accesses the given user virtual address at that instant.
+ *
+ * This does not guarantee that the page exists in the user mappings when
+ * get_user_pages returns, and there may even be a completely different
+ * page there in some cases (eg. if mmapped pagecache has been invalidated
+ * and subsequently re faulted). However it does guarantee that the page
+ * won't be freed completely. And mostly callers simply care that the page
+ * contains data that was valid *at some point in time*. Typically, an IO
+ * or similar operation cannot guarantee anything stronger anyway because
+ * locks can't be held over the syscall boundary.
+ *
+ * If write=0, the page must not be written to. If the page is written to,
+ * set_page_dirty (or set_page_dirty_lock, as appropriate) must be called
+ * after the page is finished with, and before put_page is called.
+ *
+ * get_user_pages is typically used for fewer-copy IO operations, to get a
+ * handle on the memory by some means other than accesses via the user virtual
+ * addresses. The pages may be submitted for DMA to devices or accessed via
+ * their kernel linear mapping (via the kmap APIs). Care should be taken to
+ * use the correct cache flushing APIs.
+ *
+ * See also get_user_pages_fast, for performance critical applications.
+ */
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		unsigned long start, int len, int write, int force,
 		struct page **pages, struct vm_area_struct **vmas)
diff -puN mm/util.c~mm-clean-up-get_user_pages_fast-documentation mm/util.c
--- a/mm/util.c~mm-clean-up-get_user_pages_fast-documentation
+++ a/mm/util.c
@@ -233,13 +233,21 @@ void arch_pick_mmap_layout(struct mm_str
  * @pages:	array that receives pointers to the pages pinned.
  *		Should be at least nr_pages long.
  *
- * Attempt to pin user pages in memory without taking mm->mmap_sem.
- * If not successful, it will fall back to taking the lock and
- * calling get_user_pages().
- *
  * Returns number of pages pinned. This may be fewer than the number
  * requested. If nr_pages is 0 or negative, returns 0. If no pages
  * were pinned, returns -errno.
+ *
+ * get_user_pages_fast provides equivalent functionality to get_user_pages,
+ * operating on current and current->mm, with force=0 and vma=NULL. However
+ * unlike get_user_pages, it must be called without mmap_sem held.
+ *
+ * get_user_pages_fast may take mmap_sem and page table locks, so no
+ * assumptions can be made about lack of locking. get_user_pages_fast is to be
+ * implemented in a way that is advantageous (vs get_user_pages()) when the
+ * user memory area is already faulted in and present in ptes. However if the
+ * pages have to be faulted in, it may turn out to be slightly slower so
+ * callers need to carefully consider what to use. On many architectures,
+ * get_user_pages_fast simply falls back to get_user_pages.
  */
 int __attribute__((weak)) get_user_pages_fast(unsigned long start,
 				int nr_pages, int write, struct page **pages)
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
vfs-take-2add-set_page_dirty_notag.patch
reiser4.patch


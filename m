From: akpm@linux-foundation.org
Subject: [merged] mm-munlock-use-follow_page.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:42:39 -0700
Message-ID: <200909222042.n8MKgdbF010015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751678AbZIVUoM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:44:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@suse.de, primulaelatior@gmail.com, riel@redha


The patch titled
     mm: munlock use follow_page
has been removed from the -mm tree.  Its filename was
     mm-munlock-use-follow_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: munlock use follow_page
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Hiroaki Wakabayashi points out that when mlock() has been interrupted
by SIGKILL, the subsequent munlock() takes unnecessarily long because
its use of __get_user_pages() insists on faulting in all the pages
which mlock() never reached.

It's worse than slowness if mlock() is terminated by Out Of Memory kill:
the munlock_vma_pages_all() in exit_mmap() insists on faulting in all the
pages which mlock() could not find memory for; so innocent bystanders are
killed too, and perhaps the system hangs.

__get_user_pages() does a lot that's silly for munlock(): so remove the
munlock option from __mlock_vma_pages_range(), and use a simple loop of
follow_page()s in munlock_vma_pages_range() instead; ignoring absent
pages, and not marking present pages as accessed or dirty.

(Change munlock() to only go so far as mlock() reached?  That does not
work out, given the convention that mlock() claims complete success even
when it has to give up early - in part so that an underlying file can be
extended later, and those pages locked which earlier would give SIGBUS.)

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: <stable@kernel.org>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Hiroaki Wakabayashi <primulaelatior@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   99 ++++++++++++++++++++-------------------------------
 1 file changed, 40 insertions(+), 59 deletions(-)

diff -puN mm/mlock.c~mm-munlock-use-follow_page mm/mlock.c
--- a/mm/mlock.c~mm-munlock-use-follow_page
+++ a/mm/mlock.c
@@ -139,49 +139,36 @@ static void munlock_vma_page(struct page
 }
 
 /**
- * __mlock_vma_pages_range() -  mlock/munlock a range of pages in the vma.
+ * __mlock_vma_pages_range() -  mlock a range of pages in the vma.
  * @vma:   target vma
  * @start: start address
  * @end:   end address
- * @mlock: 0 indicate munlock, otherwise mlock.
  *
- * If @mlock == 0, unlock an mlocked range;
- * else mlock the range of pages.  This takes care of making the pages present ,
- * too.
+ * This takes care of making the pages present too.
  *
  * return 0 on success, negative error code on error.
  *
  * vma->vm_mm->mmap_sem must be held for at least read.
  */
 static long __mlock_vma_pages_range(struct vm_area_struct *vma,
-				   unsigned long start, unsigned long end,
-				   int mlock)
+				    unsigned long start, unsigned long end)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long addr = start;
 	struct page *pages[16]; /* 16 gives a reasonable batch */
 	int nr_pages = (end - start) / PAGE_SIZE;
 	int ret = 0;
-	int gup_flags = 0;
+	int gup_flags;
 
 	VM_BUG_ON(start & ~PAGE_MASK);
 	VM_BUG_ON(end   & ~PAGE_MASK);
 	VM_BUG_ON(start < vma->vm_start);
 	VM_BUG_ON(end   > vma->vm_end);
-	VM_BUG_ON((!rwsem_is_locked(&mm->mmap_sem)) &&
-		  (atomic_read(&mm->mm_users) != 0));
-
-	/*
-	 * mlock:   don't page populate if vma has PROT_NONE permission.
-	 * munlock: always do munlock although the vma has PROT_NONE
-	 *          permission, or SIGKILL is pending.
-	 */
-	if (!mlock)
-		gup_flags |= GUP_FLAGS_IGNORE_VMA_PERMISSIONS |
-			     GUP_FLAGS_IGNORE_SIGKILL;
+	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
 
+	gup_flags = 0;
 	if (vma->vm_flags & VM_WRITE)
-		gup_flags |= GUP_FLAGS_WRITE;
+		gup_flags = GUP_FLAGS_WRITE;
 
 	while (nr_pages > 0) {
 		int i;
@@ -201,19 +188,10 @@ static long __mlock_vma_pages_range(stru
 		 * This can happen for, e.g., VM_NONLINEAR regions before
 		 * a page has been allocated and mapped at a given offset,
 		 * or for addresses that map beyond end of a file.
-		 * We'll mlock the the pages if/when they get faulted in.
+		 * We'll mlock the pages if/when they get faulted in.
 		 */
 		if (ret < 0)
 			break;
-		if (ret == 0) {
-			/*
-			 * We know the vma is there, so the only time
-			 * we cannot get a single page should be an
-			 * error (ret < 0) case.
-			 */
-			WARN_ON(1);
-			break;
-		}
 
 		lru_add_drain();	/* push cached pages to LRU */
 
@@ -224,28 +202,22 @@ static long __mlock_vma_pages_range(stru
 			/*
 			 * Because we lock page here and migration is blocked
 			 * by the elevated reference, we need only check for
-			 * page truncation (file-cache only).
+			 * file-cache page truncation.  This page->mapping
+			 * check also neatly skips over the ZERO_PAGE(),
+			 * though if that's common we'd prefer not to lock it.
 			 */
-			if (page->mapping) {
-				if (mlock)
-					mlock_vma_page(page);
-				else
-					munlock_vma_page(page);
-			}
+			if (page->mapping)
+				mlock_vma_page(page);
 			unlock_page(page);
-			put_page(page);		/* ref from get_user_pages() */
-
-			/*
-			 * here we assume that get_user_pages() has given us
-			 * a list of virtually contiguous pages.
-			 */
-			addr += PAGE_SIZE;	/* for next get_user_pages() */
-			nr_pages--;
+			put_page(page);	/* ref from get_user_pages() */
 		}
+
+		addr += ret * PAGE_SIZE;
+		nr_pages -= ret;
 		ret = 0;
 	}
 
-	return ret;	/* count entire vma as locked_vm */
+	return ret;	/* 0 or negative error code */
 }
 
 /*
@@ -289,7 +261,7 @@ long mlock_vma_pages_range(struct vm_are
 			is_vm_hugetlb_page(vma) ||
 			vma == get_gate_vma(current))) {
 
-		__mlock_vma_pages_range(vma, start, end, 1);
+		__mlock_vma_pages_range(vma, start, end);
 
 		/* Hide errors from mmap() and other callers */
 		return 0;
@@ -310,7 +282,6 @@ no_mlock:
 	return nr_pages;		/* error or pages NOT mlocked */
 }
 
-
 /*
  * munlock_vma_pages_range() - munlock all pages in the vma range.'
  * @vma - vma containing range to be munlock()ed.
@@ -330,10 +301,24 @@ no_mlock:
  * free them.  This will result in freeing mlocked pages.
  */
 void munlock_vma_pages_range(struct vm_area_struct *vma,
-			   unsigned long start, unsigned long end)
+			     unsigned long start, unsigned long end)
 {
+	unsigned long addr;
+
+	lru_add_drain();
 	vma->vm_flags &= ~VM_LOCKED;
-	__mlock_vma_pages_range(vma, start, end, 0);
+
+	for (addr = start; addr < end; addr += PAGE_SIZE) {
+		struct page *page = follow_page(vma, addr, FOLL_GET);
+		if (page) {
+			lock_page(page);
+			if (page->mapping)
+				munlock_vma_page(page);
+			unlock_page(page);
+			put_page(page);
+		}
+		cond_resched();
+	}
 }
 
 /*
@@ -400,18 +385,14 @@ success:
 	 * It's okay if try_to_unmap_one unmaps a page just after we
 	 * set VM_LOCKED, __mlock_vma_pages_range will bring it back.
 	 */
-	vma->vm_flags = newflags;
 
 	if (lock) {
-		ret = __mlock_vma_pages_range(vma, start, end, 1);
-
-		if (ret > 0) {
-			mm->locked_vm -= ret;
-			ret = 0;
-		} else
-			ret = __mlock_posix_error_return(ret); /* translate if needed */
+		vma->vm_flags = newflags;
+		ret = __mlock_vma_pages_range(vma, start, end);
+		if (ret < 0)
+			ret = __mlock_posix_error_return(ret);
 	} else {
-		__mlock_vma_pages_range(vma, start, end, 0);
+		munlock_vma_pages_range(vma, start, end);
 	}
 
 out:
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-optimize-touch_time-too.patch
vfs-seq_file-add-helpers-for-data-filling.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
getrusage-fill-ru_maxrss-value.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch


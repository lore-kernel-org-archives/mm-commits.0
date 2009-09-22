From: akpm@linux-foundation.org
Subject: [merged] mm-foll_dump-replace-foll_anon.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:42:49 -0700
Message-ID: <200909222042.n8MKgnYp010352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035AbZIVUnI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:43:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: FOLL_DUMP replace FOLL_ANON
has been removed from the -mm tree.  Its filename was
     mm-foll_dump-replace-foll_anon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: FOLL_DUMP replace FOLL_ANON
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

The "FOLL_ANON optimization" and its use_zero_page() test have caused
confusion and bugs: why does it test VM_SHARED? for the very good but
unsatisfying reason that VMware crashed without.  As we look to maybe
reinstating anonymous use of the ZERO_PAGE, we need to sort this out.

Easily done: it's silly for __get_user_pages() and follow_page() to
be guessing whether it's safe to assume that they're being used for
a coredump (which can take a shortcut snapshot where other uses must
handle a fault) - just tell them with GUP_FLAGS_DUMP and FOLL_DUMP.

get_dump_page() doesn't even want a ZERO_PAGE: an error suits fine.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 -
 mm/internal.h      |    1 
 mm/memory.c        |   45 ++++++++++++-------------------------------
 3 files changed, 15 insertions(+), 33 deletions(-)

diff -puN include/linux/mm.h~mm-foll_dump-replace-foll_anon include/linux/mm.h
--- a/include/linux/mm.h~mm-foll_dump-replace-foll_anon
+++ a/include/linux/mm.h
@@ -1231,7 +1231,7 @@ struct page *follow_page(struct vm_area_
 #define FOLL_WRITE	0x01	/* check pte is writable */
 #define FOLL_TOUCH	0x02	/* mark page accessed */
 #define FOLL_GET	0x04	/* do get_page on page */
-#define FOLL_ANON	0x08	/* give ZERO_PAGE if no pgtable */
+#define FOLL_DUMP	0x08	/* give error on hole if it would be zero */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
diff -puN mm/internal.h~mm-foll_dump-replace-foll_anon mm/internal.h
--- a/mm/internal.h~mm-foll_dump-replace-foll_anon
+++ a/mm/internal.h
@@ -252,6 +252,7 @@ static inline void mminit_validate_memmo
 
 #define GUP_FLAGS_WRITE		0x01
 #define GUP_FLAGS_FORCE		0x02
+#define GUP_FLAGS_DUMP		0x04
 
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		     unsigned long start, int len, int flags,
diff -puN mm/memory.c~mm-foll_dump-replace-foll_anon mm/memory.c
--- a/mm/memory.c~mm-foll_dump-replace-foll_anon
+++ a/mm/memory.c
@@ -1174,41 +1174,22 @@ no_page:
 	pte_unmap_unlock(ptep, ptl);
 	if (!pte_none(pte))
 		return page;
-	/* Fall through to ZERO_PAGE handling */
+
 no_page_table:
 	/*
 	 * When core dumping an enormous anonymous area that nobody
-	 * has touched so far, we don't want to allocate page tables.
-	 */
-	if (flags & FOLL_ANON) {
-		page = ZERO_PAGE(0);
-		if (flags & FOLL_GET)
-			get_page(page);
-		BUG_ON(flags & FOLL_WRITE);
-	}
+	 * has touched so far, we don't want to allocate unnecessary pages or
+	 * page tables.  Return error instead of NULL to skip handle_mm_fault,
+	 * then get_dump_page() will return NULL to leave a hole in the dump.
+	 * But we can only make this optimization where a hole would surely
+	 * be zero-filled if handle_mm_fault() actually did handle it.
+	 */
+	if ((flags & FOLL_DUMP) &&
+	    (!vma->vm_ops || !vma->vm_ops->fault))
+		return ERR_PTR(-EFAULT);
 	return page;
 }
 
-/* Can we do the FOLL_ANON optimization? */
-static inline int use_zero_page(struct vm_area_struct *vma)
-{
-	/*
-	 * We don't want to optimize FOLL_ANON for make_pages_present()
-	 * when it tries to page in a VM_LOCKED region. As to VM_SHARED,
-	 * we want to get the page from the page tables to make sure
-	 * that we serialize and update with any other user of that
-	 * mapping.
-	 */
-	if (vma->vm_flags & (VM_LOCKED | VM_SHARED))
-		return 0;
-	/*
-	 * And if we have a fault routine, it's not an anonymous region.
-	 */
-	return !vma->vm_ops || !vma->vm_ops->fault;
-}
-
-
-
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		     unsigned long start, int nr_pages, int flags,
 		     struct page **pages, struct vm_area_struct **vmas)
@@ -1288,8 +1269,8 @@ int __get_user_pages(struct task_struct 
 		foll_flags = FOLL_TOUCH;
 		if (pages)
 			foll_flags |= FOLL_GET;
-		if (!write && use_zero_page(vma))
-			foll_flags |= FOLL_ANON;
+		if (flags & GUP_FLAGS_DUMP)
+			foll_flags |= FOLL_DUMP;
 
 		do {
 			struct page *page;
@@ -1446,7 +1427,7 @@ struct page *get_dump_page(unsigned long
 	struct page *page;
 
 	if (__get_user_pages(current, current->mm, addr, 1,
-				GUP_FLAGS_FORCE, &page, &vma) < 1)
+			GUP_FLAGS_FORCE | GUP_FLAGS_DUMP, &page, &vma) < 1)
 		return NULL;
 	if (page == ZERO_PAGE(0)) {
 		page_cache_release(page);
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


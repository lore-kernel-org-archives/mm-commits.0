From: akpm@linux-foundation.org
Subject: - mm-remove-nopage.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:50 -0700
Message-ID: <200804282150.m3SLoode017523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964819AbYD1Vu4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:50:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: remove nopage
has been removed from the -mm tree.  Its filename was
     mm-remove-nopage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove nopage
From: Nick Piggin <npiggin@suse.de>

Nothing in the tree uses nopage any more.  Remove support for it in the
core mm code and documentation (and a few stray references to it in
comments).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    9 -------
 Documentation/filesystems/Locking          |    3 --
 drivers/media/video/vino.c                 |    2 -
 drivers/video/vermilion/vermilion.c        |    5 ++--
 fs/gfs2/ops_address.c                      |    2 -
 include/linux/mm.h                         |    8 ------
 mm/memory.c                                |   22 ++++---------------
 mm/mincore.c                               |    2 -
 mm/rmap.c                                  |    1 
 9 files changed, 11 insertions(+), 43 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~mm-remove-nopage Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~mm-remove-nopage
+++ a/Documentation/feature-removal-schedule.txt
@@ -128,15 +128,6 @@ Who:	Arjan van de Ven <arjan@linux.intel
 
 ---------------------------
 
-What:	vm_ops.nopage
-When:	Soon, provided in-kernel callers have been converted
-Why:	This interface is replaced by vm_ops.fault, but it has been around
-	forever, is used by a lot of drivers, and doesn't cost much to
-	maintain.
-Who:	Nick Piggin <npiggin@suse.de>
-
----------------------------
-
 What:	PHYSDEVPATH, PHYSDEVBUS, PHYSDEVDRIVER in the uevent environment
 When:	October 2008
 Why:	The stacking of class devices makes these values misleading and
diff -puN Documentation/filesystems/Locking~mm-remove-nopage Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~mm-remove-nopage
+++ a/Documentation/filesystems/Locking
@@ -511,7 +511,6 @@ prototypes:
 	void (*open)(struct vm_area_struct*);
 	void (*close)(struct vm_area_struct*);
 	int (*fault)(struct vm_area_struct*, struct vm_fault *);
-	struct page *(*nopage)(struct vm_area_struct*, unsigned long, int *);
 	int (*page_mkwrite)(struct vm_area_struct *, struct page *);
 
 locking rules:
@@ -519,7 +518,6 @@ locking rules:
 open:		no	yes
 close:		no	yes
 fault:		no	yes
-nopage:		no	yes
 page_mkwrite:	no	yes		no
 
 	->page_mkwrite() is called when a previously read-only page is
@@ -537,4 +535,3 @@ NULL.
 
 ipc/shm.c::shm_delete() - may need BKL.
 ->read() and ->write() in many drivers are (probably) missing BKL.
-drivers/sgi/char/graphics.c::sgi_graphics_nopage() - may need BKL.
diff -puN drivers/media/video/vino.c~mm-remove-nopage drivers/media/video/vino.c
--- a/drivers/media/video/vino.c~mm-remove-nopage
+++ a/drivers/media/video/vino.c
@@ -13,7 +13,7 @@
 /*
  * TODO:
  * - remove "mark pages reserved-hacks" from memory allocation code
- *   and implement nopage()
+ *   and implement fault()
  * - check decimation, calculating and reporting image size when
  *   using decimation
  * - implement read(), user mode buffers and overlay (?)
diff -puN drivers/video/vermilion/vermilion.c~mm-remove-nopage drivers/video/vermilion/vermilion.c
--- a/drivers/video/vermilion/vermilion.c~mm-remove-nopage
+++ a/drivers/video/vermilion/vermilion.c
@@ -112,8 +112,9 @@ static int vmlfb_alloc_vram_area(struct 
 
 	/*
 	 * It seems like __get_free_pages only ups the usage count
-	 * of the first page. This doesn't work with nopage mapping, so
-	 * up the usage count once more.
+	 * of the first page. This doesn't work with fault mapping, so
+	 * up the usage count once more (XXX: should use split_page or
+	 * compound page).
 	 */
 
 	memset((void *)va->logical, 0x00, va->size);
diff -puN fs/gfs2/ops_address.c~mm-remove-nopage fs/gfs2/ops_address.c
--- a/fs/gfs2/ops_address.c~mm-remove-nopage
+++ a/fs/gfs2/ops_address.c
@@ -438,7 +438,7 @@ static int stuffed_readpage(struct gfs2_
 	int error;
 
 	/*
-	 * Due to the order of unstuffing files and ->nopage(), we can be
+	 * Due to the order of unstuffing files and ->fault(), we can be
 	 * asked for a zero page in the case of a stuffed file being extended,
 	 * so we need to supply one here. It doesn't happen often.
 	 */
diff -puN include/linux/mm.h~mm-remove-nopage include/linux/mm.h
--- a/include/linux/mm.h~mm-remove-nopage
+++ a/include/linux/mm.h
@@ -164,8 +164,6 @@ struct vm_operations_struct {
 	void (*open)(struct vm_area_struct * area);
 	void (*close)(struct vm_area_struct * area);
 	int (*fault)(struct vm_area_struct *vma, struct vm_fault *vmf);
-	struct page *(*nopage)(struct vm_area_struct *area,
-			unsigned long address, int *type);
 	unsigned long (*nopfn)(struct vm_area_struct *area,
 			unsigned long address);
 
@@ -649,12 +647,6 @@ static inline int page_mapped(struct pag
 }
 
 /*
- * Error return values for the *_nopage functions
- */
-#define NOPAGE_SIGBUS	(NULL)
-#define NOPAGE_OOM	((struct page *) (-1))
-
-/*
  * Error return values for the *_nopfn functions
  */
 #define NOPFN_SIGBUS	((unsigned long) -1)
diff -puN mm/memory.c~mm-remove-nopage mm/memory.c
--- a/mm/memory.c~mm-remove-nopage
+++ a/mm/memory.c
@@ -1057,8 +1057,7 @@ int get_user_pages(struct task_struct *t
 		if (pages)
 			foll_flags |= FOLL_GET;
 		if (!write && !(vma->vm_flags & VM_LOCKED) &&
-		    (!vma->vm_ops || (!vma->vm_ops->nopage &&
-					!vma->vm_ops->fault)))
+		    (!vma->vm_ops || !vma->vm_ops->fault))
 			foll_flags |= FOLL_ANON;
 
 		do {
@@ -2199,20 +2198,9 @@ static int __do_fault(struct mm_struct *
 
 	BUG_ON(vma->vm_flags & VM_PFNMAP);
 
-	if (likely(vma->vm_ops->fault)) {
-		ret = vma->vm_ops->fault(vma, &vmf);
-		if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
-			return ret;
-	} else {
-		/* Legacy ->nopage path */
-		ret = 0;
-		vmf.page = vma->vm_ops->nopage(vma, address & PAGE_MASK, &ret);
-		/* no page was available -- either SIGBUS or OOM */
-		if (unlikely(vmf.page == NOPAGE_SIGBUS))
-			return VM_FAULT_SIGBUS;
-		else if (unlikely(vmf.page == NOPAGE_OOM))
-			return VM_FAULT_OOM;
-	}
+	ret = vma->vm_ops->fault(vma, &vmf);
+	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
+		return ret;
 
 	/*
 	 * For consistency in subsequent calls, make the faulted page always
@@ -2458,7 +2446,7 @@ static inline int handle_pte_fault(struc
 	if (!pte_present(entry)) {
 		if (pte_none(entry)) {
 			if (vma->vm_ops) {
-				if (vma->vm_ops->fault || vma->vm_ops->nopage)
+				if (likely(vma->vm_ops->fault))
 					return do_linear_fault(mm, vma, address,
 						pte, pmd, write_access, entry);
 				if (unlikely(vma->vm_ops->nopfn))
diff -puN mm/mincore.c~mm-remove-nopage mm/mincore.c
--- a/mm/mincore.c~mm-remove-nopage
+++ a/mm/mincore.c
@@ -33,7 +33,7 @@ static unsigned char mincore_page(struct
 	 * When tmpfs swaps out a page from a file, any process mapping that
 	 * file will not get a swp_entry_t in its pte, but rather it is like
 	 * any other file mapping (ie. marked !present and faulted in with
-	 * tmpfs's .nopage). So swapped out tmpfs mappings are tested here.
+	 * tmpfs's .fault). So swapped out tmpfs mappings are tested here.
 	 *
 	 * However when tmpfs moves the page from pagecache and into swapcache,
 	 * it is still in core, but the find_get_page below won't find it.
diff -puN mm/rmap.c~mm-remove-nopage mm/rmap.c
--- a/mm/rmap.c~mm-remove-nopage
+++ a/mm/rmap.c
@@ -662,7 +662,6 @@ void page_remove_rmap(struct page *page,
 			printk (KERN_EMERG "  page->mapping = %p\n", page->mapping);
 			print_symbol (KERN_EMERG "  vma->vm_ops = %s\n", (unsigned long)vma->vm_ops);
 			if (vma->vm_ops) {
-				print_symbol (KERN_EMERG "  vma->vm_ops->nopage = %s\n", (unsigned long)vma->vm_ops->nopage);
 				print_symbol (KERN_EMERG "  vma->vm_ops->fault = %s\n", (unsigned long)vma->vm_ops->fault);
 			}
 			if (vma->vm_file && vma->vm_file->f_op)
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
git-kvm.patch
fuse-implement-perform_write.patch
reiser4.patch
reiser4-correct-references-to-filemap_nopage.patch
likeliness-accounting-change-and-cleanup.patch


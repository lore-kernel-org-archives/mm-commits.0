From: akpm@linux-foundation.org
Subject: [merged] mm-nommu-refactor-debug-and-warning-prints.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:38:46 -0700
Message-ID: <5591acd6.ueQo6kPrI+pDUzUE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbbF2Uiq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:38:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leon@leon.nu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: nommu: refactor debug and warning prints
has been removed from the -mm tree.  Its filename was
     mm-nommu-refactor-debug-and-warning-prints.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Leon Romanovsky <leon@leon.nu>
Subject: mm: nommu: refactor debug and warning prints

kenter/kleave/kdebug are wrapper macros to print functions flow and debug
information.  This set was written before pr_devel() was introduced, so it
was controlled by "#if 0" construction.  It is questionable if anyone is
using them [1] now.

This patch removes these macros, converts numerous printk(KERN_WARNING,
...) to use general pr_warn(...) and removes debug print line from
validate_mmap_request() function.

Signed-off-by: Leon Romanovsky <leon@leon.nu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |  112 +++++++++------------------------------------------
 1 file changed, 20 insertions(+), 92 deletions(-)

diff -puN mm/nommu.c~mm-nommu-refactor-debug-and-warning-prints mm/nommu.c
--- a/mm/nommu.c~mm-nommu-refactor-debug-and-warning-prints
+++ a/mm/nommu.c
@@ -42,22 +42,6 @@
 #include <asm/mmu_context.h>
 #include "internal.h"
 
-#if 0
-#define kenter(FMT, ...) \
-	printk(KERN_DEBUG "==> %s("FMT")\n", __func__, ##__VA_ARGS__)
-#define kleave(FMT, ...) \
-	printk(KERN_DEBUG "<== %s()"FMT"\n", __func__, ##__VA_ARGS__)
-#define kdebug(FMT, ...) \
-	printk(KERN_DEBUG "xxx" FMT"yyy\n", ##__VA_ARGS__)
-#else
-#define kenter(FMT, ...) \
-	no_printk(KERN_DEBUG "==> %s("FMT")\n", __func__, ##__VA_ARGS__)
-#define kleave(FMT, ...) \
-	no_printk(KERN_DEBUG "<== %s()"FMT"\n", __func__, ##__VA_ARGS__)
-#define kdebug(FMT, ...) \
-	no_printk(KERN_DEBUG FMT"\n", ##__VA_ARGS__)
-#endif
-
 void *high_memory;
 EXPORT_SYMBOL(high_memory);
 struct page *mem_map;
@@ -665,11 +649,7 @@ static void free_page_series(unsigned lo
 	for (; from < to; from += PAGE_SIZE) {
 		struct page *page = virt_to_page(from);
 
-		kdebug("- free %lx", from);
 		atomic_long_dec(&mmap_pages_allocated);
-		if (page_count(page) != 1)
-			kdebug("free page %p: refcount not one: %d",
-			       page, page_count(page));
 		put_page(page);
 	}
 }
@@ -683,8 +663,6 @@ static void free_page_series(unsigned lo
 static void __put_nommu_region(struct vm_region *region)
 	__releases(nommu_region_sem)
 {
-	kenter("%p{%d}", region, region->vm_usage);
-
 	BUG_ON(!nommu_region_tree.rb_node);
 
 	if (--region->vm_usage == 0) {
@@ -697,10 +675,8 @@ static void __put_nommu_region(struct vm
 
 		/* IO memory and memory shared directly out of the pagecache
 		 * from ramfs/tmpfs mustn't be released here */
-		if (region->vm_flags & VM_MAPPED_COPY) {
-			kdebug("free series");
+		if (region->vm_flags & VM_MAPPED_COPY)
 			free_page_series(region->vm_start, region->vm_top);
-		}
 		kmem_cache_free(vm_region_jar, region);
 	} else {
 		up_write(&nommu_region_sem);
@@ -744,8 +720,6 @@ static void add_vma_to_mm(struct mm_stru
 	struct address_space *mapping;
 	struct rb_node **p, *parent, *rb_prev;
 
-	kenter(",%p", vma);
-
 	BUG_ON(!vma->vm_region);
 
 	mm->map_count++;
@@ -813,8 +787,6 @@ static void delete_vma_from_mm(struct vm
 	struct mm_struct *mm = vma->vm_mm;
 	struct task_struct *curr = current;
 
-	kenter("%p", vma);
-
 	protect_vma(vma, 0);
 
 	mm->map_count--;
@@ -854,7 +826,6 @@ static void delete_vma_from_mm(struct vm
  */
 static void delete_vma(struct mm_struct *mm, struct vm_area_struct *vma)
 {
-	kenter("%p", vma);
 	if (vma->vm_ops && vma->vm_ops->close)
 		vma->vm_ops->close(vma);
 	if (vma->vm_file)
@@ -957,12 +928,8 @@ static int validate_mmap_request(struct
 	int ret;
 
 	/* do the simple checks first */
-	if (flags & MAP_FIXED) {
-		printk(KERN_DEBUG
-		       "%d: Can't do fixed-address/overlay mmap of RAM\n",
-		       current->pid);
+	if (flags & MAP_FIXED)
 		return -EINVAL;
-	}
 
 	if ((flags & MAP_TYPE) != MAP_PRIVATE &&
 	    (flags & MAP_TYPE) != MAP_SHARED)
@@ -1060,8 +1027,7 @@ static int validate_mmap_request(struct
 			    ) {
 				capabilities &= ~NOMMU_MAP_DIRECT;
 				if (flags & MAP_SHARED) {
-					printk(KERN_WARNING
-					       "MAP_SHARED not completely supported on !MMU\n");
+					pr_warn("MAP_SHARED not completely supported on !MMU\n");
 					return -EINVAL;
 				}
 			}
@@ -1205,16 +1171,12 @@ static int do_mmap_private(struct vm_are
 	 *   we're allocating is smaller than a page
 	 */
 	order = get_order(len);
-	kdebug("alloc order %d for %lx", order, len);
-
 	total = 1 << order;
 	point = len >> PAGE_SHIFT;
 
 	/* we don't want to allocate a power-of-2 sized page set */
-	if (sysctl_nr_trim_pages && total - point >= sysctl_nr_trim_pages) {
+	if (sysctl_nr_trim_pages && total - point >= sysctl_nr_trim_pages)
 		total = point;
-		kdebug("try to alloc exact %lu pages", total);
-	}
 
 	base = alloc_pages_exact(total << PAGE_SHIFT, GFP_KERNEL);
 	if (!base)
@@ -1285,18 +1247,14 @@ unsigned long do_mmap_pgoff(struct file
 	unsigned long capabilities, vm_flags, result;
 	int ret;
 
-	kenter(",%lx,%lx,%lx,%lx,%lx", addr, len, prot, flags, pgoff);
-
 	*populate = 0;
 
 	/* decide whether we should attempt the mapping, and if so what sort of
 	 * mapping */
 	ret = validate_mmap_request(file, addr, len, prot, flags, pgoff,
 				    &capabilities);
-	if (ret < 0) {
-		kleave(" = %d [val]", ret);
+	if (ret < 0)
 		return ret;
-	}
 
 	/* we ignore the address hint */
 	addr = 0;
@@ -1383,11 +1341,9 @@ unsigned long do_mmap_pgoff(struct file
 			vma->vm_start = start;
 			vma->vm_end = start + len;
 
-			if (pregion->vm_flags & VM_MAPPED_COPY) {
-				kdebug("share copy");
+			if (pregion->vm_flags & VM_MAPPED_COPY)
 				vma->vm_flags |= VM_MAPPED_COPY;
-			} else {
-				kdebug("share mmap");
+			else {
 				ret = do_mmap_shared_file(vma);
 				if (ret < 0) {
 					vma->vm_region = NULL;
@@ -1467,7 +1423,6 @@ share:
 
 	up_write(&nommu_region_sem);
 
-	kleave(" = %lx", result);
 	return result;
 
 error_just_free:
@@ -1479,27 +1434,24 @@ error:
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	kmem_cache_free(vm_area_cachep, vma);
-	kleave(" = %d", ret);
 	return ret;
 
 sharing_violation:
 	up_write(&nommu_region_sem);
-	printk(KERN_WARNING "Attempt to share mismatched mappings\n");
+	pr_warn("Attempt to share mismatched mappings\n");
 	ret = -EINVAL;
 	goto error;
 
 error_getting_vma:
 	kmem_cache_free(vm_region_jar, region);
-	printk(KERN_WARNING "Allocation of vma for %lu byte allocation"
-	       " from process %d failed\n",
-	       len, current->pid);
+	pr_warn("Allocation of vma for %lu byte allocation from process %d failed\n",
+			len, current->pid);
 	show_free_areas(0);
 	return -ENOMEM;
 
 error_getting_region:
-	printk(KERN_WARNING "Allocation of vm region for %lu byte allocation"
-	       " from process %d failed\n",
-	       len, current->pid);
+	pr_warn("Allocation of vm region for %lu byte allocation from process %d failed\n",
+			len, current->pid);
 	show_free_areas(0);
 	return -ENOMEM;
 }
@@ -1563,8 +1515,6 @@ int split_vma(struct mm_struct *mm, stru
 	struct vm_region *region;
 	unsigned long npages;
 
-	kenter("");
-
 	/* we're only permitted to split anonymous regions (these should have
 	 * only a single usage on the region) */
 	if (vma->vm_file)
@@ -1628,8 +1578,6 @@ static int shrink_vma(struct mm_struct *
 {
 	struct vm_region *region;
 
-	kenter("");
-
 	/* adjust the VMA's pointers, which may reposition it in the MM's tree
 	 * and list */
 	delete_vma_from_mm(vma);
@@ -1669,8 +1617,6 @@ int do_munmap(struct mm_struct *mm, unsi
 	unsigned long end;
 	int ret;
 
-	kenter(",%lx,%zx", start, len);
-
 	len = PAGE_ALIGN(len);
 	if (len == 0)
 		return -EINVAL;
@@ -1682,11 +1628,9 @@ int do_munmap(struct mm_struct *mm, unsi
 	if (!vma) {
 		static int limit;
 		if (limit < 5) {
-			printk(KERN_WARNING
-			       "munmap of memory not mmapped by process %d"
-			       " (%s): 0x%lx-0x%lx\n",
-			       current->pid, current->comm,
-			       start, start + len - 1);
+			pr_warn("munmap of memory not mmapped by process %d (%s): 0x%lx-0x%lx\n",
+					current->pid, current->comm,
+					start, start + len - 1);
 			limit++;
 		}
 		return -EINVAL;
@@ -1695,38 +1639,27 @@ int do_munmap(struct mm_struct *mm, unsi
 	/* we're allowed to split an anonymous VMA but not a file-backed one */
 	if (vma->vm_file) {
 		do {
-			if (start > vma->vm_start) {
-				kleave(" = -EINVAL [miss]");
+			if (start > vma->vm_start)
 				return -EINVAL;
-			}
 			if (end == vma->vm_end)
 				goto erase_whole_vma;
 			vma = vma->vm_next;
 		} while (vma);
-		kleave(" = -EINVAL [split file]");
 		return -EINVAL;
 	} else {
 		/* the chunk must be a subset of the VMA found */
 		if (start == vma->vm_start && end == vma->vm_end)
 			goto erase_whole_vma;
-		if (start < vma->vm_start || end > vma->vm_end) {
-			kleave(" = -EINVAL [superset]");
+		if (start < vma->vm_start || end > vma->vm_end)
 			return -EINVAL;
-		}
-		if (start & ~PAGE_MASK) {
-			kleave(" = -EINVAL [unaligned start]");
+		if (start & ~PAGE_MASK)
 			return -EINVAL;
-		}
-		if (end != vma->vm_end && end & ~PAGE_MASK) {
-			kleave(" = -EINVAL [unaligned split]");
+		if (end != vma->vm_end && end & ~PAGE_MASK)
 			return -EINVAL;
-		}
 		if (start != vma->vm_start && end != vma->vm_end) {
 			ret = split_vma(mm, vma, start, 1);
-			if (ret < 0) {
-				kleave(" = %d [split]", ret);
+			if (ret < 0)
 				return ret;
-			}
 		}
 		return shrink_vma(mm, vma, start, end);
 	}
@@ -1734,7 +1667,6 @@ int do_munmap(struct mm_struct *mm, unsi
 erase_whole_vma:
 	delete_vma_from_mm(vma);
 	delete_vma(mm, vma);
-	kleave(" = 0");
 	return 0;
 }
 EXPORT_SYMBOL(do_munmap);
@@ -1766,8 +1698,6 @@ void exit_mmap(struct mm_struct *mm)
 	if (!mm)
 		return;
 
-	kenter("");
-
 	mm->total_vm = 0;
 
 	while ((vma = mm->mmap)) {
@@ -1776,8 +1706,6 @@ void exit_mmap(struct mm_struct *mm)
 		delete_vma(mm, vma);
 		cond_resched();
 	}

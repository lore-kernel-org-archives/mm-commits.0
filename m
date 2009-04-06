From: akpm@linux-foundation.org
Subject: [merged] nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:32:17 -0700
Message-ID: <200904061932.n36JWH95010655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754245AbZDFTex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:34:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, akpm@linux-foundation.org, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     nommu: fix a number of issues with the per-MM VMA patch
has been removed from the -mm tree.  Its filename was
     nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: fix a number of issues with the per-MM VMA patch
From: David Howells <dhowells@redhat.com>

Fix a number of issues with the per-MM VMA patch:

 (1) Make mmap_pages_allocated an atomic_long_t, just in case this is used on
     a NOMMU system with more than 2G pages.  Makes no difference on a 32-bit
     system.

 (2) Report vma->vm_pgoff * PAGE_SIZE as a 64-bit value, not a 32-bit value,
     lest it overflow.

 (3) Move the allocation of the vm_area_struct slab back for fork.c.

 (4) Use KMEM_CACHE() for both vm_area_struct and vm_region slabs.

 (5) Use BUG_ON() rather than if () BUG().

 (6) Make the default validate_nommu_regions() a static inline rather than a
     #define.

 (7) Make free_page_series()'s objection to pages with a refcount != 1 more
     informative.

 (8) Adjust the __put_nommu_region() banner comment to indicate that the
     semaphore must be held for writing.

 (9) Limit the number of warnings about munmaps of non-mmapped regions.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c    |    2 -
 fs/proc/task_nommu.c |    4 +--
 include/linux/mm.h   |    2 -
 kernel/fork.c        |    1 
 mm/mmap.c            |    3 --
 mm/nommu.c           |   52 +++++++++++++++++++----------------------
 6 files changed, 30 insertions(+), 34 deletions(-)

diff -puN fs/proc/meminfo.c~nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch
+++ a/fs/proc/meminfo.c
@@ -120,7 +120,7 @@ static int meminfo_proc_show(struct seq_
 		K(i.freeram-i.freehigh),
 #endif
 #ifndef CONFIG_MMU
-		K((unsigned long) atomic_read(&mmap_pages_allocated)),
+		K((unsigned long) atomic_long_read(&mmap_pages_allocated)),
 #endif
 		K(i.totalswap),
 		K(i.freeswap),
diff -puN fs/proc/task_nommu.c~nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch
+++ a/fs/proc/task_nommu.c
@@ -136,14 +136,14 @@ static int nommu_vma_show(struct seq_fil
 	}
 
 	seq_printf(m,
-		   "%08lx-%08lx %c%c%c%c %08lx %02x:%02x %lu %n",
+		   "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
 		   vma->vm_start,
 		   vma->vm_end,
 		   flags & VM_READ ? 'r' : '-',
 		   flags & VM_WRITE ? 'w' : '-',
 		   flags & VM_EXEC ? 'x' : '-',
 		   flags & VM_MAYSHARE ? flags & VM_SHARED ? 'S' : 's' : 'p',
-		   vma->vm_pgoff << PAGE_SHIFT,
+		   (unsigned long long) vma->vm_pgoff << PAGE_SHIFT,
 		   MAJOR(dev), MINOR(dev), ino, &len);
 
 	if (file) {
diff -puN include/linux/mm.h~nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch include/linux/mm.h
--- a/include/linux/mm.h~nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch
+++ a/include/linux/mm.h
@@ -1079,7 +1079,7 @@ static inline void setup_per_cpu_pageset
 #endif
 
 /* nommu.c */
-extern atomic_t mmap_pages_allocated;
+extern atomic_long_t mmap_pages_allocated;
 
 /* prio_tree.c */
 void vma_prio_tree_add(struct vm_area_struct *, struct vm_area_struct *old);
diff -puN kernel/fork.c~nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch kernel/fork.c
--- a/kernel/fork.c~nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch
+++ a/kernel/fork.c
@@ -1488,6 +1488,7 @@ void __init proc_caches_init(void)
 	mm_cachep = kmem_cache_create("mm_struct",
 			sizeof(struct mm_struct), ARCH_MIN_MMSTRUCT_ALIGN,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+	vm_area_cachep = KMEM_CACHE(vm_area_struct, SLAB_PANIC);
 	mmap_init();
 }
 
diff -puN mm/mmap.c~nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch mm/mmap.c
--- a/mm/mmap.c~nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch
+++ a/mm/mmap.c
@@ -2481,7 +2481,4 @@ void mm_drop_all_locks(struct mm_struct 
  */
 void __init mmap_init(void)
 {
-	vm_area_cachep = kmem_cache_create("vm_area_struct",
-			sizeof(struct vm_area_struct), 0,
-			SLAB_PANIC, NULL);
 }
diff -puN mm/nommu.c~nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch mm/nommu.c
--- a/mm/nommu.c~nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch
+++ a/mm/nommu.c
@@ -69,7 +69,7 @@ int sysctl_max_map_count = DEFAULT_MAX_M
 int sysctl_nr_trim_pages = 1; /* page trimming behaviour */
 int heap_stack_gap = 0;
 
-atomic_t mmap_pages_allocated;
+atomic_long_t mmap_pages_allocated;
 
 EXPORT_SYMBOL(mem_map);
 EXPORT_SYMBOL(num_physpages);
@@ -463,12 +463,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
  */
 void __init mmap_init(void)
 {
-	vm_region_jar = kmem_cache_create("vm_region_jar",
-					  sizeof(struct vm_region), 0,
-					  SLAB_PANIC, NULL);
-	vm_area_cachep = kmem_cache_create("vm_area_struct",
-					   sizeof(struct vm_area_struct), 0,
-					   SLAB_PANIC, NULL);
+	vm_region_jar = KMEM_CACHE(vm_region, SLAB_PANIC);
 }
 
 /*
@@ -486,27 +481,24 @@ static noinline void validate_nommu_regi
 		return;
 
 	last = rb_entry(lastp, struct vm_region, vm_rb);
-	if (unlikely(last->vm_end <= last->vm_start))
-		BUG();
-	if (unlikely(last->vm_top < last->vm_end))
-		BUG();
+	BUG_ON(unlikely(last->vm_end <= last->vm_start));
+	BUG_ON(unlikely(last->vm_top < last->vm_end));
 
 	while ((p = rb_next(lastp))) {
 		region = rb_entry(p, struct vm_region, vm_rb);
 		last = rb_entry(lastp, struct vm_region, vm_rb);
 
-		if (unlikely(region->vm_end <= region->vm_start))
-			BUG();
-		if (unlikely(region->vm_top < region->vm_end))
-			BUG();
-		if (unlikely(region->vm_start < last->vm_top))
-			BUG();
+		BUG_ON(unlikely(region->vm_end <= region->vm_start));
+		BUG_ON(unlikely(region->vm_top < region->vm_end));
+		BUG_ON(unlikely(region->vm_start < last->vm_top));
 
 		lastp = p;
 	}
 }
 #else
-#define validate_nommu_regions() do {} while(0)
+static void validate_nommu_regions(void)
+{
+}
 #endif
 
 /*
@@ -563,16 +555,17 @@ static void free_page_series(unsigned lo
 		struct page *page = virt_to_page(from);
 
 		kdebug("- free %lx", from);
-		atomic_dec(&mmap_pages_allocated);
+		atomic_long_dec(&mmap_pages_allocated);
 		if (page_count(page) != 1)
-			kdebug("free page %p [%d]", page, page_count(page));
+			kdebug("free page %p: refcount not one: %d",
+			       page, page_count(page));
 		put_page(page);
 	}
 }
 
 /*
  * release a reference to a region
- * - the caller must hold the region semaphore, which this releases
+ * - the caller must hold the region semaphore for writing, which this releases
  * - the region may not have been added to the tree yet, in which case vm_top
  *   will equal vm_start
  */
@@ -1096,7 +1089,7 @@ static int do_mmap_private(struct vm_are
 		goto enomem;
 
 	total = 1 << order;
-	atomic_add(total, &mmap_pages_allocated);
+	atomic_long_add(total, &mmap_pages_allocated);
 
 	point = rlen >> PAGE_SHIFT;
 
@@ -1107,7 +1100,7 @@ static int do_mmap_private(struct vm_are
 			order = ilog2(total - point);
 			n = 1 << order;
 			kdebug("shave %lu/%lu @%lu", n, total - point, total);
-			atomic_sub(n, &mmap_pages_allocated);
+			atomic_long_sub(n, &mmap_pages_allocated);
 			total -= n;
 			set_page_refcounted(pages + total);
 			__free_pages(pages + total, order);
@@ -1536,10 +1529,15 @@ int do_munmap(struct mm_struct *mm, unsi
 	/* find the first potentially overlapping VMA */
 	vma = find_vma(mm, start);
 	if (!vma) {
-		printk(KERN_WARNING
-		       "munmap of memory not mmapped by process %d (%s):"
-		       " 0x%lx-0x%lx\n",
-		       current->pid, current->comm, start, start + len - 1);
+		static int limit = 0;
+		if (limit < 5) {
+			printk(KERN_WARNING
+			       "munmap of memory not mmapped by process %d"
+			       " (%s): 0x%lx-0x%lx\n",
+			       current->pid, current->comm,
+			       start, start + len - 1);
+			limit++;
+		}
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
frv-fix-compile-breakage.patch
linux-next.patch
kbuild-make-it-possible-for-the-linker-to-discard-local-symbols-from-vmlinux.patch
frv-duplicate-output_buffer-of-e03.patch
flat-fix-data-sections-alignment.patch
mutex-subsystem-synchro-test-module.patch


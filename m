From: akpm@linux-foundation.org
Subject: [merged] nommu-struct-vm_regions-vm_usage-count-need-not-be-atomic.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:28:09 -0800
Message-ID: <201001212128.o0LLS90N030702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755337Ab0AUV23 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:28:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, gerg@snapgear.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     nommu: struct vm_region's vm_usage count need not be atomic
has been removed from the -mm tree.  Its filename was
     nommu-struct-vm_regions-vm_usage-count-need-not-be-atomic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: struct vm_region's vm_usage count need not be atomic
From: David Howells <dhowells@redhat.com>

The vm_usage count field in struct vm_region does not need to be atomic as
it's only even modified whilst nommu_region_sem is write locked.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 +-
 mm/nommu.c               |   14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN include/linux/mm_types.h~nommu-struct-vm_regions-vm_usage-count-need-not-be-atomic include/linux/mm_types.h
--- a/include/linux/mm_types.h~nommu-struct-vm_regions-vm_usage-count-need-not-be-atomic
+++ a/include/linux/mm_types.h
@@ -122,7 +122,7 @@ struct vm_region {
 	unsigned long	vm_pgoff;	/* the offset in vm_file corresponding to vm_start */
 	struct file	*vm_file;	/* the backing file or NULL */
 
-	atomic_t	vm_usage;	/* region usage count */
+	int		vm_usage;	/* region usage count (access under nommu_region_sem) */
 	bool		vm_icache_flushed : 1; /* true if the icache has been flushed for
 						* this region */
 };
diff -puN mm/nommu.c~nommu-struct-vm_regions-vm_usage-count-need-not-be-atomic mm/nommu.c
--- a/mm/nommu.c~nommu-struct-vm_regions-vm_usage-count-need-not-be-atomic
+++ a/mm/nommu.c
@@ -552,11 +552,11 @@ static void free_page_series(unsigned lo
 static void __put_nommu_region(struct vm_region *region)
 	__releases(nommu_region_sem)
 {
-	kenter("%p{%d}", region, atomic_read(&region->vm_usage));
+	kenter("%p{%d}", region, region->vm_usage);
 
 	BUG_ON(!nommu_region_tree.rb_node);
 
-	if (atomic_dec_and_test(&region->vm_usage)) {
+	if (--region->vm_usage == 0) {
 		if (region->vm_top > region->vm_start)
 			delete_nommu_region(region);
 		up_write(&nommu_region_sem);
@@ -1205,7 +1205,7 @@ unsigned long do_mmap_pgoff(struct file 
 	if (!vma)
 		goto error_getting_vma;
 
-	atomic_set(&region->vm_usage, 1);
+	region->vm_usage = 1;
 	region->vm_flags = vm_flags;
 	region->vm_pgoff = pgoff;
 
@@ -1272,7 +1272,7 @@ unsigned long do_mmap_pgoff(struct file 
 			}
 
 			/* we've found a region we can share */
-			atomic_inc(&pregion->vm_usage);
+			pregion->vm_usage++;
 			vma->vm_region = pregion;
 			start = pregion->vm_start;
 			start += (pgoff - pregion->vm_pgoff) << PAGE_SHIFT;
@@ -1289,7 +1289,7 @@ unsigned long do_mmap_pgoff(struct file 
 					vma->vm_region = NULL;
 					vma->vm_start = 0;
 					vma->vm_end = 0;
-					atomic_dec(&pregion->vm_usage);
+					pregion->vm_usage--;
 					pregion = NULL;
 					goto error_just_free;
 				}
@@ -1444,7 +1444,7 @@ int split_vma(struct mm_struct *mm, stru
 	/* we're only permitted to split anonymous regions that have a single
 	 * owner */
 	if (vma->vm_file ||
-	    atomic_read(&vma->vm_region->vm_usage) != 1)
+	    vma->vm_region->vm_usage != 1)
 		return -ENOMEM;
 
 	if (mm->map_count >= sysctl_max_map_count)
@@ -1518,7 +1518,7 @@ static int shrink_vma(struct mm_struct *
 
 	/* cut the backing region down to size */
 	region = vma->vm_region;
-	BUG_ON(atomic_read(&region->vm_usage) != 1);
+	BUG_ON(region->vm_usage != 1);
 
 	down_write(&nommu_region_sem);
 	delete_nommu_region(region);
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
kernel-credc-use-kmem_cache_free.patch
frv-duplicate-output_buffer-of-e03.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch


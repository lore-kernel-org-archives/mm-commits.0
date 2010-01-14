From: akpm@linux-foundation.org
Subject: + nommu-struct-vm_regions-vm_usage-count-need-not-be-atomic.patch added to -mm tree
Date: Thu, 14 Jan 2010 15:34:38 -0800
Message-ID: <201001142334.o0ENYcxq006399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756899Ab0ANXfB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 18:35:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, gerg@snapgear.com, viro@zeniv.linux.org.uk


The patch titled
     nommu: struct vm_region's vm_usage count need not be atomic
has been added to the -mm tree.  Its filename is
     nommu-struct-vm_regions-vm_usage-count-need-not-be-atomic.patch

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

nommu-fix-sysv-shm-for-nommu.patch
nommu-struct-vm_regions-vm_usage-count-need-not-be-atomic.patch
nommu-remove-a-superfluous-check-of-vm_region-vm_usage.patch
nommu-dont-need-get_unmapped_area-for-nommu.patch
nommu-fix-race-between-ramfs-truncation-and-shared-mmap.patch
nommu-fix-shared-mmap-after-truncate-shrinkage-problems.patch
kernel-credc-use-kmem_cache_free.patch
nfs-avoid-warnings-when-config_nfs_v4=n.patch
frv-duplicate-output_buffer-of-e03.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch


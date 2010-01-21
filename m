From: akpm@linux-foundation.org
Subject: [merged] nommu-fix-race-between-ramfs-truncation-and-shared-mmap.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:28:18 -0800
Message-ID: <201001212128.o0LLSIJM030711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755331Ab0AUV2e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:28:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, gerg@snapgear.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     nommu: fix race between ramfs truncation and shared mmap
has been removed from the -mm tree.  Its filename was
     nommu-fix-race-between-ramfs-truncation-and-shared-mmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: fix race between ramfs truncation and shared mmap
From: David Howells <dhowells@redhat.com>

Fix the race between the truncation of a ramfs file and an attempt to make
a shared mmap of region of that file.

The problem is that do_mmap_pgoff() calls f_op->get_unmapped_area() to
verify that the file region is made of contiguous pages and to find its
base address - but there isn't any locking to guarantee this region until
vma_prio_tree_insert() is called by add_vma_to_mm().

Note that moving the functionality into f_op->mmap() doesn't help as that
is also called before vma_prio_tree_insert().

Instead make ramfs_nommu_check_mappings() grab nommu_region_sem whilst it
does its checks.  This means that this function will wait whilst mmaps
take place.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/ramfs/file-nommu.c~nommu-fix-race-between-ramfs-truncation-and-shared-mmap fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~nommu-fix-race-between-ramfs-truncation-and-shared-mmap
+++ a/fs/ramfs/file-nommu.c
@@ -131,6 +131,8 @@ static int ramfs_nommu_check_mappings(st
 	struct vm_area_struct *vma;
 	struct prio_tree_iter iter;
 
+	down_write(&nommu_region_sem);
+
 	/* search for VMAs that fall within the dead zone */
 	vma_prio_tree_foreach(vma, &iter, &inode->i_mapping->i_mmap,
 			      newsize >> PAGE_SHIFT,
@@ -138,10 +140,13 @@ static int ramfs_nommu_check_mappings(st
 			      ) {
 		/* found one - only interested if it's shared out of the page
 		 * cache */
-		if (vma->vm_flags & VM_SHARED)
+		if (vma->vm_flags & VM_SHARED) {
+			up_write(&nommu_region_sem);
 			return -ETXTBSY; /* not quite true, but near enough */
+		}
 	}
 
+	up_write(&nommu_region_sem);
 	return 0;
 }
 
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


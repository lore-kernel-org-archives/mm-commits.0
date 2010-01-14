From: akpm@linux-foundation.org
Subject: + nommu-fix-race-between-ramfs-truncation-and-shared-mmap.patch added to -mm tree
Date: Thu, 14 Jan 2010 15:34:45 -0800
Message-ID: <201001142334.o0ENYjp9006408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757443Ab0ANXfJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 18:35:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, gerg@snapgear.com, viro@zeniv.linux.org.uk


The patch titled
     nommu: fix race between ramfs truncation and shared mmap
has been added to the -mm tree.  Its filename is
     nommu-fix-race-between-ramfs-truncation-and-shared-mmap.patch

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


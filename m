From: akpm@linux-foundation.org
Subject: + nommu-remove-a-superfluous-check-of-vm_region-vm_usage.patch added to -mm tree
Date: Thu, 14 Jan 2010 15:34:40 -0800
Message-ID: <201001142334.o0ENYekx006402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757253Ab0ANXfD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 18:35:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, gerg@snapgear.com, viro@zeniv.linux.org.uk


The patch titled
     nommu: remove a superfluous check of vm_region::vm_usage
has been added to the -mm tree.  Its filename is
     nommu-remove-a-superfluous-check-of-vm_region-vm_usage.patch

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
Subject: nommu: remove a superfluous check of vm_region::vm_usage
From: David Howells <dhowells@redhat.com>

In split_vma(), there's no need to check if the VMA being split has a
region that's in use by more than one VMA because:

 (1) The preceding test prohibits splitting of non-anonymous VMAs and regions
     (eg: file or chardev backed VMAs).

 (2) Anonymous regions can't be mapped multiple times because there's no handle
     by which to refer to the already existing region.

 (3) If a VMA has previously been split, then the region backing it has also
     been split into two regions, each of usage 1.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/nommu.c~nommu-remove-a-superfluous-check-of-vm_region-vm_usage mm/nommu.c
--- a/mm/nommu.c~nommu-remove-a-superfluous-check-of-vm_region-vm_usage
+++ a/mm/nommu.c
@@ -1441,10 +1441,9 @@ int split_vma(struct mm_struct *mm, stru
 
 	kenter("");
 
-	/* we're only permitted to split anonymous regions that have a single
-	 * owner */
-	if (vma->vm_file ||
-	    vma->vm_region->vm_usage != 1)
+	/* we're only permitted to split anonymous regions (these should have
+	 * only a single usage on the region) */
+	if (vma->vm_file)
 		return -ENOMEM;
 
 	if (mm->map_count >= sysctl_max_map_count)
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


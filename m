From: akpm@linux-foundation.org
Subject: [merged] nommu-remove-a-superfluous-check-of-vm_region-vm_usage.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:28:12 -0800
Message-ID: <201001212128.o0LLSC2V030705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755339Ab0AUV2c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:28:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, gerg@snapgear.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     nommu: remove a superfluous check of vm_region::vm_usage
has been removed from the -mm tree.  Its filename was
     nommu-remove-a-superfluous-check-of-vm_region-vm_usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


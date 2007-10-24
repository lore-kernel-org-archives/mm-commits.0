From: akpm@linux-foundation.org
Subject: - fix-mprotect-vma_wants_writenotify-prot.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:41:06 -0700
Message-ID: <200710242141.l9OLf6A3013915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36393 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754570AbXJXVlR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:41:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, coyli@suse.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     fix mprotect vma_wants_writenotify prot
has been removed from the -mm tree.  Its filename was
     fix-mprotect-vma_wants_writenotify-prot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix mprotect vma_wants_writenotify prot
From: Hugh Dickins <hugh@veritas.com>

Fix mprotect bug in recent commit 3ed75eb8f1cd89565966599c4f77d2edb086d5b0
(setup vma->vm_page_prot by vm_get_page_prot()): the vma_wants_writenotify
case was setting the same prot as when not.

Nothing wrong with the use of protection_map[] in mmap_region(),
but use vm_get_page_prot() there too in the same ~VM_SHARED way.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Coly Li <coyli@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c     |    3 +--
 mm/mprotect.c |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/mmap.c~fix-mprotect-vma_wants_writenotify-prot mm/mmap.c
--- a/mm/mmap.c~fix-mprotect-vma_wants_writenotify-prot
+++ a/mm/mmap.c
@@ -1171,8 +1171,7 @@ munmap_back:
 	vm_flags = vma->vm_flags;
 
 	if (vma_wants_writenotify(vma))
-		vma->vm_page_prot =
-			protection_map[vm_flags & (VM_READ|VM_WRITE|VM_EXEC)];
+		vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
 
 	if (!file || !vma_merge(mm, prev, addr, vma->vm_end,
 			vma->vm_flags, NULL, file, pgoff, vma_policy(vma))) {
diff -puN mm/mprotect.c~fix-mprotect-vma_wants_writenotify-prot mm/mprotect.c
--- a/mm/mprotect.c~fix-mprotect-vma_wants_writenotify-prot
+++ a/mm/mprotect.c
@@ -194,7 +194,7 @@ success:
 	vma->vm_flags = newflags;
 	vma->vm_page_prot = vm_get_page_prot(newflags);
 	if (vma_wants_writenotify(vma)) {
-		vma->vm_page_prot = vm_get_page_prot(newflags);
+		vma->vm_page_prot = vm_get_page_prot(newflags & ~VM_SHARED);
 		dirty_accountable = 1;
 	}
 
_

Patches currently in -mm which might be from hugh@veritas.com are

swapin_readahead-excise-numa-bogosity.patch
swapin_readahead-move-and-rearrange-args.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
shmem-sgp_quick-and-sgp_fault-redundant.patch
shmem_getpage-return-page-locked.patch
shmem_file_write-is-redundant.patch
swapin-fix-valid_swaphandles-defect.patch
memory-controller-memory-accounting-v7.patch
prio_tree-debugging-patch.patch

From: akpm@linux-foundation.org
Subject: + fix-mprotect-vma_wants_writenotify-prot.patch added to -mm tree
Date: Mon, 22 Oct 2007 11:59:01 -0700
Message-ID: <200710221859.l9MIx1di008454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39524 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753014AbXJVS7K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Oct 2007 14:59:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, coyli@suse.de, tony.luck@intel.com


The patch titled
     fix mprotect vma_wants_writenotify prot
has been added to the -mm tree.  Its filename is
     fix-mprotect-vma_wants_writenotify-prot.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
shmem-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
fix-mprotect-vma_wants_writenotify-prot.patch
memory-controller-memory-accounting-v7.patch
prio_tree-debugging-patch.patch

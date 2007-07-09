From: akpm@linux-foundation.org
Subject: - mm-merge-nopfn-into-fault-spufs-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 13:37:49 -0700
Message-ID: <200707092037.l69KboFR009949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52632 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754411AbXGIUiE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 16:38:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, arnd@arndb.de, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm-merge-nopfn-into-fault spufs fix
has been removed from the -mm tree.  Its filename was
     mm-merge-nopfn-into-fault-spufs-fix.patch

This patch was dropped because it was folded into mm-merge-nopfn-into-fault.patch

------------------------------------------------------
Subject: mm-merge-nopfn-into-fault spufs fix
From: Cedric Le Goater <clg@fr.ibm.com>

Here's a tentative fix for mm-merge-nopfn-into-fault.patch.

./arch/powerpc/platforms/cell/spufs/file.c: In function 'spufs_mem_mmap_fault':
./arch/powerpc/platforms/cell/spufs/file.c:122: error: 'address' undeclared (first use in this function)
./arch/powerpc/platforms/cell/spufs/file.c:122: error: (Each undeclared identifier is reported only once
./arch/powerpc/platforms/cell/spufs/file.c:122: error: for each function it appears in.)
./arch/powerpc/platforms/cell/spufs/file.c:141: error: expected ';' before 'if'
./arch/powerpc/platforms/cell/spufs/file.c:122: warning: unused variable 'addr0'

I'm not sure how useful is the addr0 variable.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/file.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/file.c~mm-merge-nopfn-into-fault-spufs-fix arch/powerpc/platforms/cell/spufs/file.c
--- a/arch/powerpc/platforms/cell/spufs/file.c~mm-merge-nopfn-into-fault-spufs-fix
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -121,13 +121,13 @@ static struct page *spufs_mem_mmap_fault
 					  struct fault_data *fdata)
 {
 	struct spu_context *ctx	= vma->vm_file->private_data;
-	unsigned long pfn, offset, addr0 = address;
+	unsigned long pfn, offset, addr0 = fdata->address;
 #ifdef CONFIG_SPU_FS_64K_LS
 	struct spu_state *csa = &ctx->csa;
 	int psize;
 
 	/* Check what page size we are using */
-	psize = get_slice_psize(vma->vm_mm, address);
+	psize = get_slice_psize(vma->vm_mm, fdata->address);
 
 	/* Some sanity checking */
 	BUG_ON(csa->use_big_pages != (psize == MMU_PAGE_64K));
@@ -135,18 +135,18 @@ static struct page *spufs_mem_mmap_fault
 	/* Wow, 64K, cool, we need to align the address though */
 	if (csa->use_big_pages) {
 		BUG_ON(vma->vm_start & 0xffff);
-		address &= ~0xfffful;
+		fdata->address &= ~0xfffful;
 	}
 #endif /* CONFIG_SPU_FS_64K_LS */
 
-	offset = fdata->pgoff << PAGE_SHIFT
+	offset = fdata->pgoff << PAGE_SHIFT;
 	if (offset >= LS_SIZE) {
 		fdata->type = VM_FAULT_SIGBUS;
 		return NULL;
 	}
 
 	pr_debug("spufs_mem_mmap_nopfn address=0x%lx -> 0x%lx, offset=0x%lx\n",
-		 addr0, address, offset);
+		 addr0, fdata->address, offset);
 
 	spu_acquire(ctx);
 
_

Patches currently in -mm which might be from clg@fr.ibm.com are

mm-merge-nopfn-into-fault.patch
mm-merge-nopfn-into-fault-spufs-fix.patch
remove-config_uts_ns-and-config_ipc_ns.patch
user-namespace-add-the-framework.patch
user-namespace-add-unshare.patch
mm-fix-create_new_namespaces-return-value.patch
add-a-kmem_cache-for-nsproxy-objects.patch
namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long.patch
containersv10-add-tasks-file-interface-fix-2.patch

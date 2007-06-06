From: akpm@linux-foundation.org
Subject: + mm-merge-nopfn-into-fault-spufs-fix.patch added to -mm tree
Date: Wed, 06 Jun 2007 11:14:11 -0700
Message-ID: <200706061814.l56IEB3B003243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48652 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755394AbXFFSO0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 14:14:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clg@fr.ibm.com, arnd@arndb.de, npiggin@suse.de


The patch titled
     mm-merge-nopfn-into-fault spufs fix
has been added to the -mm tree.  Its filename is
     mm-merge-nopfn-into-fault-spufs-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 arch/powerpc/platforms/cell/spufs/file.c |   23 ++++-----------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/file.c~mm-merge-nopfn-into-fault-spufs-fix arch/powerpc/platforms/cell/spufs/file.c
--- a/arch/powerpc/platforms/cell/spufs/file.c~mm-merge-nopfn-into-fault-spufs-fix
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -53,19 +53,6 @@ spufs_mem_open(struct inode *inode, stru
 	return 0;
 }
 
-static int
-spufs_mem_release(struct inode *inode, struct file *file)
-{
-	struct spufs_inode_info *i = SPUFS_I(inode);
-	struct spu_context *ctx = i->i_ctx;
-
-	spin_lock(&ctx->mapping_lock);
-	if (!--i->i_openers)
-		ctx->local_store = NULL;
-	spin_unlock(&ctx->mapping_lock);
-	return 0;
-}
-
 static ssize_t
 __spufs_mem_read(struct spu_context *ctx, char __user *buffer,
 			size_t size, loff_t *pos)
@@ -119,13 +106,13 @@ static struct page *spufs_mem_mmap_fault
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
@@ -133,18 +120,18 @@ static struct page *spufs_mem_mmap_fault
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

mm-merge-nopfn-into-fault-spufs-fix.patch

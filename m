From: akpm@linux-foundation.org
Subject: [merged] arch-mips-alchemy-correct-code-taking-the-size-of-a-pointer.patch removed from -mm tree
Date: Wed, 13 Jan 2010 11:29:01 -0800
Message-ID: <201001131929.o0DJT1QM023834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724Ab0AMT3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 14:29:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     arch/mips/alchemy: correct code taking the size of a pointer
has been removed from the -mm tree.  Its filename was
     arch-mips-alchemy-correct-code-taking-the-size-of-a-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/mips/alchemy: correct code taking the size of a pointer
From: Julia Lawall <julia@diku.dk>

sizeof(dp) is just the size of the pointer.  Change it to the size of the
referenced structure.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *x;
expression f;
type T;
@@

*f(...,(T)x,...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/alchemy/common/dbdma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/mips/alchemy/common/dbdma.c~arch-mips-alchemy-correct-code-taking-the-size-of-a-pointer arch/mips/alchemy/common/dbdma.c
--- a/arch/mips/alchemy/common/dbdma.c~arch-mips-alchemy-correct-code-taking-the-size-of-a-pointer
+++ a/arch/mips/alchemy/common/dbdma.c
@@ -612,7 +612,7 @@ u32 au1xxx_dbdma_put_source(u32 chanid, 
 	dma_cache_wback_inv((unsigned long)buf, nbytes);
 	dp->dscr_cmd0 |= DSCR_CMD0_V;	/* Let it rip */
 	au_sync();
-	dma_cache_wback_inv((unsigned long)dp, sizeof(dp));
+	dma_cache_wback_inv((unsigned long)dp, sizeof(*dp));
 	ctp->chan_ptr->ddma_dbell = 0;
 
 	/* Get next descriptor pointer.	*/
@@ -674,7 +674,7 @@ u32 au1xxx_dbdma_put_dest(u32 chanid, dm
 	dma_cache_inv((unsigned long)buf, nbytes);
 	dp->dscr_cmd0 |= DSCR_CMD0_V;	/* Let it rip */
 	au_sync();
-	dma_cache_wback_inv((unsigned long)dp, sizeof(dp));
+	dma_cache_wback_inv((unsigned long)dp, sizeof(*dp));
 	ctp->chan_ptr->ddma_dbell = 0;
 
 	/* Get next descriptor pointer.	*/
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-scsi-sesc-eliminate-double-free.patch
kernel-credc-use-kmem_cache_free.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-gpu-drm-nouveau-nouveau_grctxc-correct-null-test.patch
drivers-media-video-move-dereference-after-null-test.patch
net-ipv4-correct-the-size-argument-to-kzalloc.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-staging-tm6000-tm6000-videoc-correct-null-test.patch
drivers-usb-correct-the-size-argument-to-kzalloc.patch
drivers-edac-introduce-missing-kfree.patch


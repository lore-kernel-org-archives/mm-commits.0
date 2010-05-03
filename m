From: akpm@linux-foundation.org
Subject: [merged] arch-arm-plat-pxa-dmac-correct-null-test.patch removed from -mm tree
Date: Mon, 03 May 2010 13:09:40 -0400
Message-ID: <201005032011.o43KBB4C019176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756660Ab0ECULv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 May 2010 16:11:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, eric.y.miao@gmail.com, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arch/arm/plat-pxa/dma.c: correct NULL test
has been removed from the -mm tree.  Its filename was
     arch-arm-plat-pxa-dmac-correct-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/arm/plat-pxa/dma.c: correct NULL test
From: Julia Lawall <julia@diku.dk>

Test the just-allocated value for NULL rather than some other value.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,y;
statement S;
@@

x = \(kmalloc\|kcalloc\|kzalloc\)(...);
(
if ((x) == NULL) S
|
if (
-   y
+   x
       == NULL)
 S
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-pxa/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/plat-pxa/dma.c~arch-arm-plat-pxa-dmac-correct-null-test arch/arm/plat-pxa/dma.c
--- a/arch/arm/plat-pxa/dma.c~arch-arm-plat-pxa-dmac-correct-null-test
+++ a/arch/arm/plat-pxa/dma.c
@@ -245,7 +245,7 @@ static void pxa_dma_init_debugfs(void)
 
 	dbgfs_chan = kmalloc(sizeof(*dbgfs_state) * num_dma_channels,
 			     GFP_KERNEL);
-	if (!dbgfs_state)
+	if (!dbgfs_chan)
 		goto err_alloc;
 
 	chandir = debugfs_create_dir("channels", dbgfs_root);
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
arch-x86-pci-use-kasprintf.patch
drivers-media-video-avoid-null-dereference.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-char-ppdevc-use-kasprintf.patch
drivers-edac-introduce-missing-kfree.patch


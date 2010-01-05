From: akpm@linux-foundation.org
Subject: [merged] drivers-net-can-mcp251xc-correct-null-test.patch removed from -mm tree
Date: Tue, 05 Jan 2010 13:12:41 -0800
Message-ID: <201001052112.o05LCfji019882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754722Ab0AEVMs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jan 2010 16:12:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, davem@davemloft.net, oliver.hartkopp@volkswagen.de, urs.thuermann@volkswagen.de, mm-commits@vger.kernel.org


The patch titled
     drivers/net/can/mcp251x.c: correct NULL test
has been removed from the -mm tree.  Its filename was
     drivers-net-can-mcp251xc-correct-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/can/mcp251x.c: correct NULL test
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
Cc: Urs Thuermann <urs.thuermann@volkswagen.de>
Cc: Oliver Hartkopp <oliver.hartkopp@volkswagen.de>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/can/mcp251x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/can/mcp251x.c~drivers-net-can-mcp251xc-correct-null-test drivers/net/can/mcp251x.c
--- a/drivers/net/can/mcp251x.c~drivers-net-can-mcp251xc-correct-null-test
+++ a/drivers/net/can/mcp251x.c
@@ -990,7 +990,7 @@ static int __devinit mcp251x_can_probe(s
 			goto error_tx_buf;
 		}
 		priv->spi_rx_buf = kmalloc(SPI_TRANSFER_BUF_LEN, GFP_KERNEL);
-		if (!priv->spi_tx_buf) {
+		if (!priv->spi_rx_buf) {
 			ret = -ENOMEM;
 			goto error_rx_buf;
 		}
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-scsi-sesc-eliminate-double-free.patch
kernel-credc-use-kmem_cache_free.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-gpu-drm-nouveau-nouveau_grctxc-correct-null-test.patch
drivers-media-video-move-dereference-after-null-test.patch
arch-mips-alchemy-correct-code-taking-the-size-of-a-pointer.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-staging-tm6000-tm6000-videoc-correct-null-test.patch
drivers-edac-introduce-missing-kfree.patch


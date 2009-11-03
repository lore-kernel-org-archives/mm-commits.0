From: akpm@linux-foundation.org
Subject: [merged] arch-arm-plat-s3c24xx-move-dereference-after-null-test.patch removed from -mm tree
Date: Tue, 03 Nov 2009 11:57:35 -0800
Message-ID: <200911031957.nA3JvZS6026591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176AbZKCT57 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 14:57:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, ben-linux@fluff.org, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arch/arm/plat-s3c24xx: Move dereference after NULL test
has been removed from the -mm tree.  Its filename was
     arch-arm-plat-s3c24xx-move-dereference-after-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/arm/plat-s3c24xx: Move dereference after NULL test
From: Julia Lawall <julia@diku.dk>

If the NULL test on buf is needed, then the dereference should be after the
NULL test.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-s3c24xx/dma.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/arm/plat-s3c24xx/dma.c~arch-arm-plat-s3c24xx-move-dereference-after-null-test arch/arm/plat-s3c24xx/dma.c
--- a/arch/arm/plat-s3c24xx/dma.c~arch-arm-plat-s3c24xx-move-dereference-after-null-test
+++ a/arch/arm/plat-s3c24xx/dma.c
@@ -208,14 +208,14 @@ s3c2410_dma_loadbuffer(struct s3c2410_dm
 {
 	unsigned long reload;
 
-	pr_debug("s3c2410_chan_loadbuffer: loading buff %p (0x%08lx,0x%06x)\n",
-		 buf, (unsigned long)buf->data, buf->size);
-
 	if (buf == NULL) {
 		dmawarn("buffer is NULL\n");
 		return -EINVAL;
 	}
 
+	pr_debug("s3c2410_chan_loadbuffer: loading buff %p (0x%08lx,0x%06x)\n",
+		 buf, (unsigned long)buf->data, buf->size);
+
 	/* check the state of the channel before we do anything */
 
 	if (chan->load_state == S3C2410_DMALOAD_1LOADED) {
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-acpi-move-dereference-after-null-test.patch
arch-arm-plat-omap-drop-an-unnecessary-null-test.patch
drivers-media-video-move-dereference-after-null-test.patch
drivers-ata-libata-move-dereference-after-null-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-block-dac960c-use-dac960_v2_controller.patch
drivers-cpuidle-move-dereference-after-null-test.patch
drivers-mmc-move-dereference-after-null-test.patch
drivers-video-move-dereference-after-null-test.patch
drivers-char-ipmi-use-kcs_idle_state.patch


From: akpm@linux-foundation.org
Subject: [merged] drm-count-reaches-1.patch removed from -mm tree
Date: Mon, 20 Apr 2009 11:35:21 -0700
Message-ID: <200904201835.n3KIZLVo012244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225AbZDTSxW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Apr 2009 14:53:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, airlied@linux.ie, eric@anholt.net, mm-commits@vger.kernel.org


The patch titled
     drm: count reaches -1
has been removed from the -mm tree.  Its filename was
     drm-count-reaches-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: count reaches -1
From: Roel Kluin <roel.kluin@gmail.com>

With a postfix decrement in the test count will reach -1 rather than 0,
subsequent tests fail.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Eric Anholt <eric@anholt.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/via/via_dma.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/gpu/drm/via/via_dma.c~drm-count-reaches-1 drivers/gpu/drm/via/via_dma.c
--- a/drivers/gpu/drm/via/via_dma.c~drm-count-reaches-1
+++ a/drivers/gpu/drm/via/via_dma.c
@@ -481,11 +481,13 @@ static int via_wait_idle(drm_via_private
 {
 	int count = 10000000;
 
-	while (!(VIA_READ(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY) && count--);
+	while (!(VIA_READ(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY) && --count)
+		;
 
-	while (count-- && (VIA_READ(VIA_REG_STATUS) &
+	while (count && (VIA_READ(VIA_REG_STATUS) &
 			   (VIA_CMD_RGTR_BUSY | VIA_2D_ENG_BUSY |
-			    VIA_3D_ENG_BUSY))) ;
+			    VIA_3D_ENG_BUSY)))
+		--count;
 	return count;
 }
 
@@ -705,7 +707,7 @@ static int via_cmdbuf_size(struct drm_de
 	switch (d_siz->func) {
 	case VIA_CMDBUF_SPACE:
 		while (((tmp_size = via_cmdbuf_space(dev_priv)) < d_siz->size)
-		       && count--) {
+		       && --count) {
 			if (!d_siz->wait) {
 				break;
 			}
@@ -717,7 +719,7 @@ static int via_cmdbuf_size(struct drm_de
 		break;
 	case VIA_CMDBUF_LAG:
 		while (((tmp_size = via_cmdbuf_lag(dev_priv)) > d_siz->size)
-		       && count--) {
+		       && --count) {
 			if (!d_siz->wait) {
 				break;
 			}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
spi-pxa2xx-limit-reaches-1.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
microblaze-iowrite-upon-timeout.patch
uwb-event_size-should-be-signed.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
bfin_5xx-misplaced-parentheses.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch


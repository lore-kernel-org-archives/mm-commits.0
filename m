From: akpm@linux-foundation.org
Subject: [merged] viafb-returns-0-two-too-early.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:57 -0700
Message-ID: <200904011843.n31Ihv00010228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758021AbZDATMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:12:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, josephchan@via.com.tw, mm-commits@vger.kernel.org


The patch titled
     viafb: returns 0 two too early
has been removed from the -mm tree.  Its filename was
     viafb-returns-0-two-too-early.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: returns 0 two too early
From: Roel Kluin <roel.kluin@gmail.com>

Otherwise this will already return 0 if iteration MAXLOOP-2 occurs in the
first loop.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Joseph Chan <josephchan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/accel.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/video/via/accel.c~viafb-returns-0-two-too-early drivers/video/via/accel.c
--- a/drivers/video/via/accel.c~viafb-returns-0-two-too-early
+++ a/drivers/video/via/accel.c
@@ -267,13 +267,17 @@ int viafb_wait_engine_idle(void)
 	int loop = 0;
 
 	while (!(readl(viaparinfo->io_virt + VIA_REG_STATUS) &
-			VIA_VR_QUEUE_BUSY) && (loop++ < MAXLOOP))
+			VIA_VR_QUEUE_BUSY) && (loop < MAXLOOP)) {
+		loop++;
 		cpu_relax();
+	}
 
 	while ((readl(viaparinfo->io_virt + VIA_REG_STATUS) &
 		    (VIA_CMD_RGTR_BUSY | VIA_2D_ENG_BUSY | VIA_3D_ENG_BUSY)) &&
-		    (loop++ < MAXLOOP))
+		    (loop < MAXLOOP)) {
+		loop++;
 		cpu_relax();
+	}
 
 	return loop >= MAXLOOP;
 }
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
uwb-event_size-should-be-signed.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
ufs-sector_t-cannot-be-negative.patch
hppfs-hppfs_read_file-may-return-error.patch


From: akpm@linux-foundation.org
Subject: [merged] drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:46 -0700
Message-ID: <200904011843.n31IhkI4010172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933494AbZDASsG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:48:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, joe@perches.com, rmk@arm.linux.org.uk, soni.trilok@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/video/omap/hwa742.c: div reaches max_clk_div
has been removed from the -mm tree.  Its filename was
     drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/omap/hwa742.c: div reaches max_clk_div
From: Roel Kluin <roel.kluin@gmail.com>

With for(div = 0; div < max_clk_div; div++) { ... } div reaches max_clk_div.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Joe Perches <joe@perches.com>
Acked-by: Trilok Soni <soni.trilok@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/hwa742.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/omap/hwa742.c~drivers-video-omap-hwa742c-div-reaches-max_clk_div drivers/video/omap/hwa742.c
--- a/drivers/video/omap/hwa742.c~drivers-video-omap-hwa742c-div-reaches-max_clk_div
+++ a/drivers/video/omap/hwa742.c
@@ -742,7 +742,7 @@ static int calc_extif_timings(unsigned l
 		if (calc_reg_timing(sysclk, div) == 0)
 			break;
 	}
-	if (div > max_clk_div)
+	if (div >= max_clk_div)
 		goto err;
 
 	*extif_mem_div = div;
@@ -752,7 +752,7 @@ static int calc_extif_timings(unsigned l
 			break;
 	}
 
-	if (div > max_clk_div)
+	if (div >= max_clk_div)
 		goto err;
 
 	return 0;
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


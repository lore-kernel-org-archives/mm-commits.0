From: akpm@linux-foundation.org
Subject: [merged] netdev-tg3-limit-reaches-1.patch removed from -mm tree
Date: Fri, 13 Feb 2009 11:55:56 -0800
Message-ID: <200902131955.n1DJtu9V028186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751550AbZBMTz7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Feb 2009 14:55:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, mchan@broadcom.com, mm-commits@vger.kernel.org


The patch titled
     netdev: tg3: limit reaches -1
has been removed from the -mm tree.  Its filename was
     netdev-tg3-limit-reaches-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: netdev: tg3: limit reaches -1
From: Roel Kluin <roel.kluin@gmail.com>

With while (limit--) { ... } limit reaches -1, so 0 means success.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tg3.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/tg3.c~netdev-tg3-limit-reaches-1 drivers/net/tg3.c
--- a/drivers/net/tg3.c~netdev-tg3-limit-reaches-1
+++ a/drivers/net/tg3.c
@@ -852,7 +852,7 @@ static int tg3_bmcr_reset(struct tg3 *tp
 		}
 		udelay(10);
 	}
-	if (limit <= 0)
+	if (limit < 0)
 		return -EBUSY;
 
 	return 0;
@@ -1603,7 +1603,7 @@ static int tg3_wait_macro_done(struct tg
 				break;
 		}
 	}
-	if (limit <= 0)
+	if (limit < 0)
 		return -EBUSY;
 
 	return 0;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
v4l-dvb-calibration-still-successful-at-10.patch
leds-fix-confusion.patch
pci-hotplug-shpchp-busnr-reaches-end-1.patch
scsi-ncr53c8xx-div-reaches-1.patch
paride-pgc-xs-confusion.patch
m68k-amiflop-ptr-incremented-past-0x4489.patch
mm-get_nid_for_pfn-returns-int.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
ufs-sector_t-cannot-be-negative.patch


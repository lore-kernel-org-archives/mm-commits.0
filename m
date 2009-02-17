From: akpm@linux-foundation.org
Subject: [merged] pci-hotplug-shpchp-busnr-reaches-end-1.patch removed from -mm tree
Date: Tue, 17 Feb 2009 12:09:00 -0800
Message-ID: <200902172009.n1HK904w001417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685AbZBQUOa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 15:14:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci hotplug: shpchp: busnr reaches end + 1
has been removed from the -mm tree.  Its filename was
     pci-hotplug-shpchp-busnr-reaches-end-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci hotplug: shpchp: busnr reaches end + 1
From: Roel Kluin <roel.kluin@gmail.com>

With for (busnr = 0; busnr <= end; busnr++) { ...  } busnr reaches end + 1
after the loop.  so only then there is no free bus.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/shpchp_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/hotplug/shpchp_pci.c~pci-hotplug-shpchp-busnr-reaches-end-1 drivers/pci/hotplug/shpchp_pci.c
--- a/drivers/pci/hotplug/shpchp_pci.c~pci-hotplug-shpchp-busnr-reaches-end-1
+++ a/drivers/pci/hotplug/shpchp_pci.c
@@ -137,7 +137,7 @@ int __ref shpchp_configure_device(struct
 							busnr))
 					break;
 			}
-			if (busnr >= end) {
+			if (busnr > end) {
 				ctrl_err(ctrl,
 					 "No free bus for hot-added bridge\n");
 				pci_dev_put(dev);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
v4l-dvb-calibration-still-successful-at-10.patch
leds-fix-confusion.patch
scsi-ncr53c8xx-div-reaches-1.patch
paride-pgc-xs-confusion.patch
m68k-amiflop-ptr-incremented-past-0x4489.patch
mm-get_nid_for_pfn-returns-int.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
ufs-sector_t-cannot-be-negative.patch


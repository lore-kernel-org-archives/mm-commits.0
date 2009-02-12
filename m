From: akpm@linux-foundation.org
Subject: + pci-hotplug-shpchp-busnr-reaches-end-1.patch added to -mm tree
Date: Wed, 11 Feb 2009 16:10:11 -0800
Message-ID: <200902120010.n1C0AB7p031441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853AbZBLAKN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 19:10:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, jbarnes@virtuousgeek.org


The patch titled
     pci hotplug: shpchp: busnr reaches end + 1
has been added to the -mm tree.  Its filename is
     pci-hotplug-shpchp-busnr-reaches-end-1.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
rtc-t-reaches-1-tested-0.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
v4l-dvb-calibration-still-successful-at-10.patch
leds-fix-confusion.patch
netdev-tg3-limit-reaches-1.patch
sun3-print-when-lance_open-fails.patch
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
ufs-sector_t-cannot-be-negative.patch


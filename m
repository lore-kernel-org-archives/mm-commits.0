From: akpm@linux-foundation.org
Subject: [merged] rtc-t-reaches-1-tested-0.patch removed from -mm tree
Date: Thu, 12 Feb 2009 12:25:40 -0800
Message-ID: <200902122025.n1CKPevf014941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757821AbZBLUgP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Feb 2009 15:36:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, a.zummo@towertech.it, david-b@pacbell.net, mano@roarinelk.homelinux.net, mm-commits@vger.kernel.org


The patch titled
     rtc: t reaches -1, tested 0
has been removed from the -mm tree.  Its filename was
     rtc-t-reaches-1-tested-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: t reaches -1, tested 0
From: Roel Kluin <roel.kluin@gmail.com>

With a postfix decrement t will reach -1 rather than 0, so neither the
warning nor the `goto error_out' will occur.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Manuel Lauss <mano@roarinelk.homelinux.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-au1xxx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-au1xxx.c~rtc-t-reaches-1-tested-0 drivers/rtc/rtc-au1xxx.c
--- a/drivers/rtc/rtc-au1xxx.c~rtc-t-reaches-1-tested-0
+++ a/drivers/rtc/rtc-au1xxx.c
@@ -81,7 +81,7 @@ static int __devinit au1xtoy_rtc_probe(s
 	if (au_readl(SYS_TOYTRIM) != 32767) {
 		/* wait until hardware gives access to TRIM register */
 		t = 0x00100000;
-		while ((au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_T0S) && t--)
+		while ((au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_T0S) && --t)
 			msleep(1);
 
 		if (!t) {
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
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
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
ufs-sector_t-cannot-be-negative.patch


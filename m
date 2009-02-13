From: akpm@linux-foundation.org
Subject: [merged] sun3-print-when-lance_open-fails.patch removed from -mm tree
Date: Fri, 13 Feb 2009 11:55:59 -0800
Message-ID: <200902131955.n1DJtxFO028279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752638AbZBMT4C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Feb 2009 14:56:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sun3: print when lance_open() fails
has been removed from the -mm tree.  Its filename was
     sun3-print-when-lance_open-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sun3: print when lance_open() fails
From: Roel Kluin <roel.kluin@gmail.com>

With while (--i > 0) { ... } i reaches 0; print when lance_open() fails

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sun3lance.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/sun3lance.c~sun3-print-when-lance_open-fails drivers/net/sun3lance.c
--- a/drivers/net/sun3lance.c~sun3-print-when-lance_open-fails
+++ a/drivers/net/sun3lance.c
@@ -428,7 +428,7 @@ static int lance_open( struct net_device
 	while (--i > 0)
 		if (DREG & CSR0_IDON)
 			break;
-	if (i < 0 || (DREG & CSR0_ERR)) {
+	if (i <= 0 || (DREG & CSR0_ERR)) {
 		DPRINTK( 2, ( "lance_open(): opening %s failed, i=%d, csr0=%04x\n",
 					  dev->name, i, DREG ));
 		DREG = CSR0_STOP;
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


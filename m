From: akpm@linux-foundation.org
Subject: [merged] v4l-dvb-calibration-still-successful-at-10.patch removed from -mm tree
Date: Wed, 18 Feb 2009 02:13:57 -0800
Message-ID: <200902181013.n1IADvtD006116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216AbZBRKOA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 05:14:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     v4l/dvb: calibration still  successful at 10
has been removed from the -mm tree.  Its filename was
     v4l-dvb-calibration-still-successful-at-10.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: v4l/dvb: calibration still  successful at 10
From: Roel Kluin <roel.kluin@gmail.com>

With while (i++ < 10) { ...  } i can reach 11, so callibration still
succeeds at i == 10.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/common/tuners/mt2060.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/common/tuners/mt2060.c~v4l-dvb-calibration-still-successful-at-10 drivers/media/common/tuners/mt2060.c
--- a/drivers/media/common/tuners/mt2060.c~v4l-dvb-calibration-still-successful-at-10
+++ a/drivers/media/common/tuners/mt2060.c
@@ -278,7 +278,7 @@ static void mt2060_calibrate(struct mt20
 	while (i++ < 10 && mt2060_readreg(priv, REG_MISC_STAT, &b) == 0 && (b & (1 << 6)) == 0)
 		msleep(20);
 
-	if (i < 10) {
+	if (i <= 10) {
 		mt2060_readreg(priv, REG_FM_FREQ, &priv->fmfreq); // now find out, what is fmreq used for :)
 		dprintk("calibration was successful: %d", (int)priv->fmfreq);
 	} else
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
scsi-ncr53c8xx-div-reaches-1.patch
paride-pgc-xs-confusion.patch
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


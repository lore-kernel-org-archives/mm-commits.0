From: akpm@linux-foundation.org
Subject: + drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch added to -mm tree
Date: Wed, 11 Feb 2009 16:11:49 -0800
Message-ID: <200902120011.n1C0BnDK001222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756079AbZBLAMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 19:12:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, joe@perches.com, rmk@arm.linux.org.uk, soni.trilok@gmail.com


The patch titled
     drivers/video/omap/hwa742.c: div reaches max_clk_div
has been added to the -mm tree.  Its filename is
     drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch

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
Subject: drivers/video/omap/hwa742.c: div reaches max_clk_div
From: Roel Kluin <roel.kluin@gmail.com>

With for(div = 0; div < max_clk_div; div++) { ... } div reaches max_clk_div.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Trilok Soni <soni.trilok@gmail.com>
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
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
ufs-sector_t-cannot-be-negative.patch


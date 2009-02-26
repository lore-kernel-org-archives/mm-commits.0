From: akpm@linux-foundation.org
Subject: + viafb-returns-0-two-too-early.patch added to -mm tree
Date: Thu, 26 Feb 2009 14:00:32 -0800
Message-ID: <200902262200.n1QM0W2Y026670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759473AbZBZWBF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 17:01:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, josephchan@via.com.tw


The patch titled
     viafb: returns 0 two too early
has been added to the -mm tree.  Its filename is
     viafb-returns-0-two-too-early.patch

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
acpi-get_throttling_state-cannot-be-larger-state_count.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
scsi-ncr53c8xx-div-reaches-1.patch
drivers-scsi-pcmcia-nsp_csc-time_out-reaches-1.patch
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
arkfb-fix-misplaced-parentheses.patch
uvesafb-bitwise-or-has-higher-precedence-than.patch
vesafb-bitwise-or-has-higher-precedence-than.patch
viafb-returns-0-two-too-early.patch
ufs-sector_t-cannot-be-negative.patch
rio-addition-has-higher-precedence-than.patch


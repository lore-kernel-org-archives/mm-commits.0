From: akpm@linux-foundation.org
Subject: + platinumfb-misplaced-parenthesis.patch added to -mm tree
Date: Wed, 27 May 2009 23:57:02 -0700
Message-ID: <200905280657.n4S6v2MW024267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740AbZE1G54 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 02:57:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, benh@kernel.crashing.org, geert@linux-m68k.org, paulus@samba.org, syrjala@sci.fi


The patch titled
     platinumfb: fix misplaced parenthesis
has been added to the -mm tree.  Its filename is
     platinumfb-misplaced-parenthesis.patch

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
Subject: platinumfb: fix misplaced parenthesis
From: Roel Kluin <roel.kluin@gmail.com>

Since `+' has a higher precedence than the trinary operator `?', this
added `hres * (1 << color_mode)' to the boolean testing videomode and
depth.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ville Syrjala <syrjala@sci.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/platinumfb.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/video/platinumfb.c~platinumfb-misplaced-parenthesis drivers/video/platinumfb.c
--- a/drivers/video/platinumfb.c~platinumfb-misplaced-parenthesis
+++ a/drivers/video/platinumfb.c
@@ -221,10 +221,14 @@ static int platinumfb_setcolreg(u_int re
 
 static inline int platinum_vram_reqd(int video_mode, int color_mode)
 {
-	return vmode_attrs[video_mode-1].vres *
-	       (vmode_attrs[video_mode-1].hres * (1<<color_mode) +
-		((video_mode == VMODE_832_624_75) &&
-		 (color_mode > CMODE_8)) ? 0x10 : 0x20) + 0x1000;
+	int baseval = vmode_attrs[video_mode-1].hres * (1<<color_mode);
+
+	if ((video_mode == VMODE_832_624_75) && (color_mode > CMODE_8))
+		baseval += 0x10;
+	else
+		baseval += 0x20;
+
+	return vmode_attrs[video_mode-1].vres * baseval + 0x1000;
 }
 
 #define STORE_D2(a, d) { \
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
drivers-serial-mpc52xx_uartc-fix-array-overindexing-check.patch
linux-next.patch
soc-correct-print-specifiers-for-unsigneds.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
fsldma-fix-check-on-potential-fdev-chan-overflow.patch
drm-fix-lock_test_with_return-macro.patch
uwb-event_size-should-be-signed.patch
irda-count-reaches-1.patch
drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
otus-80211core-coidc-fix-array-range-check.patch
wmm_paramac_aci_acm_aifsn-tested-twice.patch
lguest-fix-array-indexing-check.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
platinumfb-misplaced-parenthesis.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch


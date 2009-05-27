From: akpm@linux-foundation.org
Subject: + carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch added to -mm tree
Date: Wed, 27 May 2009 00:15:53 -0700
Message-ID: <200905270715.n4R7Fr00005939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040AbZE0HQH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 03:16:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, bigeasy@linutronix.de, krzysztof.h1@poczta.fm


The patch titled
     carminefb: fix possible access beyond end of carmine_modedb[]
has been added to the -mm tree.  Its filename is
     carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch

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
Subject: carminefb: fix possible access beyond end of carmine_modedb[]
From: Roel Kluin <roel.kluin@gmail.com>

This check is off-by-one.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Sebastian Siewior <bigeasy@linutronix.de>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/carminefb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/carminefb.c~carminefb-fix-possible-access-beyond-end-of-carmine_modedb drivers/video/carminefb.c
--- a/drivers/video/carminefb.c~carminefb-fix-possible-access-beyond-end-of-carmine_modedb
+++ a/drivers/video/carminefb.c
@@ -562,7 +562,7 @@ static int __devinit alloc_carmine_fb(vo
 	if (ret < 0)
 		goto err_free_fb;
 
-	if (fb_mode > ARRAY_SIZE(carmine_modedb))
+	if (fb_mode >= ARRAY_SIZE(carmine_modedb))
 		fb_mode = CARMINEFB_DEFAULT_VIDEO_MODE;
 
 	par->cur_mode = par->new_mode = ~0;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
zoran-fix-error.patch
uwb-event_size-should-be-signed.patch
irda-count-reaches-1.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
sh-fix-access-beyond-array_size-of-onchip_ops.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch


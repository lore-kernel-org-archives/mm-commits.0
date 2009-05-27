From: akpm@linux-foundation.org
Subject: + s3c-fix-check-of-index-into-s3c_gpios.patch added to -mm tree
Date: Tue, 26 May 2009 22:57:39 -0700
Message-ID: <200905270557.n4R5vdfP016873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759124AbZE0F6A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 01:58:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, ben-linux@fluff.org, rmk@arm.linux.org.uk


The patch titled
     s3c: fix check of index into s3c_gpios[]
has been added to the -mm tree.  Its filename is
     s3c-fix-check-of-index-into-s3c_gpios.patch

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
Subject: s3c: fix check of index into s3c_gpios[]
From: Roel Kluin <roel.kluin@gmail.com>

The check of the s3c_gpios[] index had an off-by-one.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-s3c/gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/plat-s3c/gpio.c~s3c-fix-check-of-index-into-s3c_gpios arch/arm/plat-s3c/gpio.c
--- a/arch/arm/plat-s3c/gpio.c~s3c-fix-check-of-index-into-s3c_gpios
+++ a/arch/arm/plat-s3c/gpio.c
@@ -28,7 +28,7 @@ static __init void s3c_gpiolib_track(str
 
 	gpn = chip->chip.base;
 	for (i = 0; i < chip->chip.ngpio; i++, gpn++) {
-		BUG_ON(gpn > ARRAY_SIZE(s3c_gpios));
+		BUG_ON(gpn >= ARRAY_SIZE(s3c_gpios));
 		s3c_gpios[gpn] = chip;
 	}
 }
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
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch


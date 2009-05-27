From: akpm@linux-foundation.org
Subject: + drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch added to -mm tree
Date: Wed, 27 May 2009 00:23:40 -0700
Message-ID: <200905270723.n4R7Nerr011483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759026AbZE0HYP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 03:24:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, isdn@linux-pingi.de


The patch titled
     drivers/isdn/i4l/isdn_tty.c: fix check for array overindexing
has been added to the -mm tree.  Its filename is
     drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch

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
Subject: drivers/isdn/i4l/isdn_tty.c: fix check for array overindexing
From: Roel Kluin <roel.kluin@gmail.com>

The check for overindexing of dev->mdm.info[] has an off-by-one.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/i4l/isdn_tty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/i4l/isdn_tty.c~drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing drivers/isdn/i4l/isdn_tty.c
--- a/drivers/isdn/i4l/isdn_tty.c~drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing
+++ a/drivers/isdn/i4l/isdn_tty.c
@@ -1592,7 +1592,7 @@ isdn_tty_open(struct tty_struct *tty, st
 	int retval, line;
 
 	line = tty->index;
-	if (line < 0 || line > ISDN_MAX_CHANNELS)
+	if (line < 0 || line >= ISDN_MAX_CHANNELS)
 		return -ENODEV;
 	info = &dev->mdm.info[line];
 	if (isdn_tty_paranoia_check(info, tty->name, "isdn_tty_open"))
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
zoran-fix-error.patch
uwb-event_size-should-be-signed.patch
irda-count-reaches-1.patch
drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
otus-80211core-coidc-fix-array-range-check.patch
lguest-fix-array-indexing-check.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
sh-fix-access-beyond-array_size-of-onchip_ops.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
drivers-serial-mpc52xx_uartc-fix-array-overindexing-check.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch


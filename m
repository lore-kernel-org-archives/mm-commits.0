From: akpm@linux-foundation.org
Subject: + video-test-cmd-not-definition-in-decoder_command-drivers-media-video-zoran_devicec.patch added to -mm tree
Date: Mon, 31 Mar 2008 14:23:59 -0700
Message-ID: <200803312123.m2VLNxoK026675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756174AbYCaVYJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 17:24:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, mchehab@infradead.org


The patch titled
     video: test cmd, not definition in decoder_command(), drivers/media/video/zoran_device.c
has been added to the -mm tree.  Its filename is
     video-test-cmd-not-definition-in-decoder_command-drivers-media-video-zoran_devicec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video: test cmd, not definition in decoder_command(), drivers/media/video/zoran_device.c
From: Roel Kluin <12o3l@tiscali.nl>

include/linux/video_decoder.h:
34:#define DECODER_SET_NORM	_IOW('d', 3, int)
35:#define DECODER_SET_INPUT	_IOW('d', 4, int)

Test cmd value, not definition of DECODER_SET_INPUT

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/zoran_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/zoran_device.c~video-test-cmd-not-definition-in-decoder_command-drivers-media-video-zoran_devicec drivers/media/video/zoran_device.c
--- a/drivers/media/video/zoran_device.c~video-test-cmd-not-definition-in-decoder_command-drivers-media-video-zoran_devicec
+++ a/drivers/media/video/zoran_device.c
@@ -1727,7 +1727,7 @@ decoder_command (struct zoran *zr,
 		return -EIO;
 
 	if (zr->card.type == LML33 &&
-	    (cmd == DECODER_SET_NORM || DECODER_SET_INPUT)) {
+	    (cmd == DECODER_SET_NORM || cmd == DECODER_SET_INPUT)) {
 		int res;
 
 		// Bt819 needs to reset its FIFO buffer using #FRST pin and
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

git-dvb.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
git-net.patch
git-scsi-misc.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
git-cryptodev.patch
free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch
drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch
drivers-video-imsttfbc-add-missing-curly-brackets.patch
likeliness-accounting-change-and-cleanup.patch
video-test-cmd-not-definition-in-decoder_command-drivers-media-video-zoran_devicec.patch


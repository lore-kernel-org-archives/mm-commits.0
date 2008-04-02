From: akpm@linux-foundation.org
Subject: - video-test-cmd-not-definition-in-decoder_command-drivers-media-video-zoran_devicec.patch removed from -mm tree
Date: Wed, 02 Apr 2008 12:20:03 -0700
Message-ID: <200804021920.m32JK3bV030233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757162AbYDBTUn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Apr 2008 15:20:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     video: test cmd, not definition in decoder_command(), drivers/media/video/zoran_device.c
has been removed from the -mm tree.  Its filename was
     video-test-cmd-not-definition-in-decoder_command-drivers-media-video-zoran_devicec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-powerpc.patch
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


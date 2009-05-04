From: akpm@linux-foundation.org
Subject: + zoran-fix-error.patch added to -mm tree
Date: Mon, 04 May 2009 16:05:54 -0700
Message-ID: <200905042305.n44N5skl032404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753536AbZEDXIw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 19:08:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, hverkuil@xs4all.nl, mchehab@redhat.com


The patch titled
     zoran: fix &&/|| error
has been added to the -mm tree.  Its filename is
     zoran-fix-error.patch

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
Subject: zoran: fix &&/|| error
From: Roel Kluin <roel.kluin@gmail.com>

Fix &&/|| typo. `default_norm' can be 0 (PAL), 1 (NTSC) or 2 (SECAM),
the condition tested was impossible.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/zoran/zoran_card.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/zoran/zoran_card.c~zoran-fix-error drivers/media/video/zoran/zoran_card.c
--- a/drivers/media/video/zoran/zoran_card.c~zoran-fix-error
+++ a/drivers/media/video/zoran/zoran_card.c
@@ -1022,7 +1022,7 @@ zr36057_init (struct zoran *zr)
 	zr->vbuf_bytesperline = 0;
 
 	/* Avoid nonsense settings from user for default input/norm */
-	if (default_norm < 0 && default_norm > 2)
+	if (default_norm < 0 || default_norm > 2)
 		default_norm = 0;
 	if (default_norm == 0) {
 		zr->norm = V4L2_STD_PAL;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
i2c-pxac-timeouts-off-by-1.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
zoran-fix-error.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
uwb-event_size-should-be-signed.patch
isdn-get_free_devid-failure-ignored.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch


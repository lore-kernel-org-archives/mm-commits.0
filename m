From: akpm@linux-foundation.org
Subject: + media-strncpy-does-not-null-terminate-string.patch added to -mm tree
Date: Thu, 23 Jul 2009 13:51:46 -0700
Message-ID: <200907232051.n6NKpkdi002369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754168AbZGWUv4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 16:51:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, mchehab@infradead.org


The patch titled
     media: strncpy does not null terminate string
has been added to the -mm tree.  Its filename is
     media-strncpy-does-not-null-terminate-string.patch

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
Subject: media: strncpy does not null terminate string
From: Roel Kluin <roel.kluin@gmail.com>

strlcpy() will always null terminate the string.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-usb/dvb-usb-i2c.c |    2 +-
 drivers/media/video/pwc/pwc-v4l.c       |    2 +-
 drivers/media/video/zoran/zoran_card.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/media/dvb/dvb-usb/dvb-usb-i2c.c~media-strncpy-does-not-null-terminate-string drivers/media/dvb/dvb-usb/dvb-usb-i2c.c
--- a/drivers/media/dvb/dvb-usb/dvb-usb-i2c.c~media-strncpy-does-not-null-terminate-string
+++ a/drivers/media/dvb/dvb-usb/dvb-usb-i2c.c
@@ -19,7 +19,7 @@ int dvb_usb_i2c_init(struct dvb_usb_devi
 		return -EINVAL;
 	}
 
-	strncpy(d->i2c_adap.name, d->desc->name, sizeof(d->i2c_adap.name));
+	strlcpy(d->i2c_adap.name, d->desc->name, sizeof(d->i2c_adap.name));
 	d->i2c_adap.class = I2C_CLASS_TV_DIGITAL,
 	d->i2c_adap.algo      = d->props.i2c_algo;
 	d->i2c_adap.algo_data = NULL;
diff -puN drivers/media/video/pwc/pwc-v4l.c~media-strncpy-does-not-null-terminate-string drivers/media/video/pwc/pwc-v4l.c
--- a/drivers/media/video/pwc/pwc-v4l.c~media-strncpy-does-not-null-terminate-string
+++ a/drivers/media/video/pwc/pwc-v4l.c
@@ -1033,7 +1033,7 @@ long pwc_video_do_ioctl(struct file *fil
 			if (std->index != 0)
 				return -EINVAL;
 			std->id = V4L2_STD_UNKNOWN;
-			strncpy(std->name, "webcam", sizeof(std->name));
+			strlcpy(std->name, "webcam", sizeof(std->name));
 			return 0;
 		}
 
diff -puN drivers/media/video/zoran/zoran_card.c~media-strncpy-does-not-null-terminate-string drivers/media/video/zoran/zoran_card.c
--- a/drivers/media/video/zoran/zoran_card.c~media-strncpy-does-not-null-terminate-string
+++ a/drivers/media/video/zoran/zoran_card.c
@@ -1169,7 +1169,7 @@ zoran_setup_videocodec (struct zoran *zr
 	m->type = 0;
 
 	m->flags = CODEC_FLAG_ENCODER | CODEC_FLAG_DECODER;
-	strncpy(m->name, ZR_DEVNAME(zr), sizeof(m->name));
+	strlcpy(m->name, ZR_DEVNAME(zr), sizeof(m->name));
 	m->data = zr;
 
 	switch (type)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
media-strncpy-does-not-null-terminate-string.patch
ipath-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch
documentation-strncpy-does-not-null-terminate-string.patch
adfs-remove-redundant-test-on-unsigned.patch


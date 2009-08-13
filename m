From: akpm@linux-foundation.org
Subject: [merged] media-strncpy-does-not-null-terminate-string.patch removed from -mm tree
Date: Thu, 13 Aug 2009 12:19:37 -0700
Message-ID: <200908131919.n7DJJbMo012689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753125AbZHMTUO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 15:20:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     media: strncpy does not null terminate string
has been removed from the -mm tree.  Its filename was
     media-strncpy-does-not-null-terminate-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-avoid-calculating-possibly-invalid-address.patch
drm-i915-intel_sdvo_multifunc_encoder-sdvo_output_svid0-tested-twice.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
slram-read-buffer-overflow.patch
mtd-fix-read-buffer-overflow.patch
hfc_usb-fix-read-buffer-overflow.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fixes.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
dme1737-keep-index-within-pwm_config.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch


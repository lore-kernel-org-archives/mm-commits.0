From: akpm@osdl.org
Subject: - sound-oss-emu10k1-handle-userspace-copy-errors.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:28 -0800
Message-ID: <200612072301.kB7N1Sq6029763@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51539 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163757AbWLGXBh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:01:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sound/oss/emu10k1: handle userspace copy errors
has been removed from the -mm tree.  Its filename was
     sound-oss-emu10k1-handle-userspace-copy-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sound/oss/emu10k1: handle userspace copy errors
From: Jeff Garzik <jeff@garzik.org>

Propagate copy_to/from_user() errors back through callers.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 sound/oss/emu10k1/audio.c       |    8 ++++++-
 sound/oss/emu10k1/cardwi.c      |   31 ++++++++++++++++++++----------
 sound/oss/emu10k1/cardwi.h      |    2 -
 sound/oss/emu10k1/passthrough.c |   13 ++++++++----
 4 files changed, 38 insertions(+), 16 deletions(-)

diff -puN sound/oss/emu10k1/audio.c~sound-oss-emu10k1-handle-userspace-copy-errors sound/oss/emu10k1/audio.c
--- a/sound/oss/emu10k1/audio.c~sound-oss-emu10k1-handle-userspace-copy-errors
+++ a/sound/oss/emu10k1/audio.c
@@ -111,9 +111,15 @@ static ssize_t emu10k1_audio_read(struct
 
 		if ((bytestocopy >= wiinst->buffer.fragment_size)
 		    || (bytestocopy >= count)) {
+			int rc;
+
 			bytestocopy = min_t(u32, bytestocopy, count);
 
-			emu10k1_wavein_xferdata(wiinst, (u8 __user *)buffer, &bytestocopy);
+			rc = emu10k1_wavein_xferdata(wiinst,
+						     (u8 __user *)buffer,
+						     &bytestocopy);
+			if (rc)
+				return rc;
 
 			count -= bytestocopy;
 			buffer += bytestocopy;
diff -puN sound/oss/emu10k1/cardwi.c~sound-oss-emu10k1-handle-userspace-copy-errors sound/oss/emu10k1/cardwi.c
--- a/sound/oss/emu10k1/cardwi.c~sound-oss-emu10k1-handle-userspace-copy-errors
+++ a/sound/oss/emu10k1/cardwi.c
@@ -304,11 +304,12 @@ void emu10k1_wavein_getxfersize(struct w
 	}
 }
 
-static void copy_block(u8 __user *dst, u8 * src, u32 str, u32 len, u8 cov)
+static int copy_block(u8 __user *dst, u8 * src, u32 str, u32 len, u8 cov)
 {
-	if (cov == 1)
-		__copy_to_user(dst, src + str, len);
-	else {
+	if (cov == 1) {
+		if (__copy_to_user(dst, src + str, len))
+			return -EFAULT;
+	} else {
 		u8 byte;
 		u32 i;
 
@@ -316,22 +317,26 @@ static void copy_block(u8 __user *dst, u
 
 		for (i = 0; i < len; i++) {
 			byte = src[2 * i] ^ 0x80;
-			__copy_to_user(dst + i, &byte, 1);
+			if (__copy_to_user(dst + i, &byte, 1))
+				return -EFAULT;
 		}
 	}
+
+	return 0;
 }
 
-void emu10k1_wavein_xferdata(struct wiinst *wiinst, u8 __user *data, u32 * size)
+int emu10k1_wavein_xferdata(struct wiinst *wiinst, u8 __user *data, u32 * size)
 {
 	struct wavein_buffer *buffer = &wiinst->buffer;
 	u32 sizetocopy, sizetocopy_now, start;
 	unsigned long flags;
+	int ret;
 
 	sizetocopy = min_t(u32, buffer->size, *size);
 	*size = sizetocopy;
 
 	if (!sizetocopy)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&wiinst->lock, flags);
 	start = buffer->pos;
@@ -345,11 +350,17 @@ void emu10k1_wavein_xferdata(struct wiin
 	if (sizetocopy > sizetocopy_now) {
 		sizetocopy -= sizetocopy_now;
 
-		copy_block(data, buffer->addr, start, sizetocopy_now, buffer->cov);
-		copy_block(data + sizetocopy_now, buffer->addr, 0, sizetocopy, buffer->cov);
+		ret = copy_block(data, buffer->addr, start, sizetocopy_now,
+				 buffer->cov);
+		if (ret == 0)
+			ret = copy_block(data + sizetocopy_now, buffer->addr, 0,
+					 sizetocopy, buffer->cov);
 	} else {
-		copy_block(data, buffer->addr, start, sizetocopy, buffer->cov);
+		ret = copy_block(data, buffer->addr, start, sizetocopy,
+				 buffer->cov);
 	}
+
+	return ret;
 }
 
 void emu10k1_wavein_update(struct emu10k1_card *card, struct wiinst *wiinst)
diff -puN sound/oss/emu10k1/cardwi.h~sound-oss-emu10k1-handle-userspace-copy-errors sound/oss/emu10k1/cardwi.h
--- a/sound/oss/emu10k1/cardwi.h~sound-oss-emu10k1-handle-userspace-copy-errors
+++ a/sound/oss/emu10k1/cardwi.h
@@ -83,7 +83,7 @@ void emu10k1_wavein_close(struct emu10k1
 void emu10k1_wavein_start(struct emu10k1_wavedevice *);
 void emu10k1_wavein_stop(struct emu10k1_wavedevice *);
 void emu10k1_wavein_getxfersize(struct wiinst *, u32 *);
-void emu10k1_wavein_xferdata(struct wiinst *, u8 __user *, u32 *);
+int emu10k1_wavein_xferdata(struct wiinst *, u8 __user *, u32 *);
 int emu10k1_wavein_setformat(struct emu10k1_wavedevice *, struct wave_format *);
 void emu10k1_wavein_update(struct emu10k1_card *, struct wiinst *);
 
diff -puN sound/oss/emu10k1/passthrough.c~sound-oss-emu10k1-handle-userspace-copy-errors sound/oss/emu10k1/passthrough.c
--- a/sound/oss/emu10k1/passthrough.c~sound-oss-emu10k1-handle-userspace-copy-errors
+++ a/sound/oss/emu10k1/passthrough.c
@@ -162,12 +162,15 @@ ssize_t emu10k1_pt_write(struct file *fi
 
 		DPD(3, "prepend size %d, prepending %d bytes\n", pt->prepend_size, needed);
 		if (count < needed) {
-			copy_from_user(pt->buf + pt->prepend_size, buffer, count);
+			if (copy_from_user(pt->buf + pt->prepend_size,
+					   buffer, count))
+				return -EFAULT;
 			pt->prepend_size += count;
 			DPD(3, "prepend size now %d\n", pt->prepend_size);
 			return count;
 		}
-		copy_from_user(pt->buf + pt->prepend_size, buffer, needed);
+		if (copy_from_user(pt->buf + pt->prepend_size, buffer, needed))
+			return -EFAULT;
 		r = pt_putblock(wave_dev, (u16 *) pt->buf, nonblock);
 		if (r)
 			return r;
@@ -178,7 +181,8 @@ ssize_t emu10k1_pt_write(struct file *fi
 	blocks_copied = 0;
 	while (blocks > 0) {
 		u16 __user *bufptr = (u16 __user *) buffer + (bytes_copied/2);
-		copy_from_user(pt->buf, bufptr, PT_BLOCKSIZE);
+		if (copy_from_user(pt->buf, bufptr, PT_BLOCKSIZE))
+			return -EFAULT;
 		r = pt_putblock(wave_dev, (u16 *)pt->buf, nonblock);
 		if (r) {
 			if (bytes_copied)
@@ -193,7 +197,8 @@ ssize_t emu10k1_pt_write(struct file *fi
 	i = count - bytes_copied;
 	if (i) {
 		pt->prepend_size = i;
-		copy_from_user(pt->buf, buffer + bytes_copied, i);
+		if (copy_from_user(pt->buf, buffer + bytes_copied, i))
+			return -EFAULT;
 		bytes_copied += i;
 		DPD(3, "filling prepend buffer with %d bytes", i);
 	}
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-acpi.patch
git-cpufreq.patch
drm-handle-pci_enable_device-failure.patch
git-input.patch
git-libata-all.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
initializer-entry-defined-twice-in-pata_rz1000.patch
ata_piix-ide-mode-sata-patch-for-intel-ich9.patch
pata_it8213-add-new-driver-for-the-it8213-card.patch
git-mtd.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
8139too-force-media-setting-fix.patch
tulip-fix-shutdown-dma-irq-race.patch
git-ioat.patch
via-sb600-sata-quirk.patch
git-pciseg.patch
pci-device-ensure-sysdata-initialised-v2.patch
mpt-fusion-handle-pci-layer-error-on-resume.patch
usb-fix-ohcih-over-use-warnings.patch
isdn-fix-warnings.patch
atyfb-rivafb-minor-fixes.patch
md-conditionalize-some-code.patch
user-of-the-jiffies-rounding-patch-ata-subsystem.patch
e1000-printk-warning-fixes.patch
git-gccbug.patch


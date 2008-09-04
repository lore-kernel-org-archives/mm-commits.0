From: akpm@linux-foundation.org
Subject: + v4l_compat_ioctl32-cleanup-in-compat=n-case.patch added to -mm tree
Date: Thu, 04 Sep 2008 14:10:50 -0700
Message-ID: <200809042110.m84LAo3X031299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872AbYIDVL0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 17:11:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, mchehab@infradead.org


The patch titled
     v4l_compat_ioctl32() cleanup in COMPAT=n case
has been added to the -mm tree.  Its filename is
     v4l_compat_ioctl32-cleanup-in-compat=n-case.patch

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
Subject: v4l_compat_ioctl32() cleanup in COMPAT=n case
From: Alexey Dobriyan <adobriyan@gmail.com>

v4l_compat_ioctl32() exists even in COMPAT=n case which is unnecessary.
Instead, totally compile it out. Introduce COMPAT_VIDEO_DEV for that.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/Kconfig                           |    4 ++++
 drivers/media/video/Makefile                    |    3 ++-
 drivers/media/video/bt8xx/bttv-driver.c         |    4 ++++
 drivers/media/video/compat_ioctl32.c            |    9 ---------
 drivers/media/video/cx18/cx18-streams.c         |    2 ++
 drivers/media/video/cx23885/cx23885-video.c     |    4 ++++
 drivers/media/video/cx88/cx88-video.c           |    4 ++++
 drivers/media/video/em28xx/em28xx-video.c       |    4 ++++
 drivers/media/video/ivtv/ivtv-streams.c         |    4 ++++
 drivers/media/video/s2255drv.c                  |    2 ++
 drivers/media/video/saa7134/saa7134-video.c     |    4 ++++
 drivers/media/video/usbvision/usbvision-video.c |    6 ++++++
 drivers/media/video/uvc/uvc_v4l2.c              |    2 ++
 drivers/media/video/vivi.c                      |    2 ++
 include/media/v4l2-ioctl.h                      |    4 ++--
 15 files changed, 46 insertions(+), 12 deletions(-)

diff -puN drivers/media/Kconfig~v4l_compat_ioctl32-cleanup-in-compat=n-case drivers/media/Kconfig
--- a/drivers/media/Kconfig~v4l_compat_ioctl32-cleanup-in-compat=n-case
+++ a/drivers/media/Kconfig
@@ -29,6 +29,10 @@ config VIDEO_DEV
 	  To compile this driver as a module, choose M here: the
 	  module will be called videodev.
 
+config COMPAT_VIDEO_DEV
+	bool
+	depends on COMPAT && VIDEO_DEV
+
 config VIDEO_V4L2_COMMON
 	tristate
 	depends on (I2C || I2C=n) && VIDEO_DEV
diff -puN drivers/media/video/Makefile~v4l_compat_ioctl32-cleanup-in-compat=n-case drivers/media/video/Makefile
--- a/drivers/media/video/Makefile~v4l_compat_ioctl32-cleanup-in-compat=n-case
+++ a/drivers/media/video/Makefile
@@ -12,7 +12,8 @@ stkwebcam-objs	:=	stk-webcam.o stk-senso
 
 videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o
 
-obj-$(CONFIG_VIDEO_DEV) += videodev.o compat_ioctl32.o v4l2-int-device.o
+obj-$(CONFIG_VIDEO_DEV) += videodev.o v4l2-int-device.o
+obj-$(CONFIG_COMPAT_VIDEO_DEV) += compat_ioctl32.o
 
 obj-$(CONFIG_VIDEO_V4L2_COMMON) += v4l2-common.o
 
diff -puN drivers/media/video/bt8xx/bttv-driver.c~v4l_compat_ioctl32-cleanup-in-compat=n-case drivers/media/video/bt8xx/bttv-driver.c
--- a/drivers/media/video/bt8xx/bttv-driver.c~v4l_compat_ioctl32-cleanup-in-compat=n-case
+++ a/drivers/media/video/bt8xx/bttv-driver.c
@@ -3361,7 +3361,9 @@ static const struct file_operations bttv
 	.open	  = bttv_open,
 	.release  = bttv_release,
 	.ioctl	  = video_ioctl2,
+#ifdef CONFIG_COMPAT
 	.compat_ioctl	= v4l_compat_ioctl32,
+#endif
 	.llseek	  = no_llseek,
 	.read	  = bttv_read,
 	.mmap	  = bttv_mmap,
@@ -3649,7 +3651,9 @@ static const struct file_operations radi
 	.open	  = radio_open,
 	.read     = radio_read,
 	.release  = radio_release,
+#ifdef CONFIG_COMPAT
 	.compat_ioctl	= v4l_compat_ioctl32,
+#endif
 	.ioctl	  = video_ioctl2,
 	.llseek	  = no_llseek,
 	.poll     = radio_poll,
diff -puN drivers/media/video/compat_ioctl32.c~v4l_compat_ioctl32-cleanup-in-compat=n-case drivers/media/video/compat_ioctl32.c
--- a/drivers/media/video/compat_ioctl32.c~v4l_compat_ioctl32-cleanup-in-compat=n-case
+++ a/drivers/media/video/compat_ioctl32.c
@@ -19,8 +19,6 @@
 #include <linux/smp_lock.h>
 #include <media/v4l2-ioctl.h>
 
-#ifdef CONFIG_COMPAT
-
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
 struct video_tuner32 {
 	compat_int_t tuner;
@@ -921,12 +919,5 @@ long v4l_compat_ioctl32(struct file *fil
 	}
 	return ret;
 }
-#else
-long v4l_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	return -ENOIOCTLCMD;
-}
-#endif
-EXPORT_SYMBOL_GPL(v4l_compat_ioctl32);
 
 MODULE_LICENSE("GPL");
diff -puN drivers/media/video/cx18/cx18-streams.c~v4l_compat_ioctl32-cleanup-in-compat=n-case drivers/media/video/cx18/cx18-streams.c
--- a/drivers/media/video/cx18/cx18-streams.c~v4l_compat_ioctl32-cleanup-in-compat=n-case
+++ a/drivers/media/video/cx18/cx18-streams.c
@@ -41,7 +41,9 @@ static struct file_operations cx18_v4l2_
 	.open = cx18_v4l2_open,
 	/* FIXME change to video_ioctl2 if serialization lock can be removed */
 	.ioctl = cx18_v4l2_ioctl,
+#ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l_compat_ioctl32,
+#endif
 	.release = cx18_v4l2_close,
 	.poll = cx18_v4l2_enc_poll,
 };
diff -puN drivers/media/video/cx23885/cx23885-video.c~v4l_compat_ioctl32-cleanup-in-compat=n-case drivers/media/video/cx23885/cx23885-video.c
--- a/drivers/media/video/cx23885/cx23885-video.c~v4l_compat_ioctl32-cleanup-in-compat=n-case
+++ a/drivers/media/video/cx23885/cx23885-video.c
@@ -1436,7 +1436,9 @@ static const struct file_operations vide
 	.poll          = video_poll,
 	.mmap	       = video_mmap,
 	.ioctl	       = video_ioctl2,
+#ifdef CONFIG_COMPAT
 	.compat_ioctl  = v4l_compat_ioctl32,
+#endif
 	.llseek        = no_llseek,
 };
 
@@ -1490,7 +1492,9 @@ static const struct file_operations radi
 	.open          = video_open,
 	.release       = video_release,
 	.ioctl         = video_ioctl2,
+#ifdef CONFIG_COMPAT
 	.compat_ioctl  = v4l_compat_ioctl32,
+#endif
 	.llseek        = no_llseek,
 };
 
diff -puN drivers/media/video/cx88/cx88-video.c~v4l_compat_ioctl32-cleanup-in-compat=n-case drivers/media/video/cx88/cx88-video.c
--- a/drivers/media/video/cx88/cx88-video.c~v4l_compat_ioctl32-cleanup-in-compat=n-case
+++ a/drivers/media/video/cx88/cx88-video.c
@@ -1685,7 +1685,9 @@ static const struct file_operations vide
 	.poll          = video_poll,
 	.mmap	       = video_mmap,
 	.ioctl	       = video_ioctl2,
+#ifdef CONFIG_COMPAT
 	.compat_ioctl  = v4l_compat_ioctl32,
+#endif
 	.llseek        = no_llseek,
 };
 
@@ -1741,7 +1743,9 @@ static const struct file_operations radi
 	.open          = video_open,
 	.release       = video_release,
 	.ioctl         = video_ioctl2,
+#ifdef CONFIG_COMPAT
 	.compat_ioctl  = v4l_compat_ioctl32,
+#endif
 	.llseek        = no_llseek,
 };
 
diff -puN drivers/media/video/em28xx/em28xx-video.c~v4l_compat_ioctl32-cleanup-in-compat=n-case drivers/media/video/em28xx/em28xx-video.c
--- a/drivers/media/video/em28xx/em28xx-video.c~v4l_compat_ioctl32-cleanup-in-compat=n-case
+++ a/drivers/media/video/em28xx/em28xx-video.c
@@ -1766,7 +1766,9 @@ static const struct file_operations em28
 	.mmap          = em28xx_v4l2_mmap,
 	.ioctl	       = video_ioctl2,
 	.llseek        = no_llseek,
+#ifdef CONFIG_COMPAT
 	.compat_ioctl  = v4l_compat_ioctl32,
+#endif
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
@@ -1825,7 +1827,9 @@ static const struct file_operations radi
 	.open          = em28xx_v4l2_open,
 	.release       = em28xx_v4l2_close,
 	.ioctl	       = video_ioctl2,
+#ifdef CONFIG_COMPAT
 	.compat_ioctl  = v4l_compat_ioctl32,
+#endif
 	.llseek        = no_llseek,
 };
 
diff -puN drivers/media/video/ivtv/ivtv-streams.c~v4l_compat_ioctl32-cleanup-in-compat=n-case drivers/media/video/ivtv/ivtv-streams.c
--- a/drivers/media/video/ivtv/ivtv-streams.c~v4l_compat_ioctl32-cleanup-in-compat=n-case
+++ a/drivers/media/video/ivtv/ivtv-streams.c
@@ -49,7 +49,9 @@ static const struct file_operations ivtv
 	.write = ivtv_v4l2_write,
 	.open = ivtv_v4l2_open,
 	.ioctl = ivtv_v4l2_ioctl,
+#ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l_compat_ioctl32,
+#endif
 	.release = ivtv_v4l2_close,
 	.poll = ivtv_v4l2_enc_poll,
 };
@@ -60,7 +62,9 @@ static const struct file_operations ivtv
 	.write = ivtv_v4l2_write,
 	.open = ivtv_v4l2_open,
 	.ioctl = ivtv_v4l2_ioctl,
+#ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l_compat_ioctl32,
+#endif
 	.release = ivtv_v4l2_close,
 	.poll = ivtv_v4l2_dec_poll,
 };
diff -puN drivers/media/video/s2255drv.c~v4l_compat_ioctl32-cleanup-in-compat=n-case drivers/media/video/s2255drv.c
--- a/drivers/media/video/s2255drv.c~v4l_compat_ioctl32-cleanup-in-compat=n-case
+++ a/drivers/media/video/s2255drv.c
@@ -1764,7 +1764,9 @@ static const struct file_operations s225
 	.release = s2255_close,
 	.poll = s2255_poll,
 	.ioctl = video_ioctl2,	/* V4L2 ioctl handler */
+#ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l_compat_ioctl32,
+#endif
 	.mmap = s2255_mmap_v4l,
 	.llseek = no_llseek,
 };
diff -puN drivers/media/video/saa7134/saa7134-video.c~v4l_compat_ioctl32-cleanup-in-compat=n-case drivers/media/video/saa7134/saa7134-video.c
--- a/drivers/media/video/saa7134/saa7134-video.c~v4l_compat_ioctl32-cleanup-in-compat=n-case
+++ a/drivers/media/video/saa7134/saa7134-video.c
@@ -2371,7 +2371,9 @@ static const struct file_operations vide
 	.poll     = video_poll,
 	.mmap	  = video_mmap,
 	.ioctl	  = video_ioctl2,
+#ifdef CONFIG_COMPAT
 	.compat_ioctl	= v4l_compat_ioctl32,
+#endif
 	.llseek   = no_llseek,
 };
 
@@ -2431,7 +2433,9 @@ static const struct file_operations radi
 	.open	  = video_open,
 	.release  = video_release,
 	.ioctl	  = video_ioctl2,
+#ifdef CONFIG_COMPAT
 	.compat_ioctl	= v4l_compat_ioctl32,
+#endif
 	.llseek   = no_llseek,
 };
 
diff -puN drivers/media/video/usbvision/usbvision-video.c~v4l_compat_ioctl32-cleanup-in-compat=n-case drivers/media/video/usbvision/usbvision-video.c
--- a/drivers/media/video/usbvision/usbvision-video.c~v4l_compat_ioctl32-cleanup-in-compat=n-case
+++ a/drivers/media/video/usbvision/usbvision-video.c
@@ -1306,7 +1306,9 @@ static const struct file_operations usbv
 	.ioctl		= video_ioctl2,
 	.llseek		= no_llseek,
 /* 	.poll          = video_poll, */
+#ifdef CONFIG_COMPAT
 	.compat_ioctl  = v4l_compat_ioctl32,
+#endif
 };
 
 static const struct v4l2_ioctl_ops usbvision_ioctl_ops = {
@@ -1361,7 +1363,9 @@ static const struct file_operations usbv
 	.release	= usbvision_radio_close,
 	.ioctl		= video_ioctl2,
 	.llseek		= no_llseek,
+#ifdef CONFIG_COMPAT
 	.compat_ioctl  = v4l_compat_ioctl32,
+#endif
 };
 
 static const struct v4l2_ioctl_ops usbvision_radio_ioctl_ops = {
@@ -1398,7 +1402,9 @@ static const struct file_operations usbv
 	.release	= usbvision_vbi_close,
 	.ioctl		= usbvision_vbi_ioctl,
 	.llseek		= no_llseek,
+#ifdef CONFIG_COMPAT
 	.compat_ioctl  = v4l_compat_ioctl32,
+#endif
 };
 
 static struct video_device usbvision_vbi_template=
diff -puN drivers/media/video/uvc/uvc_v4l2.c~v4l_compat_ioctl32-cleanup-in-compat=n-case drivers/media/video/uvc/uvc_v4l2.c
--- a/drivers/media/video/uvc/uvc_v4l2.c~v4l_compat_ioctl32-cleanup-in-compat=n-case
+++ a/drivers/media/video/uvc/uvc_v4l2.c
@@ -1093,7 +1093,9 @@ struct file_operations uvc_fops = {
 	.open		= uvc_v4l2_open,
 	.release	= uvc_v4l2_release,
 	.ioctl		= uvc_v4l2_ioctl,
+#ifdef CONFIG_COMPAT
 	.compat_ioctl	= v4l_compat_ioctl32,
+#endif
 	.llseek		= no_llseek,
 	.read		= uvc_v4l2_read,
 	.mmap		= uvc_v4l2_mmap,
diff -puN drivers/media/video/vivi.c~v4l_compat_ioctl32-cleanup-in-compat=n-case drivers/media/video/vivi.c
--- a/drivers/media/video/vivi.c~v4l_compat_ioctl32-cleanup-in-compat=n-case
+++ a/drivers/media/video/vivi.c
@@ -1066,7 +1066,9 @@ static const struct file_operations vivi
 	.read           = vivi_read,
 	.poll		= vivi_poll,
 	.ioctl          = video_ioctl2, /* V4L2 ioctl handler */
+#ifdef CONFIG_COMPAT
 	.compat_ioctl   = v4l_compat_ioctl32,
+#endif
 	.mmap           = vivi_mmap,
 	.llseek         = no_llseek,
 };
diff -puN include/media/v4l2-ioctl.h~v4l_compat_ioctl32-cleanup-in-compat=n-case include/media/v4l2-ioctl.h
--- a/include/media/v4l2-ioctl.h~v4l_compat_ioctl32-cleanup-in-compat=n-case
+++ a/include/media/v4l2-ioctl.h
@@ -284,11 +284,11 @@ int v4l_compat_translate_ioctl(struct in
 #else
 #define v4l_compat_translate_ioctl(inode, file, cmd, arg, ioctl) (-EINVAL)
 #endif
-
+#ifdef CONFIG_COMPAT
 /* 32 Bits compatibility layer for 64 bits processors */
 extern long v4l_compat_ioctl32(struct file *file, unsigned int cmd,
 				unsigned long arg);
-
+#endif
 extern int video_ioctl2(struct inode *inode, struct file *file,
 			  unsigned int cmd, unsigned long arg);
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
less-softirq-vectors.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
compat_binfmt_elf-definition-tweak.patch
proc-move-sysrq-trigger-out-of-fs-proc.patch
proc-fix-return-value-of-proc_reg_open-in-too-late-case.patch
proc-proc_sys_root-tweak.patch
proc-remove-dummy-vmcore_open.patch
proc-remove-unused-get_dma_list.patch
sysctl-simplify-strategy.patch
fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch
fs-kconfig-move-autofs-autofs4-out.patch
fs-kconfig-move-cifs-out.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch
v4l_compat_ioctl32-cleanup-in-compat=n-case.patch


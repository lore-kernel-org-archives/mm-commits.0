From: akpm@osdl.org
Subject: + mark-struct-file_operations-const-4.patch added to -mm tree
Date: Tue, 23 Jan 2007 11:32:04 -0800
Message-ID: <200701231932.l0NJW4gm028985@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50767 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933120AbXAWTcN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 14:32:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     mark struct file_operations const 4
has been added to the -mm tree.  Its filename is
     mark-struct-file_operations-const-4.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mark struct file_operations const 4
From: Arjan van de Ven <arjan@linux.intel.com>

Many struct file_operations in the kernel can be "const".  Marking them const
moves these to the .rodata section, which avoids false sharing with potential
dirty data.  In addition it'll catch accidental writes at compile time to
these shared resources.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/macintosh/adb.c                         |    2 +-
 drivers/macintosh/ans-lcd.c                     |    2 +-
 drivers/macintosh/apm_emu.c                     |    2 +-
 drivers/macintosh/nvram.c                       |    2 +-
 drivers/macintosh/smu.c                         |    2 +-
 drivers/macintosh/via-pmu.c                     |    2 +-
 drivers/macintosh/via-pmu68k.c                  |    2 +-
 drivers/md/dm-ioctl.c                           |    2 +-
 drivers/md/md.c                                 |    2 +-
 drivers/media/common/saa7146_fops.c             |    2 +-
 drivers/media/radio/dsbr100.c                   |    2 +-
 drivers/media/radio/miropcm20-radio.c           |    2 +-
 drivers/media/radio/miropcm20-rds.c             |    2 +-
 drivers/media/radio/radio-aimslab.c             |    2 +-
 drivers/media/radio/radio-aztech.c              |    2 +-
 drivers/media/radio/radio-cadet.c               |    2 +-
 drivers/media/radio/radio-gemtek-pci.c          |    2 +-
 drivers/media/radio/radio-gemtek.c              |    2 +-
 drivers/media/radio/radio-maestro.c             |    2 +-
 drivers/media/radio/radio-maxiradio.c           |    2 +-
 drivers/media/radio/radio-rtrack2.c             |    2 +-
 drivers/media/radio/radio-sf16fmi.c             |    2 +-
 drivers/media/radio/radio-sf16fmr2.c            |    2 +-
 drivers/media/radio/radio-terratec.c            |    2 +-
 drivers/media/radio/radio-trust.c               |    2 +-
 drivers/media/radio/radio-typhoon.c             |    2 +-
 drivers/media/radio/radio-zoltrix.c             |    2 +-
 drivers/media/video/arv.c                       |    2 +-
 drivers/media/video/bt8xx/bttv-driver.c         |    4 ++--
 drivers/media/video/bw-qcam.c                   |    2 +-
 drivers/media/video/c-qcam.c                    |    2 +-
 drivers/media/video/cafe_ccic.c                 |    6 +++---
 drivers/media/video/cpia.c                      |    2 +-
 drivers/media/video/cpia2/cpia2_v4l.c           |    2 +-
 drivers/media/video/cx88/cx88-blackbird.c       |    2 +-
 drivers/media/video/cx88/cx88-video.c           |    4 ++--
 drivers/media/video/dabusb.c                    |    2 +-
 drivers/media/video/em28xx/em28xx-video.c       |    2 +-
 drivers/media/video/et61x251/et61x251_core.c    |    2 +-
 drivers/media/video/meye.c                      |    2 +-
 drivers/media/video/ov511.c                     |    2 +-
 drivers/media/video/pms.c                       |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c      |    2 +-
 drivers/media/video/pwc/pwc-if.c                |    2 +-
 drivers/media/video/saa5246a.c                  |    2 +-
 drivers/media/video/saa5249.c                   |    2 +-
 drivers/media/video/saa7134/saa7134-empress.c   |    2 +-
 drivers/media/video/saa7134/saa7134-oss.c       |    4 ++--
 drivers/media/video/saa7134/saa7134-video.c     |    4 ++--
 drivers/media/video/se401.c                     |    2 +-
 drivers/media/video/sn9c102/sn9c102_core.c      |    2 +-
 drivers/media/video/stradis.c                   |    2 +-
 drivers/media/video/stv680.c                    |    2 +-
 drivers/media/video/tvmixer.c                   |    2 +-
 drivers/media/video/usbvideo/usbvideo.c         |    2 +-
 drivers/media/video/usbvideo/vicam.c            |    2 +-
 drivers/media/video/usbvision/usbvision-video.c |    6 +++---
 drivers/media/video/videodev.c                  |    4 ++--
 drivers/media/video/vino.c                      |    2 +-
 drivers/media/video/vivi.c                      |    2 +-
 drivers/media/video/w9966.c                     |    2 +-
 drivers/media/video/w9968cf.c                   |    4 ++--
 drivers/media/video/zc0301/zc0301_core.c        |    2 +-
 drivers/media/video/zoran_driver.c              |    2 +-
 drivers/media/video/zoran_procfs.c              |    2 +-
 drivers/message/fusion/mptctl.c                 |    2 +-
 66 files changed, 76 insertions(+), 76 deletions(-)

diff -puN drivers/macintosh/adb.c~mark-struct-file_operations-const-4 drivers/macintosh/adb.c
--- a/drivers/macintosh/adb.c~mark-struct-file_operations-const-4
+++ a/drivers/macintosh/adb.c
@@ -885,7 +885,7 @@ out:
 	return ret;
 }
 
-static struct file_operations adb_fops = {
+static const struct file_operations adb_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.read		= adb_read,
diff -puN drivers/macintosh/ans-lcd.c~mark-struct-file_operations-const-4 drivers/macintosh/ans-lcd.c
--- a/drivers/macintosh/ans-lcd.c~mark-struct-file_operations-const-4
+++ a/drivers/macintosh/ans-lcd.c
@@ -121,7 +121,7 @@ anslcd_open( struct inode * inode, struc
 	return 0;
 }
 
-struct file_operations anslcd_fops = {
+const struct file_operations anslcd_fops = {
 	.write	= anslcd_write,
 	.ioctl	= anslcd_ioctl,
 	.open	= anslcd_open,
diff -puN drivers/macintosh/apm_emu.c~mark-struct-file_operations-const-4 drivers/macintosh/apm_emu.c
--- a/drivers/macintosh/apm_emu.c~mark-struct-file_operations-const-4
+++ a/drivers/macintosh/apm_emu.c
@@ -501,7 +501,7 @@ static int apm_emu_get_info(char *buf, c
 	return p - buf;
 }
 
-static struct file_operations apm_bios_fops = {
+static const struct file_operations apm_bios_fops = {
 	.owner		= THIS_MODULE,
 	.read		= do_read,
 	.poll		= do_poll,
diff -puN drivers/macintosh/nvram.c~mark-struct-file_operations-const-4 drivers/macintosh/nvram.c
--- a/drivers/macintosh/nvram.c~mark-struct-file_operations-const-4
+++ a/drivers/macintosh/nvram.c
@@ -100,7 +100,7 @@ static int nvram_ioctl(struct inode *ino
 	return 0;
 }
 
-struct file_operations nvram_fops = {
+const struct file_operations nvram_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= nvram_llseek,
 	.read		= read_nvram,
diff -puN drivers/macintosh/smu.c~mark-struct-file_operations-const-4 drivers/macintosh/smu.c
--- a/drivers/macintosh/smu.c~mark-struct-file_operations-const-4
+++ a/drivers/macintosh/smu.c
@@ -1277,7 +1277,7 @@ static int smu_release(struct inode *ino
 }
 
 
-static struct file_operations smu_device_fops = {
+static const struct file_operations smu_device_fops = {
 	.llseek		= no_llseek,
 	.read		= smu_read,
 	.write		= smu_write,
diff -puN drivers/macintosh/via-pmu.c~mark-struct-file_operations-const-4 drivers/macintosh/via-pmu.c
--- a/drivers/macintosh/via-pmu.c~mark-struct-file_operations-const-4
+++ a/drivers/macintosh/via-pmu.c
@@ -2672,7 +2672,7 @@ pmu_ioctl(struct inode * inode, struct f
 	return error;
 }
 
-static struct file_operations pmu_device_fops = {
+static const struct file_operations pmu_device_fops = {
 	.read		= pmu_read,
 	.write		= pmu_write,
 	.poll		= pmu_fpoll,
diff -puN drivers/macintosh/via-pmu68k.c~mark-struct-file_operations-const-4 drivers/macintosh/via-pmu68k.c
--- a/drivers/macintosh/via-pmu68k.c~mark-struct-file_operations-const-4
+++ a/drivers/macintosh/via-pmu68k.c
@@ -1039,7 +1039,7 @@ static int pmu_ioctl(struct inode * inod
 	return -EINVAL;
 }
 
-static struct file_operations pmu_device_fops = {
+static const struct file_operations pmu_device_fops = {
 	.read		= pmu_read,
 	.write		= pmu_write,
 	.ioctl		= pmu_ioctl,
diff -puN drivers/md/dm-ioctl.c~mark-struct-file_operations-const-4 drivers/md/dm-ioctl.c
--- a/drivers/md/dm-ioctl.c~mark-struct-file_operations-const-4
+++ a/drivers/md/dm-ioctl.c
@@ -1473,7 +1473,7 @@ static int ctl_ioctl(struct inode *inode
 	return r;
 }
 
-static struct file_operations _ctl_fops = {
+static const struct file_operations _ctl_fops = {
 	.ioctl	 = ctl_ioctl,
 	.owner	 = THIS_MODULE,
 };
diff -puN drivers/md/md.c~mark-struct-file_operations-const-4 drivers/md/md.c
--- a/drivers/md/md.c~mark-struct-file_operations-const-4
+++ a/drivers/md/md.c
@@ -4917,7 +4917,7 @@ static unsigned int mdstat_poll(struct f
 	return mask;
 }
 
-static struct file_operations md_seq_fops = {
+static const struct file_operations md_seq_fops = {
 	.owner		= THIS_MODULE,
 	.open           = md_seq_open,
 	.read           = seq_read,
diff -puN drivers/media/common/saa7146_fops.c~mark-struct-file_operations-const-4 drivers/media/common/saa7146_fops.c
--- a/drivers/media/common/saa7146_fops.c~mark-struct-file_operations-const-4
+++ a/drivers/media/common/saa7146_fops.c
@@ -416,7 +416,7 @@ static ssize_t fops_write(struct file *f
 	}
 }
 
-static struct file_operations video_fops =
+static const struct file_operations video_fops =
 {
 	.owner		= THIS_MODULE,
 	.open		= fops_open,
diff -puN drivers/media/radio/dsbr100.c~mark-struct-file_operations-const-4 drivers/media/radio/dsbr100.c
--- a/drivers/media/radio/dsbr100.c~mark-struct-file_operations-const-4
+++ a/drivers/media/radio/dsbr100.c
@@ -144,7 +144,7 @@ struct dsbr100_device {
 
 
 /* File system interface */
-static struct file_operations usb_dsbr100_fops = {
+static const struct file_operations usb_dsbr100_fops = {
 	.owner =	THIS_MODULE,
 	.open =		usb_dsbr100_open,
 	.release =     	usb_dsbr100_close,
diff -puN drivers/media/radio/miropcm20-radio.c~mark-struct-file_operations-const-4 drivers/media/radio/miropcm20-radio.c
--- a/drivers/media/radio/miropcm20-radio.c~mark-struct-file_operations-const-4
+++ a/drivers/media/radio/miropcm20-radio.c
@@ -216,7 +216,7 @@ static struct pcm20_device pcm20_unit = 
 	.muted  = 1,
 };
 
-static struct file_operations pcm20_fops = {
+static const struct file_operations pcm20_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
diff -puN drivers/media/radio/miropcm20-rds.c~mark-struct-file_operations-const-4 drivers/media/radio/miropcm20-rds.c
--- a/drivers/media/radio/miropcm20-rds.c~mark-struct-file_operations-const-4
+++ a/drivers/media/radio/miropcm20-rds.c
@@ -104,7 +104,7 @@ static ssize_t rds_f_read(struct file *f
 	}
 }
 
-static struct file_operations rds_fops = {
+static const struct file_operations rds_fops = {
 	.owner		= THIS_MODULE,
 	.read		= rds_f_read,
 	.open		= rds_f_open,
diff -puN drivers/media/radio/radio-aimslab.c~mark-struct-file_operations-const-4 drivers/media/radio/radio-aimslab.c
--- a/drivers/media/radio/radio-aimslab.c~mark-struct-file_operations-const-4
+++ a/drivers/media/radio/radio-aimslab.c
@@ -358,7 +358,7 @@ static int rt_ioctl(struct inode *inode,
 
 static struct rt_device rtrack_unit;
 
-static struct file_operations rtrack_fops = {
+static const struct file_operations rtrack_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
diff -puN drivers/media/radio/radio-aztech.c~mark-struct-file_operations-const-4 drivers/media/radio/radio-aztech.c
--- a/drivers/media/radio/radio-aztech.c~mark-struct-file_operations-const-4
+++ a/drivers/media/radio/radio-aztech.c
@@ -314,7 +314,7 @@ static int az_ioctl(struct inode *inode,
 
 static struct az_device aztech_unit;
 
-static struct file_operations aztech_fops = {
+static const struct file_operations aztech_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
diff -puN drivers/media/radio/radio-cadet.c~mark-struct-file_operations-const-4 drivers/media/radio/radio-cadet.c
--- a/drivers/media/radio/radio-cadet.c~mark-struct-file_operations-const-4
+++ a/drivers/media/radio/radio-cadet.c
@@ -507,7 +507,7 @@ cadet_poll(struct file *file, struct pol
 }
 
 
-static struct file_operations cadet_fops = {
+static const struct file_operations cadet_fops = {
 	.owner		= THIS_MODULE,
 	.open		= cadet_open,
 	.release       	= cadet_release,
diff -puN drivers/media/radio/radio-gemtek-pci.c~mark-struct-file_operations-const-4 drivers/media/radio/radio-gemtek-pci.c
--- a/drivers/media/radio/radio-gemtek-pci.c~mark-struct-file_operations-const-4
+++ a/drivers/media/radio/radio-gemtek-pci.c
@@ -346,7 +346,7 @@ MODULE_DEVICE_TABLE( pci, gemtek_pci_id 
 
 static int mx = 1;
 
-static struct file_operations gemtek_pci_fops = {
+static const struct file_operations gemtek_pci_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
diff -puN drivers/media/radio/radio-gemtek.c~mark-struct-file_operations-const-4 drivers/media/radio/radio-gemtek.c
--- a/drivers/media/radio/radio-gemtek.c~mark-struct-file_operations-const-4
+++ a/drivers/media/radio/radio-gemtek.c
@@ -296,7 +296,7 @@ static int gemtek_ioctl(struct inode *in
 
 static struct gemtek_device gemtek_unit;
 
-static struct file_operations gemtek_fops = {
+static const struct file_operations gemtek_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
diff -puN drivers/media/radio/radio-maestro.c~mark-struct-file_operations-const-4 drivers/media/radio/radio-maestro.c
--- a/drivers/media/radio/radio-maestro.c~mark-struct-file_operations-const-4
+++ a/drivers/media/radio/radio-maestro.c
@@ -98,7 +98,7 @@ static struct pci_driver maestro_r_drive
 	.remove		= __devexit_p(maestro_remove),
 };
 
-static struct file_operations maestro_fops = {
+static const struct file_operations maestro_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
diff -puN drivers/media/radio/radio-maxiradio.c~mark-struct-file_operations-const-4 drivers/media/radio/radio-maxiradio.c
--- a/drivers/media/radio/radio-maxiradio.c~mark-struct-file_operations-const-4
+++ a/drivers/media/radio/radio-maxiradio.c
@@ -90,7 +90,7 @@ module_param(radio_nr, int, 0);
 static int radio_ioctl(struct inode *inode, struct file *file,
 		       unsigned int cmd, unsigned long arg);
 
-static struct file_operations maxiradio_fops = {
+static const struct file_operations maxiradio_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
diff -puN drivers/media/radio/radio-rtrack2.c~mark-struct-file_operations-const-4 drivers/media/radio/radio-rtrack2.c
--- a/drivers/media/radio/radio-rtrack2.c~mark-struct-file_operations-const-4
+++ a/drivers/media/radio/radio-rtrack2.c
@@ -262,7 +262,7 @@ static int rt_ioctl(struct inode *inode,
 
 static struct rt_device rtrack2_unit;
 
-static struct file_operations rtrack2_fops = {
+static const struct file_operations rtrack2_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
diff -puN drivers/media/radio/radio-sf16fmi.c~mark-struct-file_operations-const-4 drivers/media/radio/radio-sf16fmi.c
--- a/drivers/media/radio/radio-sf16fmi.c~mark-struct-file_operations-const-4
+++ a/drivers/media/radio/radio-sf16fmi.c
@@ -265,7 +265,7 @@ static int fmi_ioctl(struct inode *inode
 
 static struct fmi_device fmi_unit;
 
-static struct file_operations fmi_fops = {
+static const struct file_operations fmi_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
diff -puN drivers/media/radio/radio-sf16fmr2.c~mark-struct-file_operations-const-4 drivers/media/radio/radio-sf16fmr2.c
--- a/drivers/media/radio/radio-sf16fmr2.c~mark-struct-file_operations-const-4
+++ a/drivers/media/radio/radio-sf16fmr2.c
@@ -410,7 +410,7 @@ static int fmr2_ioctl(struct inode *inod
 
 static struct fmr2_device fmr2_unit;
 
-static struct file_operations fmr2_fops = {
+static const struct file_operations fmr2_fops = {
 	.owner          = THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
diff -puN drivers/media/radio/radio-terratec.c~mark-struct-file_operations-const-4 drivers/media/radio/radio-terratec.c
--- a/drivers/media/radio/radio-terratec.c~mark-struct-file_operations-const-4
+++ a/drivers/media/radio/radio-terratec.c
@@ -338,7 +338,7 @@ static int tt_ioctl(struct inode *inode,
 
 static struct tt_device terratec_unit;
 
-static struct file_operations terratec_fops = {
+static const struct file_operations terratec_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
diff -puN drivers/media/radio/radio-trust.c~mark-struct-file_operations-const-4 drivers/media/radio/radio-trust.c
--- a/drivers/media/radio/radio-trust.c~mark-struct-file_operations-const-4
+++ a/drivers/media/radio/radio-trust.c
@@ -325,7 +325,7 @@ static int tr_ioctl(struct inode *inode,
 	return video_usercopy(inode, file, cmd, arg, tr_do_ioctl);
 }
 
-static struct file_operations trust_fops = {
+static const struct file_operations trust_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
diff -puN drivers/media/radio/radio-typhoon.c~mark-struct-file_operations-const-4 drivers/media/radio/radio-typhoon.c
--- a/drivers/media/radio/radio-typhoon.c~mark-struct-file_operations-const-4
+++ a/drivers/media/radio/radio-typhoon.c
@@ -318,7 +318,7 @@ static struct typhoon_device typhoon_uni
 	.mutefreq	= CONFIG_RADIO_TYPHOON_MUTEFREQ,
 };
 
-static struct file_operations typhoon_fops = {
+static const struct file_operations typhoon_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
diff -puN drivers/media/radio/radio-zoltrix.c~mark-struct-file_operations-const-4 drivers/media/radio/radio-zoltrix.c
--- a/drivers/media/radio/radio-zoltrix.c~mark-struct-file_operations-const-4
+++ a/drivers/media/radio/radio-zoltrix.c
@@ -373,7 +373,7 @@ static int zol_ioctl(struct inode *inode
 
 static struct zol_device zoltrix_unit;
 
-static struct file_operations zoltrix_fops =
+static const struct file_operations zoltrix_fops =
 {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
diff -puN drivers/media/video/arv.c~mark-struct-file_operations-const-4 drivers/media/video/arv.c
--- a/drivers/media/video/arv.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/arv.c
@@ -742,7 +742,7 @@ void ar_release(struct video_device *vfd
  * Video4Linux Module functions
  *
  ****************************************************************************/
-static struct file_operations ar_fops = {
+static const struct file_operations ar_fops = {
 	.owner		= THIS_MODULE,
 	.open		= video_exclusive_open,
 	.release	= video_exclusive_release,
diff -puN drivers/media/video/bt8xx/bttv-driver.c~mark-struct-file_operations-const-4 drivers/media/video/bt8xx/bttv-driver.c
--- a/drivers/media/video/bt8xx/bttv-driver.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/bt8xx/bttv-driver.c
@@ -3809,7 +3809,7 @@ bttv_mmap(struct file *file, struct vm_a
 	return videobuf_mmap_mapper(bttv_queue(fh),vma);
 }
 
-static struct file_operations bttv_fops =
+static const struct file_operations bttv_fops =
 {
 	.owner	  = THIS_MODULE,
 	.open	  = bttv_open,
@@ -3967,7 +3967,7 @@ static unsigned int radio_poll(struct fi
 	return cmd.result;
 }
 
-static struct file_operations radio_fops =
+static const struct file_operations radio_fops =
 {
 	.owner	  = THIS_MODULE,
 	.open	  = radio_open,
diff -puN drivers/media/video/bw-qcam.c~mark-struct-file_operations-const-4 drivers/media/video/bw-qcam.c
--- a/drivers/media/video/bw-qcam.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/bw-qcam.c
@@ -871,7 +871,7 @@ static ssize_t qcam_read(struct file *fi
 	return len;
 }
 
-static struct file_operations qcam_fops = {
+static const struct file_operations qcam_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
diff -puN drivers/media/video/c-qcam.c~mark-struct-file_operations-const-4 drivers/media/video/c-qcam.c
--- a/drivers/media/video/c-qcam.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/c-qcam.c
@@ -684,7 +684,7 @@ static ssize_t qcam_read(struct file *fi
 }
 
 /* video device template */
-static struct file_operations qcam_fops = {
+static const struct file_operations qcam_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
diff -puN drivers/media/video/cafe_ccic.c~mark-struct-file_operations-const-4 drivers/media/video/cafe_ccic.c
--- a/drivers/media/video/cafe_ccic.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/cafe_ccic.c
@@ -1716,7 +1716,7 @@ static void cafe_v4l_dev_release(struct 
  * clone it for specific real devices.
  */
 
-static struct file_operations cafe_v4l_fops = {
+static const struct file_operations cafe_v4l_fops = {
 	.owner = THIS_MODULE,
 	.open = cafe_v4l_open,
 	.release = cafe_v4l_release,
@@ -1970,7 +1970,7 @@ static ssize_t cafe_dfs_read_regs(struct
 			s - cafe_debug_buf);
 }
 
-static struct file_operations cafe_dfs_reg_ops = {
+static const struct file_operations cafe_dfs_reg_ops = {
 	.owner = THIS_MODULE,
 	.read = cafe_dfs_read_regs,
 	.open = cafe_dfs_open
@@ -1996,7 +1996,7 @@ static ssize_t cafe_dfs_read_cam(struct 
 			s - cafe_debug_buf);
 }
 
-static struct file_operations cafe_dfs_cam_ops = {
+static const struct file_operations cafe_dfs_cam_ops = {
 	.owner = THIS_MODULE,
 	.read = cafe_dfs_read_cam,
 	.open = cafe_dfs_open
diff -puN drivers/media/video/cpia.c~mark-struct-file_operations-const-4 drivers/media/video/cpia.c
--- a/drivers/media/video/cpia.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/cpia.c
@@ -3790,7 +3790,7 @@ static int cpia_mmap(struct file *file, 
 	return 0;
 }
 
-static struct file_operations cpia_fops = {
+static const struct file_operations cpia_fops = {
 	.owner		= THIS_MODULE,
 	.open		= cpia_open,
 	.release       	= cpia_close,
diff -puN drivers/media/video/cpia2/cpia2_v4l.c~mark-struct-file_operations-const-4 drivers/media/video/cpia2/cpia2_v4l.c
--- a/drivers/media/video/cpia2/cpia2_v4l.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/cpia2/cpia2_v4l.c
@@ -1924,7 +1924,7 @@ static void reset_camera_struct_v4l(stru
 /***
  * The v4l video device structure initialized for this device
  ***/
-static struct file_operations fops_template = {
+static const struct file_operations fops_template = {
 	.owner		= THIS_MODULE,
 	.open		= cpia2_open,
 	.release	= cpia2_close,
diff -puN drivers/media/video/cx88/cx88-blackbird.c~mark-struct-file_operations-const-4 drivers/media/video/cx88/cx88-blackbird.c
--- a/drivers/media/video/cx88/cx88-blackbird.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/cx88/cx88-blackbird.c
@@ -1185,7 +1185,7 @@ mpeg_mmap(struct file *file, struct vm_a
 	return videobuf_mmap_mapper(&fh->mpegq, vma);
 }
 
-static struct file_operations mpeg_fops =
+static const struct file_operations mpeg_fops =
 {
 	.owner	       = THIS_MODULE,
 	.open	       = mpeg_open,
diff -puN drivers/media/video/cx88/cx88-video.c~mark-struct-file_operations-const-4 drivers/media/video/cx88/cx88-video.c
--- a/drivers/media/video/cx88/cx88-video.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/cx88/cx88-video.c
@@ -1608,7 +1608,7 @@ static irqreturn_t cx8800_irq(int irq, v
 /* ----------------------------------------------------------- */
 /* exported stuff                                              */
 
-static struct file_operations video_fops =
+static const struct file_operations video_fops =
 {
 	.owner	       = THIS_MODULE,
 	.open	       = video_open,
@@ -1660,7 +1660,7 @@ static struct video_device cx8800_video_
        .current_norm         = V4L2_STD_NTSC_M,
 };
 
-static struct file_operations radio_fops =
+static const struct file_operations radio_fops =
 {
 	.owner         = THIS_MODULE,
 	.open          = video_open,
diff -puN drivers/media/video/dabusb.c~mark-struct-file_operations-const-4 drivers/media/video/dabusb.c
--- a/drivers/media/video/dabusb.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/dabusb.c
@@ -696,7 +696,7 @@ static int dabusb_ioctl (struct inode *i
 	return ret;
 }
 
-static struct file_operations dabusb_fops =
+static const struct file_operations dabusb_fops =
 {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
diff -puN drivers/media/video/em28xx/em28xx-video.c~mark-struct-file_operations-const-4 drivers/media/video/em28xx/em28xx-video.c
--- a/drivers/media/video/em28xx/em28xx-video.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/em28xx/em28xx-video.c
@@ -1480,7 +1480,7 @@ static int em28xx_v4l2_ioctl(struct inod
 	return ret;
 }
 
-static struct file_operations em28xx_v4l_fops = {
+static const struct file_operations em28xx_v4l_fops = {
 	.owner = THIS_MODULE,
 	.open = em28xx_v4l2_open,
 	.release = em28xx_v4l2_close,
diff -puN drivers/media/video/et61x251/et61x251_core.c~mark-struct-file_operations-const-4 drivers/media/video/et61x251/et61x251_core.c
--- a/drivers/media/video/et61x251/et61x251_core.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/et61x251/et61x251_core.c
@@ -2494,7 +2494,7 @@ static int et61x251_ioctl(struct inode* 
 }
 
 
-static struct file_operations et61x251_fops = {
+static const struct file_operations et61x251_fops = {
 	.owner = THIS_MODULE,
 	.open =    et61x251_open,
 	.release = et61x251_release,
diff -puN drivers/media/video/meye.c~mark-struct-file_operations-const-4 drivers/media/video/meye.c
--- a/drivers/media/video/meye.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/meye.c
@@ -1747,7 +1747,7 @@ static int meye_mmap(struct file *file, 
 	return 0;
 }
 
-static struct file_operations meye_fops = {
+static const struct file_operations meye_fops = {
 	.owner		= THIS_MODULE,
 	.open		= meye_open,
 	.release	= meye_release,
diff -puN drivers/media/video/ov511.c~mark-struct-file_operations-const-4 drivers/media/video/ov511.c
--- a/drivers/media/video/ov511.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/ov511.c
@@ -4653,7 +4653,7 @@ ov51x_v4l1_mmap(struct file *file, struc
 	return 0;
 }
 
-static struct file_operations ov511_fops = {
+static const struct file_operations ov511_fops = {
 	.owner =	THIS_MODULE,
 	.open =		ov51x_v4l1_open,
 	.release =	ov51x_v4l1_close,
diff -puN drivers/media/video/pms.c~mark-struct-file_operations-const-4 drivers/media/video/pms.c
--- a/drivers/media/video/pms.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/pms.c
@@ -880,7 +880,7 @@ static ssize_t pms_read(struct file *fil
 	return len;
 }
 
-static struct file_operations pms_fops = {
+static const struct file_operations pms_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
diff -puN drivers/media/video/pvrusb2/pvrusb2-v4l2.c~mark-struct-file_operations-const-4 drivers/media/video/pvrusb2/pvrusb2-v4l2.c
--- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -1109,7 +1109,7 @@ static unsigned int pvr2_v4l2_poll(struc
 }
 
 
-static struct file_operations vdev_fops = {
+static const struct file_operations vdev_fops = {
 	.owner      = THIS_MODULE,
 	.open       = pvr2_v4l2_open,
 	.release    = pvr2_v4l2_release,
diff -puN drivers/media/video/pwc/pwc-if.c~mark-struct-file_operations-const-4 drivers/media/video/pwc/pwc-if.c
--- a/drivers/media/video/pwc/pwc-if.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/pwc/pwc-if.c
@@ -152,7 +152,7 @@ static int  pwc_video_ioctl(struct inode
 			    unsigned int ioctlnr, unsigned long arg);
 static int  pwc_video_mmap(struct file *file, struct vm_area_struct *vma);
 
-static struct file_operations pwc_fops = {
+static const struct file_operations pwc_fops = {
 	.owner =	THIS_MODULE,
 	.open =		pwc_video_open,
 	.release =     	pwc_video_close,
diff -puN drivers/media/video/saa5246a.c~mark-struct-file_operations-const-4 drivers/media/video/saa5246a.c
--- a/drivers/media/video/saa5246a.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/saa5246a.c
@@ -816,7 +816,7 @@ static void __exit cleanup_saa_5246a (vo
 module_init(init_saa_5246a);
 module_exit(cleanup_saa_5246a);
 
-static struct file_operations saa_fops = {
+static const struct file_operations saa_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = saa5246a_open,
 	.release = saa5246a_release,
diff -puN drivers/media/video/saa5249.c~mark-struct-file_operations-const-4 drivers/media/video/saa5249.c
--- a/drivers/media/video/saa5249.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/saa5249.c
@@ -699,7 +699,7 @@ static void __exit cleanup_saa_5249 (voi
 module_init(init_saa_5249);
 module_exit(cleanup_saa_5249);
 
-static struct file_operations saa_fops = {
+static const struct file_operations saa_fops = {
 	.owner		= THIS_MODULE,
 	.open		= saa5249_open,
 	.release       	= saa5249_release,
diff -puN drivers/media/video/saa7134/saa7134-empress.c~mark-struct-file_operations-const-4 drivers/media/video/saa7134/saa7134-empress.c
--- a/drivers/media/video/saa7134/saa7134-empress.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/saa7134/saa7134-empress.c
@@ -319,7 +319,7 @@ static int ts_ioctl(struct inode *inode,
 	return video_usercopy(inode, file, cmd, arg, ts_do_ioctl);
 }
 
-static struct file_operations ts_fops =
+static const struct file_operations ts_fops =
 {
 	.owner	  = THIS_MODULE,
 	.open	  = ts_open,
diff -puN drivers/media/video/saa7134/saa7134-oss.c~mark-struct-file_operations-const-4 drivers/media/video/saa7134/saa7134-oss.c
--- a/drivers/media/video/saa7134/saa7134-oss.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/saa7134/saa7134-oss.c
@@ -563,7 +563,7 @@ static unsigned int dsp_poll(struct file
 	return mask;
 }
 
-struct file_operations saa7134_dsp_fops = {
+const struct file_operations saa7134_dsp_fops = {
 	.owner   = THIS_MODULE,
 	.open    = dsp_open,
 	.release = dsp_release,
@@ -804,7 +804,7 @@ static int mixer_ioctl(struct inode *ino
 	}
 }
 
-struct file_operations saa7134_mixer_fops = {
+const struct file_operations saa7134_mixer_fops = {
 	.owner   = THIS_MODULE,
 	.open    = mixer_open,
 	.release = mixer_release,
diff -puN drivers/media/video/saa7134/saa7134-video.c~mark-struct-file_operations-const-4 drivers/media/video/saa7134/saa7134-video.c
--- a/drivers/media/video/saa7134/saa7134-video.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/saa7134/saa7134-video.c
@@ -2336,7 +2336,7 @@ static int radio_ioctl(struct inode *ino
 	return video_usercopy(inode, file, cmd, arg, radio_do_ioctl);
 }
 
-static struct file_operations video_fops =
+static const struct file_operations video_fops =
 {
 	.owner	  = THIS_MODULE,
 	.open	  = video_open,
@@ -2349,7 +2349,7 @@ static struct file_operations video_fops
 	.llseek   = no_llseek,
 };
 
-static struct file_operations radio_fops =
+static const struct file_operations radio_fops =
 {
 	.owner	  = THIS_MODULE,
 	.open	  = video_open,
diff -puN drivers/media/video/se401.c~mark-struct-file_operations-const-4 drivers/media/video/se401.c
--- a/drivers/media/video/se401.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/se401.c
@@ -1185,7 +1185,7 @@ static int se401_mmap(struct file *file,
 	return 0;
 }
 
-static struct file_operations se401_fops = {
+static const struct file_operations se401_fops = {
 	.owner =	THIS_MODULE,
 	.open =         se401_open,
 	.release =      se401_close,
diff -puN drivers/media/video/sn9c102/sn9c102_core.c~mark-struct-file_operations-const-4 drivers/media/video/sn9c102/sn9c102_core.c
--- a/drivers/media/video/sn9c102/sn9c102_core.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/sn9c102/sn9c102_core.c
@@ -3121,7 +3121,7 @@ static int sn9c102_ioctl(struct inode* i
 
 /*****************************************************************************/
 
-static struct file_operations sn9c102_fops = {
+static const struct file_operations sn9c102_fops = {
 	.owner = THIS_MODULE,
 	.open =    sn9c102_open,
 	.release = sn9c102_release,
diff -puN drivers/media/video/stradis.c~mark-struct-file_operations-const-4 drivers/media/video/stradis.c
--- a/drivers/media/video/stradis.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/stradis.c
@@ -1901,7 +1901,7 @@ static int saa_release(struct inode *ino
 	return 0;
 }
 
-static struct file_operations saa_fops = {
+static const struct file_operations saa_fops = {
 	.owner = THIS_MODULE,
 	.open = saa_open,
 	.release = saa_release,
diff -puN drivers/media/video/stv680.c~mark-struct-file_operations-const-4 drivers/media/video/stv680.c
--- a/drivers/media/video/stv680.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/stv680.c
@@ -1380,7 +1380,7 @@ static ssize_t stv680_read (struct file 
 	return realcount;
 }				/* stv680_read */
 
-static struct file_operations stv680_fops = {
+static const struct file_operations stv680_fops = {
 	.owner =	THIS_MODULE,
 	.open =		stv_open,
 	.release =     	stv_close,
diff -puN drivers/media/video/tvmixer.c~mark-struct-file_operations-const-4 drivers/media/video/tvmixer.c
--- a/drivers/media/video/tvmixer.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/tvmixer.c
@@ -226,7 +226,7 @@ static struct i2c_driver driver = {
 	.detach_client   = tvmixer_clients,
 };
 
-static struct file_operations tvmixer_fops = {
+static const struct file_operations tvmixer_fops = {
 	.owner		= THIS_MODULE,
 	.llseek         = no_llseek,
 	.ioctl          = tvmixer_ioctl,
diff -puN drivers/media/video/usbvideo/usbvideo.c~mark-struct-file_operations-const-4 drivers/media/video/usbvideo/usbvideo.c
--- a/drivers/media/video/usbvideo/usbvideo.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/usbvideo/usbvideo.c
@@ -945,7 +945,7 @@ static int usbvideo_find_struct(struct u
 	return rv;
 }
 
-static struct file_operations usbvideo_fops = {
+static const struct file_operations usbvideo_fops = {
 	.owner =  THIS_MODULE,
 	.open =   usbvideo_v4l_open,
 	.release =usbvideo_v4l_close,
diff -puN drivers/media/video/usbvideo/vicam.c~mark-struct-file_operations-const-4 drivers/media/video/usbvideo/vicam.c
--- a/drivers/media/video/usbvideo/vicam.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/usbvideo/vicam.c
@@ -1234,7 +1234,7 @@ static inline void vicam_create_proc_ent
 static inline void vicam_destroy_proc_entry(void *ptr) { }
 #endif
 
-static struct file_operations vicam_fops = {
+static const struct file_operations vicam_fops = {
 	.owner		= THIS_MODULE,
 	.open		= vicam_open,
 	.release	= vicam_close,
diff -puN drivers/media/video/usbvision/usbvision-video.c~mark-struct-file_operations-const-4 drivers/media/video/usbvision/usbvision-video.c
--- a/drivers/media/video/usbvision/usbvision-video.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/usbvision/usbvision-video.c
@@ -1474,7 +1474,7 @@ static int usbvision_vbi_ioctl(struct in
 //
 
 // Video template
-static struct file_operations usbvision_fops = {
+static const struct file_operations usbvision_fops = {
 	.owner             = THIS_MODULE,
 	.open		= usbvision_v4l2_open,
 	.release	= usbvision_v4l2_close,
@@ -1495,7 +1495,7 @@ static struct video_device usbvision_vid
 
 
 // Radio template
-static struct file_operations usbvision_radio_fops = {
+static const struct file_operations usbvision_radio_fops = {
 	.owner             = THIS_MODULE,
 	.open		= usbvision_radio_open,
 	.release	= usbvision_radio_close,
@@ -1516,7 +1516,7 @@ static struct video_device usbvision_rad
 
 
 // vbi template
-static struct file_operations usbvision_vbi_fops = {
+static const struct file_operations usbvision_vbi_fops = {
 	.owner             = THIS_MODULE,
 	.open		= usbvision_vbi_open,
 	.release	= usbvision_vbi_close,
diff -puN drivers/media/video/videodev.c~mark-struct-file_operations-const-4 drivers/media/video/videodev.c
--- a/drivers/media/video/videodev.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/videodev.c
@@ -1560,7 +1560,7 @@ out:
 }
 
 
-static struct file_operations video_fops;
+static const struct file_operations video_fops;
 
 /**
  *	video_register_device - register video4linux devices
@@ -1708,7 +1708,7 @@ void video_unregister_device(struct vide
 /*
  * Video fs operations
  */
-static struct file_operations video_fops=
+static const struct file_operations video_fops=
 {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
diff -puN drivers/media/video/vino.c~mark-struct-file_operations-const-4 drivers/media/video/vino.c
--- a/drivers/media/video/vino.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/vino.c
@@ -4390,7 +4390,7 @@ static int vino_ioctl(struct inode *inod
 // __initdata
 static int vino_init_stage = 0;
 
-static struct file_operations vino_fops = {
+static const struct file_operations vino_fops = {
 	.owner		= THIS_MODULE,
 	.open		= vino_open,
 	.release	= vino_close,
diff -puN drivers/media/video/vivi.c~mark-struct-file_operations-const-4 drivers/media/video/vivi.c
--- a/drivers/media/video/vivi.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/vivi.c
@@ -1297,7 +1297,7 @@ vivi_mmap(struct file *file, struct vm_a
 	return ret;
 }
 
-static struct file_operations vivi_fops = {
+static const struct file_operations vivi_fops = {
 	.owner		= THIS_MODULE,
 	.open           = vivi_open,
 	.release        = vivi_release,
diff -puN drivers/media/video/w9966.c~mark-struct-file_operations-const-4 drivers/media/video/w9966.c
--- a/drivers/media/video/w9966.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/w9966.c
@@ -183,7 +183,7 @@ static int w9966_v4l_ioctl(struct inode 
 static ssize_t w9966_v4l_read(struct file *file, char __user *buf,
 			      size_t count, loff_t *ppos);
 
-static struct file_operations w9966_fops = {
+static const struct file_operations w9966_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
diff -puN drivers/media/video/w9968cf.c~mark-struct-file_operations-const-4 drivers/media/video/w9968cf.c
--- a/drivers/media/video/w9968cf.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/w9968cf.c
@@ -399,7 +399,7 @@ MODULE_PARM_DESC(specific_debug,
  ****************************************************************************/
 
 /* Video4linux interface */
-static struct file_operations w9968cf_fops;
+static const struct file_operations w9968cf_fops;
 static int w9968cf_open(struct inode*, struct file*);
 static int w9968cf_release(struct inode*, struct file*);
 static int w9968cf_mmap(struct file*, struct vm_area_struct*);
@@ -3467,7 +3467,7 @@ ioctl_fail:
 }
 
 
-static struct file_operations w9968cf_fops = {
+static const struct file_operations w9968cf_fops = {
 	.owner =   THIS_MODULE,
 	.open =    w9968cf_open,
 	.release = w9968cf_release,
diff -puN drivers/media/video/zc0301/zc0301_core.c~mark-struct-file_operations-const-4 drivers/media/video/zc0301/zc0301_core.c
--- a/drivers/media/video/zc0301/zc0301_core.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/zc0301/zc0301_core.c
@@ -1909,7 +1909,7 @@ static int zc0301_ioctl(struct inode* in
 }
 
 
-static struct file_operations zc0301_fops = {
+static const struct file_operations zc0301_fops = {
 	.owner =   THIS_MODULE,
 	.open =    zc0301_open,
 	.release = zc0301_release,
diff -puN drivers/media/video/zoran_driver.c~mark-struct-file_operations-const-4 drivers/media/video/zoran_driver.c
--- a/drivers/media/video/zoran_driver.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/zoran_driver.c
@@ -4679,7 +4679,7 @@ zoran_mmap (struct file           *file,
 	return 0;
 }
 
-static struct file_operations zoran_fops = {
+static const struct file_operations zoran_fops = {
 	.owner = THIS_MODULE,
 	.open = zoran_open,
 	.release = zoran_close,
diff -puN drivers/media/video/zoran_procfs.c~mark-struct-file_operations-const-4 drivers/media/video/zoran_procfs.c
--- a/drivers/media/video/zoran_procfs.c~mark-struct-file_operations-const-4
+++ a/drivers/media/video/zoran_procfs.c
@@ -186,7 +186,7 @@ static ssize_t zoran_write(struct file *
 	return count;
 }
 
-static struct file_operations zoran_operations = {
+static const struct file_operations zoran_operations = {
 	.open		= zoran_open,
 	.read		= seq_read,
 	.write		= zoran_write,
diff -puN drivers/message/fusion/mptctl.c~mark-struct-file_operations-const-4 drivers/message/fusion/mptctl.c
--- a/drivers/message/fusion/mptctl.c~mark-struct-file_operations-const-4
+++ a/drivers/message/fusion/mptctl.c
@@ -2719,7 +2719,7 @@ mptctl_hp_targetinfo(unsigned long arg)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
-static struct file_operations mptctl_fops = {
+static const struct file_operations mptctl_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.release =	mptctl_release,
_

Patches currently in -mm which might be from arjan@linux.intel.com are

git-libata-all.patch
git-netdev-all.patch
user-of-the-jiffies-rounding-code-networking.patch
mmconfig-cleanup.patch
mmconfig-fix-unreachable_devices.patch
mark-struct-file_operations-const-1.patch
mark-struct-file_operations-const-2.patch
mark-struct-file_operations-const-3.patch
mark-struct-file_operations-const-4.patch
mark-struct-file_operations-const-5.patch
mark-struct-file_operations-const-6.patch
mark-struct-file_operations-const-7.patch
mark-struct-file_operations-const-8.patch
mark-struct-file_operations-const-9.patch
mark-struct-inode_operations-const-1.patch
mark-struct-inode_operations-const-2.patch
mark-struct-inode_operations-const-3.patch

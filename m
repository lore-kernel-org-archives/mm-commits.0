From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 07 Apr 2009 12:01:53 -0700
Message-ID: <200904071901.n37J1rqi008831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753663AbZDGTC4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:02:56 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n37J1rt7018066
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 7 Apr 2009 12:02:24 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lm95241.c                     |   15 -----
 drivers/media/video/cx231xx/cx231xx-audio.c |    7 --
 drivers/media/video/cx231xx/cx231xx-cards.c |   26 ---------
 drivers/media/video/cx231xx/cx231xx-video.c |   20 -------
 firmware/WHENCE                             |   10 ---
 sound/soc/codecs/twl4030.c                  |   49 ------------------
 6 files changed, 3 insertions(+), 124 deletions(-)

diff -puN drivers/hwmon/lm95241.c~linux-next-git-rejects drivers/hwmon/lm95241.c
--- a/drivers/hwmon/lm95241.c~linux-next-git-rejects
+++ a/drivers/hwmon/lm95241.c
@@ -330,21 +330,6 @@ static int lm95241_detect(struct i2c_cli
 	 * requested, so both the detection and the identification steps
 	 * are skipped.
 	 */
-<<<<<<< HEAD:drivers/hwmon/lm95241.c
-	if (kind < 0) {	/* detection */
-		if ((i2c_smbus_read_byte_data(new_client, LM95241_REG_R_MAN_ID)
-		     != MANUFACTURER_ID)
-		|| (i2c_smbus_read_byte_data(new_client, LM95241_REG_R_CHIP_ID)
-		    < DEFAULT_REVISION)) {
-			dev_dbg(&adapter->dev,
-				"LM95241 detection failed at 0x%02x.\n",
-				address);
-			return -ENODEV;
-		}
-	}
-=======
->>>>>>> FETCH_HEAD:drivers/hwmon/lm95241.c
-
 	if (kind <= 0) { /* identification */
 		if ((i2c_smbus_read_byte_data(new_client, LM95241_REG_R_MAN_ID)
 		     == MANUFACTURER_ID)
diff -puN drivers/media/video/cx231xx/cx231xx-audio.c~linux-next-git-rejects drivers/media/video/cx231xx/cx231xx-audio.c
--- a/drivers/media/video/cx231xx/cx231xx-audio.c~linux-next-git-rejects
+++ a/drivers/media/video/cx231xx/cx231xx-audio.c
@@ -478,16 +478,9 @@ static int cx231xx_audio_init(struct cx2
 	cx231xx_info("cx231xx-audio.c: probing for cx231xx "
 		     "non standard usbaudio\n");
 
-<<<<<<< HEAD:drivers/media/video/cx231xx/cx231xx-audio.c
-	err = snd_card_create(index[devnr], "Cx231xx Audio", THIS_MODULE,
-			      0, &card);
-	if (err < 0)
-		return err;
-=======
 	card = snd_card_new(index[devnr], "Cx231xx Audio", THIS_MODULE, 0);
 	if (card == NULL)
 		return -ENOMEM;
->>>>>>> FETCH_HEAD:drivers/media/video/cx231xx/cx231xx-audio.c
 
 	spin_lock_init(&adev->slock);
 	err = snd_pcm_new(card, "Cx231xx Audio", 0, 0, 1, &pcm);
diff -puN drivers/media/video/cx231xx/cx231xx-cards.c~linux-next-git-rejects drivers/media/video/cx231xx/cx231xx-cards.c
--- a/drivers/media/video/cx231xx/cx231xx-cards.c~linux-next-git-rejects
+++ a/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -311,33 +311,19 @@ void cx231xx_card_setup(struct cx231xx *
 
 	/* request some modules */
 	if (dev->board.decoder == CX231XX_AVDECODER) {
-<<<<<<< HEAD:drivers/media/video/cx231xx/cx231xx-cards.c
-		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-					&dev->i2c_bus[0].i2c_adap,
-					"cx25840", "cx25840", 0x88 >> 1);
-		if (dev->sd_cx25840 == NULL)
-			cx231xx_info("cx25840 subdev registration failure\n");
-		cx25840_call(dev, core, load_fw);
-=======
 		dev->sd_cx25840 =
 			v4l2_i2c_new_subdev(&dev->i2c_bus[0].i2c_adap,
-					"cx25840", "cx25840", 0x88 >> 1);
+					"cx25840", "cx25840", 0x88 >> 1, 0);
 		if (dev->sd_cx25840 == NULL)
 			cx231xx_info("cx25840 subdev registration failure\n");
 		cx25840_call(dev, core, init, 0);
->>>>>>> FETCH_HEAD:drivers/media/video/cx231xx/cx231xx-cards.c
 
 	}
 
 	if (dev->board.tuner_type != TUNER_ABSENT) {
-<<<<<<< HEAD:drivers/media/video/cx231xx/cx231xx-cards.c
-		dev->sd_tuner =	v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_bus[1].i2c_adap,
-=======
 		dev->sd_tuner =
 			v4l2_i2c_new_subdev(&dev->i2c_bus[1].i2c_adap,
->>>>>>> FETCH_HEAD:drivers/media/video/cx231xx/cx231xx-cards.c
-				"tuner", "tuner", 0xc2 >> 1);
+				"tuner", "tuner", 0xc2 >> 1, 0);
 		if (dev->sd_tuner == NULL)
 			cx231xx_info("tuner subdev registration failure\n");
 
@@ -371,14 +357,10 @@ int cx231xx_config(struct cx231xx *dev)
  */
 void cx231xx_config_i2c(struct cx231xx *dev)
 {
-<<<<<<< HEAD:drivers/media/video/cx231xx/cx231xx-cards.c
-	/* u32 input = INPUT(dev->video_input)->vmux; */
-=======
 	struct v4l2_routing route;
 
 	route.input = INPUT(dev->video_input)->vmux;
 	route.output = 0;
->>>>>>> FETCH_HEAD:drivers/media/video/cx231xx/cx231xx-cards.c
 
 	call_all(dev, video, s_stream, 1);
 }
@@ -690,13 +672,9 @@ static int cx231xx_usb_probe(struct usb_
 	 */
 
 	/* Create v4l2 device */
-<<<<<<< HEAD:drivers/media/video/cx231xx/cx231xx-cards.c
-	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
-=======
 	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name),
 					"%s-%03d", "cx231xx", nr);
 	retval = v4l2_device_register(&udev->dev, &dev->v4l2_dev);
->>>>>>> FETCH_HEAD:drivers/media/video/cx231xx/cx231xx-cards.c
 	if (retval) {
 		cx231xx_errdev("v4l2_device_register failed\n");
 		cx231xx_devused &= ~(1 << nr);
diff -puN drivers/media/video/cx231xx/cx231xx-video.c~linux-next-git-rejects drivers/media/video/cx231xx/cx231xx-video.c
--- a/drivers/media/video/cx231xx/cx231xx-video.c~linux-next-git-rejects
+++ a/drivers/media/video/cx231xx/cx231xx-video.c
@@ -820,24 +820,15 @@ static struct videobuf_queue_ops cx231xx
 
 void video_mux(struct cx231xx *dev, int index)
 {
-<<<<<<< HEAD:drivers/media/video/cx231xx/cx231xx-video.c
-=======
-
 	struct v4l2_routing route;
 
 	route.input = INPUT(index)->vmux;
 	route.output = 0;
->>>>>>> FETCH_HEAD:drivers/media/video/cx231xx/cx231xx-video.c
 	dev->video_input = index;
 	dev->ctl_ainput = INPUT(index)->amux;
 
 	cx231xx_set_video_input_mux(dev, index);
 
-<<<<<<< HEAD:drivers/media/video/cx231xx/cx231xx-video.c
-	cx25840_call(dev, video, s_routing, INPUT(index)->vmux, 0, 0);
-=======
-	cx25840_call(dev, video, s_routing, &route);
->>>>>>> FETCH_HEAD:drivers/media/video/cx231xx/cx231xx-video.c
 
 	cx231xx_set_audio_input(dev, dev->ctl_ainput);
 
@@ -1096,12 +1087,6 @@ static int vidioc_s_std(struct file *fil
 	dev->height = f.fmt.pix.height;
 	get_scale(dev, dev->width, dev->height, &dev->hscale, &dev->vscale);
 
-<<<<<<< HEAD:drivers/media/video/cx231xx/cx231xx-video.c
-	call_all(dev, core, s_std, dev->norm);
-=======
-	call_all(dev, tuner, s_std, dev->norm);
->>>>>>> FETCH_HEAD:drivers/media/video/cx231xx/cx231xx-video.c
-
 	mutex_unlock(&dev->lock);
 
 	cx231xx_resolution_set(dev);
@@ -2136,11 +2121,6 @@ static int cx231xx_v4l2_close(struct fil
 		}
 
 		/* Save some power by putting tuner to sleep */
-<<<<<<< HEAD:drivers/media/video/cx231xx/cx231xx-video.c
-		call_all(dev, tuner, s_standby);
-=======
-		call_all(dev, core, s_standby, 0);
->>>>>>> FETCH_HEAD:drivers/media/video/cx231xx/cx231xx-video.c
 
 		/* do this before setting alternate! */
 		cx231xx_uninit_isoc(dev);
diff -puN firmware/WHENCE~linux-next-git-rejects firmware/WHENCE
--- a/firmware/WHENCE~linux-next-git-rejects
+++ a/firmware/WHENCE
@@ -623,8 +623,6 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
-<<<<<<< HEAD:firmware/WHENCE
-=======
 Driver: MYRI_SBUS - MyriCOM Gigabit Ethernet
 
 File: myricom/lanai.bin
@@ -635,7 +633,6 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
->>>>>>> FETCH_HEAD:firmware/WHENCE
 Driver: SCSI_QLOGICPTI - PTI Qlogic, ISP Driver
 
 File: qlogic/isp1000.bin
@@ -645,7 +642,6 @@ Licence: Unknown
 Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
-<<<<<<< HEAD:firmware/WHENCE
 
 Driver: MYRI_SBUS - MyriCOM Gigabit Ethernet
 
@@ -656,8 +652,6 @@ Licence: Unknown
 Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
-=======
->>>>>>> FETCH_HEAD:firmware/WHENCE
 
 Driver: BNX2 - Broadcom NetXtremeII
 
@@ -678,8 +672,6 @@ Licence:
 Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
-<<<<<<< HEAD:firmware/WHENCE
-=======
 
 Driver: DVB AV7110 -- AV7110 cards
 
@@ -702,4 +694,4 @@ Found in hex form in kernel source, with
 
 
 --------------------------------------------------------------------------
->>>>>>> FETCH_HEAD:firmware/WHENCE
+
diff -puN sound/soc/codecs/twl4030.c~linux-next-git-rejects sound/soc/codecs/twl4030.c
--- a/sound/soc/codecs/twl4030.c~linux-next-git-rejects
+++ a/sound/soc/codecs/twl4030.c
@@ -1217,55 +1217,6 @@ static int twl4030_set_bias_level(struct
 	return 0;
 }
 
-<<<<<<< HEAD:sound/soc/codecs/twl4030.c
-static int twl4030_startup(struct snd_pcm_substream *substream,
-			   struct snd_soc_dai *dai)
-{
-	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct snd_soc_device *socdev = rtd->socdev;
-	struct snd_soc_codec *codec = socdev->card->codec;
-	struct twl4030_priv *twl4030 = codec->private_data;
-
-	/* If we already have a playback or capture going then constrain
-	 * this substream to match it.
-	 */
-	if (twl4030->master_substream) {
-		struct snd_pcm_runtime *master_runtime;
-		master_runtime = twl4030->master_substream->runtime;
-
-		snd_pcm_hw_constraint_minmax(substream->runtime,
-					     SNDRV_PCM_HW_PARAM_RATE,
-					     master_runtime->rate,
-					     master_runtime->rate);
-
-		snd_pcm_hw_constraint_minmax(substream->runtime,
-					     SNDRV_PCM_HW_PARAM_SAMPLE_BITS,
-					     master_runtime->sample_bits,
-					     master_runtime->sample_bits);
-
-		twl4030->slave_substream = substream;
-	} else
-		twl4030->master_substream = substream;
-
-	return 0;
-}
-
-static void twl4030_shutdown(struct snd_pcm_substream *substream,
-			     struct snd_soc_dai *dai)
-{
-	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct snd_soc_device *socdev = rtd->socdev;
-	struct snd_soc_codec *codec = socdev->card->codec;
-	struct twl4030_priv *twl4030 = codec->private_data;
-
-	if (twl4030->master_substream == substream)
-		twl4030->master_substream = twl4030->slave_substream;
-
-	twl4030->slave_substream = NULL;
-}
-
-=======
->>>>>>> FETCH_HEAD:sound/soc/codecs/twl4030.c
 static int twl4030_hw_params(struct snd_pcm_substream *substream,
 			   struct snd_pcm_hw_params *params,
 			   struct snd_soc_dai *dai)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
toshiba_acpi-add-full-hotkey-support-fix.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
sysctl-lockdep-support-for-sysctl-reference-counting-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
xtensa-add-flat-support-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch


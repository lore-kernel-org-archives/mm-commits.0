From: akpm@linux-foundation.org
Subject: + sound-replace-remaining-__function__-occurences.patch added to -mm tree
Date: Mon, 03 Mar 2008 15:34:54 -0800
Message-ID: <200803032334.m23NYsQc012711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756541AbYCCXfF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 18:35:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, perex@suse.cz, tiwai@suse.de


The patch titled
     sound: replace remaining __FUNCTION__ occurences
has been added to the -mm tree.  Its filename is
     sound-replace-remaining-__function__-occurences.patch

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
Subject: sound: replace remaining __FUNCTION__ occurences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/arm/pxa2xx-ac97.c         |    8 ++++----
 sound/core/init.c               |    2 +-
 sound/isa/sb/sb16_csp.c         |   28 ++++++++++++++--------------
 sound/isa/sb/sb_common.c        |    6 +++---
 sound/oss/trident.h             |    2 +-
 sound/oss/vwsnd.c               |    6 +++---
 sound/pci/ad1889.c              |    4 ++--
 sound/pci/als300.c              |    4 ++--
 sound/pci/azt3328.c             |    4 ++--
 sound/pci/intel8x0.c            |    2 +-
 sound/soc/pxa/pxa2xx-ac97.c     |    8 ++++----
 sound/soc/s3c24xx/s3c24xx-i2s.c |   20 ++++++++++----------
 sound/soc/s3c24xx/s3c24xx-pcm.c |   28 ++++++++++++++--------------
 sound/soc/soc-dapm.c            |    2 +-
 14 files changed, 62 insertions(+), 62 deletions(-)

diff -puN sound/arm/pxa2xx-ac97.c~sound-replace-remaining-__function__-occurences sound/arm/pxa2xx-ac97.c
--- a/sound/arm/pxa2xx-ac97.c~sound-replace-remaining-__function__-occurences
+++ a/sound/arm/pxa2xx-ac97.c
@@ -66,7 +66,7 @@ static unsigned short pxa2xx_ac97_read(s
 	if (wait_event_timeout(gsr_wq, (GSR | gsr_bits) & GSR_SDONE, 1) <= 0 &&
 	    !((GSR | gsr_bits) & GSR_SDONE)) {
 		printk(KERN_ERR "%s: read error (ac97_reg=%d GSR=%#lx)\n",
-				__FUNCTION__, reg, GSR | gsr_bits);
+				__func__, reg, GSR | gsr_bits);
 		val = -1;
 		goto out;
 	}
@@ -98,7 +98,7 @@ static void pxa2xx_ac97_write(struct snd
 	if (wait_event_timeout(gsr_wq, (GSR | gsr_bits) & GSR_CDONE, 1) <= 0 &&
 	    !((GSR | gsr_bits) & GSR_CDONE))
 		printk(KERN_ERR "%s: write error (ac97_reg=%d GSR=%#lx)\n",
-				__FUNCTION__, reg, GSR | gsr_bits);
+				__func__, reg, GSR | gsr_bits);
 
 	mutex_unlock(&car_mutex);
 }
@@ -125,7 +125,7 @@ static void pxa2xx_ac97_reset(struct snd
 
 	if (!((GSR | gsr_bits) & (GSR_PCR | GSR_SCR))) {
 		printk(KERN_INFO "%s: cold reset timeout (GSR=%#lx)\n",
-				 __FUNCTION__, gsr_bits);
+				 __func__, gsr_bits);
 
 		/* let's try warm reset */
 		gsr_bits = 0;
@@ -144,7 +144,7 @@ static void pxa2xx_ac97_reset(struct snd
 
 		if (!((GSR | gsr_bits) & (GSR_PCR | GSR_SCR)))
 			printk(KERN_INFO "%s: warm reset timeout (GSR=%#lx)\n",
-					 __FUNCTION__, gsr_bits);
+					 __func__, gsr_bits);
 	}
 
 	GCR &= ~(GCR_PRIRDY_IEN|GCR_SECRDY_IEN);
diff -puN sound/core/init.c~sound-replace-remaining-__function__-occurences sound/core/init.c
--- a/sound/core/init.c~sound-replace-remaining-__function__-occurences
+++ a/sound/core/init.c
@@ -254,7 +254,7 @@ static int snd_disconnect_release(struct
 	if (likely(df))
 		return df->disconnected_f_op->release(inode, file);
 
-	panic("%s(%p, %p) failed!", __FUNCTION__, inode, file);
+	panic("%s(%p, %p) failed!", __func__, inode, file);
 }
 
 static unsigned int snd_disconnect_poll(struct file * file, poll_table * wait)
diff -puN sound/isa/sb/sb16_csp.c~sound-replace-remaining-__function__-occurences sound/isa/sb/sb16_csp.c
--- a/sound/isa/sb/sb16_csp.c~sound-replace-remaining-__function__-occurences
+++ a/sound/isa/sb/sb16_csp.c
@@ -331,7 +331,7 @@ static int snd_sb_csp_riff_load(struct s
 		return -EFAULT;
 	if ((file_h.name != RIFF_HEADER) ||
 	    (le32_to_cpu(file_h.len) >= SNDRV_SB_CSP_MAX_MICROCODE_FILE_SIZE - sizeof(file_h))) {
-		snd_printd("%s: Invalid RIFF header\n", __FUNCTION__);
+		snd_printd("%s: Invalid RIFF header\n", __func__);
 		return -EINVAL;
 	}
 	data_ptr += sizeof(file_h);
@@ -340,7 +340,7 @@ static int snd_sb_csp_riff_load(struct s
 	if (copy_from_user(&item_type, data_ptr, sizeof(item_type)))
 		return -EFAULT;
 	if (item_type != CSP__HEADER) {
-		snd_printd("%s: Invalid RIFF file type\n", __FUNCTION__);
+		snd_printd("%s: Invalid RIFF file type\n", __func__);
 		return -EINVAL;
 	}
 	data_ptr += sizeof (item_type);
@@ -395,7 +395,7 @@ static int snd_sb_csp_riff_load(struct s
 				return -EFAULT;
 
 			if (code_h.name != MAIN_HEADER) {
-				snd_printd("%s: Missing 'main' microcode\n", __FUNCTION__);
+				snd_printd("%s: Missing 'main' microcode\n", __func__);
 				return -EINVAL;
 			}
 			data_ptr += sizeof(code_h);
@@ -439,7 +439,7 @@ static int snd_sb_csp_riff_load(struct s
 				p->acc_format = p->acc_width = p->acc_rates = 0;
 				p->mode = 0;
 				snd_printd("%s: Unsupported CSP codec type: 0x%04x\n",
-					   __FUNCTION__,
+					   __func__,
 					   le16_to_cpu(funcdesc_h.VOC_type));
 				return -EINVAL;
 			}
@@ -458,7 +458,7 @@ static int snd_sb_csp_riff_load(struct s
 			return 0;
 		}
 	}
-	snd_printd("%s: Function #%d not found\n", __FUNCTION__, info.func_req);
+	snd_printd("%s: Function #%d not found\n", __func__, info.func_req);
 	return -EINVAL;
 }
 
@@ -612,7 +612,7 @@ static int get_version(struct snd_sb *ch
 static int snd_sb_csp_check_version(struct snd_sb_csp * p)
 {
 	if (p->version < 0x10 || p->version > 0x1f) {
-		snd_printd("%s: Invalid CSP version: 0x%x\n", __FUNCTION__, p->version);
+		snd_printd("%s: Invalid CSP version: 0x%x\n", __func__, p->version);
 		return 1;
 	}
 	return 0;
@@ -631,7 +631,7 @@ static int snd_sb_csp_load(struct snd_sb
 	spin_lock_irqsave(&p->chip->reg_lock, flags);
 	snd_sbdsp_command(p->chip, 0x01);	/* CSP download command */
 	if (snd_sbdsp_get_byte(p->chip)) {
-		snd_printd("%s: Download command failed\n", __FUNCTION__);
+		snd_printd("%s: Download command failed\n", __func__);
 		goto __fail;
 	}
 	/* Send CSP low byte (size - 1) */
@@ -658,7 +658,7 @@ static int snd_sb_csp_load(struct snd_sb
 			udelay (10);
 		}
 		if (status != 0x55) {
-			snd_printd("%s: Microcode initialization failed\n", __FUNCTION__);
+			snd_printd("%s: Microcode initialization failed\n", __func__);
 			goto __fail;
 		}
 	} else {
@@ -824,19 +824,19 @@ static int snd_sb_csp_start(struct snd_s
 	unsigned long flags;
 
 	if (!(p->running & (SNDRV_SB_CSP_ST_LOADED | SNDRV_SB_CSP_ST_AUTO))) {
-		snd_printd("%s: Microcode not loaded\n", __FUNCTION__);
+		snd_printd("%s: Microcode not loaded\n", __func__);
 		return -ENXIO;
 	}
 	if (p->running & SNDRV_SB_CSP_ST_RUNNING) {
-		snd_printd("%s: CSP already running\n", __FUNCTION__);
+		snd_printd("%s: CSP already running\n", __func__);
 		return -EBUSY;
 	}
 	if (!(sample_width & p->acc_width)) {
-		snd_printd("%s: Unsupported PCM sample width\n", __FUNCTION__);
+		snd_printd("%s: Unsupported PCM sample width\n", __func__);
 		return -EINVAL;
 	}
 	if (!(channels & p->acc_channels)) {
-		snd_printd("%s: Invalid number of channels\n", __FUNCTION__);
+		snd_printd("%s: Invalid number of channels\n", __func__);
 		return -EINVAL;
 	}
 
@@ -858,11 +858,11 @@ static int snd_sb_csp_start(struct snd_s
 		s_type |= 0x22;	/* 00dX 00dX    (d = 1 if 8 bit samples) */
 
 	if (set_codec_parameter(p->chip, 0x81, s_type)) {
-		snd_printd("%s: Set sample type command failed\n", __FUNCTION__);
+		snd_printd("%s: Set sample type command failed\n", __func__);
 		goto __fail;
 	}
 	if (set_codec_parameter(p->chip, 0x80, 0x00)) {
-		snd_printd("%s: Codec start command failed\n", __FUNCTION__);
+		snd_printd("%s: Codec start command failed\n", __func__);
 		goto __fail;
 	}
 	p->run_width = sample_width;
diff -puN sound/isa/sb/sb_common.c~sound-replace-remaining-__function__-occurences sound/isa/sb/sb_common.c
--- a/sound/isa/sb/sb_common.c~sound-replace-remaining-__function__-occurences
+++ a/sound/isa/sb/sb_common.c
@@ -51,7 +51,7 @@ int snd_sbdsp_command(struct snd_sb *chi
 			outb(val, SBP(chip, COMMAND));
 			return 1;
 		}
-	snd_printd("%s [0x%lx]: timeout (0x%x)\n", __FUNCTION__, chip->port, val);
+	snd_printd("%s [0x%lx]: timeout (0x%x)\n", __func__, chip->port, val);
 	return 0;
 }
 
@@ -68,7 +68,7 @@ int snd_sbdsp_get_byte(struct snd_sb *ch
 			return val;
 		}
 	}
-	snd_printd("%s [0x%lx]: timeout\n", __FUNCTION__, chip->port);
+	snd_printd("%s [0x%lx]: timeout\n", __func__, chip->port);
 	return -ENODEV;
 }
 
@@ -87,7 +87,7 @@ int snd_sbdsp_reset(struct snd_sb *chip)
 			else
 				break;
 		}
-	snd_printdd("%s [0x%lx] failed...\n", __FUNCTION__, chip->port);
+	snd_printdd("%s [0x%lx] failed...\n", __func__, chip->port);
 	return -ENODEV;
 }
 
diff -puN sound/oss/trident.h~sound-replace-remaining-__function__-occurences sound/oss/trident.h
--- a/sound/oss/trident.h~sound-replace-remaining-__function__-occurences
+++ a/sound/oss/trident.h
@@ -322,7 +322,7 @@ enum miscint_bits {
 #define VALIDATE_MAGIC(FOO,MAG)				\
 ({						  	\
 	if (!(FOO) || (FOO)->magic != MAG) { 		\
-		printk(invalid_magic,__FUNCTION__);	\
+		printk(invalid_magic,__func__);	\
 		return -ENXIO;			  	\
 	}					  	\
 })
diff -puN sound/oss/vwsnd.c~sound-replace-remaining-__function__-occurences sound/oss/vwsnd.c
--- a/sound/oss/vwsnd.c~sound-replace-remaining-__function__-occurences
+++ a/sound/oss/vwsnd.c
@@ -194,11 +194,11 @@ static void dbgassert(const char *fcn, i
  *	DBGRV	- debug print function return when verbose
  */
 
-#define ASSERT(e)      ((e) ? (void) 0 : dbgassert(__FUNCTION__, __LINE__, #e))
+#define ASSERT(e)      ((e) ? (void) 0 : dbgassert(__func__, __LINE__, #e))
 #define DBGDO(x)            x
 #define DBGX(fmt, args...)  (in_interrupt() ? 0 : printk(KERN_ERR fmt, ##args))
-#define DBGP(fmt, args...)  (DBGX("%s: " fmt, __FUNCTION__ , ##args))
-#define DBGE(fmt, args...)  (DBGX("%s" fmt, __FUNCTION__ , ##args))
+#define DBGP(fmt, args...)  (DBGX("%s: " fmt, __func__ , ##args))
+#define DBGE(fmt, args...)  (DBGX("%s" fmt, __func__ , ##args))
 #define DBGC(rtn)           (DBGP("calling %s\n", rtn))
 #define DBGR()              (DBGP("returning\n"))
 #define DBGXV(fmt, args...) (shut_up ? 0 : DBGX(fmt, ##args))
diff -puN sound/pci/ad1889.c~sound-replace-remaining-__function__-occurences sound/pci/ad1889.c
--- a/sound/pci/ad1889.c~sound-replace-remaining-__function__-occurences
+++ a/sound/pci/ad1889.c
@@ -264,10 +264,10 @@ snd_ad1889_ac97_ready(struct snd_ad1889 
 		mdelay(1);
 	if (!retry) {
 		snd_printk(KERN_ERR PFX "[%s] Link is not ready.\n",
-		       __FUNCTION__);
+		       __func__);
 		return -EIO;
 	}
-	ad1889_debug("[%s] ready after %d ms\n", __FUNCTION__, 400 - retry);
+	ad1889_debug("[%s] ready after %d ms\n", __func__, 400 - retry);
 
 	return 0;
 }
diff -puN sound/pci/als300.c~sound-replace-remaining-__function__-occurences sound/pci/als300.c
--- a/sound/pci/als300.c~sound-replace-remaining-__function__-occurences
+++ a/sound/pci/als300.c
@@ -92,8 +92,8 @@
 
 #if DEBUG_CALLS
 #define snd_als300_dbgcalls(format, args...) printk(format, ##args)
-#define snd_als300_dbgcallenter() printk(KERN_ERR "--> %s\n", __FUNCTION__)
-#define snd_als300_dbgcallleave() printk(KERN_ERR "<-- %s\n", __FUNCTION__)
+#define snd_als300_dbgcallenter() printk(KERN_ERR "--> %s\n", __func__)
+#define snd_als300_dbgcallleave() printk(KERN_ERR "<-- %s\n", __func__)
 #else
 #define snd_als300_dbgcalls(format, args...)
 #define snd_als300_dbgcallenter()
diff -puN sound/pci/azt3328.c~sound-replace-remaining-__function__-occurences sound/pci/azt3328.c
--- a/sound/pci/azt3328.c~sound-replace-remaining-__function__-occurences
+++ a/sound/pci/azt3328.c
@@ -157,8 +157,8 @@ MODULE_SUPPORTED_DEVICE("{{Aztech,AZF332
 
 #if DEBUG_CALLS
 #define snd_azf3328_dbgcalls(format, args...) printk(format, ##args)
-#define snd_azf3328_dbgcallenter() printk(KERN_ERR "--> %s\n", __FUNCTION__)
-#define snd_azf3328_dbgcallleave() printk(KERN_ERR "<-- %s\n", __FUNCTION__)
+#define snd_azf3328_dbgcallenter() printk(KERN_ERR "--> %s\n", __func__)
+#define snd_azf3328_dbgcallleave() printk(KERN_ERR "<-- %s\n", __func__)
 #else
 #define snd_azf3328_dbgcalls(format, args...)
 #define snd_azf3328_dbgcallenter()
diff -puN sound/pci/intel8x0.c~sound-replace-remaining-__function__-occurences sound/pci/intel8x0.c
--- a/sound/pci/intel8x0.c~sound-replace-remaining-__function__-occurences
+++ a/sound/pci/intel8x0.c
@@ -2670,7 +2670,7 @@ static void __devinit intel8x0_measure_a
 	t = stop_time.tv_sec - start_time.tv_sec;
 	t *= 1000000;
 	t += stop_time.tv_usec - start_time.tv_usec;
-	printk(KERN_INFO "%s: measured %lu usecs\n", __FUNCTION__, t);
+	printk(KERN_INFO "%s: measured %lu usecs\n", __func__, t);
 	if (t == 0) {
 		snd_printk(KERN_ERR "?? calculation error..\n");
 		return;
diff -puN sound/soc/pxa/pxa2xx-ac97.c~sound-replace-remaining-__function__-occurences sound/soc/pxa/pxa2xx-ac97.c
--- a/sound/soc/pxa/pxa2xx-ac97.c~sound-replace-remaining-__function__-occurences
+++ a/sound/soc/pxa/pxa2xx-ac97.c
@@ -81,7 +81,7 @@ static unsigned short pxa2xx_ac97_read(s
 	wait_event_timeout(gsr_wq, (GSR | gsr_bits) & GSR_SDONE, 1);
 	if (!((GSR | gsr_bits) & GSR_SDONE)) {
 		printk(KERN_ERR "%s: read error (ac97_reg=%x GSR=%#lx)\n",
-				__FUNCTION__, reg, GSR | gsr_bits);
+				__func__, reg, GSR | gsr_bits);
 		val = -1;
 		goto out;
 	}
@@ -121,7 +121,7 @@ static void pxa2xx_ac97_write(struct snd
 	wait_event_timeout(gsr_wq, (GSR | gsr_bits) & GSR_CDONE, 1);
 	if (!((GSR | gsr_bits) & GSR_CDONE))
 		printk(KERN_ERR "%s: write error (ac97_reg=%x GSR=%#lx)\n",
-				__FUNCTION__, reg, GSR | gsr_bits);
+				__func__, reg, GSR | gsr_bits);
 
 	mutex_unlock(&car_mutex);
 }
@@ -145,7 +145,7 @@ static void pxa2xx_ac97_warm_reset(struc
 
 	if (!((GSR | gsr_bits) & (GSR_PCR | GSR_SCR)))
 		printk(KERN_INFO "%s: warm reset timeout (GSR=%#lx)\n",
-				 __FUNCTION__, gsr_bits);
+				 __func__, gsr_bits);
 
 	GCR &= ~(GCR_PRIRDY_IEN|GCR_SECRDY_IEN);
 	GCR |= GCR_SDONE_IE|GCR_CDONE_IE;
@@ -172,7 +172,7 @@ static void pxa2xx_ac97_cold_reset(struc
 
 	if (!((GSR | gsr_bits) & (GSR_PCR | GSR_SCR)))
 		printk(KERN_INFO "%s: cold reset timeout (GSR=%#lx)\n",
-				 __FUNCTION__, gsr_bits);
+				 __func__, gsr_bits);
 
 	GCR &= ~(GCR_PRIRDY_IEN|GCR_SECRDY_IEN);
 	GCR |= GCR_SDONE_IE|GCR_CDONE_IE;
diff -puN sound/soc/s3c24xx/s3c24xx-i2s.c~sound-replace-remaining-__function__-occurences sound/soc/s3c24xx/s3c24xx-i2s.c
--- a/sound/soc/s3c24xx/s3c24xx-i2s.c~sound-replace-remaining-__function__-occurences
+++ a/sound/soc/s3c24xx/s3c24xx-i2s.c
@@ -89,7 +89,7 @@ static void s3c24xx_snd_txctrl(int on)
 	u32 iiscon;
 	u32 iismod;
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	iisfcon = readl(s3c24xx_i2s.regs + S3C2410_IISFCON);
 	iiscon  = readl(s3c24xx_i2s.regs + S3C2410_IISCON);
@@ -134,7 +134,7 @@ static void s3c24xx_snd_rxctrl(int on)
 	u32 iiscon;
 	u32 iismod;
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	iisfcon = readl(s3c24xx_i2s.regs + S3C2410_IISFCON);
 	iiscon  = readl(s3c24xx_i2s.regs + S3C2410_IISCON);
@@ -182,7 +182,7 @@ static int s3c24xx_snd_lrsync(void)
 	u32 iiscon;
 	unsigned long timeout = jiffies + msecs_to_jiffies(5);
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	while (1) {
 		iiscon = readl(s3c24xx_i2s.regs + S3C2410_IISCON);
@@ -201,7 +201,7 @@ static int s3c24xx_snd_lrsync(void)
  */
 static inline int s3c24xx_snd_is_clkmaster(void)
 {
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	return (readl(s3c24xx_i2s.regs + S3C2410_IISMOD) & S3C2410_IISMOD_SLAVE) ? 0:1;
 }
@@ -214,7 +214,7 @@ static int s3c24xx_i2s_set_fmt(struct sn
 {
 	u32 iismod;
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	iismod = readl(s3c24xx_i2s.regs + S3C2410_IISMOD);
 	DBG("hw_params r: IISMOD: %lx \n", iismod);
@@ -250,7 +250,7 @@ static int s3c24xx_i2s_hw_params(struct 
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	u32 iismod;
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		rtd->dai->cpu_dai->dma_data = &s3c24xx_i2s_pcm_stereo_out;
@@ -278,7 +278,7 @@ static int s3c24xx_i2s_trigger(struct sn
 {
 	int ret = 0;
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
@@ -320,7 +320,7 @@ static int s3c24xx_i2s_set_sysclk(struct
 {
 	u32 iismod = readl(s3c24xx_i2s.regs + S3C2410_IISMOD);
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	iismod &= ~S3C2440_IISMOD_MPLL;
 
@@ -346,7 +346,7 @@ static int s3c24xx_i2s_set_clkdiv(struct
 {
 	u32 reg;
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	switch (div_id) {
 	case S3C24XX_DIV_BCLK:
@@ -381,7 +381,7 @@ EXPORT_SYMBOL_GPL(s3c24xx_i2s_get_clockr
 
 static int s3c24xx_i2s_probe(struct platform_device *pdev)
 {
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	s3c24xx_i2s.regs = ioremap(S3C2410_PA_IIS, 0x100);
 	if (s3c24xx_i2s.regs == NULL)
diff -puN sound/soc/s3c24xx/s3c24xx-pcm.c~sound-replace-remaining-__function__-occurences sound/soc/s3c24xx/s3c24xx-pcm.c
--- a/sound/soc/s3c24xx/s3c24xx-pcm.c~sound-replace-remaining-__function__-occurences
+++ a/sound/soc/s3c24xx/s3c24xx-pcm.c
@@ -88,7 +88,7 @@ static void s3c24xx_pcm_enqueue(struct s
 	dma_addr_t pos = prtd->dma_pos;
 	int ret;
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	while (prtd->dma_loaded < prtd->dma_limit) {
 		unsigned long len = prtd->dma_period;
@@ -98,7 +98,7 @@ static void s3c24xx_pcm_enqueue(struct s
 		if ((pos + len) > prtd->dma_end) {
 			len  = prtd->dma_end - pos;
 			DBG(KERN_DEBUG "%s: corrected dma len %ld\n",
-			       __FUNCTION__, len);
+			       __func__, len);
 		}
 
 		ret = s3c2410_dma_enqueue(prtd->params->channel, 
@@ -123,7 +123,7 @@ static void s3c24xx_audio_buffdone(struc
 	struct snd_pcm_substream *substream = dev_id;
 	struct s3c24xx_runtime_data *prtd;
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	if (result == S3C2410_RES_ABORT || result == S3C2410_RES_ERR)
 		return;
@@ -152,7 +152,7 @@ static int s3c24xx_pcm_hw_params(struct 
 	unsigned long totbytes = params_buffer_bytes(params);
 	int ret=0;
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	/* return if this is a bufferless transfer e.g.
 	 * codec <--> BT codec or GSM modem -- lg FIXME */
@@ -200,7 +200,7 @@ static int s3c24xx_pcm_hw_free(struct sn
 {
 	struct s3c24xx_runtime_data *prtd = substream->runtime->private_data;
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	/* TODO - do we need to ensure DMA flushed */
 	snd_pcm_set_runtime_buffer(substream, NULL);
@@ -218,7 +218,7 @@ static int s3c24xx_pcm_prepare(struct sn
 	struct s3c24xx_runtime_data *prtd = substream->runtime->private_data;
 	int ret = 0;
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	/* return if this is a bufferless transfer e.g.
 	 * codec <--> BT codec or GSM modem -- lg FIXME */
@@ -263,7 +263,7 @@ static int s3c24xx_pcm_trigger(struct sn
 	struct s3c24xx_runtime_data *prtd = substream->runtime->private_data;
 	int ret = 0;
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	spin_lock(&prtd->lock);
 
@@ -301,7 +301,7 @@ static snd_pcm_uframes_t 
 	unsigned long res;
 	dma_addr_t src, dst;
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	spin_lock(&prtd->lock);
 	s3c2410_dma_getposition(prtd->params->channel, &src, &dst);
@@ -334,7 +334,7 @@ static int s3c24xx_pcm_open(struct snd_p
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct s3c24xx_runtime_data *prtd;
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	snd_soc_set_runtime_hwparams(substream, &s3c24xx_pcm_hardware);
 
@@ -353,7 +353,7 @@ static int s3c24xx_pcm_close(struct snd_
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct s3c24xx_runtime_data *prtd = runtime->private_data;
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	if (prtd)
 		kfree(prtd);
@@ -368,7 +368,7 @@ static int s3c24xx_pcm_mmap(struct snd_p
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	return dma_mmap_writecombine(substream->pcm->card->dev, vma,
                                      runtime->dma_area,
@@ -394,7 +394,7 @@ static int s3c24xx_pcm_preallocate_dma_b
 	struct snd_dma_buffer *buf = &substream->dma_buffer;
 	size_t size = s3c24xx_pcm_hardware.buffer_bytes_max;
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	buf->dev.type = SNDRV_DMA_TYPE_DEV;
 	buf->dev.dev = pcm->card->dev;
@@ -413,7 +413,7 @@ static void s3c24xx_pcm_free_dma_buffers
 	struct snd_dma_buffer *buf;
 	int stream;
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	for (stream = 0; stream < 2; stream++) {
 		substream = pcm->streams[stream].substream;
@@ -437,7 +437,7 @@ static int s3c24xx_pcm_new(struct snd_ca
 {
 	int ret = 0;
 
-	DBG("Entered %s\n", __FUNCTION__);
+	DBG("Entered %s\n", __func__);
 
 	if (!card->dev->dma_mask)
 		card->dev->dma_mask = &s3c24xx_pcm_dmamask;
diff -puN sound/soc/soc-dapm.c~sound-replace-remaining-__function__-occurences sound/soc/soc-dapm.c
--- a/sound/soc/soc-dapm.c~sound-replace-remaining-__function__-occurences
+++ a/sound/soc/soc-dapm.c
@@ -1288,7 +1288,7 @@ int snd_soc_dapm_stream_event(struct snd
 	mutex_unlock(&codec->mutex);
 
 	dapm_power_widgets(codec, event);
-	dump_dapm(codec, __FUNCTION__);
+	dump_dapm(codec, __func__);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(snd_soc_dapm_stream_event);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
specialixc-fix-possible-double-unlock.patch
git-x86.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
sh-replace-remaining-__function__-occurences.patch
block-fix-shadowed-variable-warning-in-blk-mapc.patch
block-remove-extern-on-function-definition.patch
xtensa-replace-remaining-__function__-occurences.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-introduce-kprobe_handle_fault-ia64-fix.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
xen-make-blkif_getgeo-static.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch


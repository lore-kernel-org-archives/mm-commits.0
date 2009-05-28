From: akpm@linux-foundation.org
Subject: + soc-correct-print-specifiers-for-unsigneds.patch added to -mm tree
Date: Wed, 27 May 2009 17:08:39 -0700
Message-ID: <200905280008.n4S08dUo030673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758284AbZE1AJv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 20:09:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk, tiwai@suse.de


The patch titled
     soc: correct print specifiers for unsigneds
has been added to the -mm tree.  Its filename is
     soc-correct-print-specifiers-for-unsigneds.patch

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
Subject: soc: correct print specifiers for unsigneds
From: Roel Kluin <roel.kluin@gmail.com>

Unsigned variables should use `%u' rather than `%d'.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/soc/atmel/playpaq_wm8510.c |    2 +-
 sound/soc/codecs/tlv320aic23.c   |    4 ++--
 sound/soc/codecs/uda134x.c       |    4 ++--
 sound/soc/codecs/wm8350.c        |    2 +-
 sound/soc/codecs/wm8400.c        |    4 ++--
 sound/soc/codecs/wm8510.c        |    2 +-
 sound/soc/codecs/wm8580.c        |    4 ++--
 sound/soc/codecs/wm8753.c        |    2 +-
 sound/soc/codecs/wm8900.c        |    6 +++---
 sound/soc/codecs/wm8990.c        |    2 +-
 sound/soc/codecs/wm9713.c        |    2 +-
 sound/soc/pxa/pxa-ssp.c          |    4 ++--
 sound/soc/s3c24xx/s3c-i2s-v2.c   |    4 ++--
 sound/soc/sh/ssi.c               |    2 +-
 14 files changed, 22 insertions(+), 22 deletions(-)

diff -puN sound/soc/atmel/playpaq_wm8510.c~soc-correct-print-specifiers-for-unsigneds sound/soc/atmel/playpaq_wm8510.c
--- a/sound/soc/atmel/playpaq_wm8510.c~soc-correct-print-specifiers-for-unsigneds
+++ a/sound/soc/atmel/playpaq_wm8510.c
@@ -117,7 +117,7 @@ static struct ssc_clock_data playpaq_wm8
 	 * Find actual rate, compare to requested rate
 	 */
 	actual_rate = (cd.ssc_rate / (cd.cmr_div * 2)) / (2 * (cd.period + 1));
-	pr_debug("playpaq_wm8510: Request rate = %d, actual rate = %d\n",
+	pr_debug("playpaq_wm8510: Request rate = %u, actual rate = %u\n",
 		 rate, actual_rate);
 
 
diff -puN sound/soc/codecs/tlv320aic23.c~soc-correct-print-specifiers-for-unsigneds sound/soc/codecs/tlv320aic23.c
--- a/sound/soc/codecs/tlv320aic23.c~soc-correct-print-specifiers-for-unsigneds
+++ a/sound/soc/codecs/tlv320aic23.c
@@ -86,7 +86,7 @@ static int tlv320aic23_write(struct snd_
 	 */
 
 	if ((reg < 0 || reg > 9) && (reg != 15)) {
-		printk(KERN_WARNING "%s Invalid register R%d\n", __func__, reg);
+		printk(KERN_WARNING "%s Invalid register R%u\n", __func__, reg);
 		return -1;
 	}
 
@@ -98,7 +98,7 @@ static int tlv320aic23_write(struct snd_
 	if (codec->hw_write(codec->control_data, data, 2) == 2)
 		return 0;
 
-	printk(KERN_ERR "%s cannot write %03x to register R%d\n", __func__,
+	printk(KERN_ERR "%s cannot write %03x to register R%u\n", __func__,
 	       value, reg);
 
 	return -EIO;
diff -puN sound/soc/codecs/uda134x.c~soc-correct-print-specifiers-for-unsigneds sound/soc/codecs/uda134x.c
--- a/sound/soc/codecs/uda134x.c~soc-correct-print-specifiers-for-unsigneds
+++ a/sound/soc/codecs/uda134x.c
@@ -101,7 +101,7 @@ static int uda134x_write(struct snd_soc_
 	pr_debug("%s reg: %02X, value:%02X\n", __func__, reg, value);
 
 	if (reg >= UDA134X_REGS_NUM) {
-		printk(KERN_ERR "%s unkown register: reg: %d",
+		printk(KERN_ERR "%s unkown register: reg: %u",
 		       __func__, reg);
 		return -EINVAL;
 	}
@@ -296,7 +296,7 @@ static int uda134x_set_dai_sysclk(struct
 	struct snd_soc_codec *codec = codec_dai->codec;
 	struct uda134x_priv *uda134x = codec->private_data;
 
-	pr_debug("%s clk_id: %d, freq: %d, dir: %d\n", __func__,
+	pr_debug("%s clk_id: %d, freq: %u, dir: %d\n", __func__,
 		 clk_id, freq, dir);
 
 	/* Anything between 256fs*8Khz and 512fs*48Khz should be acceptable
diff -puN sound/soc/codecs/wm8350.c~soc-correct-print-specifiers-for-unsigneds sound/soc/codecs/wm8350.c
--- a/sound/soc/codecs/wm8350.c~soc-correct-print-specifiers-for-unsigneds
+++ a/sound/soc/codecs/wm8350.c
@@ -1108,7 +1108,7 @@ static int wm8350_set_fll(struct snd_soc
 	if (ret < 0)
 		return ret;
 	dev_dbg(wm8350->dev,
-		"FLL in %d FLL out %d N 0x%x K 0x%x div %d ratio %d",
+		"FLL in %u FLL out %u N 0x%x K 0x%x div %d ratio %d",
 		freq_in, freq_out, fll_div.n, fll_div.k, fll_div.div,
 		fll_div.ratio);
 
diff -puN sound/soc/codecs/wm8400.c~soc-correct-print-specifiers-for-unsigneds sound/soc/codecs/wm8400.c
--- a/sound/soc/codecs/wm8400.c~soc-correct-print-specifiers-for-unsigneds
+++ a/sound/soc/codecs/wm8400.c
@@ -954,7 +954,7 @@ static int fll_factors(struct wm8400_pri
 		factors->outdiv *= 2;
 		if (factors->outdiv > 32) {
 			dev_err(wm8400->wm8400->dev,
-				"Unsupported FLL output frequency %dHz\n",
+				"Unsupported FLL output frequency %uHz\n",
 				Fout);
 			return -EINVAL;
 		}
@@ -1003,7 +1003,7 @@ static int fll_factors(struct wm8400_pri
 	factors->k = K / 10;
 
 	dev_dbg(wm8400->wm8400->dev,
-		"FLL: Fref=%d Fout=%d N=%x K=%x, FRATIO=%x OUTDIV=%x\n",
+		"FLL: Fref=%u Fout=%u N=%x K=%x, FRATIO=%x OUTDIV=%x\n",
 		Fref, Fout,
 		factors->n, factors->k, factors->fratio, factors->outdiv);
 
diff -puN sound/soc/codecs/wm8510.c~soc-correct-print-specifiers-for-unsigneds sound/soc/codecs/wm8510.c
--- a/sound/soc/codecs/wm8510.c~soc-correct-print-specifiers-for-unsigneds
+++ a/sound/soc/codecs/wm8510.c
@@ -298,7 +298,7 @@ static void pll_factors(unsigned int tar
 
 	if ((Ndiv < 6) || (Ndiv > 12))
 		printk(KERN_WARNING
-			"WM8510 N value %d outwith recommended range!d\n",
+			"WM8510 N value %u outwith recommended range!d\n",
 			Ndiv);
 
 	pll_div.n = Ndiv;
diff -puN sound/soc/codecs/wm8580.c~soc-correct-print-specifiers-for-unsigneds sound/soc/codecs/wm8580.c
--- a/sound/soc/codecs/wm8580.c~soc-correct-print-specifiers-for-unsigneds
+++ a/sound/soc/codecs/wm8580.c
@@ -415,7 +415,7 @@ static int pll_factors(struct _pll_div *
 	unsigned int K, Ndiv, Nmod;
 	int i;
 
-	pr_debug("wm8580: PLL %dHz->%dHz\n", source, target);
+	pr_debug("wm8580: PLL %uHz->%uHz\n", source, target);
 
 	/* Scale the output frequency up; the PLL should run in the
 	 * region of 90-100MHz.
@@ -447,7 +447,7 @@ static int pll_factors(struct _pll_div *
 
 	if ((Ndiv < 5) || (Ndiv > 13)) {
 		printk(KERN_ERR
-			"WM8580 N=%d outside supported range\n", Ndiv);
+			"WM8580 N=%u outside supported range\n", Ndiv);
 		return -EINVAL;
 	}
 
diff -puN sound/soc/codecs/wm8753.c~soc-correct-print-specifiers-for-unsigneds sound/soc/codecs/wm8753.c
--- a/sound/soc/codecs/wm8753.c~soc-correct-print-specifiers-for-unsigneds
+++ a/sound/soc/codecs/wm8753.c
@@ -703,7 +703,7 @@ static void pll_factors(struct _pll_div 
 
 	if ((Ndiv < 6) || (Ndiv > 12))
 		printk(KERN_WARNING
-			"wm8753: unsupported N = %d\n", Ndiv);
+			"wm8753: unsupported N = %u\n", Ndiv);
 
 	pll_div->n = Ndiv;
 	Nmod = target % source;
diff -puN sound/soc/codecs/wm8900.c~soc-correct-print-specifiers-for-unsigneds sound/soc/codecs/wm8900.c
--- a/sound/soc/codecs/wm8900.c~soc-correct-print-specifiers-for-unsigneds
+++ a/sound/soc/codecs/wm8900.c
@@ -778,11 +778,11 @@ static int fll_factors(struct _fll_div *
 	}
 
 	if (target > 100000000)
-		printk(KERN_WARNING "wm8900: FLL rate %d out of range, Fref=%d"
-		       " Fout=%d\n", target, Fref, Fout);
+		printk(KERN_WARNING "wm8900: FLL rate %u out of range, Fref=%u"
+		       " Fout=%u\n", target, Fref, Fout);
 	if (div > 32) {
 		printk(KERN_ERR "wm8900: Invalid FLL division rate %u, "
-		       "Fref=%d, Fout=%d, target=%d\n",
+		       "Fref=%u, Fout=%u, target=%u\n",
 		       div, Fref, Fout, target);
 		return -EINVAL;
 	}
diff -puN sound/soc/codecs/wm8990.c~soc-correct-print-specifiers-for-unsigneds sound/soc/codecs/wm8990.c
--- a/sound/soc/codecs/wm8990.c~soc-correct-print-specifiers-for-unsigneds
+++ a/sound/soc/codecs/wm8990.c
@@ -998,7 +998,7 @@ static void pll_factors(struct _pll_div 
 
 	if ((Ndiv < 6) || (Ndiv > 12))
 		printk(KERN_WARNING
-		"WM8990 N value outwith recommended range! N = %d\n", Ndiv);
+		"WM8990 N value outwith recommended range! N = %u\n", Ndiv);
 
 	pll_div->n = Ndiv;
 	Nmod = target % source;
diff -puN sound/soc/codecs/wm9713.c~soc-correct-print-specifiers-for-unsigneds sound/soc/codecs/wm9713.c
--- a/sound/soc/codecs/wm9713.c~soc-correct-print-specifiers-for-unsigneds
+++ a/sound/soc/codecs/wm9713.c
@@ -710,7 +710,7 @@ static void pll_factors(struct _pll_div 
 	Ndiv = target / source;
 	if ((Ndiv < 5) || (Ndiv > 12))
 		printk(KERN_WARNING
-			"WM9713 PLL N value %d out of recommended range!\n",
+			"WM9713 PLL N value %u out of recommended range!\n",
 			Ndiv);
 
 	pll_div->n = Ndiv;
diff -puN sound/soc/pxa/pxa-ssp.c~soc-correct-print-specifiers-for-unsigneds sound/soc/pxa/pxa-ssp.c
--- a/sound/soc/pxa/pxa-ssp.c~soc-correct-print-specifiers-for-unsigneds
+++ a/sound/soc/pxa/pxa-ssp.c
@@ -208,7 +208,7 @@ static int pxa_ssp_set_dai_sysclk(struct
 		~(SSCR0_ECS |  SSCR0_NCS | SSCR0_MOD | SSCR0_ACS);
 
 	dev_dbg(&ssp->pdev->dev,
-		"pxa_ssp_set_dai_sysclk id: %d, clk_id %d, freq %d\n",
+		"pxa_ssp_set_dai_sysclk id: %d, clk_id %d, freq %u\n",
 		cpu_dai->id, clk_id, freq);
 
 	switch (clk_id) {
@@ -357,7 +357,7 @@ static int pxa_ssp_set_dai_pll(struct sn
 			ssacd |= (0x6 << 4);
 
 			dev_dbg(&ssp->pdev->dev,
-				"Using SSACDD %x to supply %dHz\n",
+				"Using SSACDD %x to supply %uHz\n",
 				val, freq_out);
 			break;
 		}
diff -puN sound/soc/s3c24xx/s3c-i2s-v2.c~soc-correct-print-specifiers-for-unsigneds sound/soc/s3c24xx/s3c-i2s-v2.c
--- a/sound/soc/s3c24xx/s3c-i2s-v2.c~soc-correct-print-specifiers-for-unsigneds
+++ a/sound/soc/s3c24xx/s3c-i2s-v2.c
@@ -547,7 +547,7 @@ int s3c_i2sv2_iis_calc_rate(struct s3c_i
 		actual = clkrate / (fsdiv * div);
 		deviation = actual - rate;
 
-		printk(KERN_DEBUG "%dfs: div %d => result %d, deviation %d\n",
+		printk(KERN_DEBUG "%ufs: div %u => result %u, deviation %d\n",
 		       fsdiv, div, actual, deviation);
 
 		deviation = abs(deviation);
@@ -563,7 +563,7 @@ int s3c_i2sv2_iis_calc_rate(struct s3c_i
 			break;
 	}
 
-	printk(KERN_DEBUG "best: fs=%d, div=%d, rate=%d\n",
+	printk(KERN_DEBUG "best: fs=%u, div=%u, rate=%u\n",
 	       best_fs, best_div, best_rate);
 
 	info->fs_div = best_fs;
diff -puN sound/soc/sh/ssi.c~soc-correct-print-specifiers-for-unsigneds sound/soc/sh/ssi.c
--- a/sound/soc/sh/ssi.c~soc-correct-print-specifiers-for-unsigneds
+++ a/sound/soc/sh/ssi.c
@@ -145,7 +145,7 @@ static int ssi_hw_params(struct snd_pcm_
 	recv = (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) ? 0 : 1;
 
 	pr_debug("ssi_hw_params() enter\nssicr was    %08lx\n", ssicr);
-	pr_debug("bits: %d channels: %d\n", bits, channels);
+	pr_debug("bits: %u channels: %u\n", bits, channels);
 
 	ssicr &= ~(CR_TRMD | CR_CHNL_MASK | CR_DWL_MASK | CR_PDTA |
 		   CR_SWL_MASK);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
drivers-serial-mpc52xx_uartc-fix-array-overindexing-check.patch
linux-next.patch
soc-correct-print-specifiers-for-unsigneds.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
fsldma-fix-check-on-potential-fdev-chan-overflow.patch
drm-fix-lock_test_with_return-macro.patch
uwb-event_size-should-be-signed.patch
irda-count-reaches-1.patch
drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
otus-80211core-coidc-fix-array-range-check.patch
lguest-fix-array-indexing-check.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch


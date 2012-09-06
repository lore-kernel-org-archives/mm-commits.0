From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 06 Sep 2012 12:12:55 -0700
Message-ID: <20120906191257.0AA1E200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:65010 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2IFTM7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2012 15:12:59 -0400
Received: by eaac1 with SMTP id c1so127065eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 06 Sep 2012 12:12:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/mxs-mmc.c |    8 --------
 sound/pci/hda/hda_codec.c  |    9 ---------
 sound/pci/hda/hda_codec.h  |    4 ----
 3 files changed, 21 deletions(-)

diff -puN drivers/mmc/host/mxs-mmc.c~linux-next-git-rejects drivers/mmc/host/mxs-mmc.c
--- a/drivers/mmc/host/mxs-mmc.c~linux-next-git-rejects
+++ a/drivers/mmc/host/mxs-mmc.c
@@ -527,11 +527,7 @@ static void mxs_mmc_enable_sdio_irq(stru
 		writel(BM_SSP_CTRL0_SDIO_IRQ_CHECK,
 		       ssp->base + HW_SSP_CTRL0 + STMP_OFFSET_REG_SET);
 		writel(BM_SSP_CTRL1_SDIO_IRQ_EN,
-<<<<<<< HEAD
-		       host->base + HW_SSP_CTRL1(host) + STMP_OFFSET_REG_SET);
-=======
 		       ssp->base + HW_SSP_CTRL1(ssp) + STMP_OFFSET_REG_SET);
->>>>>>> linux-next/akpm-base
 	} else {
 		writel(BM_SSP_CTRL0_SDIO_IRQ_CHECK,
 		       ssp->base + HW_SSP_CTRL0 + STMP_OFFSET_REG_CLR);
@@ -541,11 +537,7 @@ static void mxs_mmc_enable_sdio_irq(stru
 
 	spin_unlock_irqrestore(&host->lock, flags);
 
-<<<<<<< HEAD
-	if (enable && readl(host->base + HW_SSP_STATUS(host)) &
-=======
 	if (enable && readl(ssp->base + HW_SSP_STATUS(ssp)) &
->>>>>>> linux-next/akpm-base
 			BM_SSP_STATUS_SDIO_IRQ)
 		mmc_signal_sdio_irq(host->mmc);
 
diff -puN sound/pci/hda/hda_codec.c~linux-next-git-rejects sound/pci/hda/hda_codec.c
--- a/sound/pci/hda/hda_codec.c~linux-next-git-rejects
+++ a/sound/pci/hda/hda_codec.c
@@ -1222,11 +1222,7 @@ static void snd_hda_codec_free(struct hd
 static bool snd_hda_codec_get_supported_ps(struct hda_codec *codec,
 				hda_nid_t fg, unsigned int power_state);
 
-<<<<<<< HEAD
-static void hda_set_power_state(struct hda_codec *codec, hda_nid_t fg,
-=======
 static unsigned int hda_set_power_state(struct hda_codec *codec,
->>>>>>> linux-next/akpm-base
 				unsigned int power_state);
 
 /**
@@ -1336,10 +1332,6 @@ int /*__devinit*/ snd_hda_codec_new(stru
 					   AC_VERB_GET_SUBSYSTEM_ID, 0);
 	}
 
-<<<<<<< HEAD
-	codec->epss = snd_hda_codec_get_supported_ps(codec,
-					codec->afg ? codec->afg : codec->mfg,
-=======
 #ifdef CONFIG_PM
 	codec->d3_stop_clk = snd_hda_codec_get_supported_ps(codec, fg,
 					AC_PWRST_CLKSTOP);
@@ -1347,7 +1339,6 @@ int /*__devinit*/ snd_hda_codec_new(stru
 		bus->power_keep_link_on = 1;
 #endif
 	codec->epss = snd_hda_codec_get_supported_ps(codec, fg,
->>>>>>> linux-next/akpm-base
 					AC_PWRST_EPSS);
 
 	/* power-up all before initialization */
diff -puN sound/pci/hda/hda_codec.h~linux-next-git-rejects sound/pci/hda/hda_codec.h
--- a/sound/pci/hda/hda_codec.h~linux-next-git-rejects
+++ a/sound/pci/hda/hda_codec.h
@@ -865,11 +865,7 @@ struct hda_codec {
 	unsigned int no_jack_detect:1;	/* Machine has no jack-detection */
 	unsigned int pcm_format_first:1; /* PCM format must be set first */
 	unsigned int epss:1;		/* supporting EPSS? */
-<<<<<<< HEAD
-#ifdef CONFIG_SND_HDA_POWER_SAVE
-=======
 #ifdef CONFIG_PM
->>>>>>> linux-next/akpm-base
 	unsigned int power_on :1;	/* current (global) power-state */
 	unsigned int d3_stop_clk:1;	/* support D3 operation without BCLK */
 	unsigned int pm_down_notified:1; /* PM notified to controller */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-support-migrate_discard-fix.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
linux-next-git-rejects.patch


From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 06 Feb 2012 12:28:43 -0800
Message-ID: <20120206202845.5331EA0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:43606 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab2BFU2s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 15:28:48 -0500
Received: by eekb15 with SMTP id b15so211677eek.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 12:28:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/soc/codecs/wm5100.c |   91 ------------------------------------
 1 file changed, 91 deletions(-)

diff -puN sound/soc/codecs/wm5100.c~linux-next-git-rejects sound/soc/codecs/wm5100.c
--- a/sound/soc/codecs/wm5100.c~linux-next-git-rejects
+++ a/sound/soc/codecs/wm5100.c
@@ -1263,83 +1263,6 @@ static const __devinitdata struct reg_de
 	{ WM5100_AUDIO_IF_3_19, 1 },
 };
 
-<<<<<<< HEAD
-static int wm5100_set_bias_level(struct snd_soc_codec *codec,
-				 enum snd_soc_bias_level level)
-{
-	struct wm5100_priv *wm5100 = snd_soc_codec_get_drvdata(codec);
-	int ret, i;
-
-	switch (level) {
-	case SND_SOC_BIAS_ON:
-		break;
-
-	case SND_SOC_BIAS_PREPARE:
-		break;
-
-	case SND_SOC_BIAS_STANDBY:
-		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF) {
-			ret = regulator_bulk_enable(ARRAY_SIZE(wm5100->core_supplies),
-						    wm5100->core_supplies);
-			if (ret != 0) {
-				dev_err(codec->dev,
-					"Failed to enable supplies: %d\n",
-					ret);
-				return ret;
-			}
-
-			if (wm5100->pdata.ldo_ena) {
-				gpio_set_value_cansleep(wm5100->pdata.ldo_ena,
-							1);
-				msleep(2);
-			}
-
-			regcache_cache_only(wm5100->regmap, false);
-
-			switch (wm5100->rev) {
-			case 0:
-				regcache_cache_bypass(wm5100->regmap, true);
-				snd_soc_write(codec, 0x11, 0x3);
-				snd_soc_write(codec, 0x203, 0xc);
-				snd_soc_write(codec, 0x206, 0);
-				snd_soc_write(codec, 0x207, 0xf0);
-				snd_soc_write(codec, 0x208, 0x3c);
-				snd_soc_write(codec, 0x209, 0);
-				snd_soc_write(codec, 0x211, 0x20d8);
-				snd_soc_write(codec, 0x11, 0);
-
-				for (i = 0;
-				     i < ARRAY_SIZE(wm5100_reva_patches);
-				     i++)
-					snd_soc_write(codec,
-						      wm5100_reva_patches[i].reg,
-						      wm5100_reva_patches[i].val);
-				regcache_cache_bypass(wm5100->regmap, false);
-				break;
-			default:
-				break;
-			}
-
-			regcache_sync(wm5100->regmap);
-		}
-		break;
-
-	case SND_SOC_BIAS_OFF:
-		regcache_cache_only(wm5100->regmap, true);
-		regcache_mark_dirty(wm5100->regmap);
-		if (wm5100->pdata.ldo_ena)
-			gpio_set_value_cansleep(wm5100->pdata.ldo_ena, 0);
-		regulator_bulk_disable(ARRAY_SIZE(wm5100->core_supplies),
-				       wm5100->core_supplies);
-		break;
-	}
-	codec->dapm.bias_level = level;
-
-	return 0;
-}
-
-=======
->>>>>>> linux-next/akpm-end
 static int wm5100_dai_to_base(struct snd_soc_dai *dai)
 {
 	switch (dai->id) {
@@ -2174,21 +2097,7 @@ static void wm5100_micd_irq(struct wm510
 			snd_soc_jack_report(wm5100->jack, SND_JACK_BTN_0,
 					    SND_JACK_BTN_0);
 		} else if (wm5100->jack_detecting) {
-<<<<<<< HEAD
-			dev_dbg(codec->dev, "Headphone detected\n");
-			wm5100->jack_detecting = false;
-			snd_soc_jack_report(wm5100->jack, SND_JACK_HEADPHONE,
-					    SND_JACK_HEADPHONE);
-
-			/* Increase the detection rate a bit for
-			 * responsiveness.
-			 */
-			snd_soc_update_bits(codec, WM5100_MIC_DETECT_1,
-					    WM5100_ACCDET_RATE_MASK,
-					    7 << WM5100_ACCDET_RATE_SHIFT);
-=======
 			wm5100_report_headphone(wm5100);
->>>>>>> linux-next/akpm-end
 		}
 	}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
alix2-supplement-driver-to-include-gpio-button-support-fix.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


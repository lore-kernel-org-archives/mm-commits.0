From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 28 Nov 2011 12:57:32 -0800
Message-ID: <201111282057.pASKvYSv004774@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:54197 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab1K1VE2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 16:04:28 -0500
Received: by wwp14 with SMTP id 14so158806wwp.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 13:04:27 -0800 (PST)
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

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/patch_realtek.c |    3 ---
 sound/soc/codecs/sta32x.c     |   17 -----------------
 sound/soc/codecs/wm9081.c     |    9 ---------
 3 files changed, 29 deletions(-)

diff -puN sound/pci/hda/patch_realtek.c~linux-next-git-rejects sound/pci/hda/patch_realtek.c
--- a/sound/pci/hda/patch_realtek.c~linux-next-git-rejects
+++ a/sound/pci/hda/patch_realtek.c
@@ -284,11 +284,8 @@ static inline hda_nid_t get_capsrc(struc
 		spec->capsrc_nids[idx] : spec->adc_nids[idx];
 }
 
-<<<<<<< HEAD
-=======
 static void call_update_outputs(struct hda_codec *codec);
 
->>>>>>> linux-next/akpm-end
 /* select the given imux item; either unmute exclusively or select the route */
 static int alc_mux_select(struct hda_codec *codec, unsigned int adc_idx,
 			  unsigned int idx, bool force)
diff -puN sound/soc/codecs/sta32x.c~linux-next-git-rejects sound/soc/codecs/sta32x.c
--- a/sound/soc/codecs/sta32x.c~linux-next-git-rejects
+++ a/sound/soc/codecs/sta32x.c
@@ -80,11 +80,8 @@ struct sta32x_priv {
 	unsigned int format;
 
 	u32 coef_shadow[STA32X_COEF_COUNT];
-<<<<<<< HEAD
-=======
 	struct delayed_work watchdog_work;
 	int shutdown;
->>>>>>> linux-next/akpm-end
 };
 
 static const DECLARE_TLV_DB_SCALE(mvol_tlv, -12700, 50, 1);
@@ -267,11 +264,7 @@ static int sta32x_coefficient_put(struct
 	return 0;
 }
 
-<<<<<<< HEAD
-int sta32x_sync_coef_shadow(struct snd_soc_codec *codec)
-=======
 static int sta32x_sync_coef_shadow(struct snd_soc_codec *codec)
->>>>>>> linux-next/akpm-end
 {
 	struct sta32x_priv *sta32x = snd_soc_codec_get_drvdata(codec);
 	unsigned int cfud;
@@ -296,11 +289,7 @@ static int sta32x_sync_coef_shadow(struc
 	return 0;
 }
 
-<<<<<<< HEAD
-int sta32x_cache_sync(struct snd_soc_codec *codec)
-=======
 static int sta32x_cache_sync(struct snd_soc_codec *codec)
->>>>>>> linux-next/akpm-end
 {
 	unsigned int mute;
 	int rc;
@@ -317,8 +306,6 @@ static int sta32x_cache_sync(struct snd_
 	return rc;
 }
 
-<<<<<<< HEAD
-=======
 /* work around ESD issue where sta32x resets and loses all configuration */
 static void sta32x_watchdog(struct work_struct *work)
 {
@@ -359,7 +346,6 @@ static void sta32x_watchdog_stop(struct 
 	}
 }
 
->>>>>>> linux-next/akpm-end
 #define SINGLE_COEF(xname, index) \
 {	.iface = SNDRV_CTL_ELEM_IFACE_MIXER, .name = xname, \
 	.info = sta32x_coefficient_info, \
@@ -770,10 +756,7 @@ static int sta32x_set_bias_level(struct 
 			}
 
 			sta32x_cache_sync(codec);
-<<<<<<< HEAD
-=======
 			sta32x_watchdog_start(sta32x);
->>>>>>> linux-next/akpm-end
 		}
 
 		/* Power up to mute */
diff -puN sound/soc/codecs/wm9081.c~linux-next-git-rejects sound/soc/codecs/wm9081.c
--- a/sound/soc/codecs/wm9081.c~linux-next-git-rejects
+++ a/sound/soc/codecs/wm9081.c
@@ -860,13 +860,10 @@ static int wm9081_set_bias_level(struct 
 			mdelay(100);
 
 			/* Normal bias enable & soft start off */
-<<<<<<< HEAD
 			reg &= ~WM9081_VMID_RAMP;
 			snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
-=======
 			snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
 					    WM9081_VMID_RAMP, 0);
->>>>>>> linux-next/akpm-end
 
 			/* Standard bias source */
 			snd_soc_update_bits(codec, WM9081_BIAS_CONTROL_1,
@@ -874,15 +871,12 @@ static int wm9081_set_bias_level(struct 
 		}
 
 		/* VMID 2*240k */
-<<<<<<< HEAD
 		reg = snd_soc_read(codec, WM9081_VMID_CONTROL);
 		reg &= ~WM9081_VMID_SEL_MASK;
 		reg |= 0x04;
 		snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
-=======
 		snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
 				    WM9081_VMID_SEL_MASK, 0x04);
->>>>>>> linux-next/akpm-end
 
 		/* Standby bias current on */
 		snd_soc_update_bits(codec, WM9081_BIAS_CONTROL_1,
@@ -892,7 +886,6 @@ static int wm9081_set_bias_level(struct 
 
 	case SND_SOC_BIAS_OFF:
 		/* Startup bias source and disable bias */
-<<<<<<< HEAD
 		reg = snd_soc_read(codec, WM9081_BIAS_CONTROL_1);
 		reg |= WM9081_BIAS_SRC;
 		reg &= ~WM9081_BIAS_ENA;
@@ -903,7 +896,6 @@ static int wm9081_set_bias_level(struct 
 		reg &= ~WM9081_VMID_SEL_MASK;
 		reg |= WM9081_VMID_RAMP;
 		snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
-=======
 		snd_soc_update_bits(codec, WM9081_BIAS_CONTROL_1,
 				    WM9081_BIAS_SRC | WM9081_BIAS_ENA,
 				    WM9081_BIAS_SRC);
@@ -912,7 +904,6 @@ static int wm9081_set_bias_level(struct 
 		snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
 				    WM9081_VMID_RAMP | WM9081_VMID_SEL_MASK,
 				    WM9081_VMID_RAMP);
->>>>>>> linux-next/akpm-end
 
 		/* Actively discharge LINEOUT */
 		snd_soc_update_bits(codec, WM9081_ANTI_POP_CONTROL,
_
Subject: Subject: linux-next-git-rejects

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-staging-iio-industrialio-corec-make-it-compile.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
include-net-netprio_cgrouph-various-fixes.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


From: akpm@linux-foundation.org
Subject: - git-alsa-fixup.patch removed from -mm tree
Date: Tue, 01 May 2007 22:45:00 -0700
Message-ID: <200705020545.l425j1ul014693@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754090AbXEBFpE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2007 01:45:04 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l425j13w005640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 1 May 2007 22:45:02 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-alsa-fixup
has been removed from the -mm tree.  Its filename was
     git-alsa-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-alsa-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sound/alsa/ALSA-Configuration.txt |    5 --
 sound/pci/hda/hda_intel.c                       |    5 --
 sound/pci/hda/patch_sigmatel.c                  |   35 --------------
 sound/soc/Kconfig                               |    6 --
 4 files changed, 51 deletions(-)

diff -puN sound/pci/hda/hda_intel.c~git-alsa-fixup sound/pci/hda/hda_intel.c
--- a/sound/pci/hda/hda_intel.c~git-alsa-fixup
+++ a/sound/pci/hda/hda_intel.c
@@ -993,13 +993,8 @@ static int __devinit azx_codec_create(st
 	if ((err = snd_hda_bus_new(chip->card, &bus_temp, &chip->bus)) < 0)
 		return err;
 
-<<<<<<< HEAD/sound/pci/hda/hda_intel.c
-	codecs = 0;
-	for (c = 0; c < azx_max_codecs[chip->driver_type]; c++) {
-=======
 	codecs = audio_codecs = 0;
 	for (c = 0; c < AZX_MAX_CODECS; c++) {
->>>>>>> /sound/pci/hda/hda_intel.c
 		if ((chip->codec_mask & (1 << c)) & probe_mask) {
 			struct hda_codec *codec;
 			err = snd_hda_codec_new(chip->bus, c, &codec);
diff -puN sound/pci/hda/patch_sigmatel.c~git-alsa-fixup sound/pci/hda/patch_sigmatel.c
--- a/sound/pci/hda/patch_sigmatel.c~git-alsa-fixup
+++ a/sound/pci/hda/patch_sigmatel.c
@@ -60,14 +60,9 @@ enum {
 	STAC_D945GTP5,
 	STAC_MACMINI,
 	STAC_MACBOOK,
-<<<<<<< HEAD/sound/pci/hda/patch_sigmatel.c
-	STAC_MACBOOK_PRO_V1,
-	STAC_MACBOOK_PRO_V2,
-=======
 	STAC_MACBOOK_PRO_V1,
 	STAC_MACBOOK_PRO_V2,
 	STAC_IMAC_INTEL,
->>>>>>> /sound/pci/hda/patch_sigmatel.c
 	STAC_922X_MODELS
 };
 
@@ -536,17 +531,7 @@ static unsigned int macbook_pro_v1_pin_c
 	0x02a19320, 0x400000fb
 };
 
-<<<<<<< HEAD/sound/pci/hda/patch_sigmatel.c
-static unsigned int macbook_pro_v1_pin_configs[10] = {
-	0x0321e230, 0x03a1e020, 0x9017e110, 0x01014010,
-	0x01a19021, 0x0381e021, 0x1345e240, 0x13c5e22e,
-	0x02a19320, 0x400000fb
-};
-
-static unsigned int macbook_pro_v2_pin_configs[10] = {
-=======
 static unsigned int macbook_pro_v2_pin_configs[10] = {
->>>>>>> /sound/pci/hda/patch_sigmatel.c
 	0x0221401f, 0x90a70120, 0x01813024, 0x01014010,
 	0x400000fd, 0x01016011, 0x1345e240, 0x13c5e22e,
 	0x400000fc, 0x400000fb,
@@ -562,18 +547,11 @@ static unsigned int *stac922x_brd_tbl[ST
 	[STAC_D945_REF] = ref922x_pin_configs,
 	[STAC_D945GTP3] = d945gtp3_pin_configs,
 	[STAC_D945GTP5] = d945gtp5_pin_configs,
-<<<<<<< HEAD/sound/pci/hda/patch_sigmatel.c
-	[STAC_MACMINI] = d945gtp5_pin_configs,
-	[STAC_MACBOOK] = macbook_pin_configs,
-	[STAC_MACBOOK_PRO_V1] = macbook_pro_v1_pin_configs,
-	[STAC_MACBOOK_PRO_V2] = macbook_pro_v2_pin_configs,
-=======
 	[STAC_MACMINI] = macbook_pro_v1_pin_configs,
 	[STAC_MACBOOK] = macbook_pro_v1_pin_configs,
 	[STAC_MACBOOK_PRO_V1] = macbook_pro_v1_pin_configs,
 	[STAC_MACBOOK_PRO_V2] = macbook_pro_v2_pin_configs,
 	[STAC_IMAC_INTEL] = imac_intel_pin_configs,
->>>>>>> /sound/pci/hda/patch_sigmatel.c
 };
 
 static const char *stac922x_models[STAC_922X_MODELS] = {
@@ -582,14 +560,9 @@ static const char *stac922x_models[STAC_
 	[STAC_D945GTP3]	= "3stack",
 	[STAC_MACMINI]	= "macmini",
 	[STAC_MACBOOK]	= "macbook",
-<<<<<<< HEAD/sound/pci/hda/patch_sigmatel.c
-	[STAC_MACBOOK_PRO_V1]	= "macbook-pro-v1",
-	[STAC_MACBOOK_PRO_V2]	= "macbook-pro",
-=======
 	[STAC_MACBOOK_PRO_V1]	= "macbook-pro-v1",
 	[STAC_MACBOOK_PRO_V2]	= "macbook-pro",
 	[STAC_IMAC_INTEL] = "imac-intel",
->>>>>>> /sound/pci/hda/patch_sigmatel.c
 };
 
 static struct snd_pci_quirk stac922x_cfg_tbl[] = {
@@ -1947,13 +1920,6 @@ static int patch_stac922x(struct hda_cod
 		 */
 		printk(KERN_INFO "hda_codec: STAC922x, Apple subsys_id=%x\n", codec->subsystem_id);
 		switch (codec->subsystem_id) {
-<<<<<<< HEAD/sound/pci/hda/patch_sigmatel.c
-		case 0x106b0200: /* MacBook Pro first generation */
-			spec->board_config = STAC_MACBOOK_PRO_V1;
-			break;
-		case 0x106b1e00: /* MacBook Pro second generation */
-			spec->board_config = STAC_MACBOOK_PRO_V2;
-=======
 		case 0x106b0a00: /* MacBook First generatoin */
 			spec->board_config = STAC_MACBOOK;
 			break;
@@ -1965,7 +1931,6 @@ static int patch_stac922x(struct hda_cod
 			break;
 		case 0x106b0700: /* Intel-based iMac */
 			spec->board_config = STAC_IMAC_INTEL;
->>>>>>> /sound/pci/hda/patch_sigmatel.c
 			break;
 		}
 	}
diff -puN sound/soc/Kconfig~git-alsa-fixup sound/soc/Kconfig
--- a/sound/soc/Kconfig~git-alsa-fixup
+++ a/sound/soc/Kconfig
@@ -9,15 +9,9 @@ config SND_SOC_AC97_BUS
 	bool
 
 config SND_SOC
-<<<<<<< HEAD/sound/soc/Kconfig
-	tristate "SoC audio support"
-	depends on SND
-	select SND_PCM
-=======
 	tristate "ALSA for SoC audio support"
 	depends on SND
 	select SND_PCM
->>>>>>> /sound/soc/Kconfig
 	---help---
 
 	  If you want ASoC support, you should say Y here and also to the
diff -puN Documentation/sound/alsa/ALSA-Configuration.txt~git-alsa-fixup Documentation/sound/alsa/ALSA-Configuration.txt
--- a/Documentation/sound/alsa/ALSA-Configuration.txt~git-alsa-fixup
+++ a/Documentation/sound/alsa/ALSA-Configuration.txt
@@ -907,14 +907,9 @@ Prior to version 0.9.0rc4 options had a 
 	  5stack	D945 5stack + SPDIF
 	  macmini	Intel Mac Mini
 	  macbook	Intel Mac Book
-<<<<<<< HEAD/Documentation/sound/alsa/ALSA-Configuration.txt
-	  macbook-pro-v1 Intel Mac Book Pro 1st generation
-	  macbook-pro	Intel Mac Book Pro 2nd generation
-=======
 	  macbook-pro-v1 Intel Mac Book Pro 1st generation
 	  macbook-pro	Intel Mac Book Pro 2nd generation
 	  imac-intel	Intel iMac
->>>>>>> /Documentation/sound/alsa/ALSA-Configuration.txt
 
 	STAC9202/9250/9251
 	  ref		Reference board, base config
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
zlib-backout.patch
slab-introduce-krealloc.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-arm.patch
git-avr32.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
ida-implement-idr-based-id-allocator-fix.patch
more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
git-drm.patch
git-dvb-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
git-gfs2-nmw.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
git-input.patch
git-jfs.patch
git-kvm.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc.patch
git-mmc-build-fix.patch
ne-add-platform_driver-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio.patch
git-ocfs2.patch
git-parisc.patch
git-r8169.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
s390-net-lcs-convert-to-the-kthread-api.patch
git-sh-fixup.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-__inquire_remote_apic-printk-warning-fix.patch
xfs-clean-up-shrinker-games.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
smaps-add-clear_refs-file-to-clear-reference.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
slab-mark-set_up_list3s-__init.patch
slub-core.patch
mm-optimize-kill_bdev.patch
lazy-freeing-of-memory-through-madv_free.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection.patch
fix-cycladesh-for-x86_64-and-probably-others.patch
rtc-add-rtc-rs5c313-driver.patch
enlarge-console-name.patch
move-die-notifier-handling-to-common-code.patch
fix-sscanf-%n-match-at-end-of-input-string.patch
parport-dev-driver-model-support.patch
add-support-for-deferrable-timers-respun.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc.patch
fix-kevents-childs-priority-greediness.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
enhance-initcall_debug-measure-latency.patch
dtlk-fix-error-checks-in-module_init.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch
upper-32-bits.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
speedup-divides-by-cpu_power-in-scheduler.patch
utimensat-implementation.patch
revert-rtc-add-rtc_merge_alarm.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
kprobes-the-on-off-knob-thru-debugfs-updated.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
x86-serial-convert-legacy-com-ports-to-platform-devices.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
sm501fb-printk-warning-fixes.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
git-gccbug-fixup.patch
w1-build-fix.patch

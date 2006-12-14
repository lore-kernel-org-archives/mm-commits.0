From: akpm@osdl.org
Subject: - git-alsa-fixup.patch removed from -mm tree
Date: Wed, 13 Dec 2006 21:48:15 -0800
Message-ID: <200612140548.kBE5mFc6001396@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50623 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbWLNFs1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 00:48:27 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id kBE5mLID020367
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2006 21:48:22 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, mm-commits@vger.kernel.org


The patch titled
     git-alsa-fixup
has been removed from the -mm tree.  Its filename was
     git-alsa-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-alsa-fixup
From: Andrew Morton <akpm@osdl.org>

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/sound/ac97_codec.h  |    4 ----
 sound/core/sound.c          |    8 --------
 sound/pci/ac97/ac97_codec.c |    4 ----
 3 files changed, 16 deletions(-)

diff -puN sound/core/sound.c~git-alsa-fixup sound/core/sound.c
--- a/sound/core/sound.c~git-alsa-fixup
+++ a/sound/core/sound.c
@@ -264,20 +264,12 @@ int snd_register_device_for_dev(int type
 		return minor;
 	}
 	snd_minors[minor] = preg;
-<<<<<<< HEAD/sound/core/sound.c
 	if (card)
 		device = card->dev;
 	preg->dev = device_create(sound_class, device, MKDEV(major, minor),
 				  "%s", name);
 	if (preg->dev)
 		dev_set_drvdata(preg->dev, private_data);
-=======
-	preg->class_dev = class_device_create(sound_class, NULL,
-					      MKDEV(major, minor),
-					      device, "%s", name);
-	if (preg->class_dev)
-		class_set_devdata(preg->class_dev, private_data);
->>>>>>> /sound/core/sound.c
 
 	mutex_unlock(&sound_mutex);
 	return 0;
diff -puN include/sound/ac97_codec.h~git-alsa-fixup include/sound/ac97_codec.h
--- a/include/sound/ac97_codec.h~git-alsa-fixup
+++ a/include/sound/ac97_codec.h
@@ -512,12 +512,8 @@ struct snd_ac97 {
 
 #ifdef CONFIG_SND_AC97_POWER_SAVE
 	unsigned int power_up;	/* power states */
-<<<<<<< HEAD/include/sound/ac97_codec.h
 	struct workqueue_struct *power_workq;
 	struct delayed_work power_work;
-=======
-	struct work_struct power_work;
->>>>>>> /include/sound/ac97_codec.h
 #endif
 	struct device dev;
 };
diff -puN sound/pci/ac97/ac97_codec.c~git-alsa-fixup sound/pci/ac97/ac97_codec.c
--- a/sound/pci/ac97/ac97_codec.c~git-alsa-fixup
+++ a/sound/pci/ac97/ac97_codec.c
@@ -1995,12 +1995,8 @@ int snd_ac97_mixer(struct snd_ac97_bus *
 	mutex_init(&ac97->reg_mutex);
 	mutex_init(&ac97->page_mutex);
 #ifdef CONFIG_SND_AC97_POWER_SAVE
-<<<<<<< HEAD/sound/pci/ac97/ac97_codec.c
 	ac97->power_workq = create_workqueue("ac97");
 	INIT_DELAYED_WORK(&ac97->power_work, do_update_power);
-=======
-	INIT_WORK(&ac97->power_work, do_update_power, ac97);
->>>>>>> /sound/pci/ac97/ac97_codec.c
 #endif
 
 #ifdef CONFIG_PCI
_

Patches currently in -mm which might be from akpm@osdl.org are

build-compileh-earlier.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
acpi-dont-select-pm.patch
implementation-of-acpi_video_get_next_level.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-fixup.patch
alsa-workqueue-fixes.patch
git-drm.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-input-vs-git-alsa.patch
git-libata-all.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
pata_via-suspend-resume-support-fix.patch
git-lxdialog-fixup.patch
git-mmc-fixup.patch
git-mmc-tifm_sd-warning-fix.patch
git-mtd.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
driver-for-silan-sc92031-netdev-include-fix.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-legacy-resource-fix-tidy.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-in2000-scsi_cmnd-convertion.patch
aic79xx-wrong-max-memory-at-driver-init.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver-fix.patch
git-qla3xxx-fixup.patch
nokia-e70-is-an-unusual-device.patch
fix-gregkh-usb-usb-ehci-hcd-add-shadow-budget-code.patch
git-wireless.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
add-memcpy_uncached_read-tidy.patch
touchkit-ps-2-touchscreen-driver.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-3.patch
lumpy-reclaim-v2-tidy.patch
nfs-fix-nr_file_dirty-underflow-tidy.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
implement-flush_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch


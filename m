From: akpm@osdl.org
Subject: - alsa-workqueue-fixes.patch removed from -mm tree
Date: Fri, 15 Dec 2006 14:16:51 -0800
Message-ID: <200612152216.kBFMGpTt002416@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50368 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030261AbWLOWac (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Dec 2006 17:30:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, dhowells@redhat.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     alsa-workqueue-fixes
has been removed from the -mm tree.  Its filename was
     alsa-workqueue-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: alsa-workqueue-fixes
From: Andrew Morton <akpm@osdl.org>

Fix the soc code after dhowells workqueue changes.

I converted the workqueues to per-device while I was there.  It seems strange
to create a new kernel thread (on each CPU!) and to then only have a single
global work to ever be queued upon it.

Plus without this, I'd have to use the _NAR stuff, gawd help me.

Does that workqueue really need to be per-cpu?

Does that workqueue really need to exist?  Why not use keventd?

Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/sound/soc.h  |    2 ++
 sound/soc/soc-core.c |   12 ++++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -puN sound/soc/soc-core.c~alsa-workqueue-fixes sound/soc/soc-core.c
--- a/sound/soc/soc-core.c~alsa-workqueue-fixes
+++ a/sound/soc/soc-core.c
@@ -56,7 +56,6 @@
 static DEFINE_MUTEX(pcm_mutex);
 static DEFINE_MUTEX(io_mutex);
 static struct workqueue_struct *soc_workq;
-static struct work_struct soc_stream_work;
 static DECLARE_WAIT_QUEUE_HEAD(soc_pm_waitq);
 
 /* supported sample rates */
@@ -728,9 +727,10 @@ out:
  * This is to ensure there are no pops or clicks in between any music tracks
  * due to DAPM power cycling.
  */
-static void close_delayed_work(void *data)
+static void close_delayed_work(struct work_struct *work)
 {
-	struct snd_soc_device *socdev = data;
+	struct snd_soc_device *socdev =
+		container_of(work, struct snd_soc_device, delayed_work.work);
 	struct snd_soc_codec *codec = socdev->codec;
 	struct snd_soc_codec_dai *codec_dai;
 	int i;
@@ -805,7 +805,7 @@ static int soc_codec_close(struct snd_pc
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		/* start delayed pop wq here for playback streams */
 		rtd->codec_dai->pop_wait = 1;
-		queue_delayed_work(soc_workq, &soc_stream_work,
+		queue_delayed_work(soc_workq, &socdev->delayed_work,
 			msecs_to_jiffies(pmdown_time));
 	} else {
 		/* capture streams can be powered down now */
@@ -865,7 +865,7 @@ static int soc_pcm_prepare(struct snd_pc
 					SND_SOC_DAPM_STREAM_START);
 		else {
 			rtd->codec_dai->pop_wait = 0;
-			cancel_delayed_work(&soc_stream_work);
+			cancel_delayed_work(&socdev->delayed_work);
 			if (rtd->codec_dai->digital_mute)
 				rtd->codec_dai->digital_mute(codec, rtd->codec_dai, 0);
 		}
@@ -1225,7 +1225,7 @@ static int soc_probe(struct platform_dev
 	soc_workq = create_workqueue("kdapm");
 	if (soc_workq == NULL)
 		goto work_err;
-	INIT_WORK(&soc_stream_work, close_delayed_work, socdev);
+	INIT_DELAYED_WORK(&socdev->delayed_work, close_delayed_work);
 	return 0;
 
 work_err:
diff -puN include/sound/soc.h~alsa-workqueue-fixes include/sound/soc.h
--- a/include/sound/soc.h~alsa-workqueue-fixes
+++ a/include/sound/soc.h
@@ -15,6 +15,7 @@
 
 #include <linux/platform_device.h>
 #include <linux/types.h>
+#include <linux/workqueue.h>
 #include <sound/driver.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
@@ -454,6 +455,7 @@ struct snd_soc_device {
 	struct snd_soc_platform *platform;
 	struct snd_soc_codec *codec;
 	struct snd_soc_codec_device *codec_dev;
+	struct delayed_work delayed_work;
 	void *codec_data;
 };
 
_

Patches currently in -mm which might be from akpm@osdl.org are

deadlock-in-mincore-tidy.patch
deadlock-in-mincore-speedup.patch
rtc-warning-fix.patch
fix-vm_events_fold_cpu-build-breakage-fix.patch
smc911-workqueue-fixes.patch
build-compileh-earlier.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
git-acpi-cpufreq-fixup.patch
acpi-dont-select-pm.patch
implementation-of-acpi_video_get_next_level.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
arm-systemh-build-fix.patch
git-drm.patch
ia64-enable-config_debug_spinlock_sleep.patch
infiniband-fix-for-gregkh-depredations.patch
git-libata-all.patch
git-lxdialog-fixup.patch
git-mmc-fixup.patch
git-mmc-tifm_sd-warning-fix.patch
git-mtd.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
driver-for-silan-sc92031-netdev-include-fix.patch
driver-for-silan-sc92031-netdev-fix-more.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-legacy-resource-fix-tidy.patch
pci-disable-multithreaded-probing.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver-fix.patch
git-qla3xxx-fixup.patch
funsoft-is-bust-on-sparc.patch
nokia-e70-is-an-unusual-device.patch
fix-gregkh-usb-usb-ehci-hcd-add-shadow-budget-code.patch
git-wireless.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
revert-x86_64-mm-copy-user-nocache.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
add-memcpy_uncached_read-fix.patch
add-memcpy_uncached_read-tidy.patch
touchkit-ps-2-touchscreen-driver.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-3.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
nfs-fix-nr_file_dirty-underflow-tidy.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
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
kgdb-fix-rejects.patch
git-kgdb-fixup.patch
git-kgdb-vs-define-struct-pspace.patch
kgdb-default-to-ttys0.patch
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


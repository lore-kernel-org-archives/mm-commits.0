From: akpm@linux-foundation.org
Subject: + dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read-fix.patch added to -mm tree
Date: Thu, 30 Apr 2009 13:18:50 -0700
Message-ID: <200904302018.n3UKIov9020874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753104AbZD3UWD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Apr 2009 16:22:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mchehab@infradead.org, simon@fire.lp0.eu


The patch titled
     dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read-fix
has been added to the -mm tree.  Its filename is
     dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read-fix.patch

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
Subject: dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read-fix
From: Andrew Morton <akpm@linux-foundation.org>

- remove commented-out locking operations
- simplify code

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Simon Arlott <simon@fire.lp0.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-core/dmxdev.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN drivers/media/dvb/dvb-core/dmxdev.c~dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read-fix drivers/media/dvb/dvb-core/dmxdev.c
--- a/drivers/media/dvb/dvb-core/dmxdev.c~dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read-fix
+++ a/drivers/media/dvb/dvb-core/dmxdev.c
@@ -244,19 +244,13 @@ static ssize_t dvb_dvr_read(struct file 
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dmxdev *dmxdev = dvbdev->priv;
-	int ret;
 
-	if (dmxdev->exit) {
-		//mutex_unlock(&dmxdev->mutex);
+	if (dmxdev->exit)
 		return -ENODEV;
-	}
 
-	//mutex_lock(&dmxdev->mutex);
-	ret = dvb_dmxdev_buffer_read(&dmxdev->dvr_buffer,
-				     file->f_flags & O_NONBLOCK,
-				     buf, count, ppos);
-	//mutex_unlock(&dmxdev->mutex);
-	return ret;
+	return dvb_dmxdev_buffer_read(&dmxdev->dvr_buffer,
+				      file->f_flags & O_NONBLOCK,
+				      buf, count, ppos);
 }
 
 static int dvb_dvr_set_buffer_size(struct dmxdev *dmxdev,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-close-page_mkwrite-races-try-3.patch
vmscan-avoid-multiplication-overflow-in-shrink_zone.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-apic-io_apicc-conditionally-compile-eoi_ioapic_irq.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read-fix.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
forcedeth-add-clock-gating-feature-checkpatch-fixes.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
eliminate-thousands-of-warnings-with-gcc-32-build-cleanup.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
leds-of_register_platform_driver-doesnt-exist-on-sparc64.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
ksm-add-ksm-kernel-shared-memory-driver-borked-on-non-x86.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
mutex-add-atomic_dec_and_mutex_lock-fix.patch
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


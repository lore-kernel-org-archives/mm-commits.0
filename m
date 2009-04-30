From: akpm@linux-foundation.org
Subject: - mm-only-inotify-switch-kernel_event-to-gfp_kernel.patch removed from -mm tree
Date: Thu, 30 Apr 2009 15:48:41 -0700
Message-ID: <200904302307.n3UN7eFu016468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754778AbZD3XMf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Apr 2009 19:12:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clameter@sgi.com, eparis@redhat.com, fengguang.wu@intel.com, mpm@selenic.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     mm-only: inotify: switch kernel_event() to GFP_KERNEL
has been removed from the -mm tree.  Its filename was
     mm-only-inotify-switch-kernel_event-to-gfp_kernel.patch

This patch was dropped because blah, inotify-reimplement-inotify-using-fsnotify.patch screwed this up

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-only: inotify: switch kernel_event() to GFP_KERNEL
From: Andrew Morton <akpm@linux-foundation.org>

A placeholder to remember that we need to fix this for real.  Will cause
lockdep warnings.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_user.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/notify/inotify/inotify_user.c~mm-only-inotify-switch-kernel_event-to-gfp_kernel fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~mm-only-inotify-switch-kernel_event-to-gfp_kernel
+++ a/fs/notify/inotify/inotify_user.c
@@ -189,7 +189,7 @@ static struct inotify_kernel_event * ker
 {
 	struct inotify_kernel_event *kevent;
 
-	kevent = kmem_cache_alloc(event_cachep, GFP_NOFS);
+	kevent = kmem_cache_alloc(event_cachep, GFP_KERNEL);
 	if (unlikely(!kevent))
 		return NULL;
 
@@ -220,7 +220,7 @@ static struct inotify_kernel_event * ker
 				rem = 0;
 		}
 
-		kevent->name = kmalloc(len + rem, GFP_NOFS);
+		kevent->name = kmalloc(len + rem, GFP_KERNEL);
 		if (unlikely(!kevent->name)) {
 			kmem_cache_free(event_cachep, kevent);
 			return NULL;
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
mm-only-inotify-switch-kernel_event-to-gfp_kernel.patch


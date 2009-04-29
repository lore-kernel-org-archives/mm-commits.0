From: akpm@linux-foundation.org
Subject: [folded] mm-close-page_mkwrite-races-try-3-fix.patch removed from -mm tree
Date: Wed, 29 Apr 2009 08:25:35 -0700
Message-ID: <200904291525.n3TFPZvk005628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754569AbZD2P3J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 11:29:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Valdis.Kletnieks@vt.edu, npiggin@suse.de, sage@newdream.net, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     mm-close-page_mkwrite-races-try-3-fix
has been removed from the -mm tree.  Its filename was
     mm-close-page_mkwrite-races-try-3-fix.patch

This patch was dropped because it was folded into mm-close-page_mkwrite-races-try-3.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-close-page_mkwrite-races-try-3-fix
From: Andrew Morton <akpm@linux-foundation.org>

try to go oops less.

Cc: Nick Piggin <npiggin@suse.de>
Cc: Sage Weil <sage@newdream.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-close-page_mkwrite-races-try-3-fix mm/memory.c
--- a/mm/memory.c~mm-close-page_mkwrite-races-try-3-fix
+++ a/mm/memory.c
@@ -2126,7 +2126,8 @@ unlock:
 			set_page_dirty(dirty_page);
 			unlock_page(dirty_page);
 			page_cache_release(dirty_page);
-			balance_dirty_pages_ratelimited(mapping);
+			if (mapping)
+				balance_dirty_pages_ratelimited(mapping);
 		}
 
 		/* file_update_time outside page_lock */
@@ -2767,7 +2768,7 @@ out:
 			page_mkwrite = 1;
 		unlock_page(dirty_page);
 		put_page(dirty_page);
-		if (page_mkwrite)
+		if (page_mkwrite && mapping)
 			balance_dirty_pages_ratelimited(mapping);
 
 		/* file_update_time outside page_lock */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-close-page_mkwrite-races-try-3.patch
mm-close-page_mkwrite-races-try-3-fix.patch
mm-close-page_mkwrite-races-try-3-fix-fix.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
net-rfkill-rfkillc-fix-build-with-config_rfkill_leds=n.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-apic-io_apicc-conditionally-compile-eoi_ioapic_irq.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
input-bcm5974-declare-alignment-usage.patch
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


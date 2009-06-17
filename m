From: akpm@linux-foundation.org
Subject: [merged] page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:35:17 -0700
Message-ID: <200906171835.n5HIZHGr001272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760259AbZFQSgL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:36:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     page-allocator: warn if __GFP_NOFAIL is used for a large allocation
has been removed from the -mm tree.  Its filename was
     page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator: warn if __GFP_NOFAIL is used for a large allocation
From: Andrew Morton <akpm@linux-foundation.org>

__GFP_NOFAIL is a bad fiction.  Allocations _can_ fail, and callers should
detect and suitably handle this (and not by lamely moving the infinite
loop up to the caller level either).

Attempting to use __GFP_NOFAIL for a higher-order allocation is even
worse, so add a once-off runtime check for this to slap people around for
even thinking about trying it.

Cc: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN mm/page_alloc.c~page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation
+++ a/mm/page_alloc.c
@@ -1128,6 +1128,19 @@ again:
 		list_del(&page->lru);
 		pcp->count--;
 	} else {
+		if (unlikely(gfp_flags & __GFP_NOFAIL)) {
+			/*
+			 * __GFP_NOFAIL is not to be used in new code.
+			 *
+			 * All __GFP_NOFAIL callers should be fixed so that they
+			 * properly detect and handle allocation failures.
+			 *
+			 * We most definitely don't want callers attempting to
+			 * allocate greater than single-page units with
+			 * __GFP_NOFAIL.
+			 */
+			WARN_ON_ONCE(order > 0);
+		}
 		spin_lock_irqsave(&zone->lock, flags);
 		page = __rmqueue(zone, order, migratetype);
 		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1 << order));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
jsm-clean-up-serial-jsm-correctly-support-4-8-port-boards.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
maintainers-fbdev-is-orphaned.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes.patch
gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes-gpio-pca953x-get-platform_data-from-openfirmware-cleanups.patch
documentation-changes-perl-is-needed-to-build-the-kernel-fix.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
char-moxa-prevent-opening-unavailable-ports.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
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


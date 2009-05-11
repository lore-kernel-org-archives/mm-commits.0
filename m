From: akpm@linux-foundation.org
Subject: + page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch added to -mm tree
Date: Mon, 11 May 2009 15:11:47 -0700
Message-ID: <200905112211.n4BMBlX5030712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757739AbZEKWOC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 18:14:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mel@csn.ul.ie, rientjes@google.com


The patch titled
     page-allocator: warn if __GFP_NOFAIL is used for a large allocation
has been added to the -mm tree.  Its filename is
     page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch

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
Subject: page-allocator: warn if __GFP_NOFAIL is used for a large allocation
From: Andrew Morton <akpm@linux-foundation.org>

__GFP_NOFAIL is a bad fiction.  Allocations _can_ fail, and callers should
detect and suitably handle this (and not by lamely moving the infinite
loop up to the caller level either).

Attempting to use __GFP_NOFAIL for a higher-order allocation is even
worse, so add a once-off runtime check for this to slap people around for
even thinking about trying it.

Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation
+++ a/mm/page_alloc.c
@@ -1201,8 +1201,19 @@ static int should_fail_alloc_page(gfp_t 
 {
 	if (order < fail_page_alloc.min_order)
 		return 0;
-	if (gfp_mask & __GFP_NOFAIL)
+	if (gfp_mask & __GFP_NOFAIL) {
+		/*
+		 * __GFP_NOFAIL is not to be used in new code.
+		 *
+		 * All __GFP_NOFAIL callers should be fixed so that they
+		 * properly detect and handle allocation failures.
+		 *
+		 * We most definitely don't want callers attempting to allocate
+		 * greater than single-page units with __GFP_NOFAIL.
+		 */
+		WARN_ON_ONCE(order > 0);
 		return 0;
+	}
 	if (fail_page_alloc.ignore_gfp_highmem && (gfp_mask & __GFP_HIGHMEM))
 		return 0;
 	if (fail_page_alloc.ignore_gfp_wait && (gfp_mask & __GFP_WAIT))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read-fix.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
alpha-unbreak-percpu-again.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
fs-sysfs-filec-use-create_singlethread_workqueue.patch
leds-of_register_platform_driver-doesnt-exist-on-sparc64.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-madvisec-dont-open-code-is_vm_hugetlb_page.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot-checkpatch-fixes.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
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


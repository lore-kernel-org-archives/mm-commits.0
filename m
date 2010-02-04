From: akpm@linux-foundation.org
Subject: [folded] mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3-fix.patch removed from -mm tree
Date: Thu, 04 Feb 2010 11:59:17 -0800
Message-ID: <201002041959.o14JxHCD018510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932879Ab0BDUAE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 15:00:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, kosaki.motohiro@jp.fujitsu.com, maximlevitsky@gmail.com, rjw@sisk.pl, sebott@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3-fix
has been removed from the -mm tree.  Its filename was
     mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3-fix.patch

This patch was dropped because it was folded into mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3-fix
From: Andrew Morton <akpm@linux-foundation.org>

mm/built-in.o: In function `clear_gfp_allowed_mask':
: undefined reference to `pm_mutex'
mm/built-in.o: In function `set_gfp_allowed_mask':
: undefined reference to `pm_mutex'
make: *** [.tmp_vmlinux1] Error 1


Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3-fix
+++ a/mm/page_alloc.c
@@ -77,6 +77,7 @@ unsigned long totalreserve_pages __read_
 int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
+#ifdef CONFIG_PM
 /*
  * The following functions are used by the suspend/hibernate code to temporarily
  * change gfp_allowed_mask in order to avoid using I/O during memory allocations
@@ -85,7 +86,6 @@ gfp_t gfp_allowed_mask __read_mostly = G
  * only be modified with pm_mutex held, unless the suspend/hibernate code is
  * guaranteed not to run in parallel with that modification).
  */
-
 void set_gfp_allowed_mask(gfp_t mask)
 {
 	WARN_ON(!mutex_is_locked(&pm_mutex));
@@ -100,6 +100,7 @@ gfp_t clear_gfp_allowed_mask(gfp_t mask)
 	gfp_allowed_mask &= ~mask;
 	return ret;
 }
+#endif		/* CONFIG_PM */
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 int pageblock_order __read_mostly;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix-fix-2.patch
pci-update-pci_set_vga_state-to-call-arch-functions.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
kernel-schedc-suppress-unused-var-warning.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
add-generic-sys_ipc-wrapper-fix.patch
lib-more-scalable-list_sort-fix.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch


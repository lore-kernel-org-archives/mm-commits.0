From: akpm@linux-foundation.org
Subject: + 3x59x-fix-pci-resource-management-checkpatch-fixes.patch added to -mm tree
Date: Wed, 10 Jun 2009 13:48:04 -0700
Message-ID: <200906102048.n5AKm47f019441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755872AbZFJUw7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 16:52:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, klassert@mathematik.tu-chemnitz.de, sshtylyov@ru.mvista.com


The patch titled
     3x59x-fix-pci-resource-management-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     3x59x-fix-pci-resource-management-checkpatch-fixes.patch

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
Subject: 3x59x-fix-pci-resource-management-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: space prohibited between function name and open parenthesis '('
#56: FILE: drivers/net/3c59x.c:991:
+		pci_disable_device (pdev);

WARNING: line over 80 characters
#85: FILE: drivers/net/3c59x.c:1164:
+					   sizeof(struct boom_rx_desc) * RX_RING_SIZE +

WARNING: line over 80 characters
#86: FILE: drivers/net/3c59x.c:1165:
+					   sizeof(struct boom_tx_desc) * TX_RING_SIZE,

WARNING: space prohibited between function name and open parenthesis '('
#153: FILE: drivers/net/3c59x.c:3188:
+	pci_disable_device (pdev);

total: 0 errors, 4 warnings, 124 lines checked

./patches/3x59x-fix-pci-resource-management.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c59x.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/net/3c59x.c~3x59x-fix-pci-resource-management-checkpatch-fixes drivers/net/3c59x.c
--- a/drivers/net/3c59x.c~3x59x-fix-pci-resource-management-checkpatch-fixes
+++ a/drivers/net/3c59x.c
@@ -988,7 +988,7 @@ static int __devinit vortex_init_one(str
 			   ent->driver_data, unit);
 	if (rc < 0) {
 		pci_release_regions(pdev);
-		pci_disable_device (pdev);
+		pci_disable_device(pdev);
 		return rc;
 	}
 
@@ -1161,9 +1161,9 @@ static int __devinit vortex_probe1(struc
 
 	/* Makes sure rings are at least 16 byte aligned. */
 	vp->rx_ring = pci_alloc_consistent(pdev,
-					   sizeof(struct boom_rx_desc) * RX_RING_SIZE +
-					   sizeof(struct boom_tx_desc) * TX_RING_SIZE,
-					   &vp->rx_ring_dma);
+				sizeof(struct boom_rx_desc) * RX_RING_SIZE +
+				sizeof(struct boom_tx_desc) * TX_RING_SIZE,
+				&vp->rx_ring_dma);
 	retval = -ENOMEM;
 	if (!vp->rx_ring)
 		goto free_device;
@@ -3185,7 +3185,7 @@ static void __devexit vortex_remove_one(
 			    vp->rx_ring_dma);
 
 	pci_release_regions(pdev);
-	pci_disable_device (pdev);
+	pci_disable_device(pdev);
 	free_netdev(dev);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
ds_selftest-is-borked.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
cpufreq-powernow-k8-cleanup-msg-if-bios-does-not-export-acpi-_pss-cpufreq-data-cleanup.patch
devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
e100-add-non-mii-phy-support.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
firmware_map-fix-hang-with-x86-32bit.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
pagemap-add-page-types-tool-fix.patch
videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-clean-up-functions-related-to-pages_min-checkpatch-fixes.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone-checkpatch-fixes.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
proc-merge-arrayc-into-basec-checkpatch-fixes.patch
jsm-clean-up-serial-jsm-correctly-support-4-8-port-boards.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes.patch
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


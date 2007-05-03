From: akpm@linux-foundation.org
Subject: + working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch added to -mm tree
Date: Wed, 02 May 2007 22:17:28 -0700
Message-ID: <200705030517.l435HSs6005389@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767387AbXECFRn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 01:17:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, andi@lisas.de, davej@codemonkey.org.uk


The patch titled
     working-3d-dri-intel-agpko-resume-for-i815-chip-tidy
has been added to the -mm tree.  Its filename is
     working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: working-3d-dri-intel-agpko-resume-for-i815-chip-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andreas Mohr <andi@lisas.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/char/agp/intel-agp.c~working-3d-dri-intel-agpko-resume-for-i815-chip-tidy drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~working-3d-dri-intel-agpko-resume-for-i815-chip-tidy
+++ a/drivers/char/agp/intel-agp.c
@@ -2030,8 +2030,10 @@ static int agp_i815_remember_state(struc
 	 * to be able to successfully restore X11 when AGP 3D is enabled
 	 * (register values given are after resume vs. before suspend):
 	 *
-	 * I815_GMCHCFG (0x50; we need to set bit 1 (Aperture Access Global Enable) of I815_APCONT (0x51),
-	 *              thus use I815_GMCHCFG (0x50) as 32bit base register); 0x4fdd0040 instead of 0x4fdd0240
+	 * I815_GMCHCFG (0x50; we need to set bit 1 (Aperture Access Global
+	 *              Enable) of I815_APCONT (0x51),
+	 *              thus use I815_GMCHCFG (0x50) as 32bit base register);
+	 *              0x4fdd0040 instead of 0x4fdd0240
 	 * ??? (0x80); 0x07ce1cde instead of 0x07cb94de
 	 * I815_SM_RCOMP (0x98); 0x80648064 instead of 0x80548054
 	 * I815_SM (0x9c); 0x00c48405 instead of 0x04848405
@@ -2039,7 +2041,8 @@ static int agp_i815_remember_state(struc
 	 * INTEL_AGPCTRL (0xb0); 0x00000000 instead of 0x00000080
 	 * INTEL_APSIZE (0xb4);
 	 * INTEL_ATTBASE (0xb8); 0x00000000 instead of 0x024b0000
-	 * I815_ERRSTS?? (0xc8; undocumented for i815, see above); 0x00000000 instead of 0x00000800
+	 * I815_ERRSTS?? (0xc8; undocumented for i815, see above);
+	 *              0x00000000 instead of 0x00000800
 	 * ??? (0xe8); 0x1c700000 instead of 0x18500000
 	 *
 	 * Other machines/chipsets/BIOS versions may require
@@ -2062,12 +2065,12 @@ static int agp_i815_remember_state(struc
 
 	if (restore) {
 		u32 val;
-		for (p = i815_saved_regs; (p->reg != 0); p++)
-		{
+		for (p = i815_saved_regs; (p->reg != 0); p++) {
 			pci_read_config_dword(pdev, p->reg, &val);
 			if (val != p->value) {
-				printk(KERN_DEBUG "AGP: Writing back config space on "
-					"device %s at offset %x (was %x, writing %x)\n",
+				printk(KERN_DEBUG "AGP: Writing back config "
+					"space on device %s at offset %x (was "
+					"%x, writing %x)\n",
 					pci_name(pdev), p->reg,
 					val, p->value);
 				pci_write_config_dword(pdev, p->reg,
@@ -2096,8 +2099,8 @@ static int agp_i815_remember_state(struc
  * should be cleaned up, probably by implementing a generic Linux
  * PCI function to save/restore extended PCI config space
  * by supplying a register array or so...
- * At this point, it would also be nice to clean up the _suspend()/_resume() functions
- * to use some non-ugly and nicely generic restore mechanism.
+ * At this point, it would also be nice to clean up the _suspend()/_resume()
+ * functions to use some non-ugly and nicely generic restore mechanism.
  */
 #define DEBUG_AGP_PM 0
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc.patch
rm9000-serial-driver.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-mark-set_up_list3s-__init.patch
slub-core.patch
mm-optimize-kill_bdev.patch
get_unmapped_area-handles-map_fixed-in-hugetlbfs-fix.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
cx88-video-build-fix.patch
zlib-backout.patch
git-acpi.patch
git-alsa.patch
git-agpgart.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-arm.patch
git-avr32.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
ida-implement-idr-based-id-allocator-fix.patch
more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
git-drm.patch
git-gfs2-nmw.patch
git-hid-fixup.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
git-input.patch
git-jfs.patch
git-kvm.patch
git-mmc.patch
git-e1000.patch
git-e1000-fixup-2.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio.patch
git-ocfs2.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
git-sh-fixup.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-__inquire_remote_apic-printk-warning-fix.patch
xfs-clean-up-shrinker-games.patch
lazy-freeing-of-memory-through-madv_free.patch
increase-slab-redzone-to-64bits-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
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
w1-build-fix.patch

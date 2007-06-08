From: akpm@linux-foundation.org
Subject: + i386-mtrr-clean-up-usage_table.patch added to -mm tree
Date: Thu, 07 Jun 2007 17:21:00 -0700
Message-ID: <200706080021.l580L0KF013409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38093 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762575AbXFHAVL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 20:21:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de, jesse.barnes@intel.com


The patch titled
     i386: mtrr: clean up usage_table
has been added to the -mm tree.  Its filename is
     i386-mtrr-clean-up-usage_table.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: mtrr: clean up usage_table
From: Andrew Morton <akpm@linux-foundation.org>

- Move the declaration into a header file

- "usage_table" is a dumb name for an mtrr-specific kernel-wide identifier.

  There appear to beseveral other poorly-chosen identifiers in mtrr.

Cc: Andi Kleen <ak@suse.de>
Cc: Jesse Barnes <jesse.barnes@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/if.c   |    8 ++------
 arch/i386/kernel/cpu/mtrr/main.c |   17 +++++++++--------
 arch/i386/kernel/cpu/mtrr/mtrr.h |    2 ++
 3 files changed, 13 insertions(+), 14 deletions(-)

diff -puN arch/i386/kernel/cpu/mtrr/if.c~i386-mtrr-clean-up-usage_table arch/i386/kernel/cpu/mtrr/if.c
--- a/arch/i386/kernel/cpu/mtrr/if.c~i386-mtrr-clean-up-usage_table
+++ a/arch/i386/kernel/cpu/mtrr/if.c
@@ -11,10 +11,6 @@
 #include <asm/mtrr.h>
 #include "mtrr.h"
 
-/* RED-PEN: this is accessed without any locking */
-extern unsigned int usage_table[];
-
-
 #define FILE_FCOUNT(f) (((struct seq_file *)((f)->private_data))->private)
 
 static const char *const mtrr_strings[MTRR_NUM_TYPES] =
@@ -396,7 +392,7 @@ static int mtrr_seq_show(struct seq_file
 	for (i = 0; i < max; i++) {
 		mtrr_if->get(i, &base, &size, &type);
 		if (size == 0)
-			usage_table[i] = 0;
+			mtrr_usage_table[i] = 0;
 		else {
 			if (size < (0x100000 >> PAGE_SHIFT)) {
 				/* less than 1MB */
@@ -410,7 +406,7 @@ static int mtrr_seq_show(struct seq_file
 			len += seq_printf(seq, 
 				   "reg%02i: base=0x%05lx000 (%4luMB), size=%4lu%cB: %s, count=%d\n",
 			     i, base, base >> (20 - PAGE_SHIFT), size, factor,
-			     mtrr_attrib_to_str(type), usage_table[i]);
+			     mtrr_attrib_to_str(type), mtrr_usage_table[i]);
 		}
 	}
 	return 0;
diff -puN arch/i386/kernel/cpu/mtrr/main.c~i386-mtrr-clean-up-usage_table arch/i386/kernel/cpu/mtrr/main.c
--- a/arch/i386/kernel/cpu/mtrr/main.c~i386-mtrr-clean-up-usage_table
+++ a/arch/i386/kernel/cpu/mtrr/main.c
@@ -47,7 +47,7 @@
 
 u32 num_var_ranges = 0;
 
-unsigned int usage_table[NUM_VAR_RANGES];
+unsigned int mtrr_usage_table[NUM_VAR_RANGES];
 static DEFINE_MUTEX(mtrr_mutex);
 
 u64 size_or_mask, size_and_mask;
@@ -127,7 +127,7 @@ static void __init init_table(void)
 
 	max = num_var_ranges;
 	for (i = 0; i < max; i++)
-		usage_table[i] = 1;
+		mtrr_usage_table[i] = 1;
 }
 
 struct set_mtrr_data {
@@ -381,7 +381,7 @@ int mtrr_add_page(unsigned long base, un
 			goto out;
 		}
 		if (increment)
-			++usage_table[i];
+			++mtrr_usage_table[i];
 		error = i;
 		goto out;
 	}
@@ -390,12 +390,13 @@ int mtrr_add_page(unsigned long base, un
 	if (i >= 0) {
 		set_mtrr(i, base, size, type);
 		if (likely(replace < 0))
-			usage_table[i] = 1;
+			mtrr_usage_table[i] = 1;
 		else {
-			usage_table[i] = usage_table[replace] + !!increment;
+			mtrr_usage_table[i] = mtrr_usage_table[replace] +
+						!!increment;
 			if (unlikely(replace != i)) {
 				set_mtrr(replace, 0, 0, 0);
-				usage_table[replace] = 0;
+				mtrr_usage_table[replace] = 0;
 			}
 		}
 	} else
@@ -525,11 +526,11 @@ int mtrr_del_page(int reg, unsigned long
 		printk(KERN_WARNING "mtrr: MTRR %d not used\n", reg);
 		goto out;
 	}
-	if (usage_table[reg] < 1) {
+	if (mtrr_usage_table[reg] < 1) {
 		printk(KERN_WARNING "mtrr: reg: %d has count=0\n", reg);
 		goto out;
 	}
-	if (--usage_table[reg] < 1)
+	if (--mtrr_usage_table[reg] < 1)
 		set_mtrr(reg, 0, 0, 0);
 	error = reg;
  out:
diff -puN arch/i386/kernel/cpu/mtrr/mtrr.h~i386-mtrr-clean-up-usage_table arch/i386/kernel/cpu/mtrr/mtrr.h
--- a/arch/i386/kernel/cpu/mtrr/mtrr.h~i386-mtrr-clean-up-usage_table
+++ a/arch/i386/kernel/cpu/mtrr/mtrr.h
@@ -97,3 +97,5 @@ void mtrr_state_warn(void);
 const char *mtrr_attrib_to_str(int x);
 void mtrr_wrmsr(unsigned, unsigned, unsigned);
 
+/* RED-PEN: this is accessed without any locking */
+extern unsigned int mtrr_usage_table[];
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

document-acked-by.patch
git-acpi.patch
git-acpi-tickh-needs-hrtimerh.patch
git-acpi-add-exports.patch
git-acpi-disable-acpi_processor_throttling_seq_show.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-avr32.patch
git-cpufreq-fix.patch
bugfix-cpufreq-in-combination-with-performance-governor-fix.patch
8xx-mpc885ads-pcmcia-support.patch
revert-gregkh-driver-block-device.patch
driver-core-check-return-code-of-sysfs_create_link.patch
git-dvb.patch
git-gfs2-nmw.patch
git-input.patch
git-input-fixup.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
git-md-accel.patch
git-mips-fixup.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
git-ubi.patch
sundance-phy-address-form-0-only-for-device-id-0x0200-fix.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-scsi-misc.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
watchdog-driver-for-at32ap700x-devices-fix.patch
watchdog-driver-for-at32ap700x-devices-fix-2.patch
git-wireless.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
revert-x86_64-mm-verify-cpu-rename.patch
revert-x86_64-mm-allocate-sparsemem-memmap-above-4g-on-x86_64.patch
revert-x86_64-mm-cpa-cache-flush.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-sched-clock-share.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86-64-calgary-introduce-chipset-specific-ops-fix.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2-fix.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions-fix.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
paravirt-helper-to-disable-all-io-space-fix.patch
i386-mtrr-clean-up-usage_table.patch
git-xfs.patch
git-cryptodev.patch
git-xtensa.patch
acpi-preserve-the-ebx-value-in-acpi_copy_wakeup_routine.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-v6-zonelist-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
slub-support-slub_debug-on-by-default-tidy.patch
numa-mempolicy-allow-tunable-policy-for-system-init-fix.patch
nick-broke-stuff.patch
nick-broke-more-stuff.patch
nick-broke-even-more-stuff.patch
nick-really-did-it-this-time.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
create-the-zone_movable-zone-fix-2.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers-fix.patch
pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
pm-introduce-hibernation-and-suspend-notifiers-fix-fix.patch
pm-disable-usermode-helper-before-hibernation-and-suspend-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
mpu401-warning-fixes.patch
procfs-directory-entry-cleanup-fix.patch
vdso-print-fatal-signals.patch
reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
o_cloexec-for-scm_rights-fix.patch
o_cloexec-for-scm_rights-fix-2.patch
atmel_serial-fix-break-handling.patch
lib-add-idr_for_each-fix.patch
ext3-ext4-orphan-list-check-on-destroy_inode-fix.patch
taskstats-add-context-switch-counters-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
lguest-the-net-driver-include-fix.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix-2.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
cfs-warning-fixes.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
containersv10-basic-container-framework-fix.patch
containersv10-basic-container-framework-fix-2.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
reiser4.patch
reiser4-fix.patch
nick-broke-reiser4-too.patch
check_dirty_inode_list.patch
w1-build-fix.patch

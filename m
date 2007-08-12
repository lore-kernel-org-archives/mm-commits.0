From: akpm@linux-foundation.org
Subject: + revert-acpi-enable-c3-even-when-pm2_control-is-zero.patch added to -mm tree
Date: Sun, 12 Aug 2007 09:27:55 -0700
Message-ID: <200708121627.l7CGRtwf003098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58313 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933084AbXHLQ2l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 12 Aug 2007 12:28:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ilpo.jarvinen@helsinki.fi, len.brown@intel.com, michal.k.k.piotrowski@gmail.com, venkatesh.pallipadi@intel.com


The patch titled
     revert "ACPI: Enable C3 even when PM2_control is zero"
has been added to the -mm tree.  Its filename is
     revert-acpi-enable-c3-even-when-pm2_control-is-zero.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert "ACPI: Enable C3 even when PM2_control is zero"
From: Andrew Morton <akpm@linux-foundation.org>

Revert 18eab8550397f1f3d4b8b2c5257c88dae25d58ed.  Due to

"Ilpo Jarvinen" <ilpo.jarvinen@helsinki.fi> wrote:
> 
> I noticed that v2.6.23-rc1 locks up during boot, same thing happens now 
> with the latest linus' tree (+net-2.6.24 and tcp-2.6 tree stuff on top 
> of it; in -rc1 test they weren't though). The exact location of hang
> varies a bit though. No OOPS, does not respond to sysrq or anything else 
> besides reset. Last known bootable one is something like 2.6.22-rc4 
> (I usually run 2.6.21.5 on this machine, haven't tried any 2.6.22 on
> this after those rcs). Problem seems to start after this line:
> 
> Time: acpi_pm clocksource has been installed.
> 
> ...the power led starts blinking (not periodic cycle but more or less 
> varying on-off cycle, never seen that led blink before at all, didn't know 
> that one can make it blink :-)) and the machine gets consideably slower 
> too. Never have it been able to complete booting all they way up to login 
> prompt before lock up.

Cc: "Ilpo Jarvinen" <ilpo.jarvinen@helsinki.fi>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff -puN drivers/acpi/processor_idle.c~revert-acpi-enable-c3-even-when-pm2_control-is-zero drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~revert-acpi-enable-c3-even-when-pm2_control-is-zero
+++ a/drivers/acpi/processor_idle.c
@@ -490,17 +490,7 @@ static void acpi_processor_idle(void)
 
 	case ACPI_STATE_C3:
 
-		/*
-		 * disable bus master
-		 * bm_check implies we need ARB_DIS
-		 * !bm_check implies we need cache flush
-		 * bm_control implies whether we can do ARB_DIS
-		 *
-		 * That leaves a case where bm_check is set and bm_control is
-		 * not set. In that case we cannot do much, we enter C3
-		 * without doing anything.
-		 */
-		if (pr->flags.bm_check && pr->flags.bm_control) {
+		if (pr->flags.bm_check) {
 			if (atomic_inc_return(&c3_cpu_count) ==
 			    num_online_cpus()) {
 				/*
@@ -509,7 +499,7 @@ static void acpi_processor_idle(void)
 				 */
 				acpi_set_register(ACPI_BITREG_ARB_DISABLE, 1);
 			}
-		} else if (!pr->flags.bm_check) {
+		} else {
 			/* SMP with no shared cache... Invalidate cache  */
 			ACPI_FLUSH_CPU_CACHE();
 		}
@@ -521,7 +511,7 @@ static void acpi_processor_idle(void)
 		acpi_cstate_enter(cx);
 		/* Get end time (ticks) */
 		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
-		if (pr->flags.bm_check && pr->flags.bm_control) {
+		if (pr->flags.bm_check) {
 			/* Enable bus master arbitration */
 			atomic_dec(&c3_cpu_count);
 			acpi_set_register(ACPI_BITREG_ARB_DISABLE, 0);
@@ -971,9 +961,9 @@ static void acpi_processor_power_verify_
 	if (pr->flags.bm_check) {
 		/* bus mastering control is necessary */
 		if (!pr->flags.bm_control) {
-			/* In this case we enter C3 without bus mastering */
 			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				"C3 support without bus mastering control\n"));
+					  "C3 support requires bus mastering control\n"));
+			return;
 		}
 	} else {
 		/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fbcon-kill-compile-warning.patch
fix-serial-buffer-memory-leak.patch
fix-serial-buffer-memory-leak-fix.patch
mtdchar-build-fix.patch
fix-compilation-with-gcc-42.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
free_irq-fix-debug_shirq-handling.patch
remove-bdput-from-do_open-in-fs-block_devc-fix.patch
revert-acpi-enable-c3-even-when-pm2_control-is-zero.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
dma-arch-fix.patch
git-dma-up-fix.patch
git-dvb-fixup-2.patch
adbhid-produce-all-capslock-key-events.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
iforce-warning-fix.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
ide-arm-hack.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
git-netdev-all.patch
e1000e-build-fix.patch
revert-8139too-clean-up-i-o-remapping.patch
ax88796-printk-fixes.patch
natsemi-fix-netdev-error-acounting.patch
git-ixgbe-build-fix.patch
git-net-fixup.patch
ip_auto_config-fix.patch
fib_trie-cleanup.patch
introduce-strtol_check_range.patch
git-nfsd.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
bsg-declare-request_queue.patch
aacraid-rename-check_reset.patch
scsi-ipsc-warning-fix.patch
git-unionfs.patch
git-unionfs-build-fix.patch
git-unionfs-fix-2.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
git-wireless.patch
disable-b44-and-bcm43xx.patch
revert-x86_64-mm-pci-mmconfig-eax.patch
fix-x86_64-mm-early-quirks-unification.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
git-xfs.patch
git-kgdb-fixup.patch
fix-some-x86-x86-64-acpi-cpufreq-driver-issues.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
w1-build-fix.patch

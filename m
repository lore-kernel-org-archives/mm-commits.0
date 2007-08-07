From: akpm@linux-foundation.org
Subject: + request_firmware-skip-timeout-if-userspace-was-not-notified-fix.patch added to -mm tree
Date: Tue, 07 Aug 2007 13:05:13 -0700
Message-ID: <200708072005.l77K5Exp001507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42578 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752844AbXHGUFa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 16:05:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com, javier.pello@urjc.es


The patch titled
     request_firmware-skip-timeout-if-userspace-was-not-notified-fix
has been added to the -mm tree.  Its filename is
     request_firmware-skip-timeout-if-userspace-was-not-notified-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: request_firmware-skip-timeout-if-userspace-was-not-notified-fix
From: Andrew Morton <akpm@linux-foundation.org>

coding-style fixes

Cc: Greg KH <greg@kroah.com>
Cc: Javier Pello <javier.pello@urjc.es>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_class.c |    5 ++---
 lib/kobject_uevent.c          |   14 ++++++--------
 2 files changed, 8 insertions(+), 11 deletions(-)

diff -puN drivers/base/firmware_class.c~request_firmware-skip-timeout-if-userspace-was-not-notified-fix drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~request_firmware-skip-timeout-if-userspace-was-not-notified-fix
+++ a/drivers/base/firmware_class.c
@@ -422,11 +422,10 @@ _request_firmware(const struct firmware 
 		}
 
 		retval = kobject_uevent(&f_dev->kobj, KOBJ_ADD);
-		if (retval) {
+		if (retval)
 			fw_load_abort(fw_priv);
-		} else {
+		else
 			wait_for_completion(&fw_priv->completion);
-		}
 		set_bit(FW_STATUS_DONE, &fw_priv->status);
 		del_timer_sync(&fw_priv->timeout);
 	} else
diff -puN lib/kobject_uevent.c~request_firmware-skip-timeout-if-userspace-was-not-notified-fix lib/kobject_uevent.c
--- a/lib/kobject_uevent.c~request_firmware-skip-timeout-if-userspace-was-not-notified-fix
+++ a/lib/kobject_uevent.c
@@ -200,15 +200,13 @@ int kobject_uevent_env(struct kobject *k
 		argv [1] = (char *)subsystem;
 		argv [2] = NULL;
 #if defined(CONFIG_NET)
-		if (retval) {
-			retval = call_usermodehelper (argv[0], argv, envp,
-						UMH_WAIT_EXEC);
-		} else {
-			call_usermodehelper (argv[0], argv, envp,
-						UMH_WAIT_EXEC);
-		}
+		if (retval)
+			retval = call_usermodehelper(argv[0], argv, envp,
+							UMH_WAIT_EXEC);
+		else
+			call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
 #else
-		retval = call_usermodehelper (argv[0], argv, envp,
+		retval = call_usermodehelper(argv[0], argv, envp,
 						UMH_WAIT_EXEC);
 #endif
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

genirq-temporary-fix-for-level-triggered-irq-resend-fix.patch
fbcon-kill-compile-warning-fix.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
request_firmware-skip-timeout-if-userspace-was-not-notified-fix.patch
dma-arch-fix.patch
git-dvb-fixup-2.patch
adbhid-produce-all-capslock-key-events-fix.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
iforce-warning-fix.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
ax88796-printk-fixes.patch
natsemi-fix-netdev-error-acounting.patch
git-ixgbe-build-fix.patch
ip_auto_config-fix-fix.patch
fib_trie-cleanup-fix.patch
introduce-u16_max-and-u32_max-fix.patch
introduce-strtol_check_range-fix.patch
git-ocfs2.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
aacraid-rename-check_reset.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-unionfs-build-fix.patch
git-unionfs-fix-2.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
git-wireless.patch
merge-the-sonics-silicon-backplane-subsystem-fix.patch
ssb-chipcommon-add-function-to-get-processor-clock-fix.patch
ssb-mainc-needs-dma-mappingh.patch
revert-x86_64-mm-pci-mmconfig-eax.patch
fix-x86_64-mm-early-quirks-unification.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-xfs.patch
git-kgdb-fixup.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
fix-some-x86-x86-64-acpi-cpufreq-driver-issues.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
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

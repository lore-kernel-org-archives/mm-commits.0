From: akpm@linux-foundation.org
Subject: + printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch added to -mm tree
Date: Tue, 31 Jul 2007 11:38:26 -0700
Message-ID: <200707311838.l6VIcQKZ016444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53688 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932151AbXGaSjW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 14:39:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gerg@snapgear.com, lethal@linux-sh.org, rgetz@blackfin.uclinux.org, rmk@arm.linux.org.uk, tim.bird@am.sony.com, vapier.adi@gmail.com, vapier@gentoo.org


The patch titled
     printk-add-interfaces-for-external-access-to-the-log-buffer fix
has been added to the -mm tree.  Its filename is
     printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: printk-add-interfaces-for-external-access-to-the-log-buffer fix
From: Andrew Morton <akpm@linux-foundation.org>

- compile fix

- Race fix: oops_in_progress can change at any time

- coding-style fixlets.

Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Tim Bird <tim.bird@am.sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 +-
 kernel/printk.c        |   12 ++++++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff -puN include/linux/kernel.h~printk-add-interfaces-for-external-access-to-the-log-buffer-fix include/linux/kernel.h
--- a/include/linux/kernel.h~printk-add-interfaces-for-external-access-to-the-log-buffer-fix
+++ a/include/linux/kernel.h
@@ -168,7 +168,7 @@ static inline int printk(const char *s, 
 	__attribute__ ((format (printf, 1, 2)));
 static inline int __cold printk(const char *s, ...) { return 0; }
 static inline int log_buf_get_len(void) { return 0; }
-static inline int log_buf_read(int idx); { return 0; }
+static inline int log_buf_read(int idx) { return 0; }
 static inline int log_buf_copy(char *dest, int idx, int len) { return 0; }
 #endif
 
diff -puN kernel/printk.c~printk-add-interfaces-for-external-access-to-the-log-buffer-fix kernel/printk.c
--- a/kernel/printk.c~printk-add-interfaces-for-external-access-to-the-log-buffer-fix
+++ a/kernel/printk.c
@@ -233,14 +233,17 @@ int log_buf_get_len(void)
 int log_buf_copy(char *dest, int idx, int len)
 {
 	int ret, max;
+	bool took_lock = false;
 
-	if (!oops_in_progress)
+	if (!oops_in_progress) {
 		spin_lock_irq(&logbuf_lock);
+		took_lock = true;
+	}
 
 	max = log_buf_get_len();
-	if (idx < 0 || idx >= max)
+	if (idx < 0 || idx >= max) {
 		ret = -1;
-	else {
+	} else {
 		if (len > max)
 			len = max;
 		ret = len;
@@ -250,7 +253,7 @@ int log_buf_copy(char *dest, int idx, in
 		}
 	}
 
-	if (!oops_in_progress)
+	if (took_lock)
 		spin_unlock_irq(&logbuf_lock);
 
 	return ret;
@@ -262,6 +265,7 @@ int log_buf_copy(char *dest, int idx, in
 int log_buf_read(int idx)
 {
 	char ret;
+
 	if (log_buf_copy(&ret, idx, 1) == 1)
 		return ret;
 	else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
parport_pc-locking-fix.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
kdebugh-forward-declare-struct-struct-notifier_block.patch
fs-9p-convc-error-path-fix.patch
ip2main-warning-fix.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
git-acpi-mark_tsc_unstable-build-fix.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
dma-arch-fix.patch
git-dvb.patch
git-dvb-fixup.patch
git-hwmon.patch
adbhid-produce-all-capslock-key-events-fix.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
iforce-warning-fix.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
fix-ide-ide-add-ide-set-pio-take3.patch
fix-ide-ide-add-platform-ide-driver.patch
git-mmc-build-fix.patch
git-mmc-build-fix-2.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
ax88796-printk-fixes.patch
ip_auto_config-fix-fix.patch
fib_trie-cleanup-fix.patch
git-ocfs2.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
aacraid-rename-check_reset.patch
git-block-fixup.patch
git-block-fix-headers_check.patch
sparc64-add-missing-dma_get_cache_alignment.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-unionfs-build-fix.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
git-watchdog.patch
merge-the-sonics-silicon-backplane-subsystem-fix.patch
revert-x86_64-mm-pci-mmconfig-eax.patch
fix-x86_64-mm-early-quirks-unification.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-newsetup-fixup.patch
git-kgdb-fixup.patch
git-kgdb-arm-fix.patch
git-kgdb-mips-fix.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
acpi_battery_add-use-after-free.patch
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
tpm_tis-debug.patch
w1-build-fix.patch

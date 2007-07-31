From: akpm@linux-foundation.org
Subject: + vm-dont-run-touch_buffer-during-buffercache-lookups.patch added to -mm tree
Date: Tue, 31 Jul 2007 11:28:39 -0700
Message-ID: <200707311828.l6VISfgX016091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55598 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755085AbXGaS2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 14:28:51 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l6VISls5028138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2007 11:28:48 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     VM: don't run touch_buffer() during buffercache lookups
has been added to the -mm tree.  Its filename is
     vm-dont-run-touch_buffer-during-buffercache-lookups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: VM: don't run touch_buffer() during buffercache lookups
From: Andrew Morton <akpm@linux-foundation.org>

When userspace reads a directory or a number of inodes it is very common for
the filesystem to be asked to access the same metadata block multiple times in
quick succession.  Each lookup will run touch_buffer().

As a consequence of this, large amounts of blockdev pagecache end up nailed on
the VM's active list, marked as referenced.  These pages will cause other
active pages to be evicted: mapped executables, swapout, etc.

This is probably wrong.  The core problem here is that the kernel is treating
that sudden burst of accesses to the dirents and inodes as multiple touches. 
Really we should be treating them as a single touch.

So as an experiment, just remove that touch_buffer() call.

We don't have any tests to determine the effects of this, and nobody will
bother setting one up, so ho hum, this remains in -mm for ever.


This change is probably a bit too aggressive - as a followup, filesystems
should be taught to run touch_buffer() or mark_page_accessed() against this
pagecache on each "independent" access.

The problem is, how to determine when they are "independent"?  Perhaps "the
access was to the first inode in the block" and "the access was to the first
directory entry in the block" would suffice.  The fs could then implement
use-once via:

	if (first inode in block) {
		page = find_get_page(...);
		if (page)
			mark_page_accessed(page);
		put_page(page);
	}

I don't think there's any point in doing this until we have some decent
testcases.

AFACIT ext2 has never run mark_page_accessed() against its directory
pagecache, so there is no practical way in which ext2 directories _ever_ find
their way onto the inactive list.  Nobody appears to have noticed this.

touch_buffer() is unused after this patch, but let's retain it for the above
reasons.  I guess we'll need a new probe_buffer() thing to be able to
implement the above use-once algorithm for bh-based metadata.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN fs/buffer.c~vm-dont-run-touch_buffer-during-buffercache-lookups fs/buffer.c
--- a/fs/buffer.c~vm-dont-run-touch_buffer-during-buffercache-lookups
+++ a/fs/buffer.c
@@ -1337,8 +1337,6 @@ __find_get_block(struct block_device *bd
 		if (bh)
 			bh_lru_install(bh);
 	}
-	if (bh)
-		touch_buffer(bh);
 	return bh;
 }
 EXPORT_SYMBOL(__find_get_block);
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

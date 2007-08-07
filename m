From: akpm@linux-foundation.org
Subject: + remove-bdput-from-do_open-in-fs-block_devc-fix.patch added to -mm tree
Date: Tue, 07 Aug 2007 15:24:47 -0700
Message-ID: <200708072224.l77MOlN0008013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60772 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757251AbXHGWZE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 18:25:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hch@lst.de, rafalbilski@interia.pl, viro@zeniv.linux.org.uk


The patch titled
     remove-bdput-from-do_open-in-fs-block_devc-fix
has been added to the -mm tree.  Its filename is
     remove-bdput-from-do_open-in-fs-block_devc-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: remove-bdput-from-do_open-in-fs-block_devc-fix
=46rom: Andrew Morton <akpm@linux-foundation.org>

=46ix up blkdev_open() error-path refcounting.

Cc: Rafa=B3 Bilski <rafalbilski@interia.pl>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/block_dev.c~remove-bdput-from-do_open-in-fs-block_devc-fix=
 fs/block_dev.c
--- a/fs/block_dev.c~remove-bdput-from-do_open-in-fs-block_devc-fix
+++ a/fs/block_dev.c
@@ -1246,8 +1246,10 @@ static int blkdev_open(struct inode * in
 		return -ENOMEM;
=20
 	res =3D do_open(bdev, filp, 0);
-	if (res)
+	if (res) {
+		bdput(bdev);
 		return res;
+	}
=20
 	if (!(filp->f_flags & O_EXCL) )
 		return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

genirq-temporary-fix-for-level-triggered-irq-resend-fix.patch
fbcon-kill-compile-warning-fix.patch
remove-bdput-from-do_open-in-fs-block_devc-fix.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
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
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.pat=
ch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
pci-remove-irritating-try-pci=3Dassign-busses-warning.patch
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
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fi=
x.patch
fix-some-x86-x86-64-acpi-cpufreq-driver-issues.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-t=
he-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix=
=2Epatch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix=
-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_or=
der_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuf=
f.patch
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
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.pat=
ch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.p=
atch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.p=
atch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.p=
atch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.p=
atch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.p=
atch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.p=
atch
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
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patc=
h
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
w1-build-fix.patch

From: akpm@linux-foundation.org
Subject: + 64-bit-i_version-afs-fixes.patch added to -mm tree
Date: Tue, 24 Jul 2007 02:24:07 -0700
Message-ID: <200707240928.l6O9SehT006417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51690 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761632AbXGXJaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 05:30:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dhowells@redhat.com, jean-noel.cordenner@bull.net, tytso@mit.edu


The patch titled
     64-bit i_version: afs fixes
has been added to the -mm tree.  Its filename is
     64-bit-i_version-afs-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 64-bit i_version: afs fixes
From: Andrew Morton <akpm@linux-foundation.org>

Please grep the whole tree and look for any similar bugs which this patch
introduces.

Cc: Jean Noel Cordenner <jean-noel.cordenner@bull.net>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/dir.c   |    9 +++++----
 fs/afs/inode.c |    3 ++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff -puN fs/afs/dir.c~64-bit-i_version-afs-fixes fs/afs/dir.c
--- a/fs/afs/dir.c~64-bit-i_version-afs-fixes
+++ a/fs/afs/dir.c
@@ -546,11 +546,11 @@ static struct dentry *afs_lookup(struct 
 	dentry->d_op = &afs_fs_dentry_operations;
 
 	d_add(dentry, inode);
-	_leave(" = 0 { vn=%u u=%u } -> { ino=%lu v=%lu }",
+	_leave(" = 0 { vn=%u u=%u } -> { ino=%lu v=%llu }",
 	       fid.vnode,
 	       fid.unique,
 	       dentry->d_inode->i_ino,
-	       dentry->d_inode->i_version);
+	       (unsigned long long)dentry->d_inode->i_version);
 
 	return NULL;
 }
@@ -630,9 +630,10 @@ static int afs_d_revalidate(struct dentr
 		 * been deleted and replaced, and the original vnode ID has
 		 * been reused */
 		if (fid.unique != vnode->fid.unique) {
-			_debug("%s: file deleted (uq %u -> %u I:%lu)",
+			_debug("%s: file deleted (uq %u -> %u I:%llu)",
 			       dentry->d_name.name, fid.unique,
-			       vnode->fid.unique, dentry->d_inode->i_version);
+			       vnode->fid.unique,
+			       (unsigned long long)dentry->d_inode->i_version);
 			spin_lock(&vnode->lock);
 			set_bit(AFS_VNODE_DELETED, &vnode->flags);
 			spin_unlock(&vnode->lock);
diff -puN fs/afs/inode.c~64-bit-i_version-afs-fixes fs/afs/inode.c
--- a/fs/afs/inode.c~64-bit-i_version-afs-fixes
+++ a/fs/afs/inode.c
@@ -301,7 +301,8 @@ int afs_getattr(struct vfsmount *mnt, st
 
 	inode = dentry->d_inode;
 
-	_enter("{ ino=%lu v=%lu }", inode->i_ino, inode->i_version);
+	_enter("{ ino=%lu v=%llu }", inode->i_ino,
+		(unsigned long long)inode->i_version);
 
 	generic_fillattr(inode, stat);
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86_powernow_k8_acpi-must-depend-on-acpi.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism-fix.patch
git-alsa.patch
git-alsa-fixup.patch
git-alsa-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
adbhid-produce-all-capslock-key-events-fix.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
fix-ide-ide-add-ide-set-pio-take3.patch
mmc-build-fix.patch
git-mtd.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
ip_auto_config-fix-fix.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
aacraid-rename-check_reset.patch
git-scsi-target-fixup.patch
git-unionfs.patch
git-watchdog-typo.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-newsetup-fixup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
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
fs-9p-convc-error-path-fix.patch
loop-use-unlocked_ioctl.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch

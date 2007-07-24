From: akpm@linux-foundation.org
Subject: + ecryptfs-printk-warning-fixes.patch added to -mm tree
Date: Tue, 24 Jul 2007 02:32:56 -0700
Message-ID: <200707240937.l6O9bTcx006713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48340 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760384AbXGXJho (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 05:37:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mhalcrow@us.ibm.com


The patch titled
     ecryptfs: printk warning fixes
has been added to the -mm tree.  Its filename is
     ecryptfs-printk-warning-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ecryptfs: printk warning fixes
From: Andrew Morton <akpm@linux-foundation.org>

fs/ecryptfs/keystore.c: In function 'parse_tag_1_packet':
fs/ecryptfs/keystore.c:557: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
fs/ecryptfs/keystore.c: In function 'parse_tag_3_packet':
fs/ecryptfs/keystore.c:690: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
fs/ecryptfs/keystore.c: In function 'parse_tag_11_packet':
fs/ecryptfs/keystore.c:836: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
fs/ecryptfs/keystore.c: In function 'write_tag_1_packet':
fs/ecryptfs/keystore.c:1413: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
fs/ecryptfs/keystore.c:1413: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
fs/ecryptfs/keystore.c: In function 'write_tag_11_packet':
fs/ecryptfs/keystore.c:1472: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
fs/ecryptfs/keystore.c: In function 'write_tag_3_packet':
fs/ecryptfs/keystore.c:1663: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
fs/ecryptfs/keystore.c:1663: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
fs/ecryptfs/keystore.c: In function 'ecryptfs_generate_key_packet_set':
fs/ecryptfs/keystore.c:1778: warning: passing argument 2 of 'write_tag_11_packet' from incompatible pointer type
fs/ecryptfs/main.c: In function 'ecryptfs_parse_options':
fs/ecryptfs/main.c:363: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'

Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/keystore.c |   16 ++++++++--------
 fs/ecryptfs/main.c     |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/ecryptfs/keystore.c~ecryptfs-printk-warning-fixes fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-printk-warning-fixes
+++ a/fs/ecryptfs/keystore.c
@@ -554,7 +554,7 @@ parse_tag_1_packet(struct ecryptfs_crypt
 		goto out_free;
 	}
 	if (unlikely(body_size < (ECRYPTFS_SIG_SIZE + 2))) {
-		printk(KERN_WARNING "Invalid body size ([%d])\n", body_size);
+		printk(KERN_WARNING "Invalid body size ([%td])\n", body_size);
 		rc = -EINVAL;
 		goto out_free;
 	}
@@ -687,7 +687,7 @@ parse_tag_3_packet(struct ecryptfs_crypt
 		goto out_free;
 	}
 	if (unlikely(body_size < (ECRYPTFS_SALT_SIZE + 5))) {
-		printk(KERN_WARNING "Invalid body size ([%d])\n", body_size);
+		printk(KERN_WARNING "Invalid body size ([%td])\n", body_size);
 		rc = -EINVAL;
 		goto out_free;
 	}
@@ -833,7 +833,7 @@ parse_tag_11_packet(unsigned char *data,
 		goto out;
 	}
 	if (body_size < 14) {
-		printk(KERN_WARNING "Invalid body size ([%d])\n", body_size);
+		printk(KERN_WARNING "Invalid body size ([%td])\n", body_size);
 		rc = -EINVAL;
 		goto out;
 	}
@@ -1409,7 +1409,7 @@ encrypted_session_key_set:
 			   + key_rec->enc_key_size); /* Encrypted key size */
 	if (max_packet_size > (*remaining_bytes)) {
 		printk(KERN_ERR "Packet length larger than maximum allowable; "
-		       "need up to [%d] bytes, but there are only [%d] "
+		       "need up to [%td] bytes, but there are only [%td] "
 		       "available\n", max_packet_size, (*remaining_bytes));
 		rc = -EINVAL;
 		goto out;
@@ -1449,7 +1449,7 @@ out:
  * Returns zero on success; non-zero on error.
  */
 static int
-write_tag_11_packet(char *dest, int *remaining_bytes, char *contents,
+write_tag_11_packet(char *dest, size_t *remaining_bytes, char *contents,
 		    size_t contents_length, size_t *packet_length)
 {
 	size_t packet_size_length;
@@ -1468,7 +1468,7 @@ write_tag_11_packet(char *dest, int *rem
 			   + contents_length); /* Literal data */
 	if (max_packet_size > (*remaining_bytes)) {
 		printk(KERN_ERR "Packet length larger than maximum allowable; "
-		       "need up to [%d] bytes, but there are only [%d] "
+		       "need up to [%td] bytes, but there are only [%td] "
 		       "available\n", max_packet_size, (*remaining_bytes));
 		rc = -EINVAL;
 		goto out;
@@ -1658,8 +1658,8 @@ encrypted_session_key_set:
 			   + 1                       /* Hash iterations */
 			   + key_rec->enc_key_size); /* Encrypted key size */
 	if (max_packet_size > (*remaining_bytes)) {
-		printk(KERN_ERR "Packet too large; need up to [%d] bytes, but "
-		       "there are only [%d] available\n", max_packet_size,
+		printk(KERN_ERR "Packet too large; need up to [%td] bytes, but "
+		       "there are only [%td] available\n", max_packet_size,
 		       (*remaining_bytes));
 		rc = -EINVAL;
 		goto out;
diff -puN fs/ecryptfs/main.c~ecryptfs-printk-warning-fixes fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-printk-warning-fixes
+++ a/fs/ecryptfs/main.c
@@ -358,7 +358,7 @@ static int ecryptfs_parse_options(struct
 		     NULL, mount_crypt_stat->global_default_cipher_name,
 		     mount_crypt_stat->global_default_cipher_key_size))) {
 		printk(KERN_ERR "Error attempting to initialize cipher with "
-		       "name = [%s] and key size = [%d]; rc = [%d]\n",
+		       "name = [%s] and key size = [%td]; rc = [%d]\n",
 		       mount_crypt_stat->global_default_cipher_name,
 		       mount_crypt_stat->global_default_cipher_key_size, rc);
 		rc = -EINVAL;
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
ecryptfs-printk-warning-fixes.patch
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

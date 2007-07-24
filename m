From: akpm@linux-foundation.org
Subject: + readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch added to -mm tree
Date: Mon, 23 Jul 2007 21:19:43 -0700
Message-ID: <200707240419.l6O4JhoX027834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55125 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361AbXGXEUr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 00:20:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, peterz@infradead.org, rusty@rustcorp.com.au, wfg@mail.ustc.edu.cn


The patch titled
     readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2
has been added to the -mm tree.  Its filename is
     readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/dir.c |    2 +-
 fs/ext4/dir.c |    2 +-
 fs/splice.c   |    2 +-
 mm/filemap.c  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ext3/dir.c~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2 fs/ext3/dir.c
--- a/fs/ext3/dir.c~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2
+++ a/fs/ext3/dir.c
@@ -143,7 +143,7 @@ static int ext3_readdir(struct file * fi
 					sb->s_bdev->bd_inode->i_mapping,
 					&filp->f_ra, filp,
 					index, 1);
-			filp->f_ra.prev_pos = index << PAGE_CACHE_SHIFT;
+			filp->f_ra.prev_pos = (loff_t)index << PAGE_CACHE_SHIFT;
 			bh = ext3_bread(NULL, inode, blk, 0, &err);
 		}
 
diff -puN fs/ext4/dir.c~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2 fs/ext4/dir.c
--- a/fs/ext4/dir.c~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2
+++ a/fs/ext4/dir.c
@@ -142,7 +142,7 @@ static int ext4_readdir(struct file * fi
 					sb->s_bdev->bd_inode->i_mapping,
 					&filp->f_ra, filp,
 					index, 1);
-			filp->f_ra.prev_pos = index << PAGE_CACHE_SHIFT;
+			filp->f_ra.prev_pos = (loff_t)index << PAGE_CACHE_SHIFT;
 			bh = ext4_bread(NULL, inode, blk, 0, &err);
 		}
 
diff -puN fs/splice.c~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2 fs/splice.c
--- a/fs/splice.c~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2
+++ a/fs/splice.c
@@ -454,7 +454,7 @@ fill_it:
 	 */
 	while (page_nr < nr_pages)
 		page_cache_release(pages[page_nr++]);
-	in->f_ra.prev_pos = index << PAGE_CACHE_SHIFT;
+	in->f_ra.prev_pos = (loff_t)index << PAGE_CACHE_SHIFT;
 
 	if (spd.nr_pages)
 		return splice_to_pipe(pipe, &spd);
diff -puN mm/filemap.c~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2 mm/filemap.c
--- a/mm/filemap.c~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2
+++ a/mm/filemap.c
@@ -1059,7 +1059,7 @@ out:
 	_ra->prev_pos <<= PAGE_CACHE_SHIFT;
 	_ra->prev_pos |= prev_offset;
 
-	*ppos = ((loff_t) index << PAGE_CACHE_SHIFT) + offset;
+	*ppos = ((loff_t)index << PAGE_CACHE_SHIFT) + offset;
 	if (cached_page)
 		page_cache_release(cached_page);
 	if (filp)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86_powernow_k8_acpi-must-depend-on-acpi.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
git-dvb.patch
adbhid-produce-all-capslock-key-events-fix.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
git-mtd.patch
mtd-potential-leak-in-rfd_ftl_add_mtd-fix.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
ip_auto_config-fix-fix.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
aacraid-rename-check_reset.patch
git-unionfs.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-xfs.patch
git-xfs-fixup.patch
git-kgdb-fixup-2.patch
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
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
fs-9p-convc-error-path-fix.patch
loop-use-unlocked_ioctl.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
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

From: akpm@linux-foundation.org
Subject: + git-xfs-fixup.patch added to -mm tree
Date: Mon, 23 Jul 2007 22:57:58 -0700
Message-ID: <200707240557.l6O5vwWN031140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44684 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752077AbXGXF6K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 01:58:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dgc@sgi.com, tes@sgi.com


The patch titled
     git-xfs-fixup
has been added to the -mm tree.  Its filename is
     git-xfs-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-xfs-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Fix conflicts between git-xfs and mainline.

Cc: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   49 ----------------------------------
 fs/xfs/linux-2.6/xfs_file.c |   10 ------
 2 files changed, 59 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_file.c~git-xfs-fixup fs/xfs/linux-2.6/xfs_file.c
--- a/fs/xfs/linux-2.6/xfs_file.c~git-xfs-fixup
+++ a/fs/xfs/linux-2.6/xfs_file.c
@@ -478,26 +478,16 @@ const struct file_operations xfs_dir_fil
 };
 
 static struct vm_operations_struct xfs_file_vm_ops = {
-<<<<<<< HEAD/fs/xfs/linux-2.6/xfs_file.c
 	.fault		= filemap_fault,
 	.page_mkwrite	= xfs_vm_page_mkwrite,
-=======
-	.nopage		= filemap_nopage,
 	.populate	= filemap_populate,
-	.page_mkwrite	= xfs_vm_page_mkwrite,
->>>>>>> /fs/xfs/linux-2.6/xfs_file.c
 };
 
 #ifdef CONFIG_XFS_DMAPI
 static struct vm_operations_struct xfs_dmapi_file_vm_ops = {
-<<<<<<< HEAD/fs/xfs/linux-2.6/xfs_file.c
 	.fault		= xfs_vm_fault,
 	.page_mkwrite	= xfs_vm_page_mkwrite,
-=======
-	.nopage		= xfs_vm_nopage,
 	.populate	= filemap_populate,
-	.page_mkwrite	= xfs_vm_page_mkwrite,
->>>>>>> /fs/xfs/linux-2.6/xfs_file.c
 #ifdef HAVE_VMOP_MPROTECT
 	.mprotect	= xfs_vm_mprotect,
 #endif
diff -puN fs/buffer.c~git-xfs-fixup fs/buffer.c
--- a/fs/buffer.c~git-xfs-fixup
+++ a/fs/buffer.c
@@ -2194,7 +2194,6 @@ int generic_commit_write(struct file *fi
 	return 0;
 }
 
-<<<<<<< HEAD/fs/buffer.c
 /*
  * block_page_mkwrite() is not allowed to change the file size as it gets
  * called from a page fault handler when a page is first dirtied. Hence we must
@@ -2241,54 +2240,6 @@ out_unlock:
 	unlock_page(page);
 	return ret;
 }
-=======
-/*
- * block_page_mkwrite() is not allowed to change the file size as it gets
- * called from a page fault handler when a page is first dirtied. Hence we must
- * be careful to check for EOF conditions here. We set the page up correctly
- * for a written page which means we get ENOSPC checking when writing into
- * holes and correct delalloc and unwritten extent mapping on filesystems that
- * support these features.
- *
- * We are not allowed to take the i_mutex here so we have to play games to
- * protect against truncate races as the page could now be beyond EOF.  Because
- * vmtruncate() writes the inode size before removing pages, once we have the
- * page lock we can determine safely if the page is beyond EOF. If it is not
- * beyond EOF, then the page is guaranteed safe against truncation until we
- * unlock the page.
- */
-int
-block_page_mkwrite(struct vm_area_struct *vma, struct page *page,
-		   get_block_t get_block)
-{
-	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
-	unsigned long end;
-	loff_t size;
-	int ret = -EINVAL;
-
-	lock_page(page);
-	size = i_size_read(inode);
-	if ((page->mapping != inode->i_mapping) ||
-	    ((page->index << PAGE_CACHE_SHIFT) > size)) {
-		/* page got truncated out from underneath us */
-		goto out_unlock;
-	}
-
-	/* page is wholly or partially inside EOF */
-	if (((page->index + 1) << PAGE_CACHE_SHIFT) > size)
-		end = size & ~PAGE_CACHE_MASK;
-	else
-		end = PAGE_CACHE_SIZE;
-
-	ret = block_prepare_write(page, 0, end, get_block);
-	if (!ret)
-		ret = block_commit_write(page, 0, end);
-
-out_unlock:
-	unlock_page(page);
-	return ret;
-}
->>>>>>> /fs/buffer.c
 
 /*
  * nobh_prepare_write()'s prereads are special: the buffer_heads are freed
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86_powernow_k8_acpi-must-depend-on-acpi.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism-fix.patch
git-alsa.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
adbhid-produce-all-capslock-key-events-fix.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
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
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-newsetup-fixup.patch
git-xfs.patch
git-xfs-fixup.patch
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

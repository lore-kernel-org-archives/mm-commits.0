From: akpm@linux-foundation.org
Subject: + reiser4-tree_lock-fixes-fix.patch added to -mm tree
Date: Mon, 09 Jun 2008 14:08:21 -0700
Message-ID: <200806092119.m59LJwTh008831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753353AbYFIVUt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 17:20:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, nickpiggin@yahoo.com.au


The patch titled
     reiser4-tree_lock-fixes-fix
has been added to the -mm tree.  Its filename is
     reiser4-tree_lock-fixes-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4-tree_lock-fixes-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/cryptcompress.c |    8 +++----
 fs/reiser4/plugin/file/file.c          |   24 +++++++++++------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-tree_lock-fixes-fix fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-tree_lock-fixes-fix
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -3435,7 +3435,7 @@ static int find_anon_page_cluster(struct
 {
 	int i = 0;
 	int found;
-	write_lock_irq(&mapping->tree_lock);
+	spin_lock_irq(&mapping->tree_lock);
 	do {
 		/* looking for one page */
 		found = radix_tree_gang_lookup_tag(&mapping->page_tree,
@@ -3457,7 +3457,7 @@ static int find_anon_page_cluster(struct
 		if (last_page_in_cluster(pages[i++]))
 			break;
 	} while (1);
-	write_unlock_irq(&mapping->tree_lock);
+	spin_unlock_irq(&mapping->tree_lock);
 	return i;
 }
 
@@ -3532,10 +3532,10 @@ static int capture_anon_pages(struct add
 static int cryptcompress_inode_has_anon_pages(struct inode *inode)
 {
 	int result;
-	read_lock_irq(&inode->i_mapping->tree_lock);
+	spin_lock_irq(&inode->i_mapping->tree_lock);
 	result = radix_tree_tagged(&inode->i_mapping->page_tree,
 				   PAGECACHE_TAG_REISER4_MOVED);
-	read_unlock_irq(&inode->i_mapping->tree_lock);
+	spin_unlock_irq(&inode->i_mapping->tree_lock);
 	return result;
 }
 
diff -puN fs/reiser4/plugin/file/file.c~reiser4-tree_lock-fixes-fix fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-tree_lock-fixes-fix
+++ a/fs/reiser4/plugin/file/file.c
@@ -848,9 +848,9 @@ static int has_anonymous_pages(struct in
 {
 	int result;
 
-	read_lock_irq(&inode->i_mapping->tree_lock);
+	spin_lock_irq(&inode->i_mapping->tree_lock);
 	result = radix_tree_tagged(&inode->i_mapping->page_tree, PAGECACHE_TAG_REISER4_MOVED);
-	read_unlock_irq(&inode->i_mapping->tree_lock);
+	spin_unlock_irq(&inode->i_mapping->tree_lock);
 	return result;
 }
 
@@ -994,7 +994,7 @@ capture_anonymous_pages(struct address_s
 	nr = 0;
 
 	/* find pages tagged MOVED */
-	write_lock_irq(&mapping->tree_lock);
+	spin_lock_irq(&mapping->tree_lock);
 	pvec.nr = radix_tree_gang_lookup_tag(&mapping->page_tree,
 					     (void **)pvec.pages, *index, count,
 					     PAGECACHE_TAG_REISER4_MOVED);
@@ -1014,7 +1014,7 @@ capture_anonymous_pages(struct address_s
 		radix_tree_tag_clear(&mapping->page_tree, pvec.pages[i]->index,
 				     PAGECACHE_TAG_REISER4_MOVED);
 	}
-	write_unlock_irq(&mapping->tree_lock);
+	spin_unlock_irq(&mapping->tree_lock);
 
 
 	*index = pvec.pages[i - 1]->index + 1;
@@ -1039,13 +1039,13 @@ capture_anonymous_pages(struct address_s
 				 * set MOVED tag to all pages which left not
 				 * captured
 				 */
-				write_lock_irq(&mapping->tree_lock);
+				spin_lock_irq(&mapping->tree_lock);
 				for (; i < pagevec_count(&pvec); i ++) {
 					radix_tree_tag_set(&mapping->page_tree,
 							   pvec.pages[i]->index,
 							   PAGECACHE_TAG_REISER4_MOVED);
 				}
-				write_unlock_irq(&mapping->tree_lock);
+				spin_unlock_irq(&mapping->tree_lock);
 
 				pagevec_release(&pvec);
 				return result;
@@ -1055,11 +1055,11 @@ capture_anonymous_pages(struct address_s
 				 * 0 for Writeback-ed page. Set MOVED tag on
 				 * that page
 				 */
-				write_lock_irq(&mapping->tree_lock);
+				spin_lock_irq(&mapping->tree_lock);
 				radix_tree_tag_set(&mapping->page_tree,
 						   pvec.pages[i]->index,
 						   PAGECACHE_TAG_REISER4_MOVED);
-				write_unlock_irq(&mapping->tree_lock);
+				spin_unlock_irq(&mapping->tree_lock);
 				if (i == 0)
 					*index = pvec.pages[0]->index;
 				else
@@ -1135,7 +1135,7 @@ static int sync_page_list(struct inode *
 	mapping = inode->i_mapping;
 	from = 0;
 	result = 0;
-	read_lock_irq(&mapping->tree_lock);
+	spin_lock_irq(&mapping->tree_lock);
 	while (result == 0) {
 		struct page *page;
 
@@ -1150,17 +1150,17 @@ static int sync_page_list(struct inode *
 		 * truncating by inode->i_mutex locked by sys_fsync
 		 */
 		page_cache_get(page);
-		read_unlock_irq(&mapping->tree_lock);
+		spin_unlock_irq(&mapping->tree_lock);
 
 		from = page->index + 1;
 
 		result = sync_page(page);
 
 		page_cache_release(page);
-		read_lock_irq(&mapping->tree_lock);
+		spin_lock_irq(&mapping->tree_lock);
 	}
 
-	read_unlock_irq(&mapping->tree_lock);
+	spin_unlock_irq(&mapping->tree_lock);
 	return result;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
m68k-add-ext2_find_firstnext_bit-for-ext4-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
drivers-net-wireless-iwlwifi-iwl-4965-rsc-config_iwl4965_ht=n-hack.patch
kvm-unbork.patch
kvm-is-busted-on-ia64.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
lguest-use-cpu-capability-accessors.patch
intel-agp-rewrite-gtt-on-resume.patch
intel-agp-rewrite-gtt-on-resume-update-checkpatch-fixes.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2.patch
arch-powerpc-platforms-pseries-eeh_driverc-fix-warning.patch
arch-powerpc-platforms-pseries-eeh_driverc-fix-warning-checkpatch-fixes.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
git-leds.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
drivers-mtd-devices-block2mtdc-suppress-warning.patch
bluetooth-hci_bcspc-small-cleanups-api-users-fix.patch
sundance-set-carrier-status-on-link-change-events.patch
net-sh_eth-add-support-for-renesas-superh-ethernet-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
pci-introduce-pci_slot.patch
acpi-pci-slot-detection-driver.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
pktcdvd-push-bkl-down-into-driver-fix.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues-fix.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues-fix-2.patch
watchdog-pcwd-clean-up-unlocked_ioctl-usage-fix.patch
watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl-fix.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
spufs-use-the-new-vm_ops-access-fix.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
mapping_set_error-add-unlikely.patch
huge-page-private-reservation-review-cleanups-fix.patch
sync_file_range_write-may-and-will-block-document-that-fix.patch
vmallocinfo-add-numa-information-fix.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlb-override-default-huge-page-size-ia64-build.patch
bootmem-add-debugging-framework-fix.patch
bootmem-clean-up-free_all_bootmem_core-fix.patch
bootmem-free-reserve-helpers-fix.patch
bootmem-factor-out-the-marking-of-a-pfn-range-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
build-kernel-profileo-only-when-requested-cleanups.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha.patch
cputopology-always-define-cpu-topology-information-cleanup.patch
oprofile-multiplexing-checkpatch-fixes.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch
pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way-fix.patch
pnp-convert-resource-options-to-single-linked-list-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
ext3-abort-ext3-if-the-journal-has-aborted-warning-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction-cleanup.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
tpm-increase-size-of-internal-tpm-response-buffers-checkpatch-fixes.patch
memstick-allow-set_param-method-to-return-an-error-code-checkpatch-fixes.patch
revert-linux-next-changes-to-make-memstick-use-fully-asynchronous-request-processing-apply.patch
memstick-use-fully-asynchronous-request-processing-fix.patch
revert-revert-linux-next-changes-to-make-memstick-use-fully-asynchronous-request-processing-apply.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch


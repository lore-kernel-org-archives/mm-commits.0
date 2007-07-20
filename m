From: akpm@linux-foundation.org
Subject: - git-selinux-fixup.patch removed from -mm tree
Date: Fri, 20 Jul 2007 12:25:12 -0700
Message-ID: <200707201925.l6KJPCJG012308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35181 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759103AbXGTTZU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 15:25:20 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l6KJPIqG028802
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 20 Jul 2007 12:25:19 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-selinux-fixup
has been removed from the -mm tree.  Its filename was
     git-selinux-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-selinux-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/netlabel.h       |    9 +--------
 net/netlabel/netlabel_kapi.c |   23 -----------------------
 2 files changed, 1 insertion(+), 31 deletions(-)

diff -puN include/net/netlabel.h~git-selinux-fixup include/net/netlabel.h
--- a/include/net/netlabel.h~git-selinux-fixup
+++ a/include/net/netlabel.h
@@ -343,12 +343,6 @@ static inline int netlbl_secattr_catmap_
 {
 	return 0;
 }
-<<<<<<< HEAD/include/net/netlabel.h
-static inline int netlbl_enabled(void)
-{
-	return 0;
-}
-=======
 #endif
 
 /*
@@ -365,12 +359,11 @@ int netlbl_skbuff_getattr(const struct s
 			  struct netlbl_lsm_secattr *secattr);
 void netlbl_skbuff_err(struct sk_buff *skb, int error);
 #else
-int netlbl_enabled(void)
+static inline int netlbl_enabled(void)
 {
 	return 0;
 }
 
->>>>>>> /include/net/netlabel.h
 static inline int netlbl_sock_setattr(struct sock *sk,
 				     const struct netlbl_lsm_secattr *secattr)
 {
diff -puN net/netlabel/netlabel_kapi.c~git-selinux-fixup net/netlabel/netlabel_kapi.c
--- a/net/netlabel/netlabel_kapi.c~git-selinux-fixup
+++ a/net/netlabel/netlabel_kapi.c
@@ -246,7 +246,6 @@ int netlbl_secattr_catmap_setrng(struct 
  */
 
 /**
-<<<<<<< HEAD/net/netlabel/netlabel_kapi.c
  * netlbl_enabled - Determine if the NetLabel subsystem is enabled
  *
  * Description:
@@ -267,28 +266,6 @@ int netlbl_enabled(void)
 }
 
 /**
-=======
- * netlbl_enabled - Determine if the NetLabel subsystem is enabled
- *
- * Description:
- * The LSM can use this function to determine if it should use NetLabel
- * security attributes in it's enforcement mechanism.  Currently, NetLabel is
- * considered to be enabled when it's configuration contains a valid setup for
- * at least one labeled protocol (i.e. NetLabel can understand incoming
- * labeled packets of at least one type); otherwise NetLabel is considered to
- * be disabled.
- *
- */
-int netlbl_enabled(void)
-{
-	/* At some point we probably want to expose this mechanism to the
-	 * user as well so that admins can toggle NetLabel regardless of
-	 * the configuration */
-	return (netlbl_mgmt_protocount_value() > 0 ? 1 : 0);
-}
-
-/**
->>>>>>> /net/netlabel/netlabel_kapi.c
  * netlbl_socket_setattr - Label a socket using the correct protocol
  * @sk: the socket to label
  * @secattr: the security attributes
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
git-acpi-fix-git-rejects.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
git-dvb.patch
adbhid-produce-all-capslock-key-events-fix.patch
git-kvm.patch
git-leds.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
git-mtd.patch
mtd-potential-leak-in-rfd_ftl_add_mtd-fix.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
git-selinux-fixup.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
git-scsi-misc.patch
aacraid-rename-check_reset.patch
git-block-fix.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
x86_64-clean-up-apicid_to_node-declaration.patch
clockevents-fix-resume-logic-xen-fix.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-xfs.patch
git-xfs-fixup.patch
git-kgdb-fixup-2.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
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
containersv10-basic-container-framework-fix.patch
containersv10-basic-container-framework-fix-2.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch

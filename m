From: akpm@linux-foundation.org
Subject: + add-kernel-notifierc-fix.patch added to -mm tree
Date: Thu, 19 Jul 2007 14:49:13 -0700
Message-ID: <200707192149.l6JLnDlf024832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47880 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762331AbXGSVt4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 17:49:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adobriyan@sw.ru


The patch titled
     add-kernel-notifierc-fix
has been added to the -mm tree.  Its filename is
     add-kernel-notifierc-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add-kernel-notifierc-fix
From: Andrew Morton <akpm@linux-foundation.org>

Might as well fix all the checkpatch warnigns while we're there.

Cc: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/notifier.c |   21 +++------------------
 1 files changed, 3 insertions(+), 18 deletions(-)

diff -puN kernel/notifier.c~add-kernel-notifierc-fix kernel/notifier.c
--- a/kernel/notifier.c~add-kernel-notifierc-fix
+++ a/kernel/notifier.c
@@ -107,7 +107,6 @@ int atomic_notifier_chain_register(struc
 	spin_unlock_irqrestore(&nh->lock, flags);
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(atomic_notifier_chain_register);
 
 /**
@@ -131,7 +130,6 @@ int atomic_notifier_chain_unregister(str
 	synchronize_rcu();
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(atomic_notifier_chain_unregister);
 
 /**
@@ -165,7 +163,6 @@ int __kprobes __atomic_notifier_call_cha
 	rcu_read_unlock();
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(__atomic_notifier_call_chain);
 
 int __kprobes atomic_notifier_call_chain(struct atomic_notifier_head *nh,
@@ -173,8 +170,8 @@ int __kprobes atomic_notifier_call_chain
 {
 	return __atomic_notifier_call_chain(nh, val, v, -1, NULL);
 }
-
 EXPORT_SYMBOL_GPL(atomic_notifier_call_chain);
+
 /*
  *	Blocking notifier chain routines.  All access to the chain is
  *	synchronized by an rwsem.
@@ -209,7 +206,6 @@ int blocking_notifier_chain_register(str
 	up_write(&nh->rwsem);
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(blocking_notifier_chain_register);
 
 /**
@@ -240,7 +236,6 @@ int blocking_notifier_chain_unregister(s
 	up_write(&nh->rwsem);
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(blocking_notifier_chain_unregister);
 
 /**
@@ -311,7 +306,6 @@ int raw_notifier_chain_register(struct r
 {
 	return notifier_chain_register(&nh->head, n);
 }
-
 EXPORT_SYMBOL_GPL(raw_notifier_chain_register);
 
 /**
@@ -329,7 +323,6 @@ int raw_notifier_chain_unregister(struct
 {
 	return notifier_chain_unregister(&nh->head, n);
 }
-
 EXPORT_SYMBOL_GPL(raw_notifier_chain_unregister);
 
 /**
@@ -358,7 +351,6 @@ int __raw_notifier_call_chain(struct raw
 {
 	return notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls);
 }
-
 EXPORT_SYMBOL_GPL(__raw_notifier_call_chain);
 
 int raw_notifier_call_chain(struct raw_notifier_head *nh,
@@ -366,7 +358,6 @@ int raw_notifier_call_chain(struct raw_n
 {
 	return __raw_notifier_call_chain(nh, val, v, -1, NULL);
 }
-
 EXPORT_SYMBOL_GPL(raw_notifier_call_chain);
 
 /*
@@ -403,7 +394,6 @@ int srcu_notifier_chain_register(struct 
 	mutex_unlock(&nh->mutex);
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(srcu_notifier_chain_register);
 
 /**
@@ -435,7 +425,6 @@ int srcu_notifier_chain_unregister(struc
 	synchronize_srcu(&nh->srcu);
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(srcu_notifier_chain_unregister);
 
 /**
@@ -498,7 +487,6 @@ void srcu_init_notifier_head(struct srcu
 		BUG();
 	nh->head = NULL;
 }
-
 EXPORT_SYMBOL_GPL(srcu_init_notifier_head);
 
 /**
@@ -512,11 +500,10 @@ EXPORT_SYMBOL_GPL(srcu_init_notifier_hea
  *	always returns zero.
  */
 
-int register_reboot_notifier(struct notifier_block * nb)
+int register_reboot_notifier(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_register(&reboot_notifier_list, nb);
 }
-
 EXPORT_SYMBOL(register_reboot_notifier);
 
 /**
@@ -529,15 +516,13 @@ EXPORT_SYMBOL(register_reboot_notifier);
  *	Returns zero on success, or %-ENOENT on failure.
  */
 
-int unregister_reboot_notifier(struct notifier_block * nb)
+int unregister_reboot_notifier(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_unregister(&reboot_notifier_list, nb);
 }
-
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
 
-
 static ATOMIC_NOTIFIER_HEAD(die_chain);
 
 int notify_die(enum die_val val, const char *str,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
git-acpi-fix-git-rejects.patch
acpi-add-reboot-mechanism-fix.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
git-dvb.patch
git-input.patch
adbhid-produce-all-capslock-key-events-fix.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
git-mtd.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
git-scsi-misc.patch
aacraid-rename-check_reset.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
x86_64-clean-up-apicid_to_node-declaration.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-xfs.patch
git-kgdb-fixup-2.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
file-capabilities-clear-caps-cleanup-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
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

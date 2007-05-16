From: akpm@linux-foundation.org
Subject: + invalidate_mapping_pages-add-cond_resched.patch added to -mm tree
Date: Wed, 16 May 2007 11:41:04 -0700
Message-ID: <200705161841.l4GIf4P6007193@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45971 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755639AbXEPSlz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 May 2007 14:41:55 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l4GIhBG2006375
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 16 May 2007 11:43:46 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     invalidate_mapping_pages(): add cond_resched
has been added to the -mm tree.  Its filename is
     invalidate_mapping_pages-add-cond_resched.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: invalidate_mapping_pages(): add cond_resched
From: Andrew Morton <akpm@linux-foundation.org>

invalidate_mapping_pages() can sometimes take a long time (millions of pages
to free).  Long enough for the softlockup detector to trigger.

We used to have a cond_resched() in there but I took it out because the
drop_caches code calls invalidate_mapping_pages() under inode_lock.

The patch adds a nasty flag and puts the cond_resched() back.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/drop_caches.c   |    2 +-
 include/linux/fs.h |    3 +++
 mm/truncate.c      |   38 +++++++++++++++++++++++---------------
 3 files changed, 27 insertions(+), 16 deletions(-)

diff -puN fs/drop_caches.c~invalidate_mapping_pages-add-cond_resched fs/drop_caches.c
--- a/fs/drop_caches.c~invalidate_mapping_pages-add-cond_resched
+++ a/fs/drop_caches.c
@@ -21,7 +21,7 @@ void drop_pagecache_sb(struct super_bloc
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_WILL_FREE))
 			continue;
-		invalidate_mapping_pages(inode->i_mapping, 0, -1);
+		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
 	}
 	spin_unlock(&inode_lock);
 }
diff -puN include/linux/fs.h~invalidate_mapping_pages-add-cond_resched include/linux/fs.h
--- a/include/linux/fs.h~invalidate_mapping_pages-add-cond_resched
+++ a/include/linux/fs.h
@@ -1584,6 +1584,9 @@ extern int __invalidate_device(struct bl
 extern int invalidate_partition(struct gendisk *, int);
 #endif
 extern int invalidate_inodes(struct super_block *);
+unsigned long __invalidate_mapping_pages(struct address_space *mapping,
+					pgoff_t start, pgoff_t end,
+					bool be_atomic);
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end);
 
diff -puN mm/truncate.c~invalidate_mapping_pages-add-cond_resched mm/truncate.c
--- a/mm/truncate.c~invalidate_mapping_pages-add-cond_resched
+++ a/mm/truncate.c
@@ -263,21 +263,8 @@ void truncate_inode_pages(struct address
 }
 EXPORT_SYMBOL(truncate_inode_pages);
 
-/**
- * invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
- * @mapping: the address_space which holds the pages to invalidate
- * @start: the offset 'from' which to invalidate
- * @end: the offset 'to' which to invalidate (inclusive)
- *
- * This function only removes the unlocked pages, if you want to
- * remove all the pages of one inode, you must call truncate_inode_pages.
- *
- * invalidate_mapping_pages() will not block on IO activity. It will not
- * invalidate pages which are dirty, locked, under writeback or mapped into
- * pagetables.
- */
-unsigned long invalidate_mapping_pages(struct address_space *mapping,
-				pgoff_t start, pgoff_t end)
+unsigned long __invalidate_mapping_pages(struct address_space *mapping,
+				pgoff_t start, pgoff_t end, bool be_atomic)
 {
 	struct pagevec pvec;
 	pgoff_t next = start;
@@ -318,9 +305,30 @@ unlock:
 				break;
 		}
 		pagevec_release(&pvec);
+		if (likely(!be_atomic))
+			cond_resched();
 	}
 	return ret;
 }
+
+/**
+ * invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
+ * @mapping: the address_space which holds the pages to invalidate
+ * @start: the offset 'from' which to invalidate
+ * @end: the offset 'to' which to invalidate (inclusive)
+ *
+ * This function only removes the unlocked pages, if you want to
+ * remove all the pages of one inode, you must call truncate_inode_pages.
+ *
+ * invalidate_mapping_pages() will not block on IO activity. It will not
+ * invalidate pages which are dirty, locked, under writeback or mapped into
+ * pagetables.
+ */
+unsigned long invalidate_mapping_pages(struct address_space *mapping,
+				pgoff_t start, pgoff_t end)
+{
+	return __invalidate_mapping_pages(mapping, start, end, false);
+}
 EXPORT_SYMBOL(invalidate_mapping_pages);
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
parport_pc-needs-dma-mappingh.patch
git-acpi-export-acpi_set_cstate_limit.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
fix-agk-dm-dm-io-fix-panic-on-large-request.patch
8xx-mpc885ads-pcmcia-support-fix.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
git-dvb.patch
git-dvb-fixup.patch
cinergyt2-fix-file-release-handler.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-leds.patch
git-leds-fixup.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
drivers-ata-correct-a-wrong-free-function-for-sata_nv-driver-fix.patch
git-mips-fixup.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver-build-fix.patch
git-ubi.patch
git-ubi-fixup.patch
git-battery.patch
git-battery-warning-fix.patch
ds2760_battery-warning-fix.patch
git-nfs.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-ocfs2.patch
ocfs2-fix-type-borkage.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-wireless.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-fix-machine-rebooting-fix.patch
xfs-clean-up-shrinker-games.patch
pci-x-pci-express-read-control-interfaces-fix.patch
remove-slab_ctor_constructor-fix.patch
let-smp_call_function_single-return-ebusy-on-up-fix.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using-fix.patch
slub-fix-handling-of-oversized-slabs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
compat_core_sys_select-avoid-kmalloc0.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
check_dirty_inode_list.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
reiser4.patch
reiser4-fix.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
git-gccbug-fixup.patch
w1-build-fix.patch

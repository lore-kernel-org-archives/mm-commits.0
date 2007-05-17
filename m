From: akpm@linux-foundation.org
Subject: - git-block-fixup.patch removed from -mm tree
Date: Wed, 16 May 2007 20:47:45 -0700
Message-ID: <200705170347.l4H3litA016537@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59207 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758635AbXEQDsR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 May 2007 23:48:17 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l4H3npsS023923
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 16 May 2007 20:50:23 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-block-fixup
has been removed from the -mm tree.  Its filename was
     git-block-fixup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-block-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-io.c |   17 -----------------
 fs/bio.c           |    5 -----
 2 files changed, 22 deletions(-)

diff -puN fs/bio.c~git-block-fixup fs/bio.c
--- a/fs/bio.c~git-block-fixup
+++ a/fs/bio.c
@@ -1193,12 +1193,7 @@ static void __init biovec_init_slabs(voi
 
 static int __init init_bio(void)
 {
-<<<<<<< HEAD/fs/bio.c
 	bio_slab = KMEM_CACHE(bio, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
-=======
-	bio_slab = kmem_cache_create("bio", sizeof(struct bio), 0,
-				SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL, NULL);
->>>>>>> /fs/bio.c
 
 	biovec_init_slabs();
 
diff -puN drivers/md/dm-io.c~git-block-fixup drivers/md/dm-io.c
--- a/drivers/md/dm-io.c~git-block-fixup
+++ a/drivers/md/dm-io.c
@@ -55,26 +55,9 @@ struct dm_io_client *dm_io_client_create
 	if (!client->pool)
 		goto bad;
 
-<<<<<<< HEAD/drivers/md/dm-io.c
 	client->bios = bioset_create(16, 16);
 	if (!client->bios)
 		goto bad;
-=======
-	} else {
-		/* create new pool */
-		_io_pool = mempool_create_kmalloc_pool(new_ios,
-						       sizeof(struct io));
-		if (!_io_pool)
-			return -ENOMEM;
-
-		_bios = bioset_create(16, 16);
-		if (!_bios) {
-			mempool_destroy(_io_pool);
-			_io_pool = NULL;
-			return -ENOMEM;
-		}
-	}
->>>>>>> /drivers/md/dm-io.c
 
 	return client;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using-fix.patch
slub-fix-handling-of-oversized-slabs.patch
parport_pc-needs-dma-mappingh.patch
let-smp_call_function_single-return-ebusy-on-up-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
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
ide-warning-fixes.patch
git-mips-fixup.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver-build-fix.patch
git-ubi.patch
git-ubi-fixup.patch
git-battery.patch
git-battery-warning-fix.patch
ds2760_battery-warning-fix.patch
git-nfs.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
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
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
check_dirty_inode_list.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
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

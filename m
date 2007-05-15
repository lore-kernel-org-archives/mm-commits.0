From: akpm@linux-foundation.org
Subject: - slub-config_large_allocs-must-consider-max_order-limit-fix.patch removed from -mm tree
Date: Tue, 15 May 2007 01:18:54 -0700
Message-ID: <200705150818.l4F8IvNq004933@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755886AbXEOITG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 04:19:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clameter@sgi.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     slub-config_large_allocs-must-consider-max_order-limit-fix
has been removed from the -mm tree.  Its filename was
     slub-config_large_allocs-must-consider-max_order-limit-fix.patch

This patch was dropped because it was folded into slub-config_large_allocs-must-consider-max_order-limit.patch

------------------------------------------------------
Subject: slub-config_large_allocs-must-consider-max_order-limit-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/slub_def.h~slub-config_large_allocs-must-consider-max_order-limit-fix include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-config_large_allocs-must-consider-max_order-limit-fix
+++ a/include/linux/slub_def.h
@@ -61,7 +61,7 @@ struct kmem_cache {
 
 #ifdef CONFIG_LARGE_ALLOCS
 #define KMALLOC_SHIFT_HIGH ((MAX_ORDER + PAGE_SHIFT) =< 25 ? \
-				MAX_ORDER + PAGE_SHIFT - 1 : 25)
+				(MAX_ORDER + PAGE_SHIFT - 1) : 25)
 #else
 #if !defined(CONFIG_MMU) || NR_CPUS > 512 || MAX_NUMNODES > 256
 #define KMALLOC_SHIFT_HIGH 20
@@ -88,7 +88,7 @@ static inline int kmalloc_index(int size
 	 */
 	WARN_ON_ONCE(size == 0);
 
-	if (size >= (1UL << KMALLOC_SHIFT_HIGH))
+	if (size >= (1 << KMALLOC_SHIFT_HIGH))
 		return -1;
 
 	if (size > 64 && size <= 96)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slub-config_large_allocs-must-consider-max_order-limit.patch
slub-config_large_allocs-must-consider-max_order-limit-fix.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-avr32.patch
8xx-mpc885ads-pcmcia-support-fix.patch
git-dvb-fixup.patch
cinergyt2-fix-file-release-handler.patch
i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder.patch
git-gfs2-nmw.patch
git-hid-fixup.patch
git-ieee1394.patch
git-leds.patch
git-leds-fixup.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
drivers-ata-correct-a-wrong-free-function-for-sata_nv-driver-fix.patch
git-mips-fixup.patch
git-ubi.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-ocfs2.patch
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
xfs-clean-up-shrinker-games.patch
remove-slab_ctor_constructor-fix.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using-fix.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
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
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
tglx-debug.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
git-gccbug-fixup.patch
w1-build-fix.patch

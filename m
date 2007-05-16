From: akpm@linux-foundation.org
Subject: + ide-warning-fixes.patch added to -mm tree
Date: Wed, 16 May 2007 12:46:46 -0700
Message-ID: <200705161949.l4GJnr7a008342@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36858 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757309AbXEPTvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 May 2007 15:51:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bzolnier@gmail.com


The patch titled
     ide serverworks warning fixes
has been added to the -mm tree.  Its filename is
     ide-warning-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ide serverworks warning fixes
From: Andrew Morton <akpm@linux-foundation.org>

gcc-4.3:

drivers/ide/pci/serverworks.c: In function 'svwks_tune_chipset':
drivers/ide/pci/serverworks.c:176: warning: overflow in implicit constant conversion
drivers/ide/pci/serverworks.c:190: warning: overflow in implicit constant conversion
drivers/ide/pci/serverworks.c:211: warning: overflow in implicit constant conversion
drivers/ide/pci/serverworks.c:212: warning: overflow in implicit constant conversion

Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/pci/serverworks.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/ide/pci/serverworks.c~ide-warning-fixes drivers/ide/pci/serverworks.c
--- a/drivers/ide/pci/serverworks.c~ide-warning-fixes
+++ a/drivers/ide/pci/serverworks.c
@@ -173,7 +173,7 @@ dma_pio:
 				   ((dma_stat&(1<<(5+unit)))==(1<<(5+unit)))) {
 				u8 dmaspeed = dma_timing;
 
-				dma_timing &= ~0xFF;
+				dma_timing &= ~0xFFU;
 				if ((dmaspeed & 0x20) == 0x20)
 					dmaspeed = XFER_MW_DMA_2;
 				else if ((dmaspeed & 0x21) == 0x21)
@@ -187,7 +187,7 @@ dma_pio:
 			} else if (pio_timing) {
 				u8 piospeed = pio_timing;
 
-				pio_timing &= ~0xFF;
+				pio_timing &= ~0xFFU;
 				if ((piospeed & 0x20) == 0x20)
 					piospeed = XFER_PIO_4;
 				else if ((piospeed & 0x22) == 0x22)
@@ -208,8 +208,8 @@ dma_pio:
 
 oem_setup_failed:
 
-	pio_timing	&= ~0xFF;
-	dma_timing	&= ~0xFF;
+	pio_timing	&= ~0xFFU;
+	dma_timing	&= ~0xFFU;
 	ultra_timing	&= ~(0x0F << (4*unit));
 	ultra_enable	&= ~(0x01 << drive->dn);
 	csb5_pio	&= ~(0x0F << (4*drive->dn));
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
fuse-warning-fix.patch
vxfs-warning-fixes.patch
ide-warning-fixes.patch

From: akpm@linux-foundation.org
Subject: + drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy.patch added to -mm tree
Date: Thu, 17 May 2007 13:12:47 -0700
Message-ID: <200705172012.l4HKClK6031823@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58837 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757399AbXEQUP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 16:15:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, htejun@gmail.com, jeff@garzik.org, kluo@nvidia.com, pchen@nvidia.com


The patch titled
     drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy
has been added to the -mm tree.  Its filename is
     drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Kuan Luo <kluo@nvidia.com>
Cc: Peer Chen <pchen@nvidia.com>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |   35 ++++++++++++++---------------------
 1 files changed, 14 insertions(+), 21 deletions(-)

diff -puN drivers/ata/sata_nv.c~drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy
+++ a/drivers/ata/sata_nv.c
@@ -2107,9 +2107,7 @@ static void nv_fill_sg(struct ata_queued
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg;
 	unsigned int idx;
-
 	struct nv_port_priv *pp = ap->private_data;
-
 	struct ata_prd *prd;
 
 	WARN_ON(qc->__sg == NULL);
@@ -2194,11 +2192,10 @@ static unsigned int nv_qc_issue_prot(str
 {
 	struct ata_port *ap = qc->ap;
 	struct nv_port_priv *pp = ap->private_data;
-
 	struct ata_taskfile	*tf = &(qc->tf);
 	struct ata_taskfile *ttf, rtf;
-
 	u32 fis, stat0, stat1;
+
 	ttf = &rtf;
 
 	if (qc->tf.protocol != ATA_PROT_NCQ)
@@ -2338,32 +2335,29 @@ static void fis_dump(struct ata_port *ap
 
 void ncq_hotplug(struct ata_port *ap, u32 fis)
 {
+	u32 serror;
+	struct ata_eh_info *ehi = &ap->eh_info;
 
-		u32 serror;
-		struct ata_eh_info *ehi = &ap->eh_info;
+	ata_ehi_clear_desc(ehi);
 
-		ata_ehi_clear_desc(ehi);
-
-		/* AHCI needs SError cleared; otherwise, it might lock up */
-		sata_scr_read(ap, SCR_ERROR, &serror);
-		sata_scr_write(ap, SCR_ERROR, serror);
+	/* AHCI needs SError cleared; otherwise, it might lock up */
+	sata_scr_read(ap, SCR_ERROR, &serror);
+	sata_scr_write(ap, SCR_ERROR, serror);
 
-		/* analyze @irq_stat */
-		ata_ehi_push_desc(ehi, "fis_stat 0x%08x", fis);
+	/* analyze @irq_stat */
+	ata_ehi_push_desc(ehi, "fis_stat 0x%08x", fis);
 
-		ata_ehi_hotplugged(ehi);
+	ata_ehi_hotplugged(ehi);
 
-		/* okay, let's hand over to EH */
-		ehi->serror |= serror;
+	/* okay, let's hand over to EH */
+	ehi->serror |= serror;
 
-		ata_port_freeze(ap);
+	ata_port_freeze(ap);
 }
 
-
 static int ncq_interrupt(struct ata_port *ap, u32 fis)
 {
 	struct nv_port_priv *pp = ap->private_data;
-
 	u32 rc = 0;
 	u32 tag;
 	u8 ata_stat;
@@ -2371,7 +2365,6 @@ static int ncq_interrupt(struct ata_port
 	if (!fis)
 		return 0;
 
-
 	ata_stat = ap->ops->check_status(ap);
 
 	ap->ops->irq_clear(ap); /* clear bm irq */
@@ -2398,7 +2391,7 @@ static int ncq_interrupt(struct ata_port
 		set_back_byte(pp, pp->current_tag);
 		NPRINTK("BACK OUT FIS:%x \n", fis);
 		rc = 1;
-	 } /* first handle back out */
+	} /* first handle back out */
 
 	if (fis & NV_INT_SDBFIS_MCP55) {
 		pp->ops->clear_singlefis(ap, NV_INT_SDBFIS_MCP55 | NV_INT_DEV_MCP55);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slub-fix-handling-of-oversized-slabs.patch
parport_pc-needs-dma-mappingh.patch
let-smp_call_function_single-return-ebusy-on-up.patch
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
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy.patch
ide-warning-fixes.patch
git-mips-fixup.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver-build-fix.patch
git-ubi.patch
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
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
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
check_dirty_inode_list.patch
git-gccbug-fixup.patch
w1-build-fix.patch

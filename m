From: akpm@linux-foundation.org
Subject: + pata_scc-keep-up-with-libata-core-api-changes.patch added to -mm tree
Date: Tue, 25 Sep 2007 08:46:21 -0700
Message-ID: <200709251546.l8PFkLpF024653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45728 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756154AbXIYPqu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 11:46:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, alan@redhat.com, jeff@garzik.org, mel@skynet.ie


The patch titled
     pata_scc: Keep up with libata core API changes
has been added to the -mm tree.  Its filename is
     pata_scc-keep-up-with-libata-core-api-changes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_scc: Keep up with libata core API changes
From: Satyam Sharma <satyam@infradead.org>

Little fixlets, that the build started erroring / warning about:

drivers/ata/pata_scc.c: In function 'scc_bmdma_status':
drivers/ata/pata_scc.c:734: error: structure has no member named 'active_tag'
drivers/ata/pata_scc.c: In function 'scc_pata_prereset':
drivers/ata/pata_scc.c:866: warning: passing arg 1 of 'ata_std_prereset' from incompatible pointer type
drivers/ata/pata_scc.c: In function 'scc_error_handler':
drivers/ata/pata_scc.c:908: warning: passing arg 2 of 'ata_bmdma_drive_eh' from incompatible pointer type
drivers/ata/pata_scc.c:908: warning: passing arg 3 of 'ata_bmdma_drive_eh' from incompatible pointer type
drivers/ata/pata_scc.c:908: warning: passing arg 5 of 'ata_bmdma_drive_eh' from incompatible pointer type
make[2]: *** [drivers/ata/pata_scc.o] Error 1

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Alan Cox <alan@redhat.com>
Cc: Mel Gorman <mel@skynet.ie>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_scc.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/ata/pata_scc.c~pata_scc-keep-up-with-libata-core-api-changes drivers/ata/pata_scc.c
--- a/drivers/ata/pata_scc.c~pata_scc-keep-up-with-libata-core-api-changes
+++ a/drivers/ata/pata_scc.c
@@ -594,16 +594,17 @@ static unsigned int scc_bus_softreset(st
  *	Note: Original code is ata_std_softreset().
  */
 
-static int scc_std_softreset (struct ata_port *ap, unsigned int *classes,
-                              unsigned long deadline)
+static int scc_std_softreset(struct ata_link *link, unsigned int *classes,
+                             unsigned long deadline)
 {
+	struct ata_port *ap = link->ap;
 	unsigned int slave_possible = ap->flags & ATA_FLAG_SLAVE_POSS;
 	unsigned int devmask = 0, err_mask;
 	u8 err;
 
 	DPRINTK("ENTER\n");
 
-	if (ata_link_offline(&ap->link)) {
+	if (ata_link_offline(link)) {
 		classes[0] = ATA_DEV_NONE;
 		goto out;
 	}
@@ -694,7 +695,7 @@ static void scc_bmdma_stop (struct ata_q
 			printk(KERN_WARNING "%s: Internal Bus Error\n", DRV_NAME);
 			out_be32(bmid_base + SCC_DMA_INTST, INTSTS_BMSINT);
 			/* TBD: SW reset */
-			scc_std_softreset(ap, &classes, deadline);
+			scc_std_softreset(&ap->link, &classes, deadline);
 			continue;
 		}
 
@@ -733,7 +734,7 @@ static u8 scc_bmdma_status (struct ata_p
 	void __iomem *mmio = ap->ioaddr.bmdma_addr;
 	u8 host_stat = in_be32(mmio + SCC_DMA_STATUS);
 	u32 int_status = in_be32(mmio + SCC_DMA_INTST);
-	struct ata_queued_cmd *qc = ata_qc_from_tag(ap, ap->active_tag);
+	struct ata_queued_cmd *qc = ata_qc_from_tag(ap, ap->link.active_tag);
 	static int retry = 0;
 
 	/* return if IOS_SS is cleared */
@@ -862,10 +863,10 @@ static void scc_bmdma_freeze (struct ata
  *	@deadline: deadline jiffies for the operation
  */
 
-static int scc_pata_prereset(struct ata_port *ap, unsigned long deadline)
+static int scc_pata_prereset(struct ata_link *link, unsigned long deadline)
 {
-	ap->cbl = ATA_CBL_PATA80;
-	return ata_std_prereset(ap, deadline);
+	link->ap->cbl = ATA_CBL_PATA80;
+	return ata_std_prereset(link, deadline);
 }
 
 /**
@@ -876,8 +877,10 @@ static int scc_pata_prereset(struct ata_
  *	Note: Original code is ata_std_postreset().
  */
 
-static void scc_std_postreset (struct ata_port *ap, unsigned int *classes)
+static void scc_std_postreset(struct ata_link *link, unsigned int *classes)
 {
+	struct ata_port *ap = link->ap;
+
 	DPRINTK("ENTER\n");
 
 	/* is double-select really necessary? */
_

Patches currently in -mm which might be from satyam@infradead.org are

cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
git-hwmon.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
ia64-perfmon-remove-exit_pfm_fs.patch
git-ieee1394.patch
git-infiniband.patch
pata_scc-keep-up-with-libata-core-api-changes.patch
git-net.patch
git-net-fix-spidernet-build.patch
mv643xx_eth-remove-redundant-multiple-initialization.patch
iseries_veth-kill-unused-variable.patch
spider_net_ethtool-keep-up-with-recent-netdev-stats-changes.patch
pasemi_mac-build-fix-after-recent-netdev-stats.patch
git-s390.patch
sched-use-show_regs-to-improve-__schedule_bug-output.patch
git-scsi-misc.patch
mpt-fusion-shut-up-uninitialized-variable.patch
git-block.patch
git-watchdog.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
softlockup-improve-debug-output-fix.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch
i2o-fix-defined-but-not-used-build-warnings.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
unify-dma_bit_mask-definitions-v31.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch

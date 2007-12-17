From: akpm@linux-foundation.org
Subject: - scsi-gdth-kill-unneeded-irq-argument.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:40:08 -0800
Message-ID: <200712172340.lBHNe8QB008265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52546 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936842AbXLQXy3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:54:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, James.Bottomley@steeleye.com, bharrosh@panasas.com, jgarzik@redhat.com, mm-commits@vger.kernel.org


The patch titled
     SCSI/gdth: kill unneeded 'irq' argument
has been removed from the -mm tree.  Its filename was
     scsi-gdth-kill-unneeded-irq-argument.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SCSI/gdth: kill unneeded 'irq' argument
From: Jeff Garzik <jeff@garzik.org>

Neither gdth_get_status() nor __gdth_interrupt() need their 'irq' argument,
so remove it.

[akpm@linux-foundation.org: coding style fixes]
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Acked-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN drivers/scsi/gdth.c~scsi-gdth-kill-unneeded-irq-argument drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~scsi-gdth-kill-unneeded-irq-argument
+++ a/drivers/scsi/gdth.c
@@ -141,7 +141,7 @@
 static void gdth_delay(int milliseconds);
 static void gdth_eval_mapping(ulong32 size, ulong32 *cyls, int *heads, int *secs);
 static irqreturn_t gdth_interrupt(int irq, void *dev_id);
-static irqreturn_t __gdth_interrupt(gdth_ha_str *ha, int irq,
+static irqreturn_t __gdth_interrupt(gdth_ha_str *ha,
                                     int gdth_from_wait, int* pIndex);
 static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
                                                                Scsi_Cmnd *scp);
@@ -165,7 +165,6 @@ static int gdth_internal_cache_cmd(gdth_
 static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive);
 
 static void gdth_enable_int(gdth_ha_str *ha);
-static unchar gdth_get_status(gdth_ha_str *ha, int irq);
 static int gdth_test_busy(gdth_ha_str *ha);
 static int gdth_get_cmd_index(gdth_ha_str *ha);
 static void gdth_release_event(gdth_ha_str *ha);
@@ -1334,14 +1333,12 @@ static void __init gdth_enable_int(gdth_
 }
 
 /* return IStatus if interrupt was from this card else 0 */
-static unchar gdth_get_status(gdth_ha_str *ha, int irq)
+static unchar gdth_get_status(gdth_ha_str *ha)
 {
     unchar IStatus = 0;
 
-    TRACE(("gdth_get_status() irq %d ctr_count %d\n", irq, gdth_ctr_count));
+    TRACE(("gdth_get_status() irq %d ctr_count %d\n", ha->irq, gdth_ctr_count));
 
-        if (ha->irq != (unchar)irq)             /* check IRQ */
-            return false;
         if (ha->type == GDT_EISA)
             IStatus = inb((ushort)ha->bmic + EDOORREG);
         else if (ha->type == GDT_ISA)
@@ -1523,7 +1520,7 @@ static int gdth_wait(gdth_ha_str *ha, in
         return 1;                               /* no wait required */
 
     do {
-        __gdth_interrupt(ha, (int)ha->irq, true, &wait_index);
+	__gdth_interrupt(ha, true, &wait_index);
         if (wait_index == index) {
             answer_found = TRUE;
             break;
@@ -3036,7 +3033,7 @@ static void gdth_clear_events(void)
 
 /* SCSI interface functions */
 
-static irqreturn_t __gdth_interrupt(gdth_ha_str *ha, int irq,
+static irqreturn_t __gdth_interrupt(gdth_ha_str *ha,
                                     int gdth_from_wait, int* pIndex)
 {
     gdt6m_dpram_str __iomem *dp6m_ptr = NULL;
@@ -3054,7 +3051,7 @@ static irqreturn_t __gdth_interrupt(gdth
     int act_int_coal = 0;       
 #endif
 
-    TRACE(("gdth_interrupt() IRQ %d\n",irq));
+    TRACE(("gdth_interrupt() IRQ %d\n", ha->irq));
 
     /* if polling and not from gdth_wait() -> return */
     if (gdth_polling) {
@@ -3067,7 +3064,8 @@ static irqreturn_t __gdth_interrupt(gdth
         spin_lock_irqsave(&ha->smp_lock, flags);
 
     /* search controller */
-    if (0 == (IStatus = gdth_get_status(ha, irq))) {
+    IStatus = gdth_get_status(ha);
+    if (IStatus == 0) {
         /* spurious interrupt */
         if (!gdth_polling)
             spin_unlock_irqrestore(&ha->smp_lock, flags);
@@ -3294,9 +3292,9 @@ static irqreturn_t __gdth_interrupt(gdth
 
 static irqreturn_t gdth_interrupt(int irq, void *dev_id)
 {
-	gdth_ha_str *ha = (gdth_ha_str *)dev_id;
+	gdth_ha_str *ha = dev_id;
 
-	return __gdth_interrupt(ha, irq, false, NULL);
+	return __gdth_interrupt(ha, false, NULL);
 }
 
 static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-arm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
libata-add-toshiba-mk1637gsx-to-spurious-command-completion-list.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
pata_legacy-restructure-and-revamp.patch
git-netdev-all.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
bnx2x-depends-on-zlib_inflate.patch
plip-driver-convert-killed_timer_sem-to-completion.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-scsi-misc.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-wireless.patch
iommu-sg-merging-add-device_dma_parameters-structure.patch
iommu-sg-merging-pci-add-device_dma_parameters-support.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue.patch
iommu-sg-merging-sata_inic162x-use-pci_set_dma_max_seg_size.patch
iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size.patch
iommu-sg-add-iommu-helper-functions-for-the-free-area-management.patch
iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper.patch
iommu-sg-powerpc-remove-dma-4gb-boundary-protection.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
add-accessors-for-segment_boundary_mask-in.patch
pci-add-dma-segment-boundary-support.patch
swiotlb-respect-the-segment-boundary-limits.patch
call-dma_set_seg_boundary-in-__scsi_alloc_queue.patch
tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls-x86-fix.patch
fix-versus-precedence-in-various-places.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
remove-warnings-for-longstanding-conditions.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-pointless-casts-from-void-pointers.patch
i8k-allow-i8k-driver-to-be-built-on-x86_64-systems.patch
i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch
i8k-inspiron-e1705-fix.patch

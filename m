From: akpm@linux-foundation.org
Subject: + scsi-gdth-kill-unneeded-irq-argument.patch added to -mm tree
Date: Mon, 29 Oct 2007 14:43:35 -0700
Message-ID: <200710292143.l9TLhb56024809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47494 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751925AbXJ2VoS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 17:44:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, James.Bottomley@steeleye.com, bharrosh@panasas.com, jgarzik@redhat.com


The patch titled
     SCSI/gdth: kill unneeded 'irq' argument
has been added to the -mm tree.  Its filename is
     scsi-gdth-kill-unneeded-irq-argument.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SCSI/gdth: kill unneeded 'irq' argument
From: Jeff Garzik <jeff@garzik.org>

Neither gdth_get_status() nor __gdth_interrupt() need their 'irq' argument,
so remove it.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Acked-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

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
+        __gdth_interrupt(ha, true, &wait_index);
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
@@ -3067,7 +3064,7 @@ static irqreturn_t __gdth_interrupt(gdth
         spin_lock_irqsave(&ha->smp_lock, flags);
 
     /* search controller */
-    if (0 == (IStatus = gdth_get_status(ha, irq))) {
+    if (0 == (IStatus = gdth_get_status(ha))) {
         /* spurious interrupt */
         if (!gdth_polling)
             spin_unlock_irqrestore(&ha->smp_lock, flags);
@@ -3294,9 +3291,9 @@ static irqreturn_t __gdth_interrupt(gdth
 
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
remove-bogus-default-y-for-dmar-and-net_dma.patch
acpi-sbs-fix-retval-warning.patch
git-arm.patch
media-video-planb-fix-obvious-interrupt-handling-bugs.patch
git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-add-helper-__ide_setup_pci_device.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
git-netdev-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-scsi-misc-vs-git-libata-all.patch
hptiop-fix-type-mismatch-warning.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
scsi-gdth-kill-unneeded-irq-argument.patch
git-wireless.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
remove-warnings-for-longstanding-conditions.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-pointless-casts-from-void-pointers.patch

From: akpm@linux-foundation.org
Subject: - remove-always-true-tests-in-irq-handlers.patch removed from -mm tree
Date: Mon, 29 Oct 2007 13:31:32 -0700
Message-ID: <200710292031.l9TKVWwN021857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32839 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752682AbXJ2Uco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 16:32:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, jgarzik@redhat.com, ralf@linux-mips.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Remove always-true tests in irq handlers
has been removed from the -mm tree.  Its filename was
     remove-always-true-tests-in-irq-handlers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove always-true tests in irq handlers
From: Jeff Garzik <jeff@garzik.org>

In these drivers, dev_id is always non-NULL.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/sim/simeth.c                   |    5 -----
 arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c |    5 +----
 drivers/net/cpmac.c                         |    3 ---
 drivers/net/ucc_geth.c                      |    3 ---
 drivers/net/wan/farsync.c                   |   11 +++--------
 5 files changed, 4 insertions(+), 23 deletions(-)

diff -puN arch/ia64/hp/sim/simeth.c~remove-always-true-tests-in-irq-handlers arch/ia64/hp/sim/simeth.c
--- a/arch/ia64/hp/sim/simeth.c~remove-always-true-tests-in-irq-handlers
+++ a/arch/ia64/hp/sim/simeth.c
@@ -497,11 +497,6 @@ simeth_interrupt(int irq, void *dev_id)
 {
 	struct net_device *dev = dev_id;
 
-	if ( dev == NULL ) {
-		printk(KERN_WARNING "simeth: irq %d for unknown device\n", irq);
-		return IRQ_NONE;
-	}
-
 	/*
 	 * very simple loop because we get interrupts only when receiving
 	 */
diff -puN arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c~remove-always-true-tests-in-irq-handlers arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c
--- a/arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c~remove-always-true-tests-in-irq-handlers
+++ a/arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c
@@ -126,9 +126,6 @@ static irqreturn_t hwbutton_handler(int 
 	struct hwbutton_interrupt *hirq = data;
 	unsigned long cic_ext = *CIC_EXT_CFG_REG;
 
-	if (irq != hirq->irq)
-		return IRQ_NONE;
-
 	if (CIC_EXT_IS_ACTIVE_HI(cic_ext, hirq->eirq)) {
 		/* Interrupt: pin is now HI */
 		CIC_EXT_SET_ACTIVE_LO(cic_ext, hirq->eirq);
@@ -164,7 +161,7 @@ static int msp_hwbutton_register(struct 
 	*CIC_EXT_CFG_REG = cic_ext;
 
 	return request_irq(hirq->irq, hwbutton_handler, IRQF_DISABLED,
-				hirq->name, (void *)hirq);
+			   hirq->name, hirq);
 }
 
 static int __init msp_hwbutton_setup(void)
diff -puN drivers/net/cpmac.c~remove-always-true-tests-in-irq-handlers drivers/net/cpmac.c
--- a/drivers/net/cpmac.c~remove-always-true-tests-in-irq-handlers
+++ a/drivers/net/cpmac.c
@@ -661,9 +661,6 @@ static irqreturn_t cpmac_irq(int irq, vo
 	int queue;
 	u32 status;
 
-	if (!dev)
-		return IRQ_NONE;
-
 	priv = netdev_priv(dev);
 
 	status = cpmac_read(priv->regs, CPMAC_MAC_INT_VECTOR);
diff -puN drivers/net/ucc_geth.c~remove-always-true-tests-in-irq-handlers drivers/net/ucc_geth.c
--- a/drivers/net/ucc_geth.c~remove-always-true-tests-in-irq-handlers
+++ a/drivers/net/ucc_geth.c
@@ -3619,9 +3619,6 @@ static irqreturn_t ucc_geth_irq_handler(
 
 	ugeth_vdbg("%s: IN", __FUNCTION__);
 
-	if (!ugeth)
-		return IRQ_NONE;
-
 	uccf = ugeth->uccf;
 	ug_info = ugeth->ug_info;
 
diff -puN drivers/net/wan/farsync.c~remove-always-true-tests-in-irq-handlers drivers/net/wan/farsync.c
--- a/drivers/net/wan/farsync.c~remove-always-true-tests-in-irq-handlers
+++ a/drivers/net/wan/farsync.c
@@ -1498,9 +1498,9 @@ do_bottom_half_rx(struct fst_card_info *
  *      Dev_id is our fst_card_info pointer
  */
 static irqreturn_t
-fst_intr(int irq, void *dev_id)
+fst_intr(int dummy, void *dev_id)
 {
-	struct fst_card_info *card;
+	struct fst_card_info *card = dev_id;
 	struct fst_port_info *port;
 	int rdidx;		/* Event buffer indices */
 	int wridx;
@@ -1509,17 +1509,12 @@ fst_intr(int irq, void *dev_id)
 	unsigned int do_card_interrupt;
 	unsigned int int_retry_count;
 
-	if ((card = dev_id) == NULL) {
-		dbg(DBG_INTR, "intr: spurious %d\n", irq);
-		return IRQ_NONE;
-	}
-
 	/*
 	 * Check to see if the interrupt was for this card
 	 * return if not
 	 * Note that the call to clear the interrupt is important
 	 */
-	dbg(DBG_INTR, "intr: %d %p\n", irq, card);
+	dbg(DBG_INTR, "intr: %d %p\n", card->irq, card);
 	if (card->state != FST_RUNNING) {
 		printk_err
 		    ("Interrupt received for card %d in a non running state (%d)\n",
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
remove-bogus-default-y-for-dmar-and-net_dma.patch
acpi-sbs-fix-retval-warning.patch
git-arm.patch
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

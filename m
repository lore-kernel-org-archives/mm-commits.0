From: akpm@linux-foundation.org
Subject: + cxgb3-phy-interrupts-and-gpio-pins.patch added to -mm tree
Date: Thu, 19 Apr 2007 23:26:54 -0700
Message-ID: <200704200626.l3K6Qs88008574@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423014AbXDTG1H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 02:27:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: divy@chelsio.com


The patch titled
     cxgb3: PHY interrupts and GPIO pins
has been added to the -mm tree.  Its filename is
     cxgb3-phy-interrupts-and-gpio-pins.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cxgb3: PHY interrupts and GPIO pins
From: Divy Le Ray <divy@chelsio.com>

Remove assumption that PHY interrupts use GPIOs 3 and 5.  Deal with PHY
interrupts connected to any GPIO pins.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/t3_hw.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN drivers/net/cxgb3/t3_hw.c~cxgb3-phy-interrupts-and-gpio-pins drivers/net/cxgb3/t3_hw.c
--- a/drivers/net/cxgb3/t3_hw.c~cxgb3-phy-interrupts-and-gpio-pins
+++ a/drivers/net/cxgb3/t3_hw.c
@@ -1523,19 +1523,25 @@ static int mac_intr_handler(struct adapt
  */
 int t3_phy_intr_handler(struct adapter *adapter)
 {
-	static const int intr_gpio_bits[] = { 8, 0x20 };
-
+	u32 mask, gpi = adapter_info(adapter)->gpio_intr;
 	u32 i, cause = t3_read_reg(adapter, A_T3DBG_INT_CAUSE);
 
 	for_each_port(adapter, i) {
-		if (cause & intr_gpio_bits[i]) {
-			struct cphy *phy = &adap2pinfo(adapter, i)->phy;
-			int phy_cause = phy->ops->intr_handler(phy);
+		struct port_info *p = adap2pinfo(adapter, i);
+
+		mask = gpi - (gpi & (gpi - 1));
+		gpi -= mask;
+
+		if (!(p->port_type->caps & SUPPORTED_IRQ))
+			continue;
+
+		if (cause & mask) {
+			int phy_cause = p->phy.ops->intr_handler(&p->phy);
 
 			if (phy_cause & cphy_cause_link_change)
 				t3_link_changed(adapter, i);
 			if (phy_cause & cphy_cause_fifo_error)
-				phy->fifo_errors++;
+				p->phy.fifo_errors++;
 		}
 	}
 
_

Patches currently in -mm which might be from divy@chelsio.com are

cxgb3-fix-low-memory-conditions.patch
cxgb3-phy-interrupts-and-gpio-pins.patch

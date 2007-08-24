From: akpm@linux-foundation.org
Subject: + sky2-clear-pci-power-control-reg-at-startup.patch added to -mm tree
Date: Fri, 24 Aug 2007 16:55:37 -0700
Message-ID: <200708242355.l7ONtbxY021182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55467 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755237AbXHXX4L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 19:56:11 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l7ONtbwB004029
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2007 16:55:38 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org


The patch titled
     sky2: clear PCI power control reg at startup
has been added to the -mm tree.  Its filename is
     sky2-clear-pci-power-control-reg-at-startup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sky2: clear PCI power control reg at startup
From: Stephen Hemminger <shemminger@linux-foundation.org>

Make sure PCI register for PHY power gets cleared on boot, and make
sure to avoid any PCI posting problems.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sky2.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/net/sky2.c~sky2-clear-pci-power-control-reg-at-startup drivers/net/sky2.c
--- a/drivers/net/sky2.c~sky2-clear-pci-power-control-reg-at-startup
+++ a/drivers/net/sky2.c
@@ -219,9 +219,12 @@ static void sky2_power_on(struct sky2_hw
 	else
 		sky2_write8(hw, B2_Y2_CLK_GATE, 0);
 
-	if (hw->chip_id == CHIP_ID_YUKON_EC_U || hw->chip_id == CHIP_ID_YUKON_EX) {
+	if (hw->chip_id == CHIP_ID_YUKON_EC_U ||
+	    hw->chip_id == CHIP_ID_YUKON_EX) {
 		u32 reg;
 
+		sky2_pci_write32(hw, PCI_DEV_REG3, 0);
+
 		reg = sky2_pci_read32(hw, PCI_DEV_REG4);
 		/* set all bits to 0 except bits 15..12 and 8 */
 		reg &= P_ASPM_CONTROL_MSK;
@@ -238,6 +241,8 @@ static void sky2_power_on(struct sky2_hw
 		reg = sky2_read32(hw, B2_GP_IO);
 		reg |= GLB_GPIO_STAT_RACE_DIS;
 		sky2_write32(hw, B2_GP_IO, reg);
+
+		sky2_read32(hw, B2_GP_IO);
 	}
 }
 
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
sky2-clear-pci-power-control-reg-at-startup.patch
sky2-only-bring-up-watchdog-if-link-is-active.patch
sky2-117.patch
git-net.patch
i386-optimize-memset-of-6-and-8-bytes.patch

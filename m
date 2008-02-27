From: akpm@linux-foundation.org
Subject: - sis190-read-the-mac-address-from-the-eeprom-first.patch removed from -mm tree
Date: Wed, 27 Feb 2008 14:16:41 -0800
Message-ID: <200802272216.m1RMGfsG000736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759609AbYB0WRT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 17:17:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: romieu@fr.zoreil.com, dsd@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     sis190: read the mac address from the eeprom first
has been removed from the -mm tree.  Its filename was
     sis190-read-the-mac-address-from-the-eeprom-first.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sis190: read the mac address from the eeprom first
From: Francois Romieu <romieu@fr.zoreil.com>

Reading a series of zero from the cmos sram area do not work well with
is_valid_ether_addr().  Let's read the mac address from the eeprom first as
it seems more reliable.

Fix for http://bugzilla.kernel.org/show_bug.cgi?id=9831

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Daniel Drake <dsd@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sis190.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN drivers/net/sis190.c~sis190-read-the-mac-address-from-the-eeprom-first drivers/net/sis190.c
--- a/drivers/net/sis190.c~sis190-read-the-mac-address-from-the-eeprom-first
+++ a/drivers/net/sis190.c
@@ -1633,13 +1633,18 @@ static inline void sis190_init_rxfilter(
 static int __devinit sis190_get_mac_addr(struct pci_dev *pdev, 
 					 struct net_device *dev)
 {
-	u8 from;
+	int rc;
+
+	rc = sis190_get_mac_addr_from_eeprom(pdev, dev);
+	if (rc < 0) {
+		u8 reg;
 
-	pci_read_config_byte(pdev, 0x73, &from);
+		pci_read_config_byte(pdev, 0x73, &reg);
 
-	return (from & 0x00000001) ?
-		sis190_get_mac_addr_from_apc(pdev, dev) :
-		sis190_get_mac_addr_from_eeprom(pdev, dev);
+		if (reg & 0x00000001)
+			rc = sis190_get_mac_addr_from_apc(pdev, dev);
+	}
+	return rc;
 }
 
 static void sis190_set_speed_auto(struct net_device *dev)
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

git-net.patch

From: akpm@linux-foundation.org
Subject: + atl1-read-mac-address-from-register.patch added to -mm tree
Date: Wed, 14 Feb 2007 21:48:36 -0800
Message-ID: <200702150548.l1F5maDH021245@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35718 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbXBOFsw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 00:48:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jacliburn@bellsouth.net, csnook@redhat.com


The patch titled
     atl1: read MAC address from register
has been added to the -mm tree.  Its filename is
     atl1-read-mac-address-from-register.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atl1: read MAC address from register
From: Jay Cliburn <jacliburn@bellsouth.net>

On some Asus motherboards containing the L1 NIC, the MAC address is written by
the BIOS directly to the MAC register during POST, and is not stored in
eeprom.  If we don't succeed in fetching the MAC address from eeprom or spi,
try reading it directly from the MAC register.  Suggested by Xiong Huang.

And do some cleanup while we've got the hood up...

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Chris Snook <csnook@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1/atl1_hw.c |   35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff -puN drivers/net/atl1/atl1_hw.c~atl1-read-mac-address-from-register drivers/net/atl1/atl1_hw.c
--- a/drivers/net/atl1/atl1_hw.c~atl1-read-mac-address-from-register
+++ a/drivers/net/atl1/atl1_hw.c
@@ -243,14 +243,8 @@ static int atl1_get_permanent_address(st
 			i += 4;
 		}
 
-/*
- * The following 2 lines are the Attansic originals.  Saving for posterity.
- *		*(u32 *) & eth_addr[2] = LONGSWAP(addr[0]);
- *		*(u16 *) & eth_addr[0] = SHORTSWAP(*(u16 *) & addr[1]);
- */
-		*(u32 *) & eth_addr[2] = swab32(addr[0]);
-		*(u16 *) & eth_addr[0] = swab16(*(u16 *) & addr[1]);
-
+		*(u32 *) &eth_addr[2] = swab32(addr[0]);
+		*(u16 *) &eth_addr[0] = swab16(*(u16 *) &addr[1]);
 		if (is_valid_ether_addr(eth_addr)) {
 			memcpy(hw->perm_mac_addr, eth_addr, ETH_ALEN);
 			return 0;
@@ -281,17 +275,28 @@ static int atl1_get_permanent_address(st
 		i += 4;
 	}
 
-/*
- * The following 2 lines are the Attansic originals.  Saving for posterity.
- *	*(u32 *) & eth_addr[2] = LONGSWAP(addr[0]);
- *	*(u16 *) & eth_addr[0] = SHORTSWAP(*(u16 *) & addr[1]);
- */
-	*(u32 *) & eth_addr[2] = swab32(addr[0]);
-	*(u16 *) & eth_addr[0] = swab16(*(u16 *) & addr[1]);
+	*(u32 *) &eth_addr[2] = swab32(addr[0]);
+	*(u16 *) &eth_addr[0] = swab16(*(u16 *) &addr[1]);
 	if (is_valid_ether_addr(eth_addr)) {
 		memcpy(hw->perm_mac_addr, eth_addr, ETH_ALEN);
 		return 0;
 	}
+
+	/*
+	 * On some motherboards, the MAC address is written by the
+	 * BIOS directly to the MAC register during POST, and is
+	 * not stored in eeprom.  If all else thus far has failed
+	 * to fetch the permanent MAC address, try reading it directly.
+	 */
+	addr[0] = ioread32(hw->hw_addr + REG_MAC_STA_ADDR);
+	addr[1] = ioread16(hw->hw_addr + (REG_MAC_STA_ADDR + 4));
+	*(u32 *) &eth_addr[2] = swab32(addr[0]);
+	*(u16 *) &eth_addr[0] = swab16(*(u16 *) &addr[1]);
+	if (is_valid_ether_addr(eth_addr)) {
+		memcpy(hw->perm_mac_addr, eth_addr, ETH_ALEN);
+		return 0;
+	}
+
 	return 1;
 }
 
_

Patches currently in -mm which might be from jacliburn@bellsouth.net are

origin.patch
atl1-drop-net_pci-from-kconfig.patch
atl1-read-mac-address-from-register.patch
atl1-remove-unused-define.patch
atl1-add-l1-device-id-to-pci_ids-then-use-it.patch
atl1-bump-version-number.patch

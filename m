From: akpm@linux-foundation.org
Subject: + sis190-read-the-mac-address-from-the-eeprom-first.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:30:08 -0800
Message-ID: <200802230730.m1N7Uvht017972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480AbYBWHyC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: romieu@fr.zoreil.com, dsd@gentoo.org


The patch titled
     sis190: read the mac address from the eeprom first
has been added to the -mm tree.  Its filename is
     sis190-read-the-mac-address-from-the-eeprom-first.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

sis190-read-the-mac-address-from-the-eeprom-first.patch

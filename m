From: akpm@osdl.org
Subject: - sis190-mac-address-setting-fix.patch removed from -mm tree
Date: Mon, 22 Jan 2007 12:46:40 -0800
Message-ID: <200701222046.l0MKke9j001570@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50543 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932596AbXAVUsI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 15:48:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sleepy@mike-neko.net, jeff@garzik.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sis190: mac address setting fix
has been removed from the -mm tree.  Its filename was
     sis190-mac-address-setting-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sis190: mac address setting fix
From: <sleepy@mike-neko.net>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=7747

sis190s fail to set MAC address (HWaddr) from EEPROM.

Jeff Garzik <jeff@garzik.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/sis190.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/sis190.c~sis190-mac-address-setting-fix drivers/net/sis190.c
--- a/drivers/net/sis190.c~sis190-mac-address-setting-fix
+++ a/drivers/net/sis190.c
@@ -1562,7 +1562,7 @@ static int __devinit sis190_get_mac_addr
 	for (i = 0; i < MAC_ADDR_LEN / 2; i++) {
 		__le16 w = sis190_read_eeprom(ioaddr, EEPROMMACAddr + i);
 
-		((u16 *)dev->dev_addr)[0] = le16_to_cpu(w);
+		((u16 *)dev->dev_addr)[i] = le16_to_cpu(w);
 	}
 
 	sis190_set_rgmii(tp, sis190_read_eeprom(ioaddr, EEPROMInfo));
_

Patches currently in -mm which might be from sleepy@mike-neko.net are

origin.patch

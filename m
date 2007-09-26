From: akpm@linux-foundation.org
Subject: + clean-up-redundant-phy-write-line-for-uli526x-ethernet.patch added to -mm tree
Date: Wed, 26 Sep 2007 13:27:12 -0700
Message-ID: <200709262027.l8QKRCK1002366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35446 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752810AbXIZU2V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 16:28:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tie-fei.zang@freescale.com, grundler@parisc-linux.org, jeff@garzik.org


The patch titled
     Clean up redundant PHY write line for ULi526x Ethernet driver
has been added to the -mm tree.  Its filename is
     clean-up-redundant-phy-write-line-for-uli526x-ethernet.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Clean up redundant PHY write line for ULi526x Ethernet driver
From: Roy Zang <tie-fei.zang@freescale.com>

Clean up redundant PHY write line for ULi526x Ethernet Driver.

Signed-off-by: Roy Zang <tie-fei.zang@freescale.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/net/tulip/uli526x.c~clean-up-redundant-phy-write-line-for-uli526x-ethernet drivers/net/tulip/uli526x.c
--- a/drivers/net/tulip/uli526x.c~clean-up-redundant-phy-write-line-for-uli526x-ethernet
+++ a/drivers/net/tulip/uli526x.c
@@ -1599,7 +1599,6 @@ static void uli526x_process_mode(struct 
 			case ULI526X_100MFD: phy_reg = 0x2100; break;
 			}
 			phy_write(db->ioaddr, db->phy_addr, 0, phy_reg, db->chip_id);
-       			phy_write(db->ioaddr, db->phy_addr, 0, phy_reg, db->chip_id);
 		}
 	}
 }
_

Patches currently in -mm which might be from tie-fei.zang@freescale.com are

git-powerpc-galak.patch
clean-up-redundant-phy-write-line-for-uli526x-ethernet.patch

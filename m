From: akpm@linux-foundation.org
Subject: + drivers-net-cxgb3-t3_hwc-use-new-hex_to_bin-method.patch added to -mm tree
Date: Fri, 18 Jun 2010 13:54:27 -0700
Message-ID: <201006182054.o5IKsRGN022805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063Ab0FRUyg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 16:54:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-andriy.shevchenko@nokia.com, davem@davemloft.net, divy@chelsio.com


The patch titled
     drivers/net/cxgb3/t3_hw.c: use new hex_to_bin() method
has been added to the -mm tree.  Its filename is
     drivers-net-cxgb3-t3_hwc-use-new-hex_to_bin-method.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/cxgb3/t3_hw.c: use new hex_to_bin() method
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Get rid of own implementation of hex_to_bin().

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Acked-by: Divy Le Ray <divy@chelsio.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/t3_hw.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN drivers/net/cxgb3/t3_hw.c~drivers-net-cxgb3-t3_hwc-use-new-hex_to_bin-method drivers/net/cxgb3/t3_hw.c
--- a/drivers/net/cxgb3/t3_hw.c~drivers-net-cxgb3-t3_hwc-use-new-hex_to_bin-method
+++ a/drivers/net/cxgb3/t3_hw.c
@@ -679,14 +679,6 @@ int t3_seeprom_wp(struct adapter *adapte
 	return t3_seeprom_write(adapter, EEPROM_STAT_ADDR, enable ? 0xc : 0);
 }
 
-/*
- * Convert a character holding a hex digit to a number.
- */
-static unsigned int hex2int(unsigned char c)
-{
-	return isdigit(c) ? c - '0' : toupper(c) - 'A' + 10;
-}
-
 /**
  *	get_vpd_params - read VPD parameters from VPD EEPROM
  *	@adapter: adapter to read
@@ -727,15 +719,15 @@ static int get_vpd_params(struct adapter
 		p->port_type[0] = uses_xaui(adapter) ? 1 : 2;
 		p->port_type[1] = uses_xaui(adapter) ? 6 : 2;
 	} else {
-		p->port_type[0] = hex2int(vpd.port0_data[0]);
-		p->port_type[1] = hex2int(vpd.port1_data[0]);
+		p->port_type[0] = hex_to_bin(vpd.port0_data[0]);
+		p->port_type[1] = hex_to_bin(vpd.port1_data[0]);
 		p->xauicfg[0] = simple_strtoul(vpd.xaui0cfg_data, NULL, 16);
 		p->xauicfg[1] = simple_strtoul(vpd.xaui1cfg_data, NULL, 16);
 	}
 
 	for (i = 0; i < 6; i++)
-		p->eth_base[i] = hex2int(vpd.na_data[2 * i]) * 16 +
-				 hex2int(vpd.na_data[2 * i + 1]);
+		p->eth_base[i] = hex_to_bin(vpd.na_data[2 * i]) * 16 +
+				 hex_to_bin(vpd.na_data[2 * i + 1]);
 	return 0;
 }
 
_

Patches currently in -mm which might be from ext-andriy.shevchenko@nokia.com are

linux-next.patch
drivers-net-cxgb3-t3_hwc-use-new-hex_to_bin-method.patch


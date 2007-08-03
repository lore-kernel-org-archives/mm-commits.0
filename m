From: akpm@linux-foundation.org
Subject: + remove-get_perm_addr-from-ucc_geth_ethtoolc.patch added to -mm tree
Date: Fri, 03 Aug 2007 10:55:03 -0700
Message-ID: <200708031755.l73Ht37Z020599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50899 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763378AbXHCRzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Aug 2007 13:55:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jan.altenberg@linutronix.de


The patch titled
     remove get_perm_addr from ucc_geth_ethtool.c
has been added to the -mm tree.  Its filename is
     remove-get_perm_addr-from-ucc_geth_ethtoolc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove get_perm_addr from ucc_geth_ethtool.c
From: Jan Altenberg <jan.altenberg@linutronix.de>

This is needed because commit 313674afa8fdced2fe79f50f38e1c387b63d8790
inlines the generic function to the caller.

Signed-off-by: Jan Altenberg <jan.altenberg@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ucc_geth_ethtool.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/net/ucc_geth_ethtool.c~remove-get_perm_addr-from-ucc_geth_ethtoolc drivers/net/ucc_geth_ethtool.c
--- a/drivers/net/ucc_geth_ethtool.c~remove-get_perm_addr-from-ucc_geth_ethtoolc
+++ a/drivers/net/ucc_geth_ethtool.c
@@ -379,7 +379,6 @@ static const struct ethtool_ops uec_etht
 	.get_stats_count        = uec_get_stats_count,
 	.get_strings            = uec_get_strings,
 	.get_ethtool_stats      = uec_get_ethtool_stats,
-	.get_perm_addr          = ethtool_op_get_perm_addr,
 };
 
 void uec_set_ethtool_ops(struct net_device *netdev)
_

Patches currently in -mm which might be from jan.altenberg@linutronix.de are

remove-get_perm_addr-from-ucc_geth_ethtoolc.patch
at91-include-atmel_lcdch-in-at91sam92613_devicesc.patch

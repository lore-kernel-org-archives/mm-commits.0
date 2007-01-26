From: akpm@osdl.org
Subject: + bonding-arp-monitoring-broken-on-x86_64.patch added to -mm tree
Date: Fri, 26 Jan 2007 13:12:27 -0800
Message-ID: <200701262112.l0QLCSB9026649@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55528 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbXAZVMg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 16:12:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andy@greyhouse.net, davem@davemloft.net, jeff@garzik.org, shemminger@osdl.org


The patch titled
     bonding: ARP monitoring broken on x86_64
has been added to the -mm tree.  Its filename is
     bonding-arp-monitoring-broken-on-x86_64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bonding: ARP monitoring broken on x86_64
From: Andy Gospodarek <andy@greyhouse.net>

While working with the latest bonding code I noticed a nasty problem that
will prevent arp monitoring from always functioning correctly on x86_64
systems.  Comparing ints to longs and expecting reliable results on x86_64
is a bad idea.  With this patch, arp monitoring works correctly again.

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Stephen Hemminger <shemminger@osdl.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/bonding/bonding.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/net/bonding/bonding.h~bonding-arp-monitoring-broken-on-x86_64 drivers/net/bonding/bonding.h
--- a/drivers/net/bonding/bonding.h~bonding-arp-monitoring-broken-on-x86_64
+++ a/drivers/net/bonding/bonding.h
@@ -151,8 +151,8 @@ struct slave {
 	struct slave *next;
 	struct slave *prev;
 	int    delay;
-	u32    jiffies;
-	u32    last_arp_rx;
+	unsigned long jiffies;
+	unsigned long last_arp_rx;
 	s8     link;    /* one of BOND_LINK_XXXX */
 	s8     state;   /* one of BOND_STATE_XXXX */
 	u32    original_flags;
@@ -242,7 +242,8 @@ extern inline int slave_do_arp_validate(
 	return bond->params.arp_validate & (1 << slave->state);
 }
 
-extern inline u32 slave_last_rx(struct bonding *bond, struct slave *slave)
+extern inline unsigned long slave_last_rx(struct bonding *bond,
+					struct slave *slave)
 {
 	if (slave_do_arp_validate(bond, slave))
 		return slave->last_arp_rx;
_

Patches currently in -mm which might be from andy@greyhouse.net are

bonding-arp-monitoring-broken-on-x86_64.patch

From: akpm@osdl.org
Subject: + sky2-flow-control-off.patch added to -mm tree
Date: Fri, 02 Feb 2007 17:38:40 -0800
Message-ID: <200702030138.l131ceXu023894@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49204 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946209AbXBCBim (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 20:38:42 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l131ceQ5026605
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 2 Feb 2007 17:38:40 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@osdl.org


The patch titled
     sky2: flow control off
has been added to the -mm tree.  Its filename is
     sky2-flow-control-off.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sky2: flow control off
From: Stephen Hemminger <shemminger@linux-foundation.org>

Turn flow control off for sky2.  When flow control is on, the transmitter
may get randomly stuck.  Perhaps there is hardware problem, but until
Marvell provides errata information for workaround, it should default to
off.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/sky2.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/sky2.c~sky2-flow-control-off drivers/net/sky2.c
--- a/drivers/net/sky2.c~sky2-flow-control-off
+++ a/drivers/net/sky2.c
@@ -3263,7 +3263,7 @@ static __devinit struct net_device *sky2
 
 	/* Auto speed and flow control */
 	sky2->autoneg = AUTONEG_ENABLE;
-	sky2->flow_mode = FC_BOTH;
+	sky2->flow_mode = FC_NONE;
 
 	sky2->duplex = -1;
 	sky2->speed = -1;
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

sky2-flow-control-off.patch
git-netdev-all.patch
sky2-auto-negotiation-phy-errata.patch

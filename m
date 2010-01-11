From: akpm@linux-foundation.org
Subject: [merged] net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:19:41 -0800
Message-ID: <201001112019.o0BKJfpA025591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754284Ab0AKUVR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:21:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: florian@openwrt.org, davem@davemloft.net, horms@verge.net.au, juliusv@google.com, kaber@trash.net, sshtylyov@ru.mvista.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     net/netfilter/ipvs/ip_vs_wrr.c: use lib/gcd.c
has been removed from the -mm tree.  Its filename was
     net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/netfilter/ipvs/ip_vs_wrr.c: use lib/gcd.c
From: Florian Fainelli <florian@openwrt.org>

Remove the private version of the greatest common divider to use
lib/gcd.c, the latter also implementing the a < b case.

[akpm@linux-foundation.org: repair neighboring whitespace because the diff looked odd]
Signed-off-by: Florian Fainelli <florian@openwrt.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Takashi Iwai <tiwai@suse.de>
Acked-by: Simon Horman <horms@verge.net.au>
Cc: Julius Volz <juliusv@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/ipvs/Kconfig     |    3 ++-
 net/netfilter/ipvs/ip_vs_wrr.c |   15 +--------------
 2 files changed, 3 insertions(+), 15 deletions(-)

diff -puN net/netfilter/ipvs/Kconfig~net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc net/netfilter/ipvs/Kconfig
--- a/net/netfilter/ipvs/Kconfig~net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc
+++ a/net/netfilter/ipvs/Kconfig
@@ -112,7 +112,8 @@ config	IP_VS_RR
 	  module, choose M here. If unsure, say N.
  
 config	IP_VS_WRR
-        tristate "weighted round-robin scheduling" 
+	tristate "weighted round-robin scheduling"
+	select GCD
 	---help---
 	  The weighted robin-robin scheduling algorithm directs network
 	  connections to different real servers based on server weights
diff -puN net/netfilter/ipvs/ip_vs_wrr.c~net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc net/netfilter/ipvs/ip_vs_wrr.c
--- a/net/netfilter/ipvs/ip_vs_wrr.c~net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc
+++ a/net/netfilter/ipvs/ip_vs_wrr.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/net.h>
+#include <linux/gcd.h>
 
 #include <net/ip_vs.h>
 
@@ -38,20 +39,6 @@ struct ip_vs_wrr_mark {
 };
 
 
-/*
- *    Get the gcd of server weights
- */
-static int gcd(int a, int b)
-{
-	int c;
-
-	while ((c = a % b)) {
-		a = b;
-		b = c;
-	}
-	return b;
-}

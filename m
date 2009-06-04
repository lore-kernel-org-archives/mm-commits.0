From: akpm@linux-foundation.org
Subject: + net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch added to -mm tree
Date: Thu, 04 Jun 2009 15:44:03 -0700
Message-ID: <200906042244.n54Mi35m015146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457AbZFDWpj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jun 2009 18:45:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florian@openwrt.org, davem@davemloft.net, horms@verge.net.au, juliusv@google.com, kaber@trash.net, sshtylyov@ru.mvista.com, tiwai@suse.de


The patch titled
     net/netfilter/ipvs/ip_vs_wrr.c: use lib/gcd.c
has been added to the -mm tree.  Its filename is
     net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch

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
Subject: net/netfilter/ipvs/ip_vs_wrr.c: use lib/gcd.c
From: Florian Fainelli <florian@openwrt.org>

Remove the private version of the greatest common divider to use
lib/gcd.c, the latter also implementing the a < b case.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Simon Horman <horms@verge.net.au>
Cc: Julius Volz <juliusv@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/ipvs/Kconfig     |    1 +
 net/netfilter/ipvs/ip_vs_wrr.c |   15 +--------------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff -puN net/netfilter/ipvs/Kconfig~net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc net/netfilter/ipvs/Kconfig
--- a/net/netfilter/ipvs/Kconfig~net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc
+++ a/net/netfilter/ipvs/Kconfig
@@ -113,6 +113,7 @@ config	IP_VS_RR
  
 config	IP_VS_WRR
         tristate "weighted round-robin scheduling" 
+	select GCD
 	---help---
 	  The weighted robin-robin scheduling algorithm directs network
 	  connections to different real servers based on server weights
diff -puN net/netfilter/ipvs/ip_vs_wrr.c~net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc net/netfilter/ipvs/ip_vs_wrr.c
--- a/net/netfilter/ipvs/ip_vs_wrr.c~net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc
+++ a/net/netfilter/ipvs/ip_vs_wrr.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/net.h>
+#include <linux/gcd.h>
 
 #include <net/ip_vs.h>
 
@@ -35,20 +36,6 @@ struct ip_vs_wrr_mark {
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

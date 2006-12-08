From: akpm@osdl.org
Subject: - netpoll-make-arp-replies-through-netpoll-use-mac-address-of-sender.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:31:35 -0800
Message-ID: <200612080831.kB88VZf1013488@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35736 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425178AbWLHIcA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:32:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, clalance@redhat.com, mm-commits@vger.kernel.org


The patch titled
     netpoll: make arp replies through netpoll use mac address of sender
has been removed from the -mm tree.  Its filename was
     netpoll-make-arp-replies-through-netpoll-use-mac-address-of-sender.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: netpoll: make arp replies through netpoll use mac address of sender
From: Neil Horman <nhorman@tuxdriver.com>

Back in 2.4 arp requests that were recevied by netpoll were processed in
netconsole_receive_skb, where they were responded to using the src mac of
the request sender.  In the 2.6 kernel arp_reply is responsible for this
function, but instead of using the src mac address of the incomming
request, the stored mac address that was registered for the netconsole
application is used.  While this is usually ok, it can lead to failures in
netpoll in some situations (specifically situations where a network may
have two gateways, as arp requests from one may be responded to using the
mac address of the other).  This patch reverts the behavior to what we had
in 2.4, in which all arp requests are sent back using the src address of
the request sender.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/core/netpoll.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff -puN net/core/netpoll.c~netpoll-make-arp-replies-through-netpoll-use-mac-address-of-sender net/core/netpoll.c
--- a/net/core/netpoll.c~netpoll-make-arp-replies-through-netpoll-use-mac-address-of-sender
+++ a/net/core/netpoll.c
@@ -330,6 +330,7 @@ static void arp_reply(struct sk_buff *sk
 	unsigned char *arp_ptr;
 	int size, type = ARPOP_REPLY, ptype = ETH_P_ARP;
 	__be32 sip, tip;
+	unsigned char *sha;
 	struct sk_buff *send_skb;
 	struct netpoll *np = NULL;
 
@@ -356,9 +357,14 @@ static void arp_reply(struct sk_buff *sk
 	    arp->ar_op != htons(ARPOP_REQUEST))
 		return;
 
-	arp_ptr = (unsigned char *)(arp+1) + skb->dev->addr_len;
+	arp_ptr = (unsigned char *)(arp+1);
+	/* save the location of the src hw addr */
+	sha = arp_ptr;
+	arp_ptr += skb->dev->addr_len;
 	memcpy(&sip, arp_ptr, 4);
-	arp_ptr += 4 + skb->dev->addr_len;
+	arp_ptr += 4;
+	/* if we actually cared about dst hw addr, it would get copied here */
+	arp_ptr += skb->dev->addr_len;
 	memcpy(&tip, arp_ptr, 4);
 
 	/* Should we ignore arp? */
@@ -381,7 +387,7 @@ static void arp_reply(struct sk_buff *sk
 
 	if (np->dev->hard_header &&
 	    np->dev->hard_header(send_skb, skb->dev, ptype,
-				 np->remote_mac, np->local_mac,
+				 sha, np->local_mac,
 				 send_skb->len) < 0) {
 		kfree_skb(send_skb);
 		return;
@@ -405,7 +411,7 @@ static void arp_reply(struct sk_buff *sk
 	arp_ptr += np->dev->addr_len;
 	memcpy(arp_ptr, &tip, 4);
 	arp_ptr += 4;
-	memcpy(arp_ptr, np->remote_mac, np->dev->addr_len);
+	memcpy(arp_ptr, sha, np->dev->addr_len);
 	arp_ptr += np->dev->addr_len;
 	memcpy(arp_ptr, &sip, 4);
 
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

origin.patch
git-net.patch


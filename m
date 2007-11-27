From: akpm@linux-foundation.org
Subject: + net-fix-tx-bug-vlan-in-vlan.patch added to -mm tree
Date: Mon, 26 Nov 2007 23:19:35 -0800
Message-ID: <200711270719.lAR7JZZw000347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47119 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179AbXK0HUT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 02:20:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joonwpark81@gmail.com, davem@davemloft.net, greearb@candelatech.com, herbert@gondor.apana.org.au, tristan_schmelcher@alumni.uwaterloo.ca


The patch titled
     net: fix TX bug VLAN in VLAN
has been added to the -mm tree.  Its filename is
     net-fix-tx-bug-vlan-in-vlan.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: net: fix TX bug VLAN in VLAN
From: "Joonwoo Park" <joonwpark81@gmail.com>

This patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=8766

Is it possible?
BUG((veth->h_vlan_proto != htons(ETH_P_8021Q)) && !(VLAN_DEV_INFO(dev)->flags & VLAN_FLAG_REORDER_HDR))
I'm afraid, queued packet before vconfig set_flag would do that.

Fix misbehavior of vlan_dev_hard_start_xmit() for recursive encapsulations.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Cc: Ben Greear <greearb@candelatech.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Tristan Schmelcher <tristan_schmelcher@alumni.uwaterloo.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/8021q/vlan_dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN net/8021q/vlan_dev.c~net-fix-tx-bug-vlan-in-vlan net/8021q/vlan_dev.c
--- a/net/8021q/vlan_dev.c~net-fix-tx-bug-vlan-in-vlan
+++ a/net/8021q/vlan_dev.c
@@ -462,7 +462,8 @@ int vlan_dev_hard_start_xmit(struct sk_b
 	 * OTHER THINGS LIKE FDDI/TokenRing/802.3 SNAPs...
 	 */
 
-	if (veth->h_vlan_proto != htons(ETH_P_8021Q)) {
+	if (veth->h_vlan_proto != htons(ETH_P_8021Q) ||
+		VLAN_DEV_INFO(dev)->flags & VLAN_FLAG_REORDER_HDR) {
 		int orig_headroom = skb_headroom(skb);
 		unsigned short veth_TCI;
 
_

Patches currently in -mm which might be from joonwpark81@gmail.com are

net-fix-tx-bug-vlan-in-vlan.patch

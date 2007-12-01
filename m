From: akpm@linux-foundation.org
Subject: - net-fix-tx-bug-vlan-in-vlan.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:23:08 -0800
Message-ID: <200712010023.lB10N8jT031975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49748 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757926AbXLAA2W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:28:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joonwpark81@gmail.com, davem@davemloft.net, greearb@candelatech.com, herbert@gondor.apana.org.au, tristan_schmelcher@alumni.uwaterloo.ca, mm-commits@vger.kernel.org


The patch titled
     net: fix TX bug VLAN in VLAN
has been removed from the -mm tree.  Its filename was
     net-fix-tx-bug-vlan-in-vlan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-net.patch
iwlwifi-3945-fix-race-conditional-panic.patch
iwlwifi-4965-fix-race-conditional-panic.patch

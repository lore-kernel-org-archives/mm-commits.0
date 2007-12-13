From: akpm@linux-foundation.org
Subject: - ipsec-fix-reversed-icmp6-policy-check.patch removed from -mm tree
Date: Thu, 13 Dec 2007 15:32:34 -0800
Message-ID: <200712132332.lBDNWYLt023974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50824 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757501AbXLMXdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Dec 2007 18:33:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     ipsec: fix reversed ICMP6 policy check
has been removed from the -mm tree.  Its filename was
     ipsec-fix-reversed-icmp6-policy-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ipsec: fix reversed ICMP6 policy check
From: Herbert Xu <herbert@gondor.apana.org.au>

The policy check I added for ICMP on IPv6 is reversed.  This patch fixes
that.

It also adds an skb->sp check so that unprotected packets that fail the
policy check do not crash the machine.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/icmp.c |    2 +-
 net/ipv6/icmp.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN net/ipv4/icmp.c~ipsec-fix-reversed-icmp6-policy-check net/ipv4/icmp.c
--- a/net/ipv4/icmp.c~ipsec-fix-reversed-icmp6-policy-check
+++ a/net/ipv4/icmp.c
@@ -978,7 +978,7 @@ int icmp_rcv(struct sk_buff *skb)
 	struct icmphdr *icmph;
 	struct rtable *rt = (struct rtable *)skb->dst;
 
-	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb) &&
+	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb) && skb->sp &&
 	    skb->sp->xvec[skb->sp->len - 1]->props.flags & XFRM_STATE_ICMP) {
 		int nh;
 
diff -puN net/ipv6/icmp.c~ipsec-fix-reversed-icmp6-policy-check net/ipv6/icmp.c
--- a/net/ipv6/icmp.c~ipsec-fix-reversed-icmp6-policy-check
+++ a/net/ipv6/icmp.c
@@ -646,7 +646,7 @@ static int icmpv6_rcv(struct sk_buff *sk
 	struct icmp6hdr *hdr;
 	int type;
 
-	if (xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb) &&
+	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb) && skb->sp &&
 	    skb->sp->xvec[skb->sp->len - 1]->props.flags & XFRM_STATE_ICMP) {
 		int nh;
 
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

origin.patch
git-net.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
avoid-divide-in-is_align.patch
remove-rcu_assign_pointer-penalty-for-null-pointers.patch

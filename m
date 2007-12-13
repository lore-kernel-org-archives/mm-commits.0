From: akpm@linux-foundation.org
Subject: + ipsec-do-not-let-packets-pass-when-icmp-flag-is-off.patch added to -mm tree
Date: Wed, 12 Dec 2007 19:09:44 -0800
Message-ID: <200712130309.lBD39iwr010824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36228 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492AbXLMDKT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 22:10:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: herbert@gondor.apana.org.au


The patch titled
     ipsec: do not let packets pass when ICMP flag is off
has been added to the -mm tree.  Its filename is
     ipsec-do-not-let-packets-pass-when-icmp-flag-is-off.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ipsec: do not let packets pass when ICMP flag is off
From: Herbert Xu <herbert@gondor.apana.org.au>

This fixes a logical error in ICMP policy checks which lets packets through
if the state ICMP flag is off.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/icmp.c |    7 +++++--
 net/ipv6/icmp.c |    7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff -puN net/ipv4/icmp.c~ipsec-do-not-let-packets-pass-when-icmp-flag-is-off net/ipv4/icmp.c
--- a/net/ipv4/icmp.c~ipsec-do-not-let-packets-pass-when-icmp-flag-is-off
+++ a/net/ipv4/icmp.c
@@ -978,10 +978,13 @@ int icmp_rcv(struct sk_buff *skb)
 	struct icmphdr *icmph;
 	struct rtable *rt = (struct rtable *)skb->dst;
 
-	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb) && skb->sp &&
-	    skb->sp->xvec[skb->sp->len - 1]->props.flags & XFRM_STATE_ICMP) {
+	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb)) {
 		int nh;
 
+		if (!(skb->sp && skb->sp->xvec[skb->sp->len - 1]->props.flags &
+				 XFRM_STATE_ICMP))
+			goto drop;
+
 		if (!pskb_may_pull(skb, sizeof(*icmph) + sizeof(struct iphdr)))
 			goto drop;
 
diff -puN net/ipv6/icmp.c~ipsec-do-not-let-packets-pass-when-icmp-flag-is-off net/ipv6/icmp.c
--- a/net/ipv6/icmp.c~ipsec-do-not-let-packets-pass-when-icmp-flag-is-off
+++ a/net/ipv6/icmp.c
@@ -646,10 +646,13 @@ static int icmpv6_rcv(struct sk_buff *sk
 	struct icmp6hdr *hdr;
 	int type;
 
-	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb) && skb->sp &&
-	    skb->sp->xvec[skb->sp->len - 1]->props.flags & XFRM_STATE_ICMP) {
+	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
 		int nh;
 
+		if (!(skb->sp && skb->sp->xvec[skb->sp->len - 1]->props.flags &
+				 XFRM_STATE_ICMP))
+			goto drop_no_count;
+
 		if (!pskb_may_pull(skb, sizeof(*hdr) + sizeof(*orig_hdr)))
 			goto drop_no_count;
 
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

origin.patch
git-net.patch
ipsec-fix-reversed-icmp6-policy-check.patch
ipsec-do-not-let-packets-pass-when-icmp-flag-is-off.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
avoid-divide-in-is_align.patch
remove-rcu_assign_pointer-penalty-for-null-pointers.patch

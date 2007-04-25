From: akpm@linux-foundation.org
Subject: + fix-slab-corruption-running-ip6sic.patch added to -mm tree
Date: Wed, 25 Apr 2007 01:42:53 -0700
Message-ID: <200704250842.l3P8grLb030958@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423304AbXDYInB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 04:43:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkao2@o2.pl, snakebyte@gmx.de


The patch titled
     fix slab corruption running ip6sic
has been added to the -mm tree.  Its filename is
     fix-slab-corruption-running-ip6sic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix slab corruption running ip6sic
From: Jarek Poplawski <jarkao2@o2.pl>

* Herbert Xu (herbert@gondor.apana.org.au) wrote:
> Jarek Poplawski <jarkao2@o2.pl> wrote:
> >
> > My proposal is: maybe Eric could change this in
> > xfrm6_tunnel_rcv() from xfrm6_tunnel.c e.g. like this:
> >
> > return xfrm6_rcv_spi(skb, spi) > 0 ? : 0;
> >
> > and, if no errors in testing, he could resubmit this patch?
>
> I agree, this is the right fix.

The fix proposed by Jarek indeed fixes the problem, tested on two boxes,
with an -rc5 kernel and a yesterdays git

Acked-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv6/xfrm6_tunnel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/ipv6/xfrm6_tunnel.c~fix-slab-corruption-running-ip6sic net/ipv6/xfrm6_tunnel.c
--- a/net/ipv6/xfrm6_tunnel.c~fix-slab-corruption-running-ip6sic
+++ a/net/ipv6/xfrm6_tunnel.c
@@ -261,7 +261,7 @@ static int xfrm6_tunnel_rcv(struct sk_bu
 	__be32 spi;
 
 	spi = xfrm6_tunnel_spi_lookup((xfrm_address_t *)&iph->saddr);
-	return xfrm6_rcv_spi(skb, spi);
+	return xfrm6_rcv_spi(skb, spi) > 0 ? : 0;
 }
 
 static int xfrm6_tunnel_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
_

Patches currently in -mm which might be from jarkao2@o2.pl are

ppp_generic-fix-lockdep-warning.patch
fix-slab-corruption-running-ip6sic.patch
lockdep-lookup_chain_cache-comment-errata.patch
lockdep-removed-unused-ip-argument-in-mark_lock-mark_held_locks.patch

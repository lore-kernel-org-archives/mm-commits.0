From: akpm@linux-foundation.org
Subject: - net-ipv6-ndiscc-remove-unused-variable.patch removed from -mm tree
Date: Mon, 24 Mar 2008 12:24:52 -0700
Message-ID: <200803241924.m2OJOq5C021454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759636AbYCXTZK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 15:25:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, davem@davemloft.net, pekkas@netcore.fi, mm-commits@vger.kernel.org


The patch titled
     net/ipv6/ndisc.c: remove unused variable
has been removed from the -mm tree.  Its filename was
     net-ipv6-ndiscc-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/ipv6/ndisc.c: remove unused variable
From: Julia Lawall <julia@diku.dk>

The variable hlen is initialized but never used otherwise.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
identifier i;
constant C;
@@

(
extern T i;
|
- T i;
  <+... when != i
- i = C;
  ...+>
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Pekka Savola <pekkas@netcore.fi>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv6/ndisc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN net/ipv6/ndisc.c~net-ipv6-ndiscc-remove-unused-variable net/ipv6/ndisc.c
--- a/net/ipv6/ndisc.c~net-ipv6-ndiscc-remove-unused-variable
+++ a/net/ipv6/ndisc.c
@@ -1420,7 +1420,6 @@ void ndisc_send_redirect(struct sk_buff 
 	u8 *opt;
 	int rd_len;
 	int err;
-	int hlen;
 	u8 ha_buf[MAX_ADDR_LEN], *ha = NULL;
 
 	dev = skb->dev;
@@ -1491,7 +1490,6 @@ void ndisc_send_redirect(struct sk_buff 
 		return;
 	}
 
-	hlen = 0;
 
 	skb_reserve(buff, LL_RESERVED_SPACE(dev));
 	ip6_nd_hdr(sk, buff, dev, &saddr_buf, &ipv6_hdr(skb)->saddr,
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
git-alsa-tiwai.patch
git-powerpc.patch
drivers-block-viodasdc-use-field_sizeof.patch
git-udf.patch
git-net.patch
drivers-net-ixgb-ixgb_mainc-remove-unused-variable.patch
git-ocfs2.patch
drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
fs-affs-filec-use-bug_on.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch


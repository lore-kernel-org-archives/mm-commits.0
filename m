From: akpm@linux-foundation.org
Subject: - drivers-net-xen-netfrontc-use-div_round_up.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:20:39 -0700
Message-ID: <200810182320.m9INKd9m029805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751912AbYJRXUo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, jeremy@goop.org, mm-commits@vger.kernel.org


The patch titled
     drivers/net/xen-netfront.c: Use DIV_ROUND_UP
has been removed from the -mm tree.  Its filename was
     drivers-net-xen-netfrontc-use-div_round_up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/xen-netfront.c: Use DIV_ROUND_UP
From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/xen-netfront.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/xen-netfront.c~drivers-net-xen-netfrontc-use-div_round_up drivers/net/xen-netfront.c
--- a/drivers/net/xen-netfront.c~drivers-net-xen-netfrontc-use-div_round_up
+++ a/drivers/net/xen-netfront.c
@@ -471,7 +471,7 @@ static int xennet_start_xmit(struct sk_b
 	unsigned int offset = offset_in_page(data);
 	unsigned int len = skb_headlen(skb);
 
-	frags += (offset + len + PAGE_SIZE - 1) / PAGE_SIZE;
+	frags += DIV_ROUND_UP(offset + len, PAGE_SIZE);
 	if (unlikely(frags > MAX_SKB_FRAGS + 1)) {
 		printk(KERN_ALERT "xennet: skb rides the rocket: %d frags\n",
 		       frags);
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch


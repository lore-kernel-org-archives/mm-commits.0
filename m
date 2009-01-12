From: akpm@linux-foundation.org
Subject: - net-tipc-bcasth-use-array_size.patch removed from -mm tree
Date: Mon, 12 Jan 2009 11:58:27 -0800
Message-ID: <200901121958.n0CJwRwn027641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755700AbZALT7D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 14:59:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, davem@davemloft.net, per.liden@nospam.ericsson.com, mm-commits@vger.kernel.org


The patch titled
     net/tipc/bcast.h: use ARRAY_SIZE
has been removed from the -mm tree.  Its filename was
     net-tipc-bcasth-use-array_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/tipc/bcast.h: use ARRAY_SIZE
From: Julia Lawall <julia@diku.dk>

ARRAY_SIZE is more concise to use when the size of an array is divided by
the size of its type or the size of its first element.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@i@
@@

#include <linux/kernel.h>

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(T))
+ ARRAY_SIZE(E)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Per Liden <per.liden@nospam.ericsson.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/tipc/bcast.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/tipc/bcast.h~net-tipc-bcasth-use-array_size net/tipc/bcast.h
--- a/net/tipc/bcast.h~net-tipc-bcasth-use-array_size
+++ a/net/tipc/bcast.h
@@ -124,7 +124,7 @@ static inline int tipc_nmap_equal(struct
 static inline void tipc_nmap_diff(struct tipc_node_map *nm_a, struct tipc_node_map *nm_b,
 				  struct tipc_node_map *nm_diff)
 {
-	int stop = sizeof(nm_a->map) / sizeof(u32);
+	int stop = ARRAY_SIZE(nm_a->map);
 	int w;
 	int b;
 	u32 map;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch


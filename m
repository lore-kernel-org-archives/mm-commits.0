From: akpm@linux-foundation.org
Subject: + net-tipc-bcasth-use-array_size.patch added to -mm tree
Date: Wed, 12 Nov 2008 15:37:57 -0800
Message-ID: <200811122337.mACNbvh3027651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757117AbYKLXiT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 18:38:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, davem@davemloft.net, per.liden@nospam.ericsson.com


The patch titled
     net/tipc/bcast.h: use ARRAY_SIZE
has been added to the -mm tree.  Its filename is
     net-tipc-bcasth-use-array_size.patch

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
drivers-media-use-array_size.patch
drivers-mtd-maps-nettelc-use-array_size.patch
net-tipc-bcasth-use-array_size.patch
drivers-isdn-misdn-use-array_size.patch
drivers-message-fusion-use-array_size.patch
drivers-staging-wlan-ng-p80211wextc-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
drivers-net-wireless-ath9k-rcc-use-array_size.patch
crypto-md4c-use-array_size.patch


From: akpm@linux-foundation.org
Subject: - 2621-rc5-mm3-fix-e1000-compilation.patch removed from -mm tree
Date: Wed, 09 May 2007 15:24:57 -0700
Message-ID: <200705092225.l49MOv3T004193@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755478AbXEIWZk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 18:25:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, auke-jan.h.kok@intel.com, mm-commits@vger.kernel.org


The patch titled
     2.6.21-rc5-mm3: fix e1000 compilation
has been removed from the -mm tree.  Its filename was
     2621-rc5-mm3-fix-e1000-compilation.patch

This patch was dropped because I'm cleaning old stuff out of my patches directory

------------------------------------------------------
Subject: 2.6.21-rc5-mm3: fix e1000 compilation
From: Alexey Dobriyan <adobriyan@sw.ru>

  CC [M]  drivers/net/e1000/e1000_main.o
drivers/net/e1000/e1000_main.c: In function 'e1000_tso':
drivers/net/e1000/e1000_main.c:2968: error: dereferencing pointer to incomplete type
	...

Cc: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000_main.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/net/e1000/e1000_main.c~2621-rc5-mm3-fix-e1000-compilation drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~2621-rc5-mm3-fix-e1000-compilation
+++ a/drivers/net/e1000/e1000_main.c
@@ -32,6 +32,8 @@
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
 #include <linux/netdevice.h>
+#include <linux/tcp.h>
+#include <linux/ipv6.h>
 #include <net/checksum.h>
 #include <net/ip6_checksum.h>
 #include <linux/mii.h>
@@ -2976,15 +2978,13 @@ e1000_tso(struct e1000_adapter *adapter,
 								 IPPROTO_TCP,
 								 0);
 			cmd_length = E1000_TXD_CMD_IP;
-			ipcse = skb->h.raw - skb->data - 1;
+			ipcse = skb_transport_offset(skb) - 1;
 		} else if (skb_shinfo(skb)->gso_type == SKB_GSO_TCPV6) {
-			skb->nh.ipv6h->payload_len = 0;
-			skb->h.th->check =
-				~csum_ipv6_magic(&skb->nh.ipv6h->saddr,
-						 &skb->nh.ipv6h->daddr,
-						 0,
-						 IPPROTO_TCP,
-						 0);
+			ipv6_hdr(skb)->payload_len = 0;
+			tcp_hdr(skb)->check =
+				~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
+						 &ipv6_hdr(skb)->daddr,
+						 0, IPPROTO_TCP, 0);
 			ipcse = 0;
 		}
 		ipcss = skb_network_offset(skb);
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
fix-rmmod-read-write-races-in-proc-entries.patch

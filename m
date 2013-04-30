From: akpm@linux-foundation.org
Subject: [merged] net-core-rename-random32-to-prandom_u32.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:03:02 -0700
Message-ID: <20130430190302.73F4E31C07C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:38384 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933566Ab3D3TDD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:03:03 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so87615vbf.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:03:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: net/core:  rename random32() to prandom_u32()
has been removed from the -mm tree.  Its filename was
     net-core-rename-random32-to-prandom_u32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: net/core:  rename random32() to prandom_u32()

Use preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/pktgen.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff -puN net/core/pktgen.c~net-core-rename-random32-to-prandom_u32 net/core/pktgen.c
--- a/net/core/pktgen.c~net-core-rename-random32-to-prandom_u32
+++ a/net/core/pktgen.c
@@ -2198,7 +2198,7 @@ static inline int f_pick(struct pktgen_d
 				pkt_dev->curfl = 0; /*reset */
 		}
 	} else {
-		flow = random32() % pkt_dev->cflows;
+		flow = prandom_u32() % pkt_dev->cflows;
 		pkt_dev->curfl = flow;
 
 		if (pkt_dev->flows[flow].count > pkt_dev->lflow) {
@@ -2246,7 +2246,7 @@ static void set_cur_queue_map(struct pkt
 	else if (pkt_dev->queue_map_min <= pkt_dev->queue_map_max) {
 		__u16 t;
 		if (pkt_dev->flags & F_QUEUE_MAP_RND) {
-			t = random32() %
+			t = prandom_u32() %
 				(pkt_dev->queue_map_max -
 				 pkt_dev->queue_map_min + 1)
 				+ pkt_dev->queue_map_min;
@@ -2278,7 +2278,7 @@ static void mod_cur_headers(struct pktge
 		__u32 tmp;
 
 		if (pkt_dev->flags & F_MACSRC_RND)
-			mc = random32() % pkt_dev->src_mac_count;
+			mc = prandom_u32() % pkt_dev->src_mac_count;
 		else {
 			mc = pkt_dev->cur_src_mac_offset++;
 			if (pkt_dev->cur_src_mac_offset >=
@@ -2304,7 +2304,7 @@ static void mod_cur_headers(struct pktge
 		__u32 tmp;
 
 		if (pkt_dev->flags & F_MACDST_RND)
-			mc = random32() % pkt_dev->dst_mac_count;
+			mc = prandom_u32() % pkt_dev->dst_mac_count;
 
 		else {
 			mc = pkt_dev->cur_dst_mac_offset++;
@@ -2331,21 +2331,21 @@ static void mod_cur_headers(struct pktge
 		for (i = 0; i < pkt_dev->nr_labels; i++)
 			if (pkt_dev->labels[i] & MPLS_STACK_BOTTOM)
 				pkt_dev->labels[i] = MPLS_STACK_BOTTOM |
-					     ((__force __be32)random32() &
+					     ((__force __be32)prandom_u32() &
 						      htonl(0x000fffff));
 	}
 
 	if ((pkt_dev->flags & F_VID_RND) && (pkt_dev->vlan_id != 0xffff)) {
-		pkt_dev->vlan_id = random32() & (4096-1);
+		pkt_dev->vlan_id = prandom_u32() & (4096 - 1);
 	}
 
 	if ((pkt_dev->flags & F_SVID_RND) && (pkt_dev->svlan_id != 0xffff)) {
-		pkt_dev->svlan_id = random32() & (4096 - 1);
+		pkt_dev->svlan_id = prandom_u32() & (4096 - 1);
 	}
 
 	if (pkt_dev->udp_src_min < pkt_dev->udp_src_max) {
 		if (pkt_dev->flags & F_UDPSRC_RND)
-			pkt_dev->cur_udp_src = random32() %
+			pkt_dev->cur_udp_src = prandom_u32() %
 				(pkt_dev->udp_src_max - pkt_dev->udp_src_min)
 				+ pkt_dev->udp_src_min;
 
@@ -2358,7 +2358,7 @@ static void mod_cur_headers(struct pktge
 
 	if (pkt_dev->udp_dst_min < pkt_dev->udp_dst_max) {
 		if (pkt_dev->flags & F_UDPDST_RND) {
-			pkt_dev->cur_udp_dst = random32() %
+			pkt_dev->cur_udp_dst = prandom_u32() %
 				(pkt_dev->udp_dst_max - pkt_dev->udp_dst_min)
 				+ pkt_dev->udp_dst_min;
 		} else {
@@ -2375,7 +2375,7 @@ static void mod_cur_headers(struct pktge
 		if (imn < imx) {
 			__u32 t;
 			if (pkt_dev->flags & F_IPSRC_RND)
-				t = random32() % (imx - imn) + imn;
+				t = prandom_u32() % (imx - imn) + imn;
 			else {
 				t = ntohl(pkt_dev->cur_saddr);
 				t++;
@@ -2396,7 +2396,7 @@ static void mod_cur_headers(struct pktge
 				__be32 s;
 				if (pkt_dev->flags & F_IPDST_RND) {
 
-					t = random32() % (imx - imn) + imn;
+					t = prandom_u32() % (imx - imn) + imn;
 					s = htonl(t);
 
 					while (ipv4_is_loopback(s) ||
@@ -2404,7 +2404,8 @@ static void mod_cur_headers(struct pktge
 					       ipv4_is_lbcast(s) ||
 					       ipv4_is_zeronet(s) ||
 					       ipv4_is_local_multicast(s)) {
-						t = random32() % (imx - imn) + imn;
+						t = prandom_u32() %
+							(imx - imn) + imn;
 						s = htonl(t);
 					}
 					pkt_dev->cur_daddr = s;
@@ -2437,7 +2438,7 @@ static void mod_cur_headers(struct pktge
 
 			for (i = 0; i < 4; i++) {
 				pkt_dev->cur_in6_daddr.s6_addr32[i] =
-				    (((__force __be32)random32() |
+				    (((__force __be32)prandom_u32() |
 				      pkt_dev->min_in6_daddr.s6_addr32[i]) &
 				     pkt_dev->max_in6_daddr.s6_addr32[i]);
 			}
@@ -2447,7 +2448,7 @@ static void mod_cur_headers(struct pktge
 	if (pkt_dev->min_pkt_size < pkt_dev->max_pkt_size) {
 		__u32 t;
 		if (pkt_dev->flags & F_TXSIZE_RND) {
-			t = random32() %
+			t = prandom_u32() %
 				(pkt_dev->max_pkt_size - pkt_dev->min_pkt_size)
 				+ pkt_dev->min_pkt_size;
 		} else {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix-fix.patch
remove-unused-random32-and-srandom32.patch
notifier-error-inject-fix-module-names-in-kconfig.patch


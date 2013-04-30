From: akpm@linux-foundation.org
Subject: [merged] net-core-remove-duplicate-statements-by-do-while-loop.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:03:05 -0700
Message-ID: <20130430190305.7931B5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:52770 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933566Ab3D3TDG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:03:06 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so87430yhz.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:03:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: net/core: remove duplicate statements by do-while loop
has been removed from the -mm tree.  Its filename was
     net-core-remove-duplicate-statements-by-do-while-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: net/core: remove duplicate statements by do-while loop

Remove duplicate statements by using do-while loop instead of while loop.

- A;
- while (e) {
+ do {
	A;
- }
+ } while (e);

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/pktgen.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN net/core/pktgen.c~net-core-remove-duplicate-statements-by-do-while-loop net/core/pktgen.c
--- a/net/core/pktgen.c~net-core-remove-duplicate-statements-by-do-while-loop
+++ a/net/core/pktgen.c
@@ -2396,18 +2396,15 @@ static void mod_cur_headers(struct pktge
 				__be32 s;
 				if (pkt_dev->flags & F_IPDST_RND) {
 
-					t = prandom_u32() % (imx - imn) + imn;
-					s = htonl(t);
-
-					while (ipv4_is_loopback(s) ||
-					       ipv4_is_multicast(s) ||
-					       ipv4_is_lbcast(s) ||
-					       ipv4_is_zeronet(s) ||
-					       ipv4_is_local_multicast(s)) {
+					do {
 						t = prandom_u32() %
 							(imx - imn) + imn;
 						s = htonl(t);
-					}
+					} while (ipv4_is_loopback(s) ||
+						ipv4_is_multicast(s) ||
+						ipv4_is_lbcast(s) ||
+						ipv4_is_zeronet(s) ||
+						ipv4_is_local_multicast(s));
 					pkt_dev->cur_daddr = s;
 				} else {
 					t = ntohl(pkt_dev->cur_daddr);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix-fix.patch
remove-unused-random32-and-srandom32.patch
notifier-error-inject-fix-module-names-in-kconfig.patch


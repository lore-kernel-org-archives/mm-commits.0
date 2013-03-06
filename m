From: akpm@linux-foundation.org
Subject: + net-core-remove-duplicate-statements-by-do-while-loop.patch added to -mm tree
Date: Tue, 05 Mar 2013 17:02:30 -0800
Message-ID: <20130306010230.C98175A41EB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:64469 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3CFBCb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 20:02:31 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so809454yen.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 17:02:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, davem@davemloft.net


The patch titled
     Subject: net/core: remove duplicate statements by do-while loop
has been added to the -mm tree.  Its filename is
     net-core-remove-duplicate-statements-by-do-while-loop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
raid6test-use-prandom_bytes.patch
uuid-use-prandom_bytes.patch
x86-pageattr-test-remove-srandom32-call.patch
x86-rename-random32-to-prandom_u32.patch
lib-rename-random32-to-prandom_u32.patch
mm-rename-random32-to-prandom_u32.patch
kernel-rename-random32-to-prandom_u32.patch
drbd-rename-random32-to-prandom_u32.patch
infiniband-rename-random32-to-prandom_u32.patch
mmc-rename-random32-to-prandom_u32.patch
video-uvesafb-rename-random32-to-prandom_u32.patch
xfs-rename-random32-to-prandom_u32.patch
uwb-rename-random32-to-prandom_u32.patch
lguest-rename-random32-to-prandom_u32.patch
scsi-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32.patch
net-sunrpc-rename-random32-to-prandom_u32.patch
net-sched-rename-random32-to-prandom_u32.patch
net-netfilter-rename-random32-to-prandom_u32.patch
net-core-rename-random32-to-prandom_u32.patch
net-core-remove-duplicate-statements-by-do-while-loop.patch
net-rename-random32-to-prandom.patch
remove-unused-random32-and-srandom32.patch


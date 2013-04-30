From: akpm@linux-foundation.org
Subject: [merged] net-sched-rename-random32-to-prandom_u32.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:02:56 -0700
Message-ID: <20130430190256.7EC1F31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:38065 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933566Ab3D3TC6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:02:58 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so87591vbe.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:02:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, davem@davemloft.net, jhs@mojatatu.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net/sched: rename random32() to prandom_u32()
has been removed from the -mm tree.  Its filename was
     net-sched-rename-random32-to-prandom_u32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: net/sched: rename random32() to prandom_u32()

Use preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sched/sch_choke.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/sched/sch_choke.c~net-sched-rename-random32-to-prandom_u32 net/sched/sch_choke.c
--- a/net/sched/sch_choke.c~net-sched-rename-random32-to-prandom_u32
+++ a/net/sched/sch_choke.c
@@ -80,7 +80,7 @@ struct choke_sched_data {
 /* deliver a random number between 0 and N - 1 */
 static u32 random_N(unsigned int N)
 {
-	return reciprocal_divide(random32(), N);
+	return reciprocal_divide(prandom_u32(), N);
 }
 
 /* number of elements in queue including holes */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix-fix.patch
remove-unused-random32-and-srandom32.patch
notifier-error-inject-fix-module-names-in-kconfig.patch


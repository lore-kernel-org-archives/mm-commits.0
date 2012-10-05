From: akpm@linux-foundation.org
Subject: [merged] aoe-failover-remote-interface-based-on-aoe_deadsecs-parameter.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:21:18 -0700
Message-ID: <20121005202119.1F8185C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:53149 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:21:20 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so58063wib.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:21:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: failover remote interface based on aoe_deadsecs parameter
has been removed from the -mm tree.  Its filename was
     aoe-failover-remote-interface-based-on-aoe_deadsecs-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: failover remote interface based on aoe_deadsecs parameter

The aoe_deadsecs module parameter allows the user to specify a hard limit
on the number of seconds an AoE command can be retransmitted before the
AoE block device is considered to have failed.

Using aoe_deadsecs to determine the time we try using a different remote
interface helps to ensure that the hard limit is not reached before we've
tried to recover by sending to a different remote port.

As a data storage target, the AoE target is unambiguously identified by
its {major, minor} AoE address tuple, and an AoE target can have multiple
MAC addresses.  However, note that "target" in the driver code and
comments means a {major, minor, MAC address} tuple, as in "somewhere to
send packets".

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    1 -
 drivers/block/aoe/aoecmd.c |    8 +++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-failover-remote-interface-based-on-aoe_deadsecs-parameter drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-failover-remote-interface-based-on-aoe_deadsecs-parameter
+++ a/drivers/block/aoe/aoe.h
@@ -96,7 +96,6 @@ enum {
 	TIMERTICK = HZ / 10,
 	MINTIMER = HZ >> 2,
 	MAXTIMER = HZ << 1,
-	HELPWAIT = 20,
 };
 
 struct buf {
diff -puN drivers/block/aoe/aoecmd.c~aoe-failover-remote-interface-based-on-aoe_deadsecs-parameter drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-failover-remote-interface-based-on-aoe_deadsecs-parameter
+++ a/drivers/block/aoe/aoecmd.c
@@ -633,11 +633,9 @@ rexmit_timer(ulong vp)
 		list_del(pos);
 
 		t = f->t;
-		if (n > HELPWAIT) {
-			/* see if another target can help */
-			if (d->ntargets > 1)
-				d->htgt = t;
-		}
+		if (n > aoe_deadsecs/2)
+			d->htgt = t; /* see if another target can help */
+
 		if (t->nout == t->maxout) {
 			if (t->maxout > 1)
 				t->maxout--;
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch


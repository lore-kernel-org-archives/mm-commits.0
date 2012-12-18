From: akpm@linux-foundation.org
Subject: [merged] aoe-copy-fallback-timing-information-on-destination-failover.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:10:41 -0800
Message-ID: <20121218201042.1B9A0200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:57272 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2LRUKo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:10:44 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so63444wib.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:10:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: copy fallback timing information on destination failover
has been removed from the -mm tree.  Its filename was
     aoe-copy-fallback-timing-information-on-destination-failover.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: copy fallback timing information on destination failover

commit f3b8e07af7744cbb ("aoe: commands in retransmit queue use new
destination on failure") omits the copying of the coarse-grained time when
an AoE command was sent during the failover from one destination MAC
address on the AoE target to another.

The coarse-grained timing is only used when the system time changes or an
unlikely length of time has passed since the sending of the AoE command. 
Users will not be impacted unless their system clock is very inaccurate or
something unusual (e.g., 10 GbE link reset) happens during the period when
the aoe driver is handling the failure of a port on the AoE target.  Being
effected will mean that an AoE target could be considered "down" too
eagerly.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/aoe/aoecmd.c~aoe-copy-fallback-timing-information-on-destination-failover drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-copy-fallback-timing-information-on-destination-failover
+++ a/drivers/block/aoe/aoecmd.c
@@ -581,6 +581,7 @@ reassign_frame(struct list_head *pos)
 	nf->waited = 0;
 	nf->waited_total = f->waited_total;
 	nf->sent = f->sent;
+	nf->sent_jiffs = f->sent_jiffs;
 	f->skb = skb;
 	aoe_freetframe(f);
 	f->t->nout--;
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch


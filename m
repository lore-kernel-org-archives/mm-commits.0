From: akpm@linux-foundation.org
Subject: [merged] aoe-manipulate-aoedev-network-stats-under-lock.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:10:20 -0800
Message-ID: <20121218201021.10D98200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f73.google.com ([74.125.83.73]:65442 "EHLO
	mail-ee0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2LRUKX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:10:23 -0500
Received: by mail-ee0-f73.google.com with SMTP id c50so63478eek.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:10:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: manipulate aoedev network stats under lock
has been removed from the -mm tree.  Its filename was
     aoe-manipulate-aoedev-network-stats-under-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: manipulate aoedev network stats under lock

With this bugfix in place the calculation of the criterion for "lateness"
is performed under lock.  Without the lock, there is a chance that one of
the non-atomic operations performed on the round trip time statistics
could be incomplete, such that an incorrect lateness criterion would be
calculated.

Without this change, the effect of the bug would be rare unecessary but
benign retransmissions.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~aoe-manipulate-aoedev-network-stats-under-lock drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-manipulate-aoedev-network-stats-under-lock
+++ a/drivers/block/aoe/aoecmd.c
@@ -603,14 +603,14 @@ rexmit_timer(ulong vp)
 
 	d = (struct aoedev *) vp;
 
+	spin_lock_irqsave(&d->lock, flags);
+
 	/* timeout based on observed timings and variations */
 	timeout = 2 * d->rttavg >> RTTSCALE;
 	timeout += 8 * d->rttdev >> RTTDSCALE;
 	if (timeout == 0)
 		timeout = 1;
 
-	spin_lock_irqsave(&d->lock, flags);

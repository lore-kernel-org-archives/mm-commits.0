From: akpm@osdl.org
Subject: + sched-avoid-div-in-rebalance_tick.patch added to -mm tree
Date: Mon, 22 Jan 2007 14:03:08 -0800
Message-ID: <200701222203.l0MM38Eo003358@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56544 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108AbXAVWEE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 17:04:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, alan@lxorguk.ukuu.org.uk, mingo@elte.hu


The patch titled
     sched: avoid div in rebalance_tick
has been added to the -mm tree.  Its filename is
     sched-avoid-div-in-rebalance_tick.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: avoid div in rebalance_tick
From: Nick Piggin <npiggin@suse.de>

Avoid expensive integer divide 3 times per CPU per tick.

A userspace test of this loop went from 26ns, down to 19ns on a G5; and
from 123ns down to 28ns on a P3.

(Also avoid a variable bit shift, as suggested by Alan. The effect
of this wasn't noticable on the CPUs I tested with).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sched.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff -puN kernel/sched.c~sched-avoid-div-in-rebalance_tick kernel/sched.c
--- a/kernel/sched.c~sched-avoid-div-in-rebalance_tick
+++ a/kernel/sched.c
@@ -2887,14 +2887,16 @@ static void active_load_balance(struct r
 static void update_load(struct rq *this_rq)
 {
 	unsigned long this_load;
-	int i, scale;
+	unsigned int i, scale;
 
 	this_load = this_rq->raw_weighted_load;
 
 	/* Update our load: */
-	for (i = 0, scale = 1; i < 3; i++, scale <<= 1) {
+	for (i = 0, scale = 1; i < 3; i++, scale += scale) {
 		unsigned long old_load, new_load;
 
+		/* scale is effectively 1 << i now, and >> i divides by scale */
+
 		old_load = this_rq->cpu_load[i];
 		new_load = this_load;
 		/*
@@ -2904,7 +2906,7 @@ static void update_load(struct rq *this_
 		 */
 		if (new_load > old_load)
 			new_load += scale-1;
-		this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) / scale;
+		this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) >> i;
 	}
 }
 
_

Patches currently in -mm which might be from npiggin@suse.de are

git-block.patch
sched-avoid-div-in-rebalance_tick.patch

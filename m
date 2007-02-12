From: akpm@linux-foundation.org
Subject: - sched-avoid-div-in-rebalance_tick.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:47:22 -0800
Message-ID: <200702122247.l1CMlMZ6013909@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45373 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965439AbXBLWrm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:47:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, alan@lxorguk.ukuu.org.uk, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sched: avoid div in rebalance_tick
has been removed from the -mm tree.  Its filename was
     sched-avoid-div-in-rebalance_tick.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN kernel/sched.c~sched-avoid-div-in-rebalance_tick kernel/sched.c
--- a/kernel/sched.c~sched-avoid-div-in-rebalance_tick
+++ a/kernel/sched.c
@@ -2897,14 +2897,16 @@ static void active_load_balance(struct r
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
@@ -2914,7 +2916,7 @@ static void update_load(struct rq *this_
 		 */
 		if (new_load > old_load)
 			new_load += scale-1;
-		this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) / scale;
+		this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) >> i;
 	}
 }
 
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
git-block.patch
fs-fix-__block_write_full_page-error-case-buffer-submission.patch

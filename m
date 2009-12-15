From: akpm@linux-foundation.org
Subject: [merged] drivers-cpuidle-move-dereference-after-null-test.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:55:13 -0800
Message-ID: <200912152155.nBFLtE0A015455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933770AbZLOV4x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:56:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, arjan@linux.intel.com, mingo@elte.hu, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/cpuidle: Move dereference after NULL test
has been removed from the -mm tree.  Its filename was
     drivers-cpuidle-move-dereference-after-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/cpuidle: Move dereference after NULL test
From: Julia Lawall <julia@diku.dk>

It does not seem possible that ldev can be NULL, so drop the unnecessary
test.  If ldev can somehow be NULL, then the initialization of last_idx
should be moved below the test.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/governors/ladder.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/cpuidle/governors/ladder.c~drivers-cpuidle-move-dereference-after-null-test drivers/cpuidle/governors/ladder.c
--- a/drivers/cpuidle/governors/ladder.c~drivers-cpuidle-move-dereference-after-null-test
+++ a/drivers/cpuidle/governors/ladder.c
@@ -69,9 +69,6 @@ static int ladder_select_state(struct cp
 	int last_residency, last_idx = ldev->last_state_idx;
 	int latency_req = pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY);
 
-	if (unlikely(!ldev))
-		return 0;

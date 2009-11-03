From: akpm@linux-foundation.org
Subject: + drivers-cpuidle-move-dereference-after-null-test.patch added to -mm tree
Date: Mon, 02 Nov 2009 22:24:16 -0800
Message-ID: <200911030624.nA36OG6Y029472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754990AbZKCGY1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 01:24:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, arjan@linux.intel.com, mingo@elte.hu, venkatesh.pallipadi@intel.com


The patch titled
     drivers/cpuidle: Move dereference after NULL test
has been added to the -mm tree.  Its filename is
     drivers-cpuidle-move-dereference-after-null-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Arjan van de Ven <arjan@linux.intel.com>
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

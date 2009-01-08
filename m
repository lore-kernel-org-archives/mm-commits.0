From: akpm@linux-foundation.org
Subject: - generic-swap-sched-remove-local-swap-macro.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:51:22 -0800
Message-ID: <200901082251.n08MpMl4030502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754554AbZAHWvh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, mingo@elte.hu, wfg@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     generic swap(): sched: remove local swap() macro
has been removed from the -mm tree.  Its filename was
     generic-swap-sched-remove-local-swap-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: generic swap(): sched: remove local swap() macro
From: Wu Fengguang <fengguang.wu@intel.com>

Use the new generic implementation.

Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched_fair.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/sched_fair.c~generic-swap-sched-remove-local-swap-macro kernel/sched_fair.c
--- a/kernel/sched_fair.c~generic-swap-sched-remove-local-swap-macro
+++ a/kernel/sched_fair.c
@@ -1617,8 +1617,6 @@ static void task_tick_fair(struct rq *rq
 	}
 }
 
-#define swap(a, b) do { typeof(a) tmp = (a); (a) = (b); (b) = tmp; } while (0)

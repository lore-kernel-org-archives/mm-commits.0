From: akpm@linux-foundation.org
Subject: + generic-swap-sched-remove-local-swap-macro.patch added to -mm tree
Date: Wed, 03 Dec 2008 00:19:17 -0800
Message-ID: <200812030819.mB38JHs7010313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbYLCIT0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 03:19:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, mingo@elte.hu, wfg@linux.intel.com


The patch titled
     generic swap(): sched: remove local swap() macro
has been added to the -mm tree.  Its filename is
     generic-swap-sched-remove-local-swap-macro.patch

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
@@ -1606,8 +1606,6 @@ static void task_tick_fair(struct rq *rq
 	}
 }
 
-#define swap(a, b) do { typeof(a) tmp = (a); (a) = (b); (b) = tmp; } while (0)

From: akpm@linux-foundation.org
Subject: [patch 113/119] mm: replace TIF_MEMDIE checks by
 tsk_is_oom_victim
Date: Wed, 06 Sep 2017 16:24:53 -0700
Message-ID: <20170906232453.dAnNq1Kdn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51300 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754327AbdIFXYz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:24:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, torvalds@linux-foundation.org

From: Michal Hocko <mhocko@suse.com>
Subject: mm: replace TIF_MEMDIE checks by tsk_is_oom_victim

TIF_MEMDIE is set only to the tasks whick were either directly selected by
the OOM killer or passed through mark_oom_victim from the allocator path. 
tsk_is_oom_victim is more generic and allows to identify all tasks
(threads) which share the mm with the oom victim.

Please note that the freezer still needs to check TIF_MEMDIE because we
cannot thaw tasks which do not participage in oom_victims counting
otherwise a !TIF_MEMDIE task could interfere after oom_disbale returns.

Link: http://lkml.kernel.org/r/20170810075019.28998-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/cpuset.c |    9 +++++----
 mm/memcontrol.c        |    2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN kernel/cgroup/cpuset.c~mm-replace-tif_memdie-checks-by-tsk_is_oom_victim kernel/cgroup/cpuset.c
--- a/kernel/cgroup/cpuset.c~mm-replace-tif_memdie-checks-by-tsk_is_oom_victim
+++ a/kernel/cgroup/cpuset.c
@@ -56,6 +56,7 @@
 #include <linux/time64.h>
 #include <linux/backing-dev.h>
 #include <linux/sort.h>
+#include <linux/oom.h>
 
 #include <linux/uaccess.h>
 #include <linux/atomic.h>
@@ -2500,12 +2501,12 @@ static struct cpuset *nearest_hardwall_a
  * If we're in interrupt, yes, we can always allocate.  If @node is set in
  * current's mems_allowed, yes.  If it's not a __GFP_HARDWALL request and this
  * node is set in the nearest hardwalled cpuset ancestor to current's cpuset,
- * yes.  If current has access to memory reserves due to TIF_MEMDIE, yes.
+ * yes.  If current has access to memory reserves as an oom victim, yes.
  * Otherwise, no.
  *
  * GFP_USER allocations are marked with the __GFP_HARDWALL bit,
  * and do not allow allocations outside the current tasks cpuset
- * unless the task has been OOM killed as is marked TIF_MEMDIE.
+ * unless the task has been OOM killed.
  * GFP_KERNEL allocations are not so marked, so can escape to the
  * nearest enclosing hardwalled ancestor cpuset.
  *
@@ -2528,7 +2529,7 @@ static struct cpuset *nearest_hardwall_a
  * affect that:
  *	in_interrupt - any node ok (current task context irrelevant)
  *	GFP_ATOMIC   - any node ok
- *	TIF_MEMDIE   - any node ok
+ *	tsk_is_oom_victim   - any node ok
  *	GFP_KERNEL   - any node in enclosing hardwalled cpuset ok
  *	GFP_USER     - only nodes in current tasks mems allowed ok.
  */
@@ -2546,7 +2547,7 @@ bool __cpuset_node_allowed(int node, gfp
 	 * Allow tasks that have access to memory reserves because they have
 	 * been OOM killed to get memory anywhere.
 	 */
-	if (unlikely(test_thread_flag(TIF_MEMDIE)))
+	if (unlikely(tsk_is_oom_victim(current)))
 		return true;
 	if (gfp_mask & __GFP_HARDWALL)	/* If hardwall request, stop here */
 		return false;
diff -puN mm/memcontrol.c~mm-replace-tif_memdie-checks-by-tsk_is_oom_victim mm/memcontrol.c
--- a/mm/memcontrol.c~mm-replace-tif_memdie-checks-by-tsk_is_oom_victim
+++ a/mm/memcontrol.c
@@ -1917,7 +1917,7 @@ retry:
 	 * bypass the last charges so that they can exit quickly and
 	 * free their memory.
 	 */
-	if (unlikely(test_thread_flag(TIF_MEMDIE) ||
+	if (unlikely(tsk_is_oom_victim(current) ||
 		     fatal_signal_pending(current) ||
 		     current->flags & PF_EXITING))
 		goto force;
_

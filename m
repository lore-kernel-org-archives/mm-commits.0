From: akpm@linux-foundation.org
Subject: [patch 003/124] mm, oom: header nodemask is NULL when cpusets are disabled
Date: Fri, 24 Feb 2017 14:55:42 -0800
Message-ID: <58b0b9ee.9R/I/jontWlaQQk3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36948 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdBXWzn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:55:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rientjes@google.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mgorman@suse.de, mhocko@suse.com, vbabka@suse.cz

From: David Rientjes <rientjes@google.com>
Subject: mm, oom: header nodemask is NULL when cpusets are disabled

Commit 82e7d3abec86 ("oom: print nodemask in the oom report") implicitly
sets the allocation nodemask to cpuset_current_mems_allowed when there is
no effective mempolicy.  cpuset_current_mems_allowed is only effective
when cpusets are enabled, which is also printed by dump_header(), so
setting the nodemask to cpuset_current_mems_allowed is redundant and
prevents debugging issues where ac->nodemask is not set properly in the
page allocator.

This provides better debugging output since
cpuset_print_current_mems_allowed() is already provided.

[rientjes@google.com: newline per Hillf]
  Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1701200158300.88321@chino.kir.corp.google.com
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1701191454470.2381@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-header-nodemask-is-null-when-cpusets-are-disabled mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-header-nodemask-is-null-when-cpusets-are-disabled
+++ a/mm/oom_kill.c
@@ -403,12 +403,14 @@ static void dump_tasks(struct mem_cgroup
 
 static void dump_header(struct oom_control *oc, struct task_struct *p)
 {
-	nodemask_t *nm = (oc->nodemask) ? oc->nodemask : &cpuset_current_mems_allowed;
-
-	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), nodemask=%*pbl, order=%d, oom_score_adj=%hd\n",
-		current->comm, oc->gfp_mask, &oc->gfp_mask,
-		nodemask_pr_args(nm), oc->order,
-		current->signal->oom_score_adj);
+	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), nodemask=",
+		current->comm, oc->gfp_mask, &oc->gfp_mask);
+	if (oc->nodemask)
+		pr_cont("%*pbl", nodemask_pr_args(oc->nodemask));
+	else
+		pr_cont("(null)");
+	pr_cont(",  order=%d, oom_score_adj=%hd\n",
+		oc->order, current->signal->oom_score_adj);
 	if (!IS_ENABLED(CONFIG_COMPACTION) && oc->order)
 		pr_warn("COMPACTION is disabled!!!\n");
 
@@ -417,7 +419,7 @@ static void dump_header(struct oom_contr
 	if (oc->memcg)
 		mem_cgroup_print_oom_info(oc->memcg, p);
 	else
-		show_mem(SHOW_MEM_FILTER_NODES, nm);
+		show_mem(SHOW_MEM_FILTER_NODES, oc->nodemask);
 	if (sysctl_oom_dump_tasks)
 		dump_tasks(oc->memcg, oc->nodemask);
 }
_

From: akpm@linux-foundation.org
Subject: + mm-oom-header-nodemask-is-null-when-cpusets-are-disabled.patch
 added to -mm tree
Date: Thu, 19 Jan 2017 15:03:25 -0800
Message-ID: <588145bd.R/mReTZZXYNRPhsW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40802 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752160AbdASXNb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2017 18:13:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: header nodemask is NULL when cpusets are disabled
has been added to the -mm tree.  Its filename is
     mm-oom-header-nodemask-is-null-when-cpusets-are-disabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-header-nodemask-is-null-when-cpusets-are-disabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-header-nodemask-is-null-when-cpusets-are-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1701191454470.2381@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
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
+		pr_cont("(null)\n");
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

Patches currently in -mm which might be from rientjes@google.com are

mm-memcg-do-not-retry-precharge-charges.patch
mm-compaction-add-vmstats-for-kcompactd-work.patch
mm-thp-add-new-defermadvise-defrag-option.patch
mm-page_alloc-warn_alloc-nodemask-is-null-when-cpusets-are-disabled.patch
mm-oom-header-nodemask-is-null-when-cpusets-are-disabled.patch


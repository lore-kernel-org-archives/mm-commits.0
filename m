From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-oom-header-nodemask-is-null-when-cpusets-are-disabled-fix.patch removed
 from -mm tree
Date: Fri, 24 Feb 2017 14:26:01 -0800
Message-ID: <58b0b2f9.YAgp51H4dCCyJCHc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33392 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbdBXW0C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:26:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mgorman@suse.de, mhocko@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: header nodemask is NULL when cpusets are disabled fix
has been removed from the -mm tree.  Its filename was
     mm-oom-header-nodemask-is-null-when-cpusets-are-disabled-fix.patch

This patch was dropped because it was folded into mm-oom-header-nodemask-is-null-when-cpusets-are-disabled.patch

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: header nodemask is NULL when cpusets are disabled fix

Newline per Hillf

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1701200158300.88321@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~mm-oom-header-nodemask-is-null-when-cpusets-are-disabled-fix mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-header-nodemask-is-null-when-cpusets-are-disabled-fix
+++ a/mm/oom_kill.c
@@ -408,7 +408,7 @@ static void dump_header(struct oom_contr
 	if (oc->nodemask)
 		pr_cont("%*pbl", nodemask_pr_args(oc->nodemask));
 	else
-		pr_cont("(null)\n");
+		pr_cont("(null)");
 	pr_cont(",  order=%d, oom_score_adj=%hd\n",
 		oc->order, current->signal->oom_score_adj);
 	if (!IS_ENABLED(CONFIG_COMPACTION) && oc->order)
_

Patches currently in -mm which might be from rientjes@google.com are

mm-oom-header-nodemask-is-null-when-cpusets-are-disabled.patch
mm-madvise-fail-with-enomem-when-splitting-vma-will-hit-max_map_count.patch


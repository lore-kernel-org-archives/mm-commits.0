From: akpm@linux-foundation.org
Subject: + include-linux-nodemaskh-create-next_node_in-helper-fix.patch
 added to -mm tree
Date: Wed, 30 Mar 2016 11:14:48 -0700
Message-ID: <56fc1798.XD4QJJmKOeJQrSQ8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbcC3SOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Mar 2016 14:14:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: use next_node_in() helper
has been added to the -mm tree.  Its filename is
     include-linux-nodemaskh-create-next_node_in-helper-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-nodemaskh-create-next_node_in-helper-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-nodemaskh-create-next_node_in-helper-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: use next_node_in() helper

add missing parts found by
git grep -A1 "= *\<next_node("

Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/kernel/setup.c |    4 +---
 arch/x86/mm/numa.c       |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff -puN arch/tile/kernel/setup.c~include-linux-nodemaskh-create-next_node_in-helper-fix arch/tile/kernel/setup.c
--- a/arch/tile/kernel/setup.c~include-linux-nodemaskh-create-next_node_in-helper-fix
+++ a/arch/tile/kernel/setup.c
@@ -962,9 +962,7 @@ static void __init setup_numa_mapping(vo
 		cpumask_set_cpu(best_cpu, &node_2_cpu_mask[node]);
 		cpu_2_node[best_cpu] = node;
 		cpumask_clear_cpu(best_cpu, &unbound_cpus);
-		node = next_node(node, default_nodes);
-		if (node == MAX_NUMNODES)
-			node = first_node(default_nodes);
+		node = next_node_in(node, default_nodes);
 	}
 
 	/* Print out node assignments and set defaults for disabled cpus */
diff -puN arch/x86/mm/numa.c~include-linux-nodemaskh-create-next_node_in-helper-fix arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~include-linux-nodemaskh-create-next_node_in-helper-fix
+++ a/arch/x86/mm/numa.c
@@ -617,9 +617,7 @@ static void __init numa_init_array(void)
 		if (early_cpu_to_node(i) != NUMA_NO_NODE)
 			continue;
 		numa_set_node(i, rr);
-		rr = next_node(rr, node_online_map);
-		if (rr == MAX_NUMNODES)
-			rr = first_node(node_online_map);
+		rr = next_node_in(rr, node_online_map);
 	}
 }
 
_

Patches currently in -mm which might be from mhocko@suse.com are

oom-oom_reaper-do-not-enqueue-task-if-it-is-on-the-oom_reaper_list-head.patch
include-linux-nodemaskh-create-next_node_in-helper-fix.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch


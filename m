From: akpm@linux-foundation.org
Subject: [merged] oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:33:53 -0700
Message-ID: <201103232037.p2NKbUxT028243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933387Ab1CWUi1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:38:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     oom: suppress show_mem() for many nodes in irq context on page alloc failure
has been removed from the -mm tree.  Its filename was
     oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: suppress show_mem() for many nodes in irq context on page alloc failure
From: David Rientjes <rientjes@google.com>

When a page allocation failure occurs, show_mem() is called to dump the
state of the VM so users may understand what happened to get into that
condition.

This output, however, can be extremely verbose.  In irq context, it may
result in significant delays that incur NMI watchdog timeouts when the
machine is large (we use CONFIG_NODES_SHIFT > 8 here to define a "large"
machine since the length of the show_mem() output is proportional to the
number of possible nodes).

This patch suppresses the show_mem() call in irq context when the kernel
has CONFIG_NODES_SHIFT > 8.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure mm/page_alloc.c
--- a/mm/page_alloc.c~oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure
+++ a/mm/page_alloc.c
@@ -1714,6 +1714,20 @@ try_next_zone:
 	return page;
 }
 
+/*
+ * Large machines with many possible nodes should not always dump per-node
+ * meminfo in irq context.
+ */
+static inline bool should_suppress_show_mem(void)
+{
+	bool ret = false;
+
+#if NODES_SHIFT > 8
+	ret = in_interrupt();
+#endif
+	return ret;
+}
+
 static inline int
 should_alloc_retry(gfp_t gfp_mask, unsigned int order,
 				unsigned long pages_reclaimed)
@@ -2161,7 +2175,8 @@ nopage:
 			" order:%d, mode:0x%x\n",
 			current->comm, order, gfp_mask);
 		dump_stack();
-		show_mem();
+		if (!should_suppress_show_mem())
+			show_mem();
 	}
 	return page;
 got_pg:
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
jbd-remove-dependency-on-__gfp_nofail.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-give-current-access-to-memory-reserves-if-its-trying-to-die.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist-v2.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_attch.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc-v2.patch
cpuset-hold-callback_mutex-in-cpuset_clone.patch
sysctl-add-some-missing-input-constraint-checks.patch


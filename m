From: akpm@linux-foundation.org
Subject: [merged] memcg-support-hierarchical-memorynuma_stats.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:38:32 -0800
Message-ID: <5283e348.Te0/ol/aOUEux5jp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3KMUid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, gthelen@google.com, yinghan@google.com

Subject: [merged] memcg-support-hierarchical-memorynuma_stats.patch removed from -mm tree
To: yinghan@google.com,gthelen@google.com,hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:32 -0800


The patch titled
     Subject: memcg: support hierarchical memory.numa_stats
has been removed from the -mm tree.  Its filename was
     memcg-support-hierarchical-memorynuma_stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ying Han <yinghan@google.com>
Subject: memcg: support hierarchical memory.numa_stats

The memory.numa_stat file was not hierarchical.  Memory charged to the
children was not shown in parent's numa_stat.

This change adds the "hierarchical_" stats to the existing stats.  The new
hierarchical stats include the sum of all children's values in addition to
the value of the memcg.

Tested: Create cgroup a, a/b and run workload under b.  The values of
b are included in the "hierarchical_*" under a.

$ cd /sys/fs/cgroup
$ echo 1 > memory.use_hierarchy
$ mkdir a a/b

Run workload in a/b:
$ (echo $BASHPID >> a/b/cgroup.procs && cat /some/file && bash) &

The hierarchical_ fields in parent (a) show use of workload in a/b:
$ cat a/memory.numa_stat
total=0 N0=0 N1=0 N2=0 N3=0
file=0 N0=0 N1=0 N2=0 N3=0
anon=0 N0=0 N1=0 N2=0 N3=0
unevictable=0 N0=0 N1=0 N2=0 N3=0
hierarchical_total=908 N0=552 N1=317 N2=39 N3=0
hierarchical_file=850 N0=549 N1=301 N2=0 N3=0
hierarchical_anon=58 N0=3 N1=16 N2=39 N3=0
hierarchical_unevictable=0 N0=0 N1=0 N2=0 N3=0

$ cat a/b/memory.numa_stat
total=908 N0=552 N1=317 N2=39 N3=0
file=850 N0=549 N1=301 N2=0 N3=0
anon=58 N0=3 N1=16 N2=39 N3=0
unevictable=0 N0=0 N1=0 N2=0 N3=0
hierarchical_total=908 N0=552 N1=317 N2=39 N3=0
hierarchical_file=850 N0=549 N1=301 N2=0 N3=0
hierarchical_anon=58 N0=3 N1=16 N2=39 N3=0
hierarchical_unevictable=0 N0=0 N1=0 N2=0 N3=0

Signed-off-by: Ying Han <yinghan@google.com>
Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   10 +++++++---
 mm/memcontrol.c                  |   17 +++++++++++++++++
 2 files changed, 24 insertions(+), 3 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-support-hierarchical-memorynuma_stats Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-support-hierarchical-memorynuma_stats
+++ a/Documentation/cgroups/memory.txt
@@ -573,15 +573,19 @@ an memcg since the pages are allowed to
 node.  One of the use cases is evaluating application performance by
 combining this information with the application's CPU allocation.
 
-We export "total", "file", "anon" and "unevictable" pages per-node for
-each memcg.  The ouput format of memory.numa_stat is:
+Each memcg's numa_stat file includes "total", "file", "anon" and "unevictable"
+per-node page counts including "hierarchical_<counter>" which sums up all
+hierarchical children's values in addition to the memcg's own value.
+
+The ouput format of memory.numa_stat is:
 
 total=<total pages> N0=<node 0 pages> N1=<node 1 pages> ...
 file=<total file pages> N0=<node 0 pages> N1=<node 1 pages> ...
 anon=<total anon pages> N0=<node 0 pages> N1=<node 1 pages> ...
 unevictable=<total anon pages> N0=<node 0 pages> N1=<node 1 pages> ...
+hierarchical_<counter>=<counter pages> N0=<node 0 pages> N1=<node 1 pages> ...
 
-And we have total = file + anon + unevictable.
+The "total" count is sum of file + anon + unevictable.
 
 6. Hierarchy support
 
diff -puN mm/memcontrol.c~memcg-support-hierarchical-memorynuma_stats mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-support-hierarchical-memorynuma_stats
+++ a/mm/memcontrol.c
@@ -5396,6 +5396,23 @@ static int memcg_numa_stat_show(struct c
 		seq_putc(m, '\n');
 	}
 
+	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
+		struct mem_cgroup *iter;
+
+		nr = 0;
+		for_each_mem_cgroup_tree(iter, memcg)
+			nr += mem_cgroup_nr_lru_pages(iter, stat->lru_mask);
+		seq_printf(m, "hierarchical_%s=%lu", stat->name, nr);
+		for_each_node_state(nid, N_MEMORY) {
+			nr = 0;
+			for_each_mem_cgroup_tree(iter, memcg)
+				nr += mem_cgroup_node_nr_lru_pages(
+					iter, nid, stat->lru_mask);
+			seq_printf(m, " N%d=%lu", nid, nr);
+		}
+		seq_putc(m, '\n');
+	}
+
 	return 0;
 }
 #endif /* CONFIG_NUMA */
_

Patches currently in -mm which might be from yinghan@google.com are

origin.patch


From: akpm@linux-foundation.org
Subject: + memcg-refactor-mem_control_numa_stat_show.patch added to -mm
 tree
Date: Thu, 26 Sep 2013 14:30:34 -0700
Message-ID: <5244a77a.uCI1oZ+FvysQzlGH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3IZVaf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Sep 2013 17:30:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghan@google.com, mhocko@suse.cz, hannes@cmpxchg.org, gthelen@google.com

Subject: + memcg-refactor-mem_control_numa_stat_show.patch added to -mm tree
To: gthelen@google.com,hannes@cmpxchg.org,mhocko@suse.cz,yinghan@google.com
From: akpm@linux-foundation.org
Date: Thu, 26 Sep 2013 14:30:34 -0700


The patch titled
     Subject: memcg: refactor mem_control_numa_stat_show()
has been added to the -mm tree.  Its filename is
     memcg-refactor-mem_control_numa_stat_show.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-refactor-mem_control_numa_stat_show.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-refactor-mem_control_numa_stat_show.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: memcg: refactor mem_control_numa_stat_show()

Refactor mem_control_numa_stat_show() to use a new stats structure for
smaller and simpler code.  This consolidates nearly identical code.

  text      data      bss        dec      hex   filename
8,137,679 1,703,496 1,896,448 11,737,623 b31a17 vmlinux.before
8,136,911 1,703,496 1,896,448 11,736,855 b31717 vmlinux.after

Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Ying Han <yinghan@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   56 ++++++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 34 deletions(-)

diff -puN mm/memcontrol.c~memcg-refactor-mem_control_numa_stat_show mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-refactor-mem_control_numa_stat_show
+++ a/mm/memcontrol.c
@@ -5407,45 +5407,33 @@ static int mem_cgroup_move_charge_write(
 static int memcg_numa_stat_show(struct cgroup_subsys_state *css,
 				struct cftype *cft, struct seq_file *m)
 {
+	struct numa_stat {
+		const char *name;
+		unsigned int lru_mask;
+	};
+
+	static const struct numa_stat stats[] = {
+		{ "total", LRU_ALL },
+		{ "file", LRU_ALL_FILE },
+		{ "anon", LRU_ALL_ANON },
+		{ "unevictable", BIT(LRU_UNEVICTABLE) },
+	};
+	const struct numa_stat *stat;
 	int nid;
-	unsigned long total_nr, file_nr, anon_nr, unevictable_nr;
-	unsigned long node_nr;
+	unsigned long nr;
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
-	total_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL);
-	seq_printf(m, "total=%lu", total_nr);
-	for_each_node_state(nid, N_MEMORY) {
-		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid, LRU_ALL);
-		seq_printf(m, " N%d=%lu", nid, node_nr);
-	}
-	seq_putc(m, '\n');
-
-	file_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL_FILE);
-	seq_printf(m, "file=%lu", file_nr);
-	for_each_node_state(nid, N_MEMORY) {
-		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
-				LRU_ALL_FILE);
-		seq_printf(m, " N%d=%lu", nid, node_nr);
+	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
+		nr = mem_cgroup_nr_lru_pages(memcg, stat->lru_mask);
+		seq_printf(m, "%s=%lu", stat->name, nr);
+		for_each_node_state(nid, N_MEMORY) {
+			nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
+							  stat->lru_mask);
+			seq_printf(m, " N%d=%lu", nid, nr);
+		}
+		seq_putc(m, '\n');
 	}
-	seq_putc(m, '\n');
 
-	anon_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL_ANON);
-	seq_printf(m, "anon=%lu", anon_nr);
-	for_each_node_state(nid, N_MEMORY) {
-		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
-				LRU_ALL_ANON);
-		seq_printf(m, " N%d=%lu", nid, node_nr);
-	}
-	seq_putc(m, '\n');

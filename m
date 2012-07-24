From: akpm@linux-foundation.org
Subject: + memcg-oom-provide-more-info-while-memcg-oom-happening.patch added to -mm tree
Date: Tue, 24 Jul 2012 13:33:03 -0700
Message-ID: <20120724203305.66D831E0049@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:49967 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941Ab2GXUdI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jul 2012 16:33:08 -0400
Received: by ghbz15 with SMTP id z15so918740ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jul 2012 13:33:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: handai.szj@taobao.com, gthelen@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: memcg, oom: provide more info while memcg oom happening
has been added to the -mm tree.  Its filename is
     memcg-oom-provide-more-info-while-memcg-oom-happening.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sha Zhengju <handai.szj@taobao.com>
Subject: memcg, oom: provide more info while memcg oom happening

When an memcg oom is happening the current memcg related dump information
is limited for debugging.  Provide more detailed memcg page statistics
together with the total one while hierarchy is enabled.

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   71 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 63 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-oom-provide-more-info-while-memcg-oom-happening mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-oom-provide-more-info-while-memcg-oom-happening
+++ a/mm/memcontrol.c
@@ -113,6 +113,14 @@ static const char * const mem_cgroup_eve
 	"pgmajfault",
 };
 
+static const char * const mem_cgroup_lru_names[] = {
+	"inactive_anon",
+	"active_anon",
+	"inactive_file",
+	"active_file",
+	"unevictable",
+};
+
 /*
  * Per memcg event counter is incremented at every pagein/pageout. With THP,
  * it will be incremated by the number of pages. This counter is used for
@@ -1372,6 +1380,59 @@ static void move_unlock_mem_cgroup(struc
 	spin_unlock_irqrestore(&memcg->move_lock, *flags);
 }
 
+#define K(x) ((x) << (PAGE_SHIFT-10))
+static void mem_cgroup_print_oom_stat(struct mem_cgroup *memcg)
+{
+	int i;
+	struct mem_cgroup *mi;
+
+	printk(KERN_INFO "Memory cgroup stat:\n");
+	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
+		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
+			continue;
+		printk(KERN_CONT "%s:%ldKB ", mem_cgroup_stat_names[i],
+			   K(mem_cgroup_read_stat(memcg, i)));
+	}
+
+	for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++)
+		printk(KERN_CONT "%s:%lu ", mem_cgroup_events_names[i],
+			   mem_cgroup_read_events(memcg, i));
+
+	for (i = 0; i < NR_LRU_LISTS; i++)
+		printk(KERN_CONT "%s:%luKB ", mem_cgroup_lru_names[i],
+			   K(mem_cgroup_nr_lru_pages(memcg, BIT(i))));
+
+	/* Dump the total statistics if hierarchy is enabled. */
+	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
+		long long val = 0;
+
+		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
+			continue;
+		for_each_mem_cgroup_tree(mi, memcg)
+			val += mem_cgroup_read_stat(mi, i);
+		printk(KERN_CONT "total_%s:%lldKB ", mem_cgroup_stat_names[i], K(val));
+	}
+
+	for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++) {
+		unsigned long long val = 0;
+
+		for_each_mem_cgroup_tree(mi, memcg)
+			val += mem_cgroup_read_events(mi, i);
+		printk(KERN_CONT "total_%s:%llu ", mem_cgroup_events_names[i], val);
+	}
+
+	for (i = 0; i < NR_LRU_LISTS; i++) {
+		unsigned long long val = 0;
+
+		for_each_mem_cgroup_tree(mi, memcg)
+			val += mem_cgroup_nr_lru_pages(mi, BIT(i));
+		printk(KERN_CONT "total_%s:%lluKB ", mem_cgroup_lru_names[i], K(val));
+	}
+
+	printk(KERN_CONT "\n");
+
+}
+
 /**
  * mem_cgroup_print_oom_info: Called from OOM with tasklist_lock held in read mode.
  * @memcg: The memory cgroup that went over limit
@@ -1436,6 +1497,8 @@ done:
 		res_counter_read_u64(&memcg->memsw, RES_USAGE) >> 10,
 		res_counter_read_u64(&memcg->memsw, RES_LIMIT) >> 10,
 		res_counter_read_u64(&memcg->memsw, RES_FAILCNT));
+
+	mem_cgroup_print_oom_stat(memcg);
 }
 
 /*
@@ -4129,14 +4192,6 @@ static int memcg_numa_stat_show(struct c
 }
 #endif /* CONFIG_NUMA */
 
-static const char * const mem_cgroup_lru_names[] = {
-	"inactive_anon",
-	"active_anon",
-	"inactive_file",
-	"active_file",
-	"unevictable",
-};

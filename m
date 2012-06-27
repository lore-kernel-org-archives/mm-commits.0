From: akpm@linux-foundation.org
Subject: + memcg-rename-mem_control_xxx-to-memcg_xxx.patch added to -mm tree
Date: Tue, 26 Jun 2012 17:21:40 -0700
Message-ID: <20120627002140.994D7A040B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:47136 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab2F0AVm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jun 2012 20:21:42 -0400
Received: by bkty5 with SMTP id y5so21644bkt.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Jun 2012 17:21:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liwp@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mhocko@suse.cz


The patch titled
     Subject: memcg: rename mem_control_xxx to memcg_xxx
has been added to the -mm tree.  Its filename is
     memcg-rename-mem_control_xxx-to-memcg_xxx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: memcg: rename mem_control_xxx to memcg_xxx

Replace memory_cgroup_xxx() with memcg_xxx()

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-rename-mem_control_xxx-to-memcg_xxx mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-rename-mem_control_xxx-to-memcg_xxx
+++ a/mm/memcontrol.c
@@ -4006,7 +4006,7 @@ static int mem_cgroup_move_charge_write(
 #endif
 
 #ifdef CONFIG_NUMA
-static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
+static int memcg_numa_stat_show(struct cgroup *cont, struct cftype *cft,
 				      struct seq_file *m)
 {
 	int nid;
@@ -4065,7 +4065,7 @@ static inline void mem_cgroup_lru_names_
 	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
 }
 
-static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
+static int memcg_stat_show(struct cgroup *cont, struct cftype *cft,
 				 struct seq_file *m)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
@@ -4579,7 +4579,7 @@ static struct cftype mem_cgroup_files[] 
 	},
 	{
 		.name = "stat",
-		.read_seq_string = mem_control_stat_show,
+		.read_seq_string = memcg_stat_show,
 	},
 	{
 		.name = "force_empty",
@@ -4611,7 +4611,7 @@ static struct cftype mem_cgroup_files[] 
 #ifdef CONFIG_NUMA
 	{
 		.name = "numa_stat",
-		.read_seq_string = mem_control_numa_stat_show,
+		.read_seq_string = memcg_numa_stat_show,
 	},
 #endif
 #ifdef CONFIG_MEMCG_SWAP
_
Subject: Subject: memcg: rename mem_control_xxx to memcg_xxx

Patches currently in -mm which might be from liwp@linux.vnet.ibm.com are

linux-next.patch
mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads.patch
mm-cleanup-on-the-comments-of-zone_reclaim_stat.patch
mm-fix-page-reclaim-comment-error.patch
mm-remove-unused-lru_all_evictable.patch
memcg-rename-mem_control_xxx-to-memcg_xxx.patch


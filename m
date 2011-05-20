From: akpm@linux-foundation.org
Subject: + memcg-add-memorynumastat-api-for-numa-statistics-v5.patch added to -mm tree
Date: Fri, 20 May 2011 15:08:01 -0700
Message-ID: <201105202208.p4KM810l000974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756806Ab1ETWIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 May 2011 18:08:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg-add-memorynumastat-api-for-numa-statistics-v5
has been added to the -mm tree.  Its filename is
     memcg-add-memorynumastat-api-for-numa-statistics-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-add-memorynumastat-api-for-numa-statistics-v5
From: Ying Han <yinghan@google.com>

1. disable the API non-NUMA kernel.

Signed-off-by: Ying Han <yinghan@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/memcontrol.c~memcg-add-memorynumastat-api-for-numa-statistics-v5 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-memorynumastat-api-for-numa-statistics-v5
+++ a/mm/memcontrol.c
@@ -1089,6 +1089,7 @@ unsigned long mem_cgroup_zone_nr_lru_pag
 	return MEM_CGROUP_ZSTAT(mz, lru);
 }
 
+#ifdef CONFIG_NUMA
 static unsigned long mem_cgroup_node_nr_file_lru_pages(struct mem_cgroup *memcg,
 							int nid)
 {
@@ -1173,6 +1174,7 @@ static unsigned long mem_cgroup_nr_lru_p
 
 	return total;
 }
+#endif /* CONFIG_NUMA */
 
 struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
 						      struct zone *zone)
@@ -4029,6 +4031,7 @@ mem_cgroup_get_total_stat(struct mem_cgr
 		mem_cgroup_get_local_stat(iter, s);
 }
 
+#ifdef CONFIG_NUMA
 static int mem_control_numa_stat_show(struct seq_file *m, void *arg)
 {
 	int nid;
@@ -4071,6 +4074,7 @@ static int mem_control_numa_stat_show(st
 	seq_putc(m, '\n');
 	return 0;
 }
+#endif /* CONFIG_NUMA */
 
 static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
 				 struct cgroup_map_cb *cb)
@@ -4506,6 +4510,7 @@ static int mem_cgroup_oom_control_write(
 	return 0;
 }
 
+#ifdef CONFIG_NUMA
 static const struct file_operations mem_control_numa_stat_file_operations = {
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -4519,6 +4524,7 @@ static int mem_control_numa_stat_open(st
 	file->f_op = &mem_control_numa_stat_file_operations;
 	return single_open(file, mem_control_numa_stat_show, cont);
 }
+#endif /* CONFIG_NUMA */
 
 static struct cftype mem_cgroup_files[] = {
 	{
@@ -4583,10 +4589,12 @@ static struct cftype mem_cgroup_files[] 
 		.unregister_event = mem_cgroup_oom_unregister_event,
 		.private = MEMFILE_PRIVATE(_OOM_TYPE, OOM_CONTROL),
 	},
+#ifdef CONFIG_NUMA
 	{
 		.name = "numa_stat",
 		.open = mem_control_numa_stat_open,
 	},
+#endif
 };
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
_

Patches currently in -mm which might be from yinghan@google.com are

vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix-2.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order-fix.patch
memcg-fix-get_scan_count-for-small-targets.patch
memcg-remove-unused-retry-signal-from-reclaim.patch
memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages.patch
memcg-add-memorynumastat-api-for-numa-statistics.patch
memcg-add-memorynumastat-api-for-numa-statistics-v5.patch


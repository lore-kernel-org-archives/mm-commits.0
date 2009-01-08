From: akpm@linux-foundation.org
Subject: - memcg-show-real-limit-under-hierarchy-mode.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:49:31 -0800
Message-ID: <200901082249.n08MnVHe028784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762823AbZAHWuD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:50:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: show real limit under hierarchy mode
has been removed from the -mm tree.  Its filename was
     memcg-show-real-limit-under-hierarchy-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: show real limit under hierarchy mode
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Show "real" limit of memcg.  This helps my debugging and maybe useful for
users.

While testing hierarchy like this

	mount -t cgroup none /cgroup -t memory
	mkdir /cgroup/A
	set use_hierarchy==1 to "A"
	mkdir /cgroup/A/01
	mkdir /cgroup/A/01/02
	mkdir /cgroup/A/01/03
	mkdir /cgroup/A/01/03/04
	mkdir /cgroup/A/08
	mkdir /cgroup/A/08/01
	....
and set each own limit to them, "real" limit of each memcg is unclear.
This patch shows real limit by checking all ancestors.

Changelog: (v1) -> (v2)
	- remove "if" and use "min(a,b)"

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff -puN mm/memcontrol.c~memcg-show-real-limit-under-hierarchy-mode mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-show-real-limit-under-hierarchy-mode
+++ a/mm/memcontrol.c
@@ -1782,6 +1782,34 @@ static int mem_cgroup_write(struct cgrou
 	return ret;
 }
 
+static void memcg_get_hierarchical_limit(struct mem_cgroup *memcg,
+		unsigned long long *mem_limit, unsigned long long *memsw_limit)
+{
+	struct cgroup *cgroup;
+	unsigned long long min_limit, min_memsw_limit, tmp;
+
+	min_limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
+	min_memsw_limit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
+	cgroup = memcg->css.cgroup;
+	if (!memcg->use_hierarchy)
+		goto out;
+
+	while (cgroup->parent) {
+		cgroup = cgroup->parent;
+		memcg = mem_cgroup_from_cont(cgroup);
+		if (!memcg->use_hierarchy)
+			break;
+		tmp = res_counter_read_u64(&memcg->res, RES_LIMIT);
+		min_limit = min(min_limit, tmp);
+		tmp = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
+		min_memsw_limit = min(min_memsw_limit, tmp);
+	}
+out:
+	*mem_limit = min_limit;
+	*memsw_limit = min_memsw_limit;
+	return;
+}
+
 static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
 {
 	struct mem_cgroup *mem;
@@ -1855,6 +1883,13 @@ static int mem_control_stat_show(struct 
 		cb->fill(cb, "unevictable", unevictable * PAGE_SIZE);
 
 	}
+	{
+		unsigned long long limit, memsw_limit;
+		memcg_get_hierarchical_limit(mem_cont, &limit, &memsw_limit);
+		cb->fill(cb, "hierarchical_memory_limit", limit);
+		if (do_swap_account)
+			cb->fill(cb, "hierarchical_memsw_limit", memsw_limit);
+	}
 
 #ifdef CONFIG_DEBUG_VM
 	cb->fill(cb, "inactive_ratio", calc_inactive_ratio(mem_cont, NULL));
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch


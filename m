From: akpm@linux-foundation.org
Subject: - cpuset-speed-up-sched-domain-partition.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:14:19 -0700
Message-ID: <200807301914.m6UJEJgQ010898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758AbYG3TQe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:16:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, balbir@in.ibm.com, clg@fr.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: speed up sched domain partition
has been removed from the -mm tree.  Its filename was
     cpuset-speed-up-sched-domain-partition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: speed up sched domain partition
From: Lai Jiangshan <laijs@cn.fujitsu.com>

Date: Mon, 28 Jul 2008 10:38:22 +0800
Subject: [PATCH 2/3] cpuset: speed up sched domain partition

All child cpusets contain a subset of the parent's cpus, so we can skip
them when partitioning sched domains. This decreases 'csa' greately for
cpusets with multi-level hierarchy.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   41 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

diff -puN kernel/cpuset.c~cpuset-speed-up-sched-domain-partition kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-speed-up-sched-domain-partition
+++ a/kernel/cpuset.c
@@ -486,13 +486,38 @@ static int cpusets_overlap(struct cpuset
 static void
 update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
 {
-	if (!dattr)
-		return;
 	if (dattr->relax_domain_level < c->relax_domain_level)
 		dattr->relax_domain_level = c->relax_domain_level;
 	return;
 }
 
+static void
+update_domain_attr_tree(struct sched_domain_attr *dattr, struct cpuset *c)
+{
+	LIST_HEAD(q);
+
+	list_add(&c->stack_list, &q);
+	while (!list_empty(&q)) {
+		struct cpuset *cp;
+		struct cgroup *cont;
+		struct cpuset *child;
+
+		cp = list_first_entry(&q, struct cpuset, stack_list);
+		list_del(q.next);
+
+		if (cpus_empty(cp->cpus_allowed))
+			continue;
+
+		if (is_sched_load_balance(cp))
+			update_domain_attr(dattr, cp);
+
+		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
+			child = cgroup_cs(cont);
+			list_add_tail(&child->stack_list, &q);
+		}
+	}
+}
+
 /*
  * rebuild_sched_domains()
  *
@@ -614,8 +639,16 @@ void rebuild_sched_domains(void)
 		if (cpus_empty(cp->cpus_allowed))
 			continue;
 
-		if (is_sched_load_balance(cp))
+		/*
+		 * All child cpusets contain a subset of the parent's cpus, so
+		 * just skip them, and then we call update_domain_attr_tree()
+		 * to calc relax_domain_level of the corresponding sched
+		 * domain.
+		 */
+		if (is_sched_load_balance(cp)) {
 			csa[csn++] = cp;
+			continue;
+		}
 
 		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
 			child = cgroup_cs(cont);
@@ -686,7 +719,7 @@ restart:
 					cpus_or(*dp, *dp, b->cpus_allowed);
 					b->pn = -1;
 					if (dattr)
-						update_domain_attr(dattr
+						update_domain_attr_tree(dattr
 								   + nslot, b);
 				}
 			}
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch


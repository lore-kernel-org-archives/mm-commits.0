From: akpm@linux-foundation.org
Subject: + cpuset-speed-up-sched-domain-partition.patch added to -mm tree
Date: Sun, 27 Jul 2008 20:27:00 -0700
Message-ID: <200807280327.m6S3R0Wv017926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752429AbYG1D2M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jul 2008 23:28:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@in.ibm.com, clg@fr.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, laijs@cn.fujitsu.com, menage@google.com, pj@sgi.com


The patch titled
     cpuset: speed up sched domain partition
has been added to the -mm tree.  Its filename is
     cpuset-speed-up-sched-domain-partition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: speed up sched domain partition
From: Li Zefan <lizf@cn.fujitsu.com>

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
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   41 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

diff -puN kernel/cpuset.c~cpuset-speed-up-sched-domain-partition kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-speed-up-sched-domain-partition
+++ a/kernel/cpuset.c
@@ -485,13 +485,38 @@ static int cpusets_overlap(struct cpuset
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
@@ -611,8 +636,16 @@ void rebuild_sched_domains(void)
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
@@ -683,7 +716,7 @@ restart:
 					cpus_or(*dp, *dp, b->cpus_allowed);
 					b->pn = -1;
 					if (dattr)
-						update_domain_attr(dattr
+						update_domain_attr_tree(dattr
 								   + nslot, b);
 				}
 			}
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
cgroup-fix-possible-memory-leak.patch
cgroup-remove-duplicate-code-in-allocate_cg_link.patch
cgroup-uninline-cgroup_has_css_refs.patch
memcg-remove-redundant-check-in-move_task.patch
cpuset-a-bit-cleanup-for-scan_for_empty_cpusets.patch
cpuset-clean-up-cpuset-hierarchy-traversal-code.patch
cpuset-speed-up-sched-domain-partition.patch
cpuset-fix-wrong-calculation-of-relax-domain-level.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch


From: akpm@linux-foundation.org
Subject: + cpuset-a-bit-cleanup-for-scan_for_empty_cpusets.patch added to -mm tree
Date: Sun, 27 Jul 2008 20:26:56 -0700
Message-ID: <200807280326.m6S3Qu2v017920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752284AbYG1D2L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jul 2008 23:28:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@in.ibm.com, clg@fr.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, pj@sgi.com


The patch titled
     cpuset: a bit cleanup for scan_for_empty_cpusets()
has been added to the -mm tree.  Its filename is
     cpuset-a-bit-cleanup-for-scan_for_empty_cpusets.patch

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
Subject: cpuset: a bit cleanup for scan_for_empty_cpusets()
From: Li Zefan <lizf@cn.fujitsu.com>

clean up hierarchy traversal code

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN kernel/cpuset.c~cpuset-a-bit-cleanup-for-scan_for_empty_cpusets kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-a-bit-cleanup-for-scan_for_empty_cpusets
+++ a/kernel/cpuset.c
@@ -1833,24 +1833,21 @@ static void remove_tasks_in_empty_cpuset
  */
 static void scan_for_empty_cpusets(const struct cpuset *root)
 {
+	LIST_HEAD(queue);
 	struct cpuset *cp;	/* scans cpusets being updated */
 	struct cpuset *child;	/* scans child cpusets of cp */
-	struct list_head queue;
 	struct cgroup *cont;
 	nodemask_t oldmems;
 
-	INIT_LIST_HEAD(&queue);
-
 	list_add_tail((struct list_head *)&root->stack_list, &queue);
 
 	while (!list_empty(&queue)) {
-		cp = container_of(queue.next, struct cpuset, stack_list);
+		cp = list_first_entry(&queue, struct cpuset, stack_list);
 		list_del(queue.next);
 		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
 			child = cgroup_cs(cont);
 			list_add_tail(&child->stack_list, &queue);
 		}
-		cont = cp->css.cgroup;
 
 		/* Continue past cpusets with all cpus, mems online */
 		if (cpus_subset(cp->cpus_allowed, cpu_online_map) &&
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


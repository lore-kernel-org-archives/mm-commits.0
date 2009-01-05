From: akpm@linux-foundation.org
Subject: + cpuset-convert-cpuset_attach-to-use-cpumask_var_t.patch added to -mm tree
Date: Sun, 04 Jan 2009 23:47:59 -0800
Message-ID: <200901050747.n057lxdx026528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346AbZAEHsT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 02:48:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com, mingo@elte.hu, rusty@rustcorp.com.au, travis@sgi.com


The patch titled
     cpuset: convert cpuset_attach() to use cpumask_var_t
has been added to the -mm tree.  Its filename is
     cpuset-convert-cpuset_attach-to-use-cpumask_var_t.patch

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
Subject: cpuset: convert cpuset_attach() to use cpumask_var_t
From: Li Zefan <lizf@cn.fujitsu.com>

Impact: reduce stack usage

Allocate a cpumask_var_t in cpuset_can_attach() and then use it in
cpuset_attach(), so we won't fail cpuset_attach().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Mike Travis <travis@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff -puN kernel/cpuset.c~cpuset-convert-cpuset_attach-to-use-cpumask_var_t kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-convert-cpuset_attach-to-use-cpumask_var_t
+++ a/kernel/cpuset.c
@@ -1306,6 +1306,14 @@ static int fmeter_getrate(struct fmeter 
 	return val;
 }
 
+/*
+ * Since cpuset_attach() can't fail, we allocate a cpumask_var_t in
+ * cpuset_can_attach() and then use it in cpuset_attach().
+ *
+ * Protected by cgroup_lock.
+ */
+static cpumask_var_t cpus_attach;
+
 /* Called by cgroups to determine if a cpuset is usable; cgroup_mutex held */
 static int cpuset_can_attach(struct cgroup_subsys *ss,
 			     struct cgroup *cont, struct task_struct *tsk)
@@ -1321,16 +1329,25 @@ static int cpuset_can_attach(struct cgro
 		if (!cpus_equal(tsk->cpus_allowed, cs->cpus_allowed))
 			ret = -EINVAL;
 		mutex_unlock(&callback_mutex);
+
+		if (ret)
+			return ret;
 	}
 
-	return ret < 0 ? ret : security_task_setscheduler(tsk, 0, NULL);
+	ret = security_task_setscheduler(tsk, 0, NULL);
+	if (ret)
+		return ret;
+
+	if (!alloc_cpumask_var(&cpus_attach, GFP_KERNEL))
+		return -ENOMEM;
+
+	return 0;
 }
 
 static void cpuset_attach(struct cgroup_subsys *ss,
 			  struct cgroup *cont, struct cgroup *oldcont,
 			  struct task_struct *tsk)
 {
-	cpumask_t cpus;
 	nodemask_t from, to;
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
@@ -1338,15 +1355,15 @@ static void cpuset_attach(struct cgroup_
 	int err;
 
 	if (cs == &top_cpuset) {
-		cpus = cpu_possible_map;
+		cpumask_copy(cpus_attach, cpu_possible_mask);
 	} else {
 		mutex_lock(&callback_mutex);
-		guarantee_online_cpus(cs, &cpus);
+		guarantee_online_cpus(cs, cpus_attach);
 		mutex_unlock(&callback_mutex);
 	}
-	err = set_cpus_allowed_ptr(tsk, &cpus);
+	err = set_cpus_allowed_ptr(tsk, cpus_attach);
 	if (err)
-		return;
+		goto out;
 
 	from = oldcs->mems_allowed;
 	to = cs->mems_allowed;
@@ -1358,6 +1375,8 @@ static void cpuset_attach(struct cgroup_
 		mmput(mm);
 	}
 
+out:
+	free_cpumask_var(cpus_attach);
 }
 
 /* The various types of files and directories in a cpuset file system */
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
vfs-factor-out-duplicated-code-in-get_fs_type.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed-fix.patch
cgroups-documentation-updates.patch
cgroups-remove-some-redundant-null-checks.patch
ns_cgroup-remove-unused-spinlock.patch
memcg-fix-a-typo-in-kconfig.patch
cgroups-make-root_list-contains-active-hierarchies-only.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code-fix.patch
cgroups-make-cgroup_path-rcu-safe.patch
cgroups-make-cgroup_path-rcu-safe-fixlet.patch
devices-cgroup-allow-mkfifo.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch
memcg-add-mem_cgroup_disabled-fix.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
memcg-fix-reclaim-result-checks.patch
memcg-swapout-refcnt-fix.patch
memcg-fix-double-free-and-make-refcnt-sane.patch
memcg-use-css_tryget-in-memcg.patch
memcg-use-css_tryget-in-memcg-fix.patch
memcg-fix-lru-accounting-for-swapcache-v2.patch
memcg-fix-shmems-swap-accounting.patch
cgroups-add-a-per-subsystem-hierarchy_mutex.patch
cgroups-use-hierarchy_mutex-in-memory-controller.patch
cgroups-add-css_tryget.patch
cpuset-remove-on-stack-cpumask_t-in-cpuset_sprintf_cpulist.patch
cpuset-remove-on-stack-cpumask_t-in-cpuset_can_attach.patch
cpuset-convert-cpuset_attach-to-use-cpumask_var_t.patch
cpuset-dont-allocate-trial-cpuset-on-stack.patch
cpuset-convert-cpuset-cpus_allowed-to-cpumask_var_t.patch
cpuset-remove-remaining-pointers-to-cpumask_t.patch


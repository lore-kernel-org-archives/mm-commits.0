From: akpm@linux-foundation.org
Subject: + cpuset-remove-remaining-pointers-to-cpumask_t.patch added to -mm tree
Date: Sun, 04 Jan 2009 23:48:05 -0800
Message-ID: <200901050748.n057m5vj026625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369AbZAEHsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 02:48:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com, mingo@elte.hu, rusty@rustcorp.com.au, travis@sgi.com


The patch titled
     cpuset: remove remaining pointers to cpumask_t
has been added to the -mm tree.  Its filename is
     cpuset-remove-remaining-pointers-to-cpumask_t.patch

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
Subject: cpuset: remove remaining pointers to cpumask_t
From: Li Zefan <lizf@cn.fujitsu.com>

Impact: cleanups, use new cpumask API

Final trivial cleanups: mainly s/cpumask_t/struct cpumask

Note there is a FIXME in generate_sched_domains(). A future patch will
change struct cpumask *doms to struct cpumask *doms[].
(I suppose Rusty will do this.)

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Mike Travis <travis@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |   10 ++++++----
 kernel/cpuset.c        |   28 +++++++++++++++-------------
 2 files changed, 21 insertions(+), 17 deletions(-)

diff -puN include/linux/cpuset.h~cpuset-remove-remaining-pointers-to-cpumask_t include/linux/cpuset.h
--- a/include/linux/cpuset.h~cpuset-remove-remaining-pointers-to-cpumask_t
+++ a/include/linux/cpuset.h
@@ -20,8 +20,9 @@ extern int number_of_cpusets;	/* How man
 extern int cpuset_init_early(void);
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
-extern void cpuset_cpus_allowed(struct task_struct *p, cpumask_t *mask);
-extern void cpuset_cpus_allowed_locked(struct task_struct *p, cpumask_t *mask);
+extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
+extern void cpuset_cpus_allowed_locked(struct task_struct *p,
+				       struct cpumask *mask);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -86,12 +87,13 @@ static inline int cpuset_init_early(void
 static inline int cpuset_init(void) { return 0; }
 static inline void cpuset_init_smp(void) {}
 
-static inline void cpuset_cpus_allowed(struct task_struct *p, cpumask_t *mask)
+static inline void cpuset_cpus_allowed(struct task_struct *p,
+				       struct cpumask *mask)
 {
 	*mask = cpu_possible_map;
 }
 static inline void cpuset_cpus_allowed_locked(struct task_struct *p,
-								cpumask_t *mask)
+					      struct cpumask *mask)
 {
 	*mask = cpu_possible_map;
 }
diff -puN kernel/cpuset.c~cpuset-remove-remaining-pointers-to-cpumask_t kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-remove-remaining-pointers-to-cpumask_t
+++ a/kernel/cpuset.c
@@ -289,7 +289,8 @@ static struct file_system_type cpuset_fs
  * Call with callback_mutex held.
  */
 
-static void guarantee_online_cpus(const struct cpuset *cs, cpumask_t *pmask)
+static void guarantee_online_cpus(const struct cpuset *cs,
+				  struct cpumask *pmask)
 {
 	while (cs && !cpumask_intersects(cs->cpus_allowed, cpu_online_mask))
 		cs = cs->parent;
@@ -610,7 +611,8 @@ update_domain_attr_tree(struct sched_dom
  *	element of the partition (one sched domain) to be passed to
  *	partition_sched_domains().
  */
-static int generate_sched_domains(cpumask_t **domains,
+/* FIXME: see the FIXME in partition_sched_domains() */
+static int generate_sched_domains(struct cpumask **domains,
 			struct sched_domain_attr **attributes)
 {
 	LIST_HEAD(q);		/* queue of cpusets to be scanned */
@@ -618,10 +620,10 @@ static int generate_sched_domains(cpumas
 	struct cpuset **csa;	/* array of all cpuset ptrs */
 	int csn;		/* how many cpuset ptrs in csa so far */
 	int i, j, k;		/* indices for partition finding loops */
-	cpumask_t *doms;	/* resulting partition; i.e. sched domains */
+	struct cpumask *doms;	/* resulting partition; i.e. sched domains */
 	struct sched_domain_attr *dattr;  /* attributes for custom domains */
 	int ndoms = 0;		/* number of sched domains in result */
-	int nslot;		/* next empty doms[] cpumask_t slot */
+	int nslot;		/* next empty doms[] struct cpumask slot */
 
 	doms = NULL;
 	dattr = NULL;
@@ -629,7 +631,7 @@ static int generate_sched_domains(cpumas
 
 	/* Special case for the 99% of systems with one, full, sched domain */
 	if (is_sched_load_balance(&top_cpuset)) {
-		doms = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
+		doms = kmalloc(cpumask_size(), GFP_KERNEL);
 		if (!doms)
 			goto done;
 
@@ -708,7 +710,7 @@ restart:
 	 * Now we know how many domains to create.
 	 * Convert <csn, csa> to <ndoms, doms> and populate cpu masks.
 	 */
-	doms = kmalloc(ndoms * sizeof(cpumask_t), GFP_KERNEL);
+	doms = kmalloc(ndoms * cpumask_size(), GFP_KERNEL);
 	if (!doms)
 		goto done;
 
@@ -720,7 +722,7 @@ restart:
 
 	for (nslot = 0, i = 0; i < csn; i++) {
 		struct cpuset *a = csa[i];
-		cpumask_t *dp;
+		struct cpumask *dp;
 		int apn = a->pn;
 
 		if (apn < 0) {
@@ -743,7 +745,7 @@ restart:
 			continue;
 		}
 
-		cpus_clear(*dp);
+		cpumask_clear(dp);
 		if (dattr)
 			*(dattr + nslot) = SD_ATTR_INIT;
 		for (j = i; j < csn; j++) {
@@ -790,7 +792,7 @@ done:
 static void do_rebuild_sched_domains(struct work_struct *unused)
 {
 	struct sched_domain_attr *attr;
-	cpumask_t *doms;
+	struct cpumask *doms;
 	int ndoms;
 
 	get_online_cpus();
@@ -2059,7 +2061,7 @@ static int cpuset_track_online_cpus(stru
 				unsigned long phase, void *unused_cpu)
 {
 	struct sched_domain_attr *attr;
-	cpumask_t *doms;
+	struct cpumask *doms;
 	int ndoms;
 
 	switch (phase) {
@@ -2129,7 +2131,7 @@ void __init cpuset_init_smp(void)
 /**
  * cpuset_cpus_allowed - return cpus_allowed mask from a tasks cpuset.
  * @tsk: pointer to task_struct from which to obtain cpuset->cpus_allowed.
- * @pmask: pointer to cpumask_t variable to receive cpus_allowed set.
+ * @pmask: pointer to struct cpumask variable to receive cpus_allowed set.
  *
  * Description: Returns the cpumask_var_t cpus_allowed of the cpuset
  * attached to the specified @tsk.  Guaranteed to return some non-empty
@@ -2137,7 +2139,7 @@ void __init cpuset_init_smp(void)
  * tasks cpuset.
  **/
 
-void cpuset_cpus_allowed(struct task_struct *tsk, cpumask_t *pmask)
+void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 {
 	mutex_lock(&callback_mutex);
 	cpuset_cpus_allowed_locked(tsk, pmask);
@@ -2148,7 +2150,7 @@ void cpuset_cpus_allowed(struct task_str
  * cpuset_cpus_allowed_locked - return cpus_allowed mask from a tasks cpuset.
  * Must be called with callback_mutex held.
  **/
-void cpuset_cpus_allowed_locked(struct task_struct *tsk, cpumask_t *pmask)
+void cpuset_cpus_allowed_locked(struct task_struct *tsk, struct cpumask *pmask)
 {
 	task_lock(tsk);
 	guarantee_online_cpus(task_cs(tsk), pmask);
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


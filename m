From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 07 Jun 2012 11:51:05 -0700
Message-ID: <20120607185107.981D3A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53824 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab2FGSvJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2012 14:51:09 -0400
Received: by vcbfl13 with SMTP id fl13so90022vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Jun 2012 11:51:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c                   |   11 ---
 tools/power/x86/turbostat/turbostat.c |   85 ------------------------
 2 files changed, 96 deletions(-)

diff -puN kernel/sched/fair.c~linux-next-git-rejects kernel/sched/fair.c
--- a/kernel/sched/fair.c~linux-next-git-rejects
+++ a/kernel/sched/fair.c
@@ -3698,7 +3698,6 @@ unsigned long scale_rt_power(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	u64 total, available, age_stamp, avg;
-<<<<<<< HEAD
 
 	/*
 	 * Since we're reading these variables without serialization make sure
@@ -3707,16 +3706,6 @@ unsigned long scale_rt_power(int cpu)
 	age_stamp = ACCESS_ONCE(rq->age_stamp);
 	avg = ACCESS_ONCE(rq->rt_avg);
 
-=======
-
-	/*
-	 * Since we're reading these variables without serialization make sure
-	 * we read them once before doing sanity checks on them.
-	 */
-	age_stamp = ACCESS_ONCE(rq->age_stamp);
-	avg = ACCESS_ONCE(rq->rt_avg);
-
->>>>>>> linux-next/akpm-base
 	total = sched_avg_period() + (rq->clock - age_stamp);
 
 	if (unlikely(total < avg)) {
diff -puN tools/power/x86/turbostat/turbostat.c~linux-next-git-rejects tools/power/x86/turbostat/turbostat.c
--- a/tools/power/x86/turbostat/turbostat.c~linux-next-git-rejects
+++ a/tools/power/x86/turbostat/turbostat.c
@@ -75,83 +75,6 @@ int aperf_mperf_unstable;
 int backwards_count;
 char *progname;
 
-<<<<<<< HEAD
-int num_cpus;
-cpu_set_t *cpu_present_set, *cpu_mask;
-size_t cpu_present_setsize, cpu_mask_size;
-
-struct counters {
-	unsigned long long tsc;		/* per thread */
-	unsigned long long aperf;	/* per thread */
-	unsigned long long mperf;	/* per thread */
-	unsigned long long c1;	/* per thread (calculated) */
-	unsigned long long c3;	/* per core */
-	unsigned long long c6;	/* per core */
-	unsigned long long c7;	/* per core */
-	unsigned long long pc2;	/* per package */
-	unsigned long long pc3;	/* per package */
-	unsigned long long pc6;	/* per package */
-	unsigned long long pc7;	/* per package */
-	unsigned long long extra_msr;	/* per thread */
-	int pkg;
-	int core;
-	int cpu;
-	struct counters *next;
-};
-
-struct counters *cnt_even;
-struct counters *cnt_odd;
-struct counters *cnt_delta;
-struct counters *cnt_average;
-struct timeval tv_even;
-struct timeval tv_odd;
-struct timeval tv_delta;
-
-int mark_cpu_present(int pkg, int core, int cpu)
-{
-	CPU_SET_S(cpu, cpu_present_setsize, cpu_present_set);
-	return 0;
-}
-
-/*
- * cpu_mask_init(ncpus)
- *
- * allocate and clear cpu_mask
- * set cpu_mask_size
- */
-void cpu_mask_init(int ncpus)
-{
-	cpu_mask = CPU_ALLOC(ncpus);
-	if (cpu_mask == NULL) {
-		perror("CPU_ALLOC");
-		exit(3);
-	}
-	cpu_mask_size = CPU_ALLOC_SIZE(ncpus);
-	CPU_ZERO_S(cpu_mask_size, cpu_mask);
-
-	/*
-	 * Allocate and initialize cpu_present_set
-	 */
-	cpu_present_set = CPU_ALLOC(ncpus);
-	if (cpu_present_set == NULL) {
-		perror("CPU_ALLOC");
-		exit(3);
-	}
-	cpu_present_setsize = CPU_ALLOC_SIZE(ncpus);
-	CPU_ZERO_S(cpu_present_setsize, cpu_present_set);
-	for_all_cpus(mark_cpu_present);
-}
-
-void cpu_mask_uninit()
-{
-	CPU_FREE(cpu_mask);
-	cpu_mask = NULL;
-	cpu_mask_size = 0;
-	CPU_FREE(cpu_present_set);
-	cpu_present_set = NULL;
-	cpu_present_setsize = 0;
-}
-=======
 cpu_set_t *cpu_present_set, *cpu_affinity_set;
 size_t cpu_present_setsize, cpu_affinity_setsize;
 
@@ -210,7 +133,6 @@ struct topo_params {
 } topo;
 
 struct timeval tv_even, tv_odd, tv_delta;
->>>>>>> linux-next/akpm-base
 
 int cpu_migrate(int cpu)
 {
@@ -1466,17 +1388,10 @@ void turbostat_init()
 int fork_it(char **argv)
 {
 	pid_t child_pid;
-<<<<<<< HEAD
-	get_counters(cnt_even);
-
-        /* clear affinity side-effect of get_counters() */
-        sched_setaffinity(0, cpu_present_setsize, cpu_present_set);
-=======
 
 	for_all_cpus(get_counters, EVEN_COUNTERS);
 	/* clear affinity side-effect of get_counters() */
 	sched_setaffinity(0, cpu_present_setsize, cpu_present_set);
->>>>>>> linux-next/akpm-base
 	gettimeofday(&tv_even, (struct timezone *)NULL);
 
 	child_pid = fork();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
btree-fix-tree-corruption-in-btree_get_prev-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


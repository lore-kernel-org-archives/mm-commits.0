From: akpm@linux-foundation.org
Subject: [merged] memcg-use-generic-percpu-instead-of-private-implementation.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:59:20 -0400
Message-ID: <201003150659.o2F6xr76016575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935755Ab0COHAL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:00:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: use generic percpu instead of private implementation
has been removed from the -mm tree.  Its filename was
     memcg-use-generic-percpu-instead-of-private-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: use generic percpu instead of private implementation
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

When per-cpu counter for memcg was implemneted, dynamic percpu allocator
was not very good.  But now, we have good one and useful macros.  This
patch replaces memcg's private percpu counter implementation with generic
dynamic percpu allocator.

The benefits are
	- We can remove private implementation.
	- The counters will be NUMA-aware. (Current one is not...)
	- This patch makes sizeof struct mem_cgroup smaller. Then,
	  struct mem_cgroup may be fit in page size on small config.
        - About basic performance aspects, see below.

 [Before]
 # size mm/memcontrol.o
   text    data     bss     dec     hex filename
  24373    2528    4132   31033    7939 mm/memcontrol.o

 [page-fault-throuput test on 8cpu/SMP in root cgroup]
 # /root/bin/perf stat -a -e page-faults,cache-misses --repeat 5 ./multi-fault-fork 8

 Performance counter stats for './multi-fault-fork 8' (5 runs):

       45878618  page-faults                ( +-   0.110% )
      602635826  cache-misses               ( +-   0.105% )

   61.005373262  seconds time elapsed   ( +-   0.004% )

 Then cache-miss/page fault = 13.14

 [After]
 #size mm/memcontrol.o
   text    data     bss     dec     hex filename
  23913    2528    4132   30573    776d mm/memcontrol.o
 # /root/bin/perf stat -a -e page-faults,cache-misses --repeat 5 ./multi-fault-fork 8

 Performance counter stats for './multi-fault-fork 8' (5 runs):

       48179400  page-faults                ( +-   0.271% )
      588628407  cache-misses               ( +-   0.136% )

   61.004615021  seconds time elapsed   ( +-   0.004% )

  Then cache-miss/page fault = 12.22

 Text size is reduced.
 This performance improvement is not big and will be invisible in real world
 applications. But this result shows this patch has some good effect even
 on (small) SMP.


Here is a test program I used.

 1. fork() processes on each cpus.
 2. do page fault repeatedly on each process.
 3. after 60secs, kill all childredn and exit.

(3 is necessary for getting stable data, this is improvement from previous one.)

#define _GNU_SOURCE
#include <stdio.h>
#include <sched.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>
#include <stdlib.h>

/*
 * For avoiding contention in page table lock, FAULT area is
 * sparse. If FAULT_LENGTH is too large for your cpus, decrease it.
 */
#define FAULT_LENGTH	(2 * 1024 * 1024)
#define PAGE_SIZE	4096
#define MAXNUM		(128)

void alarm_handler(int sig)
{
}

void *worker(int cpu, int ppid)
{
	void *start, *end;
	char *c;
	cpu_set_t set;
	int i;

	CPU_ZERO(&set);
	CPU_SET(cpu, &set);
	sched_setaffinity(0, sizeof(set), &set);

	start = mmap(NULL, FAULT_LENGTH, PROT_READ|PROT_WRITE,
			MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
	if (start == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}
	end = start + FAULT_LENGTH;

	pause();
	//fprintf(stderr, "run%d", cpu);
	while (1) {
		for (c = (char*)start; (void *)c < end; c += PAGE_SIZE)
			*c = 0;
		madvise(start, FAULT_LENGTH, MADV_DONTNEED);
	}
	return NULL;
}

int main(int argc, char *argv[])
{
	int num, i, ret, pid, status;
	int pids[MAXNUM];

	if (argc < 2)
		return 0;

	setpgid(0, 0);
	signal(SIGALRM, alarm_handler);
	num = atoi(argv[1]);	
	pid = getpid();

	for (i = 0; i < num; ++i) {
		ret = fork();
		if (!ret) {
			worker(i, pid);
			exit(0);
		}
		pids[i] = ret;
	}
	sleep(1);
	kill(-pid, SIGALRM);
	sleep(60);
	for (i = 0; i < num; i++)
		kill(pids[i], SIGKILL);
	for (i = 0; i < num; i++)
		waitpid(pids[i], &status, 0);
	return 0;
}

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  184 +++++++++++++++-------------------------------
 1 file changed, 63 insertions(+), 121 deletions(-)

diff -puN mm/memcontrol.c~memcg-use-generic-percpu-instead-of-private-implementation mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-generic-percpu-instead-of-private-implementation
+++ a/mm/memcontrol.c
@@ -89,54 +89,8 @@ enum mem_cgroup_stat_index {
 
 struct mem_cgroup_stat_cpu {
 	s64 count[MEM_CGROUP_STAT_NSTATS];
-} ____cacheline_aligned_in_smp;
-
-struct mem_cgroup_stat {
-	struct mem_cgroup_stat_cpu cpustat[0];
 };
 
-static inline void
-__mem_cgroup_stat_set_safe(struct mem_cgroup_stat_cpu *stat,
-				enum mem_cgroup_stat_index idx, s64 val)
-{
-	stat->count[idx] = val;
-}
-
-static inline s64
-__mem_cgroup_stat_read_local(struct mem_cgroup_stat_cpu *stat,
-				enum mem_cgroup_stat_index idx)
-{
-	return stat->count[idx];
-}
-
-/*
- * For accounting under irq disable, no need for increment preempt count.
- */
-static inline void __mem_cgroup_stat_add_safe(struct mem_cgroup_stat_cpu *stat,
-		enum mem_cgroup_stat_index idx, int val)
-{
-	stat->count[idx] += val;
-}
-
-static s64 mem_cgroup_read_stat(struct mem_cgroup_stat *stat,
-		enum mem_cgroup_stat_index idx)
-{
-	int cpu;
-	s64 ret = 0;
-	for_each_possible_cpu(cpu)
-		ret += stat->cpustat[cpu].count[idx];
-	return ret;
-}
-
-static s64 mem_cgroup_local_usage(struct mem_cgroup_stat *stat)
-{
-	s64 ret;
-
-	ret = mem_cgroup_read_stat(stat, MEM_CGROUP_STAT_CACHE);
-	ret += mem_cgroup_read_stat(stat, MEM_CGROUP_STAT_RSS);
-	return ret;
-}
-
 /*
  * per-zone information in memory controller.
  */
@@ -270,9 +224,9 @@ struct mem_cgroup {
 	unsigned long 	move_charge_at_immigrate;
 
 	/*
-	 * statistics. This must be placed at the end of memcg.
+	 * percpu counter.
 	 */
-	struct mem_cgroup_stat stat;
+	struct mem_cgroup_stat_cpu *stat;
 };
 
 /* Stuffs for move charges at task migration. */
@@ -441,19 +395,14 @@ mem_cgroup_remove_exceeded(struct mem_cg
 static bool mem_cgroup_soft_limit_check(struct mem_cgroup *mem)
 {
 	bool ret = false;
-	int cpu;
 	s64 val;
-	struct mem_cgroup_stat_cpu *cpustat;
 
-	cpu = get_cpu();
-	cpustat = &mem->stat.cpustat[cpu];
-	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_SOFTLIMIT);
+	val = this_cpu_read(mem->stat->count[MEM_CGROUP_STAT_SOFTLIMIT]);
 	if (unlikely(val < 0)) {
-		__mem_cgroup_stat_set_safe(cpustat, MEM_CGROUP_STAT_SOFTLIMIT,
+		this_cpu_write(mem->stat->count[MEM_CGROUP_STAT_SOFTLIMIT],
 				SOFTLIMIT_EVENTS_THRESH);
 		ret = true;
 	}
-	put_cpu();
 	return ret;
 }
 
@@ -549,17 +498,31 @@ mem_cgroup_largest_soft_limit_node(struc
 	return mz;
 }
 
+static s64 mem_cgroup_read_stat(struct mem_cgroup *mem,
+		enum mem_cgroup_stat_index idx)
+{
+	int cpu;
+	s64 val = 0;
+
+	for_each_possible_cpu(cpu)
+		val += per_cpu(mem->stat->count[idx], cpu);
+	return val;
+}
+
+static s64 mem_cgroup_local_usage(struct mem_cgroup *mem)
+{
+	s64 ret;
+
+	ret = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_RSS);
+	ret += mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_CACHE);
+	return ret;
+}
+
 static void mem_cgroup_swap_statistics(struct mem_cgroup *mem,
 					 bool charge)
 {
 	int val = (charge) ? 1 : -1;
-	struct mem_cgroup_stat *stat = &mem->stat;
-	struct mem_cgroup_stat_cpu *cpustat;
-	int cpu = get_cpu();
-
-	cpustat = &stat->cpustat[cpu];
-	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_SWAPOUT, val);
-	put_cpu();
+	this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_SWAPOUT], val);
 }
 
 static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
@@ -567,26 +530,22 @@ static void mem_cgroup_charge_statistics
 					 bool charge)
 {
 	int val = (charge) ? 1 : -1;
-	struct mem_cgroup_stat *stat = &mem->stat;
-	struct mem_cgroup_stat_cpu *cpustat;
-	int cpu = get_cpu();
 
-	cpustat = &stat->cpustat[cpu];
+	preempt_disable();
+
 	if (PageCgroupCache(pc))
-		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_CACHE, val);
+		__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_CACHE], val);
 	else
-		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_RSS, val);
+		__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_RSS], val);
 
 	if (charge)
-		__mem_cgroup_stat_add_safe(cpustat,
-				MEM_CGROUP_STAT_PGPGIN_COUNT, 1);
+		__this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_PGPGIN_COUNT]);
 	else
-		__mem_cgroup_stat_add_safe(cpustat,
-				MEM_CGROUP_STAT_PGPGOUT_COUNT, 1);
-	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_SOFTLIMIT, -1);
-	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_THRESHOLDS, -1);
+		__this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_PGPGOUT_COUNT]);
+	__this_cpu_dec(mem->stat->count[MEM_CGROUP_STAT_SOFTLIMIT]);
+	__this_cpu_dec(mem->stat->count[MEM_CGROUP_STAT_THRESHOLDS]);
 
-	put_cpu();
+	preempt_enable();
 }
 
 static unsigned long mem_cgroup_get_local_zonestat(struct mem_cgroup *mem,
@@ -1244,7 +1203,7 @@ static int mem_cgroup_hierarchical_recla
 				}
 			}
 		}
-		if (!mem_cgroup_local_usage(&victim->stat)) {
+		if (!mem_cgroup_local_usage(victim)) {
 			/* this cgroup's local usage == 0 */
 			css_put(&victim->css);
 			continue;
@@ -1310,9 +1269,6 @@ static void record_last_oom(struct mem_c
 void mem_cgroup_update_file_mapped(struct page *page, int val)
 {
 	struct mem_cgroup *mem;
-	struct mem_cgroup_stat *stat;
-	struct mem_cgroup_stat_cpu *cpustat;
-	int cpu;
 	struct page_cgroup *pc;
 
 	pc = lookup_page_cgroup(page);
@@ -1328,13 +1284,10 @@ void mem_cgroup_update_file_mapped(struc
 		goto done;
 
 	/*
-	 * Preemption is already disabled, we don't need get_cpu()
+	 * Preemption is already disabled. We can use __this_cpu_xxx
 	 */
-	cpu = smp_processor_id();
-	stat = &mem->stat;
-	cpustat = &stat->cpustat[cpu];
+	__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_FILE_MAPPED], val);
 
-	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_FILE_MAPPED, val);
 done:
 	unlock_page_cgroup(pc);
 }
@@ -1761,9 +1714,6 @@ static void __mem_cgroup_move_account(st
 	struct mem_cgroup *from, struct mem_cgroup *to, bool uncharge)
 {
 	struct page *page;
-	int cpu;
-	struct mem_cgroup_stat *stat;
-	struct mem_cgroup_stat_cpu *cpustat;
 
 	VM_BUG_ON(from == to);
 	VM_BUG_ON(PageLRU(pc->page));
@@ -1773,18 +1723,11 @@ static void __mem_cgroup_move_account(st
 
 	page = pc->page;
 	if (page_mapped(page) && !PageAnon(page)) {
-		cpu = smp_processor_id();
-		/* Update mapped_file data for mem_cgroup "from" */
-		stat = &from->stat;
-		cpustat = &stat->cpustat[cpu];
-		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_FILE_MAPPED,
-						-1);
-
-		/* Update mapped_file data for mem_cgroup "to" */
-		stat = &to->stat;
-		cpustat = &stat->cpustat[cpu];
-		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_FILE_MAPPED,
-						1);
+		/* Update mapped_file data for mem_cgroup */
+		preempt_disable();
+		__this_cpu_dec(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
+		__this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
+		preempt_enable();
 	}
 	mem_cgroup_charge_statistics(from, pc, false);
 	if (uncharge)
@@ -2885,7 +2828,7 @@ static int
 mem_cgroup_get_idx_stat(struct mem_cgroup *mem, void *data)
 {
 	struct mem_cgroup_idx_data *d = data;
-	d->val += mem_cgroup_read_stat(&mem->stat, d->idx);
+	d->val += mem_cgroup_read_stat(mem, d->idx);
 	return 0;
 }
 
@@ -3134,18 +3077,18 @@ static int mem_cgroup_get_local_stat(str
 	s64 val;
 
 	/* per cpu stat */
-	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_CACHE);
+	val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_CACHE);
 	s->stat[MCS_CACHE] += val * PAGE_SIZE;
-	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_RSS);
+	val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_RSS);
 	s->stat[MCS_RSS] += val * PAGE_SIZE;
-	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_FILE_MAPPED);
+	val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_FILE_MAPPED);
 	s->stat[MCS_FILE_MAPPED] += val * PAGE_SIZE;
-	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_PGPGIN_COUNT);
+	val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_PGPGIN_COUNT);
 	s->stat[MCS_PGPGIN] += val;
-	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_PGPGOUT_COUNT);
+	val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_PGPGOUT_COUNT);
 	s->stat[MCS_PGPGOUT] += val;
 	if (do_swap_account) {
-		val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_SWAPOUT);
+		val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_SWAPOUT);
 		s->stat[MCS_SWAP] += val * PAGE_SIZE;
 	}
 
@@ -3276,19 +3219,14 @@ static int mem_cgroup_swappiness_write(s
 static bool mem_cgroup_threshold_check(struct mem_cgroup *mem)
 {
 	bool ret = false;
-	int cpu;
 	s64 val;
-	struct mem_cgroup_stat_cpu *cpustat;
 
-	cpu = get_cpu();
-	cpustat = &mem->stat.cpustat[cpu];
-	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_THRESHOLDS);
+	val = this_cpu_read(mem->stat->count[MEM_CGROUP_STAT_THRESHOLDS]);
 	if (unlikely(val < 0)) {
-		__mem_cgroup_stat_set_safe(cpustat, MEM_CGROUP_STAT_THRESHOLDS,
+		this_cpu_write(mem->stat->count[MEM_CGROUP_STAT_THRESHOLDS],
 				THRESHOLDS_EVENTS_THRESH);
 		ret = true;
 	}
-	put_cpu();
 	return ret;
 }
 
@@ -3676,17 +3614,12 @@ static void free_mem_cgroup_per_zone_inf
 	kfree(mem->info.nodeinfo[node]);
 }
 
-static int mem_cgroup_size(void)
-{
-	int cpustat_size = nr_cpu_ids * sizeof(struct mem_cgroup_stat_cpu);
-	return sizeof(struct mem_cgroup) + cpustat_size;
-}
-
 static struct mem_cgroup *mem_cgroup_alloc(void)
 {
 	struct mem_cgroup *mem;
-	int size = mem_cgroup_size();
+	int size = sizeof(struct mem_cgroup);
 
+	/* Can be very big if MAX_NUMNODES is very big */
 	if (size < PAGE_SIZE)
 		mem = kmalloc(size, GFP_KERNEL);
 	else
@@ -3694,6 +3627,14 @@ static struct mem_cgroup *mem_cgroup_all
 
 	if (mem)
 		memset(mem, 0, size);
+	mem->stat = alloc_percpu(struct mem_cgroup_stat_cpu);
+	if (!mem->stat) {
+		if (size < PAGE_SIZE)
+			kfree(mem);
+		else
+			vfree(mem);
+		mem = NULL;
+	}
 	return mem;
 }
 
@@ -3718,7 +3659,8 @@ static void __mem_cgroup_free(struct mem
 	for_each_node_state(node, N_POSSIBLE)
 		free_mem_cgroup_per_zone_info(mem, node);
 
-	if (mem_cgroup_size() < PAGE_SIZE)
+	free_percpu(mem->stat);
+	if (sizeof(struct mem_cgroup) < PAGE_SIZE)
 		kfree(mem);
 	else
 		vfree(mem);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance.patch
memory-hotplug-allow-setting-of-phys_device.patch
memory-hotplug-s390-set-phys_device.patch
linux-next.patch
cgroups-net_cls-as-module.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch


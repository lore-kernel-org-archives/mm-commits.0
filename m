From: akpm@linux-foundation.org
Subject: + memory-controller-soft-limit-organize-cgroups-v9-fix.patch added to -mm tree
Date: Mon, 03 Aug 2009 16:09:25 -0700
Message-ID: <200908032309.n73N9PRq026298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753426AbZHCXJo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2009 19:09:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, balbir@linux.vnet.ibm.com, jirislaby@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com


The patch titled
     memory controller: soft limit organize cgroups v9 fix
has been added to the -mm tree.  Its filename is
     memory-controller-soft-limit-organize-cgroups-v9-fix.patch

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
Subject: memory controller: soft limit organize cgroups v9 fix
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

CONFIG_CGROUP_MEM_RES_CTLR=y CONFIG_PREEMPT=y mmotm fails to boot:
Kernel panic - not syncing: No init found; after lots of scheduling
while atomics, starting from when async_thread does sd_probe_async.

mem_cgroup_soft_limit_check() was doing an unbalanced get_cpu(): don't
get_cpu if we won't need it, and put_cpu if we did get_cpu.

And fix the silliness of passing it an "over_soft_limit" argument
that just tells it to return false when false.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reported-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memory-controller-soft-limit-organize-cgroups-v9-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-soft-limit-organize-cgroups-v9-fix
+++ a/mm/memcontrol.c
@@ -334,23 +334,21 @@ mem_cgroup_remove_exceeded(struct mem_cg
 	spin_unlock(&mctz->lock);
 }
 
-static bool mem_cgroup_soft_limit_check(struct mem_cgroup *mem,
-					bool over_soft_limit)
+static bool mem_cgroup_soft_limit_check(struct mem_cgroup *mem)
 {
 	bool ret = false;
-	int cpu = get_cpu();
+	int cpu;
 	s64 val;
 	struct mem_cgroup_stat_cpu *cpustat;
 
-	if (!over_soft_limit)
-		return ret;
-
+	cpu = get_cpu();
 	cpustat = &mem->stat.cpustat[cpu];
 	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_EVENTS);
 	if (unlikely(val > SOFTLIMIT_EVENTS_THRESH)) {
 		__mem_cgroup_stat_reset_safe(cpustat, MEM_CGROUP_STAT_EVENTS);
 		ret = true;
 	}
+	put_cpu();
 	return ret;
 }
 
@@ -1231,7 +1229,7 @@ static int __mem_cgroup_try_charge(struc
 	if (soft_fail_res) {
 		mem_over_soft_limit =
 			mem_cgroup_from_res_counter(soft_fail_res, res);
-		if (mem_cgroup_soft_limit_check(mem_over_soft_limit, true))
+		if (mem_cgroup_soft_limit_check(mem_over_soft_limit))
 			mem_cgroup_update_tree(mem_over_soft_limit, page);
 	}
 	return 0;
@@ -1762,7 +1760,7 @@ __mem_cgroup_uncharge_common(struct page
 	mz = page_cgroup_zoneinfo(pc);
 	unlock_page_cgroup(pc);
 
-	if (mem_cgroup_soft_limit_check(mem, soft_limit_excess))
+	if (soft_limit_excess && mem_cgroup_soft_limit_check(mem))
 		mem_cgroup_update_tree(mem, page);
 	/* at swapout, this memcg will be accessed to record to swap */
 	if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

acpi-fix-null-bug-for-hid-uid-string.patch
mm-oom-analysis-add-shmem-vmstat.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch


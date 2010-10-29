From: akpm@linux-foundation.org
Subject: + memcg-cpu-hotplug-lockdep-warning-fix.patch added to -mm tree
Date: Fri, 29 Oct 2010 13:19:55 -0700
Message-ID: <201010292019.o9TKJtwr014980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761854Ab0J2U0D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Oct 2010 16:26:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, arighi@develer.com, fengguang.wu@intel.com, gthelen@google.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: CPU hotplug lockdep warning fix
has been added to the -mm tree.  Its filename is
     memcg-cpu-hotplug-lockdep-warning-fix.patch

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
Subject: memcg: CPU hotplug lockdep warning fix
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Recent move to get_online_cpus() ends up calling get_online_cpus() from
mem_cgroup_read_stat().  However mem_cgroup_read_stat() is called under
rcu lock.  get_online_cpus() can sleep.  The dirty limit patches expose
this BUG more readily due to their usage of mem_cgroup_page_stat()

This patch address this issue as identified by lockdep and moves the
hotplug protection to a higher layer.  This might increase the time
required to hotplug, but not by much.

Warning messages

BUG: sleeping function called from invalid context at kernel/cpu.c:62
in_atomic(): 0, irqs_disabled(): 0, pid: 6325, name: pagetest
2 locks held by pagetest/6325:
do_page_fault+0x27d/0x4a0
mem_cgroup_page_stat+0x0/0x23f
Pid: 6325, comm: pagetest Not tainted 2.6.36-rc5-mm1+ #201
Call Trace:
[<ffffffff81041224>] __might_sleep+0x12d/0x131
[<ffffffff8104f4af>] get_online_cpus+0x1c/0x51
[<ffffffff8110eedb>] mem_cgroup_read_stat+0x27/0xa3
[<ffffffff811125d2>] mem_cgroup_page_stat+0x131/0x23f
[<ffffffff811124a1>] ? mem_cgroup_page_stat+0x0/0x23f
[<ffffffff810d57c3>] global_dirty_limits+0x42/0xf8
[<ffffffff810d58b3>] throttle_vm_writeout+0x3a/0xb4
[<ffffffff810dc2f8>] shrink_zone+0x3e6/0x3f8
[<ffffffff81074a35>] ? ktime_get_ts+0xb2/0xbf
[<ffffffff810dd1aa>] do_try_to_free_pages+0x106/0x478
[<ffffffff810dd601>] try_to_free_mem_cgroup_pages+0xe5/0x14c
[<ffffffff8110f947>] mem_cgroup_hierarchical_reclaim+0x314/0x3a2
[<ffffffff81111b31>] __mem_cgroup_try_charge+0x29b/0x593
[<ffffffff8111194a>] ? __mem_cgroup_try_charge+0xb4/0x593
[<ffffffff81071258>] ? local_clock+0x40/0x59
[<ffffffff81009015>] ? sched_clock+0x9/0xd
[<ffffffff810710d5>] ? sched_clock_local+0x1c/0x82
[<ffffffff8111398a>] mem_cgroup_charge_common+0x4b/0x76
[<ffffffff81141469>] ? bio_add_page+0x36/0x38
[<ffffffff81113ba9>] mem_cgroup_cache_charge+0x1f4/0x214
[<ffffffff810cd195>] add_to_page_cache_locked+0x4a/0x148
....

Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Righi <arighi@develer.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-cpu-hotplug-lockdep-warning-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-cpu-hotplug-lockdep-warning-fix
+++ a/mm/memcontrol.c
@@ -579,7 +579,6 @@ static s64 mem_cgroup_read_stat(struct m
 	int cpu;
 	s64 val = 0;
 
-	get_online_cpus();
 	for_each_online_cpu(cpu)
 		val += per_cpu(mem->stat->count[idx], cpu);
 #ifdef CONFIG_HOTPLUG_CPU
@@ -587,7 +586,6 @@ static s64 mem_cgroup_read_stat(struct m
 	val += mem->nocpu_base.count[idx];
 	spin_unlock(&mem->pcp_counter_lock);
 #endif
-	put_online_cpus();
 	return val;
 }
 
@@ -1345,6 +1343,7 @@ s64 mem_cgroup_page_stat(enum mem_cgroup
 	struct mem_cgroup *iter;
 	s64 value;
 
+	get_online_cpus();
 	rcu_read_lock();
 	mem = mem_cgroup_from_task(current);
 	if (__mem_cgroup_has_dirty_limit(mem)) {
@@ -1366,6 +1365,7 @@ s64 mem_cgroup_page_stat(enum mem_cgroup
 	} else
 		value = -EINVAL;
 	rcu_read_unlock();
+	put_online_cpus();
 
 	return value;
 }
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
mm-smaps-export-mlock-information.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
writeback-create-dirty_info-structure.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-cpu-hotplug-lockdep-warning-fix.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch


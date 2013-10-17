From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-protect-mem_cgroup_read_events-for-cpu-hotplug.patch removed from
 -mm tree
Date: Thu, 17 Oct 2013 11:12:53 -0700
Message-ID: <526028a5.rBt2+WwRWclxV6Dt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758741Ab3JQSMy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:12:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, rientjes@google.com

Subject: [merged] mm-memcg-protect-mem_cgroup_read_events-for-cpu-hotplug.patch removed from -mm tree
To: rientjes@google.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:12:53 -0700


The patch titled
     Subject: mm, memcg: protect mem_cgroup_read_events for cpu hotplug
has been removed from the -mm tree.  Its filename was
     mm-memcg-protect-mem_cgroup_read_events-for-cpu-hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, memcg: protect mem_cgroup_read_events for cpu hotplug

for_each_online_cpu() needs the protection of {get,put}_online_cpus() so
cpu_online_mask doesn't change during the iteration.

cpu_hotplug.lock is held while a cpu is going down, it's a coarse lock
that is used kernel-wide to synchronize cpu hotplug activity.  Memcg has a
cpu hotplug notifier, called while there may not be any cpu hotplug
refcounts, which drains per-cpu event counts to memcg->nocpu_base.events
to maintain a cumulative event count as cpus disappear.  Without
get_online_cpus() in mem_cgroup_read_events(), it's possible to account
for the event count on a dying cpu twice, and this value may be
significantly large.

In fact, all memcg->pcp_counter_lock use should be nested by 
{get,put}_online_cpus().

This fixes that issue and ensures the reported statistics are not vastly
over-reported during cpu hotplug.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memcontrol.c~mm-memcg-protect-mem_cgroup_read_events-for-cpu-hotplug mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-protect-mem_cgroup_read_events-for-cpu-hotplug
+++ a/mm/memcontrol.c
@@ -866,6 +866,7 @@ static unsigned long mem_cgroup_read_eve
 	unsigned long val = 0;
 	int cpu;
 
+	get_online_cpus();
 	for_each_online_cpu(cpu)
 		val += per_cpu(memcg->stat->events[idx], cpu);
 #ifdef CONFIG_HOTPLUG_CPU
@@ -873,6 +874,7 @@ static unsigned long mem_cgroup_read_eve
 	val += memcg->nocpu_base.events[idx];
 	spin_unlock(&memcg->pcp_counter_lock);
 #endif
+	put_online_cpus();
 	return val;
 }
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
kthread-make-kthread_create-killable.patch
x86-srat-use-numa_no_node.patch
mm-vmalloc-use-numa_no_node.patch
mm-add-a-helper-function-to-check-may-oom-condition.patch
mm-arch-use-numa_no_node.patch
mm-mempolicy-make-mpol_to_str-robust-and-always-succeed.patch
mm-vmalloc-dont-set-area-caller-twice.patch
mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down.patch
mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch
revert-mm-vmallocc-emit-the-failure-message-before-return.patch
mm-mempolicy-use-numa_no_node.patch
mm-rearrange-madvise-code-to-allow-for-reuse.patch
mm-add-a-field-to-store-names-for-private-anonymous-memory.patch


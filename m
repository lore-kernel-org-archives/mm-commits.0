From: akpm@linux-foundation.org
Subject: + mm-memcg-protect-mem_cgroup_read_events-for-cpu-hotplug.patch
 added to -mm tree
Date: Thu, 03 Oct 2013 12:33:33 -0700
Message-ID: <524dc68d.70ZTIFmZuTbfywZL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab3JCTde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Oct 2013 15:33:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, rientjes@google.com

Subject: + mm-memcg-protect-mem_cgroup_read_events-for-cpu-hotplug.patch added to -mm tree
To: rientjes@google.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Thu, 03 Oct 2013 12:33:33 -0700


The patch titled
     Subject: mm, memcg: protect mem_cgroup_read_events for cpu hotplug
has been added to the -mm tree.  Its filename is
     mm-memcg-protect-mem_cgroup_read_events-for-cpu-hotplug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-protect-mem_cgroup_read_events-for-cpu-hotplug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-protect-mem_cgroup_read_events-for-cpu-hotplug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-memcg-protect-mem_cgroup_read_events-for-cpu-hotplug.patch
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
linux-next.patch


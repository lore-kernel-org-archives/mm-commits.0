From: akpm@linux-foundation.org
Subject: [merged] memcg-change-oom_info_lock-to-mutex.patch removed from
 -mm tree
Date: Thu, 27 Feb 2014 12:23:52 -0800
Message-ID: <530f9ed8.PLpXCID9j4+pKTAI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaB0UXx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Feb 2014 15:23:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, kirill.shutemov@linux.intel.com, hannes@cmpxchg.org, mhocko@suse.cz

Subject: [merged] memcg-change-oom_info_lock-to-mutex.patch removed from -mm tree
To: mhocko@suse.cz,hannes@cmpxchg.org,kirill.shutemov@linux.intel.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 27 Feb 2014 12:23:52 -0800


The patch titled
     Subject: memcg: change oom_info_lock to mutex
has been removed from the -mm tree.  Its filename was
     memcg-change-oom_info_lock-to-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: change oom_info_lock to mutex

Kirill has reported the following:
[    2.386563] Task in /test killed as a result of limit of /test
[    2.387326] memory: usage 10240kB, limit 10240kB, failcnt 51
[    2.388098] memory+swap: usage 10240kB, limit 10240kB, failcnt 0
[    2.388861] kmem: usage 0kB, limit 18014398509481983kB, failcnt 0
[    2.389640] Memory cgroup stats for /test:
[    2.390178] BUG: sleeping function called from invalid context at kernel/cpu.c:68
[    2.391516] in_atomic(): 1, irqs_disabled(): 0, pid: 66, name: memcg_test
[    2.392416] 2 locks held by memcg_test/66:
[    2.392945]  #0:  (memcg_oom_lock#2){+.+...}, at: [<ffffffff81131014>] pagefault_out_of_memory+0x14/0x90
[    2.394233]  #1:  (oom_info_lock){+.+...}, at: [<ffffffff81197b2a>] mem_cgroup_print_oom_info+0x2a/0x390
[    2.395496] CPU: 2 PID: 66 Comm: memcg_test Not tainted 3.14.0-rc1-dirty #745
[    2.396536] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Bochs 01/01/2011
[    2.397540]  ffffffff81a3cc90 ffff88081d26dba0 ffffffff81776ea3 0000000000000000
[    2.398541]  ffff88081d26dbc8 ffffffff8108418a 0000000000000000 ffff88081d15c000
[    2.399533]  0000000000000000 ffff88081d26dbd8 ffffffff8104f6bc ffff88081d26dc10
[    2.400588] Call Trace:
[    2.400908]  [<ffffffff81776ea3>] dump_stack+0x4d/0x66
[    2.401578]  [<ffffffff8108418a>] __might_sleep+0x16a/0x210
[    2.402295]  [<ffffffff8104f6bc>] get_online_cpus+0x1c/0x60
[    2.403005]  [<ffffffff8118fb67>] mem_cgroup_read_stat+0x27/0xb0
[    2.403769]  [<ffffffff81197d60>] mem_cgroup_print_oom_info+0x260/0x390
[    2.404653]  [<ffffffff8177314e>] dump_header+0x88/0x251
[    2.405342]  [<ffffffff810a3bfd>] ? trace_hardirqs_on+0xd/0x10
[    2.406098]  [<ffffffff81130618>] oom_kill_process+0x258/0x3d0
[    2.406833]  [<ffffffff81198746>] mem_cgroup_oom_synchronize+0x656/0x6c0
[    2.407674]  [<ffffffff811973a0>] ? mem_cgroup_charge_common+0xd0/0xd0
[    2.408553]  [<ffffffff81131014>] pagefault_out_of_memory+0x14/0x90
[    2.409354]  [<ffffffff817712f7>] mm_fault_error+0x91/0x189
[    2.410069]  [<ffffffff81783eae>] __do_page_fault+0x48e/0x580
[    2.410791]  [<ffffffff8108f656>] ? local_clock+0x16/0x30
[    2.411467]  [<ffffffff810a3bfd>] ? trace_hardirqs_on+0xd/0x10
[    2.412248]  [<ffffffff8177f6fc>] ? _raw_spin_unlock_irq+0x2c/0x40
[    2.413039]  [<ffffffff8108312b>] ? finish_task_switch+0x7b/0x100
[    2.413821]  [<ffffffff813b954a>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[    2.414652]  [<ffffffff81783fae>] do_page_fault+0xe/0x10
[    2.415330]  [<ffffffff81780552>] page_fault+0x22/0x30

which complains that mem_cgroup_read_stat cannot be called from an atomic
context but mem_cgroup_print_oom_info takes a spinlock.  Change
oom_info_lock to a mutex.

This was introduced by 947b3dd1a84b ("memcg, oom: lock
mem_cgroup_print_oom_info").

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-change-oom_info_lock-to-mutex mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-change-oom_info_lock-to-mutex
+++ a/mm/memcontrol.c
@@ -1687,7 +1687,7 @@ void mem_cgroup_print_oom_info(struct me
 	 * protects memcg_name and makes sure that parallel ooms do not
 	 * interleave
 	 */
-	static DEFINE_SPINLOCK(oom_info_lock);
+	static DEFINE_MUTEX(oom_info_lock);
 	struct cgroup *task_cgrp;
 	struct cgroup *mem_cgrp;
 	static char memcg_name[PATH_MAX];
@@ -1698,7 +1698,7 @@ void mem_cgroup_print_oom_info(struct me
 	if (!p)
 		return;
 
-	spin_lock(&oom_info_lock);
+	mutex_lock(&oom_info_lock);
 	rcu_read_lock();
 
 	mem_cgrp = memcg->css.cgroup;
@@ -1767,7 +1767,7 @@ done:
 
 		pr_cont("\n");
 	}
-	spin_unlock(&oom_info_lock);
+	mutex_unlock(&oom_info_lock);
 }
 
 /*
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
memcg-fix-endless-loop-in-__mem_cgroup_iter_next.patch
memcg-reparent-charges-of-children-before-processing-parent.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
drop_caches-add-some-documentation-and-info-message.patch
mm-exclude-memory-less-nodes-from-zone_reclaim.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
printk-remove-duplicated-check-for-log-level.patch
printk-remove-obsolete-check-for-log-level-c.patch
printk-add-comment-about-tricky-check-for-text-buffer-size.patch
printk-use-also-the-last-bytes-in-the-ring-buffer.patch
printk-do-not-compute-the-size-of-the-message-twice.patch
linux-next.patch


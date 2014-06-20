From: akpm@linux-foundation.org
Subject: + mm-memcontrol-rewrite-uncharge-api-fix-4.patch added to -mm
 tree
Date: Fri, 20 Jun 2014 15:26:12 -0700
Message-ID: <53a4b504.j21EG/DTwZA7EEcf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbaFTW0N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:26:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org, mhocko@suse.cz


The patch titled
     Subject: memcg: mem_cgroup_charge_statistics needs preempt_disable
has been added to the -mm tree.  Its filename is
     mm-memcontrol-rewrite-uncharge-api-fix-4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-rewrite-uncharge-api-fix-4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-rewrite-uncharge-api-fix-4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: mem_cgroup_charge_statistics needs preempt_disable

preempt_disable was previously disabled by lock_page_cgroup which has been
removed by "mm: memcontrol: rewrite uncharge API".

This fixes the a flood of splats like this:
[    3.149371] BUG: using __this_cpu_add() in preemptible [00000000] code: udevd/1271
[    3.151458] caller is __this_cpu_preempt_check+0x13/0x15
[    3.152927] CPU: 0 PID: 1271 Comm: udevd Not tainted 3.15.0-test1 #366
[    3.154637] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[    3.156788]  0000000000000000 ffff88000005fba8 ffffffff814efe3f 0000000000000000
[    3.158810]  ffff88000005fbd8 ffffffff8125b969 ffff880007413448 0000000000000001
[    3.160836]  ffffea00001e8c00 0000000000000001 ffff88000005fbe8 ffffffff8125b9a8
[    3.162950] Call Trace:
[    3.163598]  [<ffffffff814efe3f>] dump_stack+0x4e/0x7a
[    3.164942]  [<ffffffff8125b969>] check_preemption_disabled+0xd2/0xe5
[    3.166618]  [<ffffffff8125b9a8>] __this_cpu_preempt_check+0x13/0x15
[    3.168267]  [<ffffffff8112b630>] mem_cgroup_charge_statistics.isra.36+0xb5/0xc6
[    3.170169]  [<ffffffff8112d2c5>] commit_charge+0x23c/0x256
[    3.171823]  [<ffffffff8113101b>] mem_cgroup_commit_charge+0xb8/0xd7
[    3.173838]  [<ffffffff810f5dab>] shmem_getpage_gfp+0x399/0x605
[    3.175363]  [<ffffffff810f7456>] shmem_write_begin+0x3d/0x58
[    3.176854]  [<ffffffff810e1361>] generic_perform_write+0xbc/0x192
[    3.178445]  [<ffffffff8114a086>] ? file_update_time+0x34/0xac
[    3.179952]  [<ffffffff810e2ae4>] __generic_file_aio_write+0x2c0/0x300
[    3.181655]  [<ffffffff810e2b76>] generic_file_aio_write+0x52/0xbd
[    3.183234]  [<ffffffff81133944>] do_sync_write+0x59/0x78
[    3.184630]  [<ffffffff81133ea8>] vfs_write+0xc4/0x181
[    3.185957]  [<ffffffff81134801>] SyS_write+0x4a/0x91
[    3.187258]  [<ffffffff814fd30e>] tracesys+0xd0/0xd5

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/memcontrol.c~mm-memcontrol-rewrite-uncharge-api-fix-4 mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-rewrite-uncharge-api-fix-4
+++ a/mm/memcontrol.c
@@ -904,6 +904,8 @@ static void mem_cgroup_charge_statistics
 					 struct page *page,
 					 int nr_pages)
 {
+	preempt_disable();
+
 	/*
 	 * Here, RSS means 'mapped anon' and anon's SwapCache. Shmem/tmpfs is
 	 * counted as CACHE even if it's on ANON LRU.
@@ -928,6 +930,7 @@ static void mem_cgroup_charge_statistics
 	}
 
 	__this_cpu_add(memcg->stat->nr_page_events, nr_pages);
+	preempt_enable();
 }
 
 unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
_

Patches currently in -mm which might be from mhocko@suse.cz are

watchdog-remove-preemption-restrictions-when-restarting-lockup-detector.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
mm-memcontrol-rewrite-uncharge-api-fix-4.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch


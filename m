From: akpm@linux-foundation.org
Subject: [folded-merged] mm-memcontrol-rewrite-uncharge-api-fix-4.patch
 removed from -mm tree
Date: Wed, 06 Aug 2014 13:56:08 -0700
Message-ID: <53e29668.Gf9RLFeH3eCjYsyI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:64354 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444AbaHFU4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 16:56:09 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so623534igi.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 13:56:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, balbi@ti.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: mem_cgroup_charge_statistics needs preempt_disable
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-rewrite-uncharge-api-fix-4.patch

This patch was dropped because it was folded into mm-memcontrol-rewrite-uncharge-api.patch

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
Tested-by: Felipe Balbi <balbi@ti.com>
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

origin.patch
kbuild-explain-stack-protector-strong-config-logic.patch
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
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-rewrite-uncharge-api-fix-double-migration-v2.patch
mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration.patch
mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration-2.patch
mm-memcontrol-rewrite-uncharge-api-fix-clear-page-mapping-in-migration.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim-fix.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-remove-all_unreclaimable-fix.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
mm-vmscan-clean-up-struct-scan_control-v2.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-writeback-prevent-race-when-calculating-dirty-limits.patch
slub-remove-kmemcg-id-from-create_unique_id.patch
mm-vmscan-fix-an-outdated-comment-still-mentioning-get_scan_ratio.patch
memcg-vmscan-fix-forced-scan-of-anonymous-pages.patch
memcg-vmscan-fix-forced-scan-of-anonymous-pages-fix-cleanups.patch
mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
mm-memcontrol-clean-up-reclaim-size-variable-use-in-try_charge.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch


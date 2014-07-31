From: akpm@linux-foundation.org
Subject: [merged] memcg-oom_notify-use-after-free-fix.patch removed from
 -mm tree
Date: Thu, 31 Jul 2014 13:22:12 -0700
Message-ID: <53daa574.Zmrtgx0Vu9BBn2u5%akpm__49952.952101785$1406838156$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:62173 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaGaUWZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jul 2014 16:22:25 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so327479qap.4
        for <mm-commits@vger.kernel.org>; Thu, 31 Jul 2014 13:22:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, paulfurtado91@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: oom_notify use-after-free fix
has been removed from the -mm tree.  Its filename was
     memcg-oom_notify-use-after-free-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: oom_notify use-after-free fix

Paul Furtado has reported the following GPF:

general protection fault: 0000 [#1] SMP
Modules linked in: ipv6 dm_mod xen_netfront coretemp hwmon x86_pkg_temp_thermal crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 microcode pcspkr ext4 jbd2 mbcache raid0 xen_blkfront
CPU: 3 PID: 3062 Comm: java Not tainted 3.16.0-rc5 #1
task: ffff8801cfe8f170 ti: ffff8801d2ec4000 task.ti: ffff8801d2ec4000
RIP: e030:[<ffffffff811c0b80>]  [<ffffffff811c0b80>] mem_cgroup_oom_synchronize+0x140/0x240
RSP: e02b:ffff8801d2ec7d48  EFLAGS: 00010283
RAX: 0000000000000001 RBX: ffff88009d633800 RCX: 000000000000000e
RDX: fffffffffffffffe RSI: ffff88009d630200 RDI: ffff88009d630200
RBP: ffff8801d2ec7da8 R08: 0000000000000012 R09: 00000000fffffffe
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88009d633800
R13: ffff8801d2ec7d48 R14: dead000000100100 R15: ffff88009d633a30
FS:  00007f1748bb4700(0000) GS:ffff8801def80000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f4110300308 CR3: 00000000c05f7000 CR4: 0000000000002660
Stack:
 ffff88009d633800 0000000000000000 ffff8801cfe8f170 ffffffff811bae10
 ffffffff81ca73f8 ffffffff81ca73f8 ffff8801d2ec7dc8 0000000000000006
 00000000e3b30000 00000000e3b30000 ffff8801d2ec7f58 0000000000000001
Call Trace:
 [<ffffffff811bae10>] ? mem_cgroup_wait_acct_move+0x110/0x110
 [<ffffffff81159628>] pagefault_out_of_memory+0x18/0x90
 [<ffffffff8105cee9>] mm_fault_error+0xa9/0x1a0
 [<ffffffff8105d488>] __do_page_fault+0x478/0x4c0
 [<ffffffff81004f00>] ? xen_mc_flush+0xb0/0x1b0
 [<ffffffff81003ab3>] ? xen_write_msr_safe+0xa3/0xd0
 [<ffffffff81012a40>] ? __switch_to+0x2d0/0x600
 [<ffffffff8109e273>] ? finish_task_switch+0x53/0xf0
 [<ffffffff81643b0a>] ? __schedule+0x37a/0x6d0
 [<ffffffff8105d5dc>] do_page_fault+0x2c/0x40
 [<ffffffff81649858>] page_fault+0x28/0x30
Code: 44 00 00 48 89 df e8 40 ca ff ff 48 85 c0 49 89 c4 74 35 4c 8b b0 30 02 00 00 4c 8d b8 30 02 00 00 4d 39 fe 74 1b 0f 1f 44 00 00 <49> 8b 7e 10 be 01 00 00 00 e8 42 d2 04 00 4d 8b 36 4d 39 fe 75
RIP  [<ffffffff811c0b80>] mem_cgroup_oom_synchronize+0x140/0x240
 RSP <ffff8801d2ec7d48>

fb2a6fc56be6 ("mm: memcg: rework and document OOM waiting and wakeup") has
moved mem_cgroup_oom_notify outside of memcg_oom_lock assuming it is
protected by the hierarchical OOM-lock.  Although this is true for the
notification part the protection doesn't cover unregistration of event
which can happen in parallel now so mem_cgroup_oom_notify can see already
unlinked and/or freed mem_cgroup_eventfd_list.

Fix this by using memcg_oom_lock also in mem_cgroup_oom_notify.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=80881

Fixes: fb2a6fc56be6 (mm: memcg: rework and document OOM waiting and wakeup)
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Paul Furtado <paulfurtado91@gmail.com>
Tested-by: Paul Furtado <paulfurtado91@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/memcontrol.c~memcg-oom_notify-use-after-free-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-oom_notify-use-after-free-fix
+++ a/mm/memcontrol.c
@@ -5415,8 +5415,12 @@ static int mem_cgroup_oom_notify_cb(stru
 {
 	struct mem_cgroup_eventfd_list *ev;
 
+	spin_lock(&memcg_oom_lock);
+
 	list_for_each_entry(ev, &memcg->oom_notify, list)
 		eventfd_signal(ev->eventfd, 1);
+
+	spin_unlock(&memcg_oom_lock);
 	return 0;
 }
 
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
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse.patch
mm-memcontrol-rewrite-charge-api-fix-hugetlb-charging.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
mm-memcontrol-rewrite-uncharge-api-fix-4.patch
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
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: [alternative-merged] mm-cond_resched-in-tlb_flush_mmu-to-fix-soft-lockups-on-config_preempt.patch removed from -mm tree
Date: Fri, 04 Jan 2013 11:39:59 -0800
Message-ID: <20130104194001.58FDB20005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f73.google.com ([74.125.82.73]:55917 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab3ADTkF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jan 2013 14:40:05 -0500
Received: by mail-wg0-f73.google.com with SMTP id dt12so1049834wgb.4
        for <mm-commits@vger.kernel.org>; Fri, 04 Jan 2013 11:40:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, a.p.zijlstra@chello.nl, mgorman@suse.de, riel@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cond_resched in tlb_flush_mmu to fix soft lockups on !CONFIG_PREEMPT
has been removed from the -mm tree.  Its filename was
     mm-cond_resched-in-tlb_flush_mmu-to-fix-soft-lockups-on-config_preempt.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: cond_resched in tlb_flush_mmu to fix soft lockups on !CONFIG_PREEMPT

Since e303297 (mm: extended batches for generic mmu_gather) we are
batching pages to be freed until either tlb_next_batch cannot allocate a
new batch or we are done.

This works just fine most of the time but we can get in troubles with
non-preemptible kernel (CONFIG_PREEMPT_NONE or CONFIG_PREEMPT_VOLUNTARY)
on large machines where too aggressive batching might lead to soft lockups
during process exit path (exit_mmap) because there are no scheduling
points down the free_pages_and_swap_cache path and so the freeing can take
long enough to trigger the soft lockup.

The lockup is harmless except when the system is setup to panic on
softlockup which is not that unusual.

The simplest way to work around this issue is to explicitly cond_resched
per batch in tlb_flush_mmu (1020 pages on x86_64).

The following lockup has been reported for 3.0 kernel with a huge process
(in order of hundreds gigs but I do know any more details).

[65674.040540] BUG: soft lockup - CPU#56 stuck for 22s! [kernel:31053]
[65674.040544] Modules linked in: af_packet nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase autofs4 binfmt_misc dm_round_robin dm_multipath bonding cpufreq_conservative cpufreq_userspace cpufreq_powersave pcc_cpufreq mperf microcode fuse loop osst sg sd_mod crc_t10dif st qla2xxx scsi_transport_fc scsi_tgt netxen_nic i7core_edac iTCO_wdt joydev e1000e serio_raw pcspkr edac_core iTCO_vendor_support acpi_power_meter rtc_cmos hpwdt hpilo button container usbhid hid dm_mirror dm_region_hash dm_log linear uhci_hcd ehci_hcd usbcore usb_common scsi_dh_emc scsi_dh_alua scsi_dh_hp_sw scsi_dh_rdac scsi_dh dm_snapshot pcnet32 mii edd dm_mod raid1 ext3 mbcache jbd fan thermal processor thermal_sys hwmon cciss scsi_mod
[65674.040602] Supported: Yes
[65674.040604] CPU 56
[65674.040639] Pid: 31053, comm: kernel Not tainted 3.0.31-0.9-default #1 HP ProLiant DL580 G7
[65674.040643] RIP: 0010:[<ffffffff81443a88>]  [<ffffffff81443a88>] _raw_spin_unlock_irqrestore+0x8/0x10
[65674.040656] RSP: 0018:ffff883ec1037af0  EFLAGS: 00000206
[65674.040657] RAX: 0000000000000e00 RBX: ffffea01a0817e28 RCX: ffff88803ffd9e80
[65674.040659] RDX: 0000000000000200 RSI: 0000000000000206 RDI: 0000000000000206
[65674.040661] RBP: 0000000000000002 R08: 0000000000000001 R09: ffff887ec724a400
[65674.040663] R10: 0000000000000000 R11: dead000000200200 R12: ffffffff8144c26e
[65674.040665] R13: 0000000000000030 R14: 0000000000000297 R15: 000000000000000e
[65674.040667] FS:  00007ed834282700(0000) GS:ffff88c03f200000(0000) knlGS:0000000000000000
[65674.040669] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[65674.040671] CR2: 000000000068b240 CR3: 0000003ec13c5000 CR4: 00000000000006e0
[65674.040673] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[65674.040675] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[65674.040678] Process kernel (pid: 31053, threadinfo ffff883ec1036000, task ffff883ebd5d4100)
[65674.040680] Stack:
[65674.042972]  ffffffff810fc935 ffff88a9f1e182b0 0000000000000206 0000000000000009
[65674.042978]  0000000000000000 ffffea01a0817e60 ffffea0211d3a808 ffffea0211d3a840
[65674.042983]  ffffea01a0827a28 ffffea01a0827a60 ffffea0288a598c0 ffffea0288a598f8
[65674.042989] Call Trace:
[65674.045765]  [<ffffffff810fc935>] release_pages+0xc5/0x260
[65674.045779]  [<ffffffff811289dd>] free_pages_and_swap_cache+0x9d/0xc0
[65674.045786]  [<ffffffff81115d6c>] tlb_flush_mmu+0x5c/0x80
[65674.045791]  [<ffffffff8111628e>] tlb_finish_mmu+0xe/0x50
[65674.045796]  [<ffffffff8111c65d>] exit_mmap+0xbd/0x120
[65674.045805]  [<ffffffff810582d9>] mmput+0x49/0x120
[65674.045813]  [<ffffffff8105cbb2>] exit_mm+0x122/0x160
[65674.045818]  [<ffffffff8105e95a>] do_exit+0x17a/0x430
[65674.045824]  [<ffffffff8105ec4d>] do_group_exit+0x3d/0xb0
[65674.045831]  [<ffffffff8106f7c7>] get_signal_to_deliver+0x247/0x480
[65674.045840]  [<ffffffff81002931>] do_signal+0x71/0x1b0
[65674.045845]  [<ffffffff81002b08>] do_notify_resume+0x98/0xb0
[65674.045853]  [<ffffffff8144bb60>] int_signal+0x12/0x17
[65674.046737] DWARF2 unwinder stuck at int_signal+0x12/0x17

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@vger.kernel.org>	[3.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memory.c~mm-cond_resched-in-tlb_flush_mmu-to-fix-soft-lockups-on-config_preempt mm/memory.c
--- a/mm/memory.c~mm-cond_resched-in-tlb_flush_mmu-to-fix-soft-lockups-on-config_preempt
+++ a/mm/memory.c
@@ -240,6 +240,7 @@ void tlb_flush_mmu(struct mmu_gather *tl
 	for (batch = &tlb->local; batch; batch = batch->next) {
 		free_pages_and_swap_cache(batch->pages, batch->nr);
 		batch->nr = 0;
+		cond_resched();
 	}
 	tlb->active = &tlb->local;
 }
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-fix-zone_watermark_ok_safe-accounting-of-isolated-pages.patch
mm-limit-mmu_gather-batching-to-fix-soft-lockups-on-config_preempt.patch
mm-limit-mmu_gather-batching-to-fix-soft-lockups-on-config_preempt-fix.patch
memcg-oom-provide-more-precise-dump-info-while-memcg-oom-happening.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmksm-use-new-hashtable-implementation.patch
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch


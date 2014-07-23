From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration-2.patch added
 to -mm tree
Date: Wed, 23 Jul 2014 14:05:58 -0700
Message-ID: <53d023b6.zFJuyITGGKhva9tw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:43935 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282AbaGWVF7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jul 2014 17:05:59 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so523015oah.0
        for <mm-commits@vger.kernel.org>; Wed, 23 Jul 2014 14:05:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, miklos@szeredi.hu, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: rewrite uncharge API fix - page cache migration 2
has been added to the -mm tree.  Its filename is
     mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: rewrite uncharge API fix - page cache migration 2

In case of fuse page cache replacement the target page in migration
can already be charged when splice steals it from page cache.  That
triggers the !PageCgrouUsed() assertion during commit:

[  755.141095] page:ffffea00031f9b00 count:2 mapcount:0 mapping:ffff8800c84d1858 index:0x0
[  755.141097] page flags: 0x3fffc000000029(locked|uptodate|lru)
[  755.141098] page dumped because: VM_BUG_ON_PAGE(PageCgroupUsed(pc))
[  755.141098] pc:ffff880215cfe6c0 pc->flags:7 pc->mem_cgroup:ffff880216c23000
[  755.141113] ------------[ cut here ]------------
[  755.141113] kernel BUG at /home/hannes/src/linux/linux/mm/memcontrol.c:2736!
[  755.141115] invalid opcode: 0000 [#1] SMP
[  755.141117] CPU: 0 PID: 342 Comm: lt-fusexmp_fh Not tainted 3.16.0-rc5-mm1-00502-g5e5b90c20054 #367
[  755.141117] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./H61M-DGS, BIOS P1.30 05/10/2012
[  755.141118] task: ffff880213104580 ti: ffff8800c9204000 task.ti: ffff8800c9204000
[  755.141121] RIP: 0010:[<ffffffff81188497>]  [<ffffffff81188497>] commit_charge+0xa7/0xb0
[  755.141122] RSP: 0018:ffff8800c9207c18  EFLAGS: 00010286
[  755.141123] RAX: 000000000000003f RBX: ffffea00031f9b00 RCX: 0000000000004c4b
[  755.141123] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff880213104580
[  755.141124] RBP: ffff8800c9207c40 R08: 0000000000000001 R09: 0000000000000000
[  755.141124] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880216c23000
[  755.141125] R13: 0000000000000001 R14: ffff8800c84d1858 R15: 0000000000000000
[  755.141125] FS:  00007fc15f7fe700(0000) GS:ffff88021f200000(0000) knlGS:0000000000000000
[  755.141126] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  755.141127] CR2: 00007f693db3b6b0 CR3: 0000000211d54000 CR4: 00000000000407f0
[  755.141127] Stack:
[  755.141128]  ffffea00031f8480 ffffea00031f9b00 ffffea00031f8480 ffffea00031f9b00
[  755.141129]  0000000000000000 ffff8800c9207c78 ffffffff8118e283 00000001c9207c60
[  755.141130]  ffff880215cfe120 00000001c9207c78 ffffea00031f9b00 ffffea00031f8480
[  755.141131] Call Trace:
[  755.141133]  [<ffffffff8118e283>] mem_cgroup_migrate+0xe3/0x210
[  755.141135]  [<ffffffff8111a086>] replace_page_cache_page+0xf6/0x1c0
[  755.141137]  [<ffffffff8127aceb>] fuse_copy_page+0x1bb/0x5f0
[  755.141138]  [<ffffffff8127b20f>] fuse_copy_args+0xef/0x140
[  755.141140]  [<ffffffff8127caba>] fuse_dev_do_write+0x7ba/0xd30
[  755.141143]  [<ffffffff8109518d>] ? trace_hardirqs_on_caller+0x15d/0x200
[  755.141146]  [<ffffffff816a83ea>] ? __mutex_unlock_slowpath+0xaa/0x180
[  755.141147]  [<ffffffff8109518d>] ? trace_hardirqs_on_caller+0x15d/0x200
[  755.141148]  [<ffffffff8109523d>] ? trace_hardirqs_on+0xd/0x10
[  755.141150]  [<ffffffff8127d2b2>] fuse_dev_splice_write+0x282/0x360
[  755.141152]  [<ffffffff811c4ce1>] SyS_splice+0x351/0x800
[  755.141153]  [<ffffffff8109518d>] ? trace_hardirqs_on_caller+0x15d/0x200
[  755.141155]  [<ffffffff816ab192>] system_call_fastpath+0x16/0x1b
[  755.141166] Code: 07 48 89 10 8b 75 e4 e8 f8 fd ff ff 48 83 c4 10 5b 41 5c 41 5d 5d c3 0f 1f 44 00 00 48 c7 c6 68 0b 9c 81 48 89 df e8 e9 a2 f9 ff <0f> 0b 0f 1f 80 00 00 00 00 66 66 66 66 90 48 39 f7 74 26 48 85
[  755.141167] RIP  [<ffffffff81188497>] commit_charge+0xa7/0xb0
[  755.141167]  RSP <ffff8800c9207c18>
[  755.141665] ---[ end trace 2d0ea36c8e3ded5b ]---

If the target page is already charged, just leave it as is and abort
the charge migration attempt.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/memcontrol.c~mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration-2 mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration-2
+++ a/mm/memcontrol.c
@@ -6623,6 +6623,12 @@ void mem_cgroup_migrate(struct page *old
 	if (mem_cgroup_disabled())
 		return;
 
+	/* Page cache replacement: new page already charged? */
+	pc = lookup_page_cgroup(newpage);
+	if (PageCgroupUsed(pc))
+		return;
+
+	/* Re-entrant migration: old page already uncharged? */
 	pc = lookup_page_cgroup(oldpage);
 	if (!PageCgroupUsed(pc))
 		return;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

shmem-fix-faulting-into-a-hole-not-taking-i_mutex.patch
shmem-fix-splicing-from-a-hole-while-its-punched.patch
mm-page-writebackc-fix-divide-by-zero-in-bdi_dirty_limits.patch
vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
mm-page-flags-clean-up-the-page-flag-test-set-clear-macros.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-charge-api-fix-3.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
mm-memcontrol-rewrite-uncharge-api-fix-4.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse.patch
mm-memcontrol-rewrite-uncharge-api-fix-uncharge-from-irq-context.patch
mm-memcontrol-rewrite-uncharge-api-fix-double-migration-v2.patch
mm-memcontrol-rewrite-uncharge-api-fix-migrate-before-re-mapping.patch
mm-memcontrol-rewrite-charge-api-fix-hugetlb-charging.patch
mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration.patch
mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration-2.patch
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
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-update-the-description-for-vm_total_pages.patch
mm-vmscan-report-the-number-of-file-anon-pages-respectively.patch
mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated.patch
mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines.patch
mm-move-zone-pages_scanned-into-a-vmstat-counter.patch
mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu.patch
mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered.patch
mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy.patch
mm-writeback-prevent-race-when-calculating-dirty-limits.patch
slub-remove-kmemcg-id-from-create_unique_id.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch


From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration-2.patch removed from -mm tree
Date: Thu, 07 Aug 2014 15:33:05 -0700
Message-ID: <53e3fea1.Q1hDohlNCevumNqh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:64189 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbaHGWdG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 18:33:06 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so640549qap.0
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 15:33:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, miklos@szeredi.hu, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: rewrite uncharge API fix - page cache migration 2
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration-2.patch

This patch was dropped because it was folded into mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration.patch

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
@@ -6652,6 +6652,12 @@ void mem_cgroup_migrate(struct page *old
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

origin.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch


From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-rmap-use-rmap_walk-in-page_referenced-fix.patch removed from -mm tree
Date: Tue, 21 Jan 2014 15:32:53 -0800
Message-ID: <52df03a5.hAGVB+DUCbV719I9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaAUXcy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 18:32:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mingo@kernel.org, mgorman@suse.de, iamjoonsoo.kim@lge.com, hughd@google.com, dhillf@gmail.com, bob.liu@oracle.com, liwanp@linux.vnet.ibm.com

Subject: [folded-merged] mm-rmap-use-rmap_walk-in-page_referenced-fix.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,bob.liu@oracle.com,dhillf@gmail.com,hughd@google.com,iamjoonsoo.kim@lge.com,mgorman@suse.de,mingo@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 15:32:53 -0800


The patch titled
     Subject: mm/rmap: fix BUG at rmap_walk
has been removed from the -mm tree.  Its filename was
     mm-rmap-use-rmap_walk-in-page_referenced-fix.patch

This patch was dropped because it was folded into mm-rmap-use-rmap_walk-in-page_referenced.patch

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/rmap: fix BUG at rmap_walk

This bug is introduced by commit 37f093cdf(mm/rmap: use rmap_walk() in
page_referenced()).  page_get_anon_vma() called in page_referenced_anon()
will lock and increase the refcount of anon_vma.  PageLocked is not
required by page_referenced_anon() and there is not any assertion before,
commit 37f093cdf introduced this extra BUG_ON() checking for anon page by
mistake.  This patch fix it by remove rmap_walk()'s VM_BUG_ON() and
comment reason why the page must be locked for rmap_walk_ksm() and
rmap_walk_file().

[  588.698828] kernel BUG at mm/rmap.c:1663!
[  588.699380] invalid opcode: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
[  588.700347] Dumping ftrace buffer:
[  588.701186]    (ftrace buffer empty)
[  588.702062] Modules linked in:
[  588.702759] CPU: 0 PID: 4647 Comm: kswapd0 Tainted: G      D W    3.13.0-rc4-next-20131218-sasha-00012-g1962367-dirty #4155
[  588.704330] task: ffff880062bcb000 ti: ffff880062450000 task.ti: ffff880062450000
[  588.705507] RIP: 0010:[<ffffffff81289c80>]  [<ffffffff81289c80>] rmap_walk+0x10/0x50
[  588.706800] RSP: 0018:ffff8800624518d8  EFLAGS: 00010246
[  588.707515] RAX: 000fffff80080048 RBX: ffffea00000227c0 RCX: 0000000000000000
[  588.707515] RDX: 0000000000000000 RSI: ffff8800624518e8 RDI: ffffea00000227c0
[  588.707515] RBP: ffff8800624518d8 R08: ffff8800624518e8 R09: 0000000000000000
[  588.707515] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800624519d8
[  588.707515] R13: 0000000000000000 R14: ffffea00000227e0 R15: 0000000000000000
[  588.707515] FS:  0000000000000000(0000) GS:ffff880065200000(0000) knlGS:0000000000000000
[  588.707515] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  588.707515] CR2: 00007fec40cbe0f8 CR3: 00000000c2382000 CR4: 00000000000006f0
[  588.707515] Stack:
[  588.707515]  ffff880062451958 ffffffff81289f4b ffff880062451918 ffffffff81289f80
[  588.707515]  0000000000000000 0000000000000000 ffffffff8128af60 0000000000000000
[  588.707515]  0000000000000024 0000000000000000 0000000000000000 0000000000000286
[  588.707515] Call Trace:
[  588.707515]  [<ffffffff81289f4b>] page_referenced+0xcb/0x100
[  588.707515]  [<ffffffff81289f80>] ? page_referenced+0x100/0x100
[  588.707515]  [<ffffffff8128af60>] ? invalid_page_referenced_vma+0x170/0x170
[  588.707515]  [<ffffffff81264302>] shrink_active_list+0x212/0x330
[  588.707515]  [<ffffffff81260e23>] ? inactive_file_is_low+0x33/0x50
[  588.707515]  [<ffffffff812646f5>] shrink_lruvec+0x2d5/0x300
[  588.707515]  [<ffffffff812647b6>] shrink_zone+0x96/0x1e0
[  588.707515]  [<ffffffff81265b06>] kswapd_shrink_zone+0xf6/0x1c0
[  588.707515]  [<ffffffff81265f43>] balance_pgdat+0x373/0x550
[  588.707515]  [<ffffffff81266d63>] kswapd+0x2f3/0x350
[  588.707515]  [<ffffffff81266a70>] ? perf_trace_mm_vmscan_lru_isolate_template+0x120/0x120
[  588.707515]  [<ffffffff8115c9c5>] kthread+0x105/0x110
[  588.707515]  [<ffffffff8115c8c0>] ? set_kthreadd_affinity+0x30/0x30
[  588.707515]  [<ffffffff843a6a7c>] ret_from_fork+0x7c/0xb0
[  588.707515]  [<ffffffff8115c8c0>] ? set_kthreadd_affinity+0x30/0x30
[  588.707515] Code: c0 48 83 c4 18 89 d0 5b 41 5c 41 5d 41 5e 41 5f c9 c3 66 0f 1f 84
00 00 00 00 00 55 48 89 e5 66 66 66 66 90 48 8b 07 a8 01 75 10 <0f> 0b 66 0f 1f 44 00 0
0 eb fe 66 0f 1f 44 00 00 f6 47 08 01 74
[  588.707515] RIP  [<ffffffff81289c80>] rmap_walk+0x10/0x50
[  588.707515]  RSP <ffff8800624518d8>

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Bob Liu <bob.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c  |    5 +++++
 mm/rmap.c |   10 ++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff -puN mm/ksm.c~mm-rmap-use-rmap_walk-in-page_referenced-fix mm/ksm.c
--- a/mm/ksm.c~mm-rmap-use-rmap_walk-in-page_referenced-fix
+++ a/mm/ksm.c
@@ -1899,6 +1899,11 @@ int rmap_walk_ksm(struct page *page, str
 	int search_new_forks = 0;
 
 	VM_BUG_ON(!PageKsm(page));
+
+	/*
+	 * Rely on the page lock to protect against concurrent modifications
+	 * to that page's node of the stable tree.
+	 */
 	VM_BUG_ON(!PageLocked(page));
 
 	stable_node = page_stable_node(page);
diff -puN mm/rmap.c~mm-rmap-use-rmap_walk-in-page_referenced-fix mm/rmap.c
--- a/mm/rmap.c~mm-rmap-use-rmap_walk-in-page_referenced-fix
+++ a/mm/rmap.c
@@ -1632,6 +1632,14 @@ static int rmap_walk_file(struct page *p
 	struct vm_area_struct *vma;
 	int ret = SWAP_AGAIN;
 
+	/*
+	 * The page lock not only makes sure that page->mapping cannot
+	 * suddenly be NULLified by truncation, it makes sure that the
+	 * structure at mapping cannot be freed and reused yet,
+	 * so we can safely take mapping->i_mmap_mutex.
+	 */
+	VM_BUG_ON(!PageLocked(page));
+
 	if (!mapping)
 		return ret;
 	mutex_lock(&mapping->i_mmap_mutex);
@@ -1663,8 +1671,6 @@ done:
 
 int rmap_walk(struct page *page, struct rmap_walk_control *rwc)
 {
-	VM_BUG_ON(!PageLocked(page));

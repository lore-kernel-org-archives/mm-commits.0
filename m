From: akpm@linux-foundation.org
Subject: [merged] hugetlb-fix-lockdep-splat-caused-by-pmd-sharing.patch
 removed from -mm tree
Date: Wed, 14 Aug 2013 12:35:36 -0700
Message-ID: <520bdc08.p5XffEsjOmORH56p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114Ab3HNTfh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 15:35:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, minchan@kernel.org, davej@redhat.com, mhocko@suse.cz

Subject: [merged] hugetlb-fix-lockdep-splat-caused-by-pmd-sharing.patch removed from -mm tree
To: mhocko@suse.cz,davej@redhat.com,minchan@kernel.org,peterz@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 12:35:36 -0700


The patch titled
     Subject: hugetlb: fix lockdep splat caused by pmd sharing
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-lockdep-splat-caused-by-pmd-sharing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: hugetlb: fix lockdep splat caused by pmd sharing

Dave has reported the following lockdep splat:
[128095.470960] =================================
[128095.471315] [ INFO: inconsistent lock state ]
[128095.471660] 3.11.0-rc1+ #9 Not tainted
[128095.472156] ---------------------------------
[128095.472905] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[128095.473650] kswapd0/49 [HC0[0]:SC0[0]:HE1:SE1] takes:
[128095.474373]  (&mapping->i_mmap_mutex){+.+.?.}, at: [<c114971b>] page_referenced+0x87/0x5e3
[128095.475128] {RECLAIM_FS-ON-W} state was registered at:
[128095.475866]   [<c10a6232>] mark_held_locks+0x81/0xe7
[128095.476597]   [<c10a8db3>] lockdep_trace_alloc+0x5e/0xbc
[128095.477322]   [<c112316b>] __alloc_pages_nodemask+0x8b/0x9b6
[128095.478049]   [<c1123ab6>] __get_free_pages+0x20/0x31
[128095.478769]   [<c1123ad9>] get_zeroed_page+0x12/0x14
[128095.479477]   [<c113fe1e>] __pmd_alloc+0x1c/0x6b
[128095.480138]   [<c1155ea7>] huge_pmd_share+0x265/0x283
[128095.480138]   [<c1155f22>] huge_pte_alloc+0x5d/0x71
[128095.480138]   [<c115612e>] hugetlb_fault+0x7c/0x64a
[128095.480138]   [<c114087c>] handle_mm_fault+0x255/0x299
[128095.480138]   [<c15bbab0>] __do_page_fault+0x142/0x55c
[128095.480138]   [<c15bbed7>] do_page_fault+0xd/0x16
[128095.480138]   [<c15b927c>] error_code+0x6c/0x74
[128095.480138] irq event stamp: 3136917
[128095.480138] hardirqs last  enabled at (3136917): [<c15b8139>] _raw_spin_unlock_irq+0x27/0x50
[128095.480138] hardirqs last disabled at (3136916): [<c15b7f4e>] _raw_spin_lock_irq+0x15/0x78
[128095.480138] softirqs last  enabled at (3136180): [<c1048e4a>] __do_softirq+0x137/0x30f
[128095.480138] softirqs last disabled at (3136175): [<c1049195>] irq_exit+0xa8/0xaa
[128095.480138]
other info that might help us debug this:
[128095.480138]  Possible unsafe locking scenario:
[128095.480138]        CPU0
[128095.480138]        ----
[128095.480138]   lock(&mapping->i_mmap_mutex);
[128095.480138]   <Interrupt>
[128095.480138]     lock(&mapping->i_mmap_mutex);
[128095.480138]
 *** DEADLOCK ***
[128095.480138] no locks held by kswapd0/49.
[128095.480138]
stack backtrace:
[128095.480138] CPU: 1 PID: 49 Comm: kswapd0 Not tainted 3.11.0-rc1+ #9
[128095.480138] Hardware name: Dell Inc.                 Precision WorkStation 490    /0DT031, BIOS A08 04/25/2008
[128095.480138]  c1d32630 00000000 ee39fb18 c15b001e ee395780 ee39fb54 c15acdcb c1751845
[128095.480138]  c1751bbf 00000031 00000000 00000000 00000000 00000000 00000001 00000001
[128095.480138]  c1751bbf 00000008 ee395c44 00000100 ee39fb88 c10a6130 00000008 0000d8fb
[128095.480138] Call Trace:
[128095.480138]  [<c15b001e>] dump_stack+0x4b/0x79
[128095.480138]  [<c15acdcb>] print_usage_bug+0x1d9/0x1e3
[128095.480138]  [<c10a6130>] mark_lock+0x1e0/0x261
[128095.480138]  [<c10a5878>] ? check_usage_backwards+0x109/0x109
[128095.480138]  [<c10a6cde>] __lock_acquire+0x623/0x17f2
[128095.480138]  [<c107aa43>] ? sched_clock_cpu+0xcd/0x130
[128095.480138]  [<c107a7e8>] ? sched_clock_local+0x42/0x12e
[128095.480138]  [<c10a84cf>] lock_acquire+0x7d/0x195
[128095.480138]  [<c114971b>] ? page_referenced+0x87/0x5e3
[128095.480138]  [<c15b3671>] mutex_lock_nested+0x6c/0x3a7
[128095.480138]  [<c114971b>] ? page_referenced+0x87/0x5e3
[128095.480138]  [<c114971b>] ? page_referenced+0x87/0x5e3
[128095.480138]  [<c11661d5>] ? mem_cgroup_charge_statistics.isra.24+0x61/0x9e
[128095.480138]  [<c114971b>] page_referenced+0x87/0x5e3
[128095.480138]  [<f8433030>] ? raid0_congested+0x26/0x8a [raid0]
[128095.480138]  [<c112b9c7>] shrink_page_list+0x3d9/0x947
[128095.480138]  [<c10a6457>] ? trace_hardirqs_on+0xb/0xd
[128095.480138]  [<c112c3cf>] shrink_inactive_list+0x155/0x4cb
[128095.480138]  [<c112cd07>] shrink_lruvec+0x300/0x5ce
[128095.480138]  [<c112d028>] shrink_zone+0x53/0x14e
[128095.480138]  [<c112e531>] kswapd+0x517/0xa75
[128095.480138]  [<c112e01a>] ? mem_cgroup_shrink_node_zone+0x280/0x280
[128095.480138]  [<c10661ff>] kthread+0xa8/0xaa
[128095.480138]  [<c10a6457>] ? trace_hardirqs_on+0xb/0xd
[128095.480138]  [<c15bf737>] ret_from_kernel_thread+0x1b/0x28
[128095.480138]  [<c1066157>] ? insert_kthread_work+0x63/0x63

which is a false positive caused by hugetlb pmd sharing code which
allocates a new pmd from withing mapping->i_mmap_mutex.  If this
allocation causes reclaim then the lockdep detector complains that we
might self-deadlock.

This is not correct though, because hugetlb pages are not reclaimable so
their mapping will be never touched from the reclaim path.

The patch tells lockup detector that hugetlb i_mmap_mutex is special by
assigning it a separate lockdep class so it won't report possible
deadlocks on unrelated mappings.

[peterz@infradead.org: comment for annotation]
Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/hugetlbfs/inode.c~hugetlb-fix-lockdep-splat-caused-by-pmd-sharing fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlb-fix-lockdep-splat-caused-by-pmd-sharing
+++ a/fs/hugetlbfs/inode.c
@@ -463,6 +463,14 @@ static struct inode *hugetlbfs_get_root(
 	return inode;
 }
 
+/*
+ * Hugetlbfs is not reclaimable; therefore its i_mmap_mutex will never
+ * be taken from reclaim -- unlike regular filesystems. This needs an
+ * annotation because huge_pmd_share() does an allocation under
+ * i_mmap_mutex.
+ */
+struct lock_class_key hugetlbfs_i_mmap_mutex_key;
+
 static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 					struct inode *dir,
 					umode_t mode, dev_t dev)
@@ -474,6 +482,8 @@ static struct inode *hugetlbfs_get_inode
 		struct hugetlbfs_inode_info *info;
 		inode->i_ino = get_next_ino();
 		inode_init_owner(inode, dir, mode);
+		lockdep_set_class(&inode->i_mapping->i_mmap_mutex,
+				&hugetlbfs_i_mmap_mutex_key);
 		inode->i_mapping->a_ops = &hugetlbfs_aops;
 		inode->i_mapping->backing_dev_info =&hugetlbfs_backing_dev_info;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch


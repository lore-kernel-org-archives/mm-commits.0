From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-clear-kswapds-special-reclaim-powers-before-exiting.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:27:51 -0700
Message-ID: <53960ab7.Q1T04eRICdY33drQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbaFIT1x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:27:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tangchen@cn.fujitsu.com, stable@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com, hannes@cmpxchg.org

Subject: [merged] mm-vmscan-clear-kswapds-special-reclaim-powers-before-exiting.patch removed from -mm tree
To: hannes@cmpxchg.org,guz.fnst@cn.fujitsu.com,isimatu.yasuaki@jp.fujitsu.com,stable@vger.kernel.org,tangchen@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:27:51 -0700


The patch titled
     Subject: mm: vmscan: clear kswapd's special reclaim powers before exiting
has been removed from the -mm tree.  Its filename was
     mm-vmscan-clear-kswapds-special-reclaim-powers-before-exiting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: clear kswapd's special reclaim powers before exiting

When kswapd exits, it can end up taking locks that were previously held by
allocating tasks while they waited for reclaim.  Lockdep currently warns
about this:

On Wed, May 28, 2014 at 06:06:34PM +0800, Gu Zheng wrote:
> [ 2457.683370] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
> [ 2457.761540] kswapd2/1151 [HC0[0]:SC0[0]:HE1:SE1] takes:
> [ 2457.824102]  (&sig->group_rwsem){+++++?}, at: [<ffffffff81071864>] exit_signals+0x24/0x130
> [ 2457.923538] {RECLAIM_FS-ON-W} state was registered at:
> [ 2457.985055]   [<ffffffff810bfc99>] mark_held_locks+0xb9/0x140
> [ 2458.053976]   [<ffffffff810c1e3a>] lockdep_trace_alloc+0x7a/0xe0
> [ 2458.126015]   [<ffffffff81194f47>] kmem_cache_alloc_trace+0x37/0x240
> [ 2458.202214]   [<ffffffff812c6e89>] flex_array_alloc+0x99/0x1a0
> [ 2458.272175]   [<ffffffff810da563>] cgroup_attach_task+0x63/0x430
> [ 2458.344214]   [<ffffffff810dcca0>] attach_task_by_pid+0x210/0x280
> [ 2458.417294]   [<ffffffff810dcd26>] cgroup_procs_write+0x16/0x20
> [ 2458.488287]   [<ffffffff810d8410>] cgroup_file_write+0x120/0x2c0
> [ 2458.560320]   [<ffffffff811b21a0>] vfs_write+0xc0/0x1f0
> [ 2458.622994]   [<ffffffff811b2bac>] SyS_write+0x4c/0xa0
> [ 2458.684618]   [<ffffffff815ec3c0>] tracesys+0xdd/0xe2
> [ 2458.745214] irq event stamp: 49
> [ 2458.782794] hardirqs last  enabled at (49): [<ffffffff815e2b56>] _raw_spin_unlock_irqrestore+0x36/0x70
> [ 2458.894388] hardirqs last disabled at (48): [<ffffffff815e337b>] _raw_spin_lock_irqsave+0x2b/0xa0
> [ 2459.000771] softirqs last  enabled at (0): [<ffffffff81059247>] copy_process.part.24+0x627/0x15f0
> [ 2459.107161] softirqs last disabled at (0): [<          (null)>]           (null)
> [ 2459.195852]
> [ 2459.195852] other info that might help us debug this:
> [ 2459.274024]  Possible unsafe locking scenario:
> [ 2459.274024]
> [ 2459.344911]        CPU0
> [ 2459.374161]        ----
> [ 2459.403408]   lock(&sig->group_rwsem);
> [ 2459.448490]   <Interrupt>
> [ 2459.479825]     lock(&sig->group_rwsem);
> [ 2459.526979]
> [ 2459.526979]  *** DEADLOCK ***
> [ 2459.526979]
> [ 2459.597866] no locks held by kswapd2/1151.
> [ 2459.646896]
> [ 2459.646896] stack backtrace:
> [ 2459.699049] CPU: 30 PID: 1151 Comm: kswapd2 Not tainted 3.10.39+ #4
> [ 2459.774098] Hardware name: FUJITSU PRIMEQUEST2800E/SB, BIOS PRIMEQUEST 2000 Series BIOS Version 01.48 05/07/2014
> [ 2459.895983]  ffffffff82284bf0 ffff88085856bbf8 ffffffff815dbcf6 ffff88085856bc48
> [ 2459.985003]  ffffffff815d67c6 0000000000000000 ffff880800000001 ffff880800000001
> [ 2460.074024]  000000000000000a ffff88085edc9600 ffffffff810be0e0 0000000000000009
> [ 2460.163087] Call Trace:
> [ 2460.192345]  [<ffffffff815dbcf6>] dump_stack+0x19/0x1b
> [ 2460.253874]  [<ffffffff815d67c6>] print_usage_bug+0x1f7/0x208
> [ 2460.399807]  [<ffffffff810bfb5d>] mark_lock+0x21d/0x2a0
> [ 2460.462369]  [<ffffffff810c076a>] __lock_acquire+0x52a/0xb60
> [ 2460.735516]  [<ffffffff810c1592>] lock_acquire+0xa2/0x140
> [ 2460.935691]  [<ffffffff815e01e1>] down_read+0x51/0xa0
> [ 2461.062888]  [<ffffffff81071864>] exit_signals+0x24/0x130
> [ 2461.127536]  [<ffffffff81060d55>] do_exit+0xb5/0xa50
> [ 2461.320433]  [<ffffffff8108303b>] kthread+0xdb/0x100
> [ 2461.532049]  [<ffffffff815ec0ec>] ret_from_fork+0x7c/0xb0

This is because the kswapd thread is still marked as a reclaimer at the
time of exit.  But because it is exiting, nobody is actually waiting on it
to make reclaim progress anymore, and it's nothing but a regular thread at
this point.  Be tidy and strip it of all its powers (PF_MEMALLOC,
PF_SWAPWRITE, PF_KSWAPD, and the lockdep reclaim state) before returning
from the thread function.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/vmscan.c~mm-vmscan-clear-kswapds-special-reclaim-powers-before-exiting mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-clear-kswapds-special-reclaim-powers-before-exiting
+++ a/mm/vmscan.c
@@ -3372,7 +3372,10 @@ static int kswapd(void *p)
 		}
 	}
 
+	tsk->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD);
 	current->reclaim_state = NULL;
+	lockdep_clear_current_reclaim_state();
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
linux-next.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-mm-introduce-lowlimit-reclaim-fix.patch
memcg-mm-introduce-lowlimit-reclaim-fix2patch.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
memcg-document-memorylow_limit_in_bytes.patch
vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch


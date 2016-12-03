From: akpm@linux-foundation.org
Subject: [patch 2/2] mm, vmscan: add cond_resched() into
 shrink_node_memcg()
Date: Fri, 02 Dec 2016 17:26:48 -0800
Message-ID: <58421f58.OCcGx9Hdjlqc8dZA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34614 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755479AbcLCB01 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2016 20:26:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, bb@kernelpanic.ru, buczek@molgen.mpg.de, caker@theshore.net, pmenzel@molgen.mpg.de

From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmscan: add cond_resched() into shrink_node_memcg()

Boris Zhmurov has reported RCU stalls during the kswapd reclaim:
17511.573645] INFO: rcu_sched detected stalls on CPUs/tasks:
[17511.573699]  23-...: (22 ticks this GP) idle=92f/140000000000000/0 softirq=2638404/2638404 fqs=23
[17511.573740]  (detected by 4, t=6389 jiffies, g=786259, c=786258, q=42115)
[17511.573776] Task dump for CPU 23:
[17511.573777] kswapd1         R  running task        0   148      2 0x00000008
[17511.573781]  0000000000000000 ffff8efe5f491400 ffff8efe44523e68 ffff8f16a7f49000
[17511.573782]  0000000000000000 ffffffffafb67482 0000000000000000 0000000000000000
[17511.573784]  0000000000000000 0000000000000000 ffff8efe44523e58 00000000016dbbee
[17511.573786] Call Trace:
[17511.573796]  [<ffffffffafb67482>] ? shrink_node+0xd2/0x2f0
[17511.573798]  [<ffffffffafb683ab>] ? kswapd+0x2cb/0x6a0
[17511.573800]  [<ffffffffafb680e0>] ? mem_cgroup_shrink_node+0x160/0x160
[17511.573806]  [<ffffffffafa8b63d>] ? kthread+0xbd/0xe0
[17511.573810]  [<ffffffffafa2967a>] ? __switch_to+0x1fa/0x5c0
[17511.573813]  [<ffffffffaff9095f>] ? ret_from_fork+0x1f/0x40
[17511.573815]  [<ffffffffafa8b580>] ? kthread_create_on_node+0x180/0x180

a closer code inspection has shown that we might indeed miss all the
scheduling points in the reclaim path if no pages can be isolated from
the LRU list. This is a pathological case but other reports from Donald
Buczek have shown that we might indeed hit such a path:
        clusterd-989   [009] .... 118023.654491: mm_vmscan_direct_reclaim_end: nr_reclaimed=193
         kswapd1-86    [001] dN.. 118023.987475: mm_vmscan_lru_isolate: isolate_mode=0 classzone=0 order=0 nr_requested=32 nr_scanned=4239830 nr_taken=0 file=1
         kswapd1-86    [001] dN.. 118024.320968: mm_vmscan_lru_isolate: isolate_mode=0 classzone=0 order=0 nr_requested=32 nr_scanned=4239844 nr_taken=0 file=1
         kswapd1-86    [001] dN.. 118024.654375: mm_vmscan_lru_isolate: isolate_mode=0 classzone=0 order=0 nr_requested=32 nr_scanned=4239858 nr_taken=0 file=1
         kswapd1-86    [001] dN.. 118024.987036: mm_vmscan_lru_isolate: isolate_mode=0 classzone=0 order=0 nr_requested=32 nr_scanned=4239872 nr_taken=0 file=1
         kswapd1-86    [001] dN.. 118025.319651: mm_vmscan_lru_isolate: isolate_mode=0 classzone=0 order=0 nr_requested=32 nr_scanned=4239886 nr_taken=0 file=1
         kswapd1-86    [001] dN.. 118025.652248: mm_vmscan_lru_isolate: isolate_mode=0 classzone=0 order=0 nr_requested=32 nr_scanned=4239900 nr_taken=0 file=1
         kswapd1-86    [001] dN.. 118025.984870: mm_vmscan_lru_isolate: isolate_mode=0 classzone=0 order=0 nr_requested=32 nr_scanned=4239914 nr_taken=0 file=1
[...]
         kswapd1-86    [001] dN.. 118084.274403: mm_vmscan_lru_isolate: isolate_mode=0 classzone=0 order=0 nr_requested=32 nr_scanned=4241133 nr_taken=0 file=1

this is minute long snapshot which didn't take a single page from the
LRU. It is not entirely clear why only 1303 pages have been scanned
during that time (maybe there was a heavy IRQ activity interfering).

In any case it looks like we can really hit long periods without
scheduling on non preemptive kernels so an explicit cond_resched() in
shrink_node_memcg which is independent on the reclaim operation is due.

Link: http://lkml.kernel.org/r/20161202095841.16648-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Boris Zhmurov <bb@kernelpanic.ru>
Tested-by: Boris Zhmurov <bb@kernelpanic.ru>
Reported-by: Donald Buczek <buczek@molgen.mpg.de>
Reported-by: "Christopher S. Aker" <caker@theshore.net>
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmscan.c~mm-vmscan-add-cond_resched-into-shrink_node_memcg mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-add-cond_resched-into-shrink_node_memcg
+++ a/mm/vmscan.c
@@ -2354,6 +2354,8 @@ static void shrink_node_memcg(struct pgl
 			}
 		}
 
+		cond_resched();
+
 		if (nr_reclaimed < nr_to_reclaim || scan_adjusted)
 			continue;
 
_

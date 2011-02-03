From: akpm@linux-foundation.org
Subject: [merged] memcg-prevent-endless-loop-when-charging-huge-pages.patch removed from -mm tree
Date: Thu, 03 Feb 2011 11:46:21 -0800
Message-ID: <201102031946.p13JkL1P021002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756721Ab1BCTqe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 14:46:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: prevent endless loop when charging huge pages
has been removed from the -mm tree.  Its filename was
     memcg-prevent-endless-loop-when-charging-huge-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: prevent endless loop when charging huge pages
From: Johannes Weiner <hannes@cmpxchg.org>

The charging code can encounter a charge size that is bigger than a
regular page in two situations: one is a batched charge to fill the
per-cpu stocks, the other is a huge page charge.

This code is distributed over two functions, however, and only the outer
one is aware of huge pages.  In case the charging fails, the inner
function will tell the outer function to retry if the charge size is
bigger than regular pages--assuming batched charging is the only case. 
And the outer function will retry forever charging a huge page.

This patch makes sure the inner function can distinguish between batch
charging and a single huge page charge.  It will only signal another
attempt if batch charging failed, and go into regular reclaim when it is
called on behalf of a huge page.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-prevent-endless-loop-when-charging-huge-pages mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-prevent-endless-loop-when-charging-huge-pages
+++ a/mm/memcontrol.c
@@ -1837,8 +1837,15 @@ static int __mem_cgroup_do_charge(struct
 		flags |= MEM_CGROUP_RECLAIM_NOSWAP;
 	} else
 		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
-
-	if (csize > PAGE_SIZE) /* change csize and retry */
+	/*
+	 * csize can be either a huge page (HPAGE_SIZE), a batch of
+	 * regular pages (CHARGE_SIZE), or a single regular page
+	 * (PAGE_SIZE).
+	 *
+	 * Never reclaim on behalf of optional batching, retry with a
+	 * single page instead.
+	 */
+	if (csize == CHARGE_SIZE)
 		return CHARGE_RETRY;
 
 	if (!(gfp_mask & __GFP_WAIT))
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch


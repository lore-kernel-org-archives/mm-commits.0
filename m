From: akpm@linux-foundation.org
Subject: [merged] memcg-never-oom-when-charging-huge-pages.patch removed from -mm tree
Date: Thu, 03 Feb 2011 11:46:26 -0800
Message-ID: <201102031946.p13JkQFl021008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756731Ab1BCTqn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 14:46:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: never OOM when charging huge pages
has been removed from the -mm tree.  Its filename was
     memcg-never-oom-when-charging-huge-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: never OOM when charging huge pages
From: Johannes Weiner <hannes@cmpxchg.org>

Huge page coverage should obviously have less priority than the continued
execution of a process.

Never kill a process when charging it a huge page fails.  Instead, give up
after the first failed reclaim attempt and fall back to regular pages.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-never-oom-when-charging-huge-pages mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-never-oom-when-charging-huge-pages
+++ a/mm/memcontrol.c
@@ -2351,13 +2351,19 @@ static int mem_cgroup_charge_common(stru
 				gfp_t gfp_mask, enum charge_type ctype)
 {
 	struct mem_cgroup *mem = NULL;
+	int page_size = PAGE_SIZE;
 	struct page_cgroup *pc;
+	bool oom = true;
 	int ret;
-	int page_size = PAGE_SIZE;
 
 	if (PageTransHuge(page)) {
 		page_size <<= compound_order(page);
 		VM_BUG_ON(!PageTransHuge(page));
+		/*
+		 * Never OOM-kill a process for a huge page.  The
+		 * fault handler will fall back to regular pages.
+		 */
+		oom = false;
 	}
 
 	pc = lookup_page_cgroup(page);
@@ -2366,7 +2372,7 @@ static int mem_cgroup_charge_common(stru
 		return 0;
 	prefetchw(pc);
 
-	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, true, page_size);
+	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, oom, page_size);
 	if (ret || !mem)
 		return ret;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch


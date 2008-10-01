From: akpm@linux-foundation.org
Subject: - memcg-check-under-limit-at-shrink_usage.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:50:08 -0700
Message-ID: <200810012150.m91Lo8nC005827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753604AbYJAVu2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:50:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@in.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: check under limit at shrink_usage
has been removed from the -mm tree.  Its filename was
     memcg-check-under-limit-at-shrink_usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: check under limit at shrink_usage
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Current memory cgroup(both in mainline and -mm) doesn't account swap
caches as memory(swap cache support is dropped temporarily now).

So try_to_free_mem_cgroup_pages doesn't reflect the count of pages that
have been moved to swap cache.

But this makes mem_cgroup_shrink_usage fail easily if most of the pages
are anon/shmem, and then shmem_getpage returns -ENOMEM and the process
will be killed.

This patch adds res_counter_check_under_limit to avoid these cases.

BTW, even if swap cache support is enabled again, if a process is moved to
another cgroup, which has been just made, between precharge and
shrink_usage in shmem_getpage, shrink_usage may fail just because there is
no pages to reclaim.

So this change would make sense anyway.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memcontrol.c~memcg-check-under-limit-at-shrink_usage mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-check-under-limit-at-shrink_usage
+++ a/mm/memcontrol.c
@@ -806,6 +806,7 @@ int mem_cgroup_shrink_usage(struct mm_st
 
 	do {
 		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask);
+		progress += res_counter_check_under_limit(&mem->res);
 	} while (!progress && --retry);
 
 	css_put(&mem->css);
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

vmscan-split-lru-lists-into-anon-file-sets-memcg-fix-handling-of-shmem-migrationv2.patch
unevictable-lru-infrastructure.patch


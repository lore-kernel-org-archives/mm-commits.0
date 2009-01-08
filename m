From: akpm@linux-foundation.org
Subject: - memcg-hierarchy-avoid-unnecessary-reclaim.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:49:00 -0800
Message-ID: <200901082249.n08Mn06c028302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761660AbZAHWtl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:49:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@in.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: hierarchy avoid unnecessary reclaim
has been removed from the -mm tree.  Its filename was
     memcg-hierarchy-avoid-unnecessary-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: hierarchy avoid unnecessary reclaim
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

If hierarchy is not used, no tree-walk is necessary.

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memcontrol.c~memcg-hierarchy-avoid-unnecessary-reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-hierarchy-avoid-unnecessary-reclaim
+++ a/mm/memcontrol.c
@@ -606,6 +606,8 @@ static int mem_cgroup_hierarchical_recla
 	ret = try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap);
 	if (mem_cgroup_check_under_limit(root_mem))
 		return 0;
+	if (!root_mem->use_hierarchy)
+		return ret;
 
 	next_mem = mem_cgroup_get_first_node(root_mem);
 
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch


From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-mem_cgroup_rotate_reclaimable_page.patch removed from -mm tree
Date: Mon, 18 Apr 2011 11:02:15 -0700
Message-ID: <201104181758.p3IHwRdN016030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754235Ab1DRR7O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 13:59:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.dumazet@gmail.com, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix mem_cgroup_rotate_reclaimable_page()
has been removed from the -mm tree.  Its filename was
     memcg-fix-mem_cgroup_rotate_reclaimable_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix mem_cgroup_rotate_reclaimable_page()
From: Eric Dumazet <eric.dumazet@gmail.com>

commit 3f58a8294333 ("move memcg reclaimable page into tail of inactive
list") added inline keyword twice in its prototype.

  CC      arch/x86/kernel/asm-offsets.s
In file included from include/linux/swap.h:8,
                 from include/linux/suspend.h:4,
                 from arch/x86/kernel/asm-offsets.c:12:
include/linux/memcontrol.h:220: error: duplicate `inline'

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~memcg-fix-mem_cgroup_rotate_reclaimable_page include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-fix-mem_cgroup_rotate_reclaimable_page
+++ a/include/linux/memcontrol.h
@@ -216,7 +216,7 @@ static inline void mem_cgroup_del_lru_li
 	return ;
 }
 
-static inline inline void mem_cgroup_rotate_reclaimable_page(struct page *page)
+static inline void mem_cgroup_rotate_reclaimable_page(struct page *page)
 {
 	return ;
 }
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

origin.patch
linux-next.patch
vfs-avoid-large-kmallocs-for-the-fdtable.patch
net-convert-%p-usage-to-%pk.patch
percpu_counter-change-return-value-and-add-comments.patch


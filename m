From: akpm@linux-foundation.org
Subject: [merged]
 memcg-correct-comments-for-__mem_cgroup_begin_update_page_stat.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:51:35 -0700
Message-ID: <5390ca47.o1a/54UCOJk9PJAe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaFETvf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:51:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, h.huangqiang@huawei.com

Subject: [merged] memcg-correct-comments-for-__mem_cgroup_begin_update_page_stat.patch removed from -mm tree
To: h.huangqiang@huawei.com,hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:51:35 -0700


The patch titled
     Subject: memcg: correct comments for __mem_cgroup_begin_update_page_stat
has been removed from the -mm tree.  Its filename was
     memcg-correct-comments-for-__mem_cgroup_begin_update_page_stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qiang Huang <h.huangqiang@huawei.com>
Subject: memcg: correct comments for __mem_cgroup_begin_update_page_stat

Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-correct-comments-for-__mem_cgroup_begin_update_page_stat mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-correct-comments-for-__mem_cgroup_begin_update_page_stat
+++ a/mm/memcontrol.c
@@ -2276,12 +2276,11 @@ cleanup:
 }
 
 /*
- * Currently used to update mapped file statistics, but the routine can be
- * generalized to update other statistics as well.
+ * Used to update mapped file or writeback or other statistics.
  *
  * Notes: Race condition
  *
- * We usually use page_cgroup_lock() for accessing page_cgroup member but
+ * We usually use lock_page_cgroup() for accessing page_cgroup member but
  * it tends to be costly. But considering some conditions, we doesn't need
  * to do so _always_.
  *
@@ -2295,8 +2294,8 @@ cleanup:
  * by flags.
  *
  * Considering "move", this is an only case we see a race. To make the race
- * small, we check mm->moving_account and detect there are possibility of race
- * If there is, we take a lock.
+ * small, we check memcg->moving_account and detect there are possibility
+ * of race or not. If there is, we take a lock.
  */
 
 void __mem_cgroup_begin_update_page_stat(struct page *page,
_

Patches currently in -mm which might be from h.huangqiang@huawei.com are

origin.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: +
 memcg-correct-comments-for-__mem_cgroup_begin_update_page_stat.patch added
 to -mm tree
Date: Wed, 07 May 2014 13:32:55 -0700
Message-ID: <536a9877.GYWJj2iytAxiVEio%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaEGUc4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 16:32:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, h.huangqiang@huawei.com

Subject: + memcg-correct-comments-for-__mem_cgroup_begin_update_page_stat.patch added to -mm tree
To: h.huangqiang@huawei.com,hannes@cmpxchg.org,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 13:32:55 -0700


The patch titled
     Subject: memcg: correct comments for __mem_cgroup_begin_update_page_stat
has been added to the -mm tree.  Its filename is
     memcg-correct-comments-for-__mem_cgroup_begin_update_page_stat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-correct-comments-for-__mem_cgroup_begin_update_page_stat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-correct-comments-for-__mem_cgroup_begin_update_page_stat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2251,12 +2251,11 @@ cleanup:
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
@@ -2270,8 +2269,8 @@ cleanup:
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

memcg-fold-mem_cgroup_stolen.patch
memcg-fold-mem_cgroup_stolen-fix.patch
memcg-correct-comments-for-__mem_cgroup_begin_update_page_stat.patch


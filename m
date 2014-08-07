From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:04:27 -0700
Message-ID: <53e3dbcb.w816AWV6hkh3nU3L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:47977 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbaHGUE2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:28 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so1174292pdj.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL charges
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL charges

There is no reason why oom-disabled and __GFP_NOFAIL charges should try to
reclaim only once when every other charge tries several times before
giving up.  Make them all retry the same number of times.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges
+++ a/mm/memcontrol.c
@@ -2566,7 +2566,7 @@ static int mem_cgroup_try_charge(struct
 				 bool oom)
 {
 	unsigned int batch = max(CHARGE_BATCH, nr_pages);
-	int nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct res_counter *fail_res;
 	unsigned long nr_reclaimed;
@@ -2638,6 +2638,9 @@ retry:
 	if (mem_cgroup_wait_acct_move(mem_over_limit))
 		goto retry;
 
+	if (nr_retries--)
+		goto retry;
+
 	if (gfp_mask & __GFP_NOFAIL)
 		goto bypass;
 
@@ -2647,9 +2650,6 @@ retry:
 	if (!oom)
 		goto nomem;
 
-	if (nr_oom_retries--)
-		goto retry;

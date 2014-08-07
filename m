From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-catch-root-bypass-in-move-precharge.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:04:33 -0700
Message-ID: <53e3dbd1.XRrNh2cODyjjWOrT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:62575 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbaHGUEe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:34 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so613264qap.0
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: catch root bypass in move precharge
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-catch-root-bypass-in-move-precharge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: catch root bypass in move precharge

When mem_cgroup_try_charge() returns -EINTR, it bypassed the charge to the
root memcg.  But move precharging does not catch this and treats this case
as if no charge had happened, thus leaking a charge against root.  Because
of an old optimization, the root memcg's res_counter is not actually
charged right now, but it's still an imbalance and subsequent patches will
charge the root memcg again.

Catch those bypasses to the root memcg and properly cancel them before
giving up the move.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-catch-root-bypass-in-move-precharge mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-catch-root-bypass-in-move-precharge
+++ a/mm/memcontrol.c
@@ -6401,6 +6401,10 @@ static int mem_cgroup_do_precharge(unsig
 		mc.precharge += count;
 		return ret;
 	}
+	if (ret == -EINTR) {
+		__mem_cgroup_cancel_charge(root_mem_cgroup, count);
+		return ret;
+	}
 
 	/* Try charges one by one with reclaim */
 	while (count--) {
@@ -6409,8 +6413,11 @@ static int mem_cgroup_do_precharge(unsig
 		/*
 		 * In case of failure, any residual charges against
 		 * mc.to will be dropped by mem_cgroup_clear_mc()
-		 * later on.
+		 * later on.  However, cancel any charges that are
+		 * bypassed to root right away or they'll be lost.
 		 */
+		if (ret == -EINTR)
+			__mem_cgroup_cancel_charge(root_mem_cgroup, 1);
 		if (ret)
 			return ret;
 		mc.precharge++;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch


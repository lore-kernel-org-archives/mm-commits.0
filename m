From: akpm@linux-foundation.org
Subject: [merged] vmscan-fix-sane_reclaim-helper-for-legacy-memcg.patch
 removed from -mm tree
Date: Mon, 28 Sep 2015 11:16:07 -0700
Message-ID: <560983e7.5cMs7Huq00j5Rr+p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752AbbI1SQH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 14:16:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: fix sane_reclaim helper for legacy memcg
has been removed from the -mm tree.  Its filename was
     vmscan-fix-sane_reclaim-helper-for-legacy-memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: vmscan: fix sane_reclaim helper for legacy memcg

The sane_reclaim() helper is supposed to return false for memcg reclaim if
the legacy hierarchy is used, because the latter lacks dirty throttling
mechanism, and so it did before it was accidentally broken by commit
33398cf2f360c ("memcg: export struct mem_cgroup").  Fix it.

Fixes: 33398cf2f360c ("memcg: export struct mem_cgroup")
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-fix-sane_reclaim-helper-for-legacy-memcg mm/vmscan.c
--- a/mm/vmscan.c~vmscan-fix-sane_reclaim-helper-for-legacy-memcg
+++ a/mm/vmscan.c
@@ -175,7 +175,7 @@ static bool sane_reclaim(struct scan_con
 	if (!memcg)
 		return true;
 #ifdef CONFIG_CGROUP_WRITEBACK
-	if (memcg->css.cgroup)
+	if (cgroup_on_dfl(memcg->css.cgroup))
 		return true;
 #endif
 	return false;
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-make-optimistic-check-for-swapin-readahead-fix-2.patch


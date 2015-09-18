From: akpm@linux-foundation.org
Subject: + vmscan-fix-sane_reclaim-helper-for-legacy-memcg.patch added to
 -mm tree
Date: Fri, 18 Sep 2015 12:55:57 -0700
Message-ID: <55fc6c4d.4avHX9NNDx5gjI3e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbbIRTz6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Sep 2015 15:55:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: fix sane_reclaim helper for legacy memcg
has been added to the -mm tree.  Its filename is
     vmscan-fix-sane_reclaim-helper-for-legacy-memcg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmscan-fix-sane_reclaim-helper-for-legacy-memcg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmscan-fix-sane_reclaim-helper-for-legacy-memcg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

vmscan-fix-sane_reclaim-helper-for-legacy-memcg.patch
mm-make-optimistic-check-for-swapin-readahead-fix-2.patch


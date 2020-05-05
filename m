From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-simplify-value-comparison-between-count-and-limit.patch added
 to -mm tree
Date: Tue, 05 May 2020 15:52:08 -0700
Message-ID: <20200505225208.MxvfSYQFc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729332AbgEEWwJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 May 2020 18:52:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kaixuxia@tencent.com, mhocko@suse.com, mm-commits@vger.kernel.org, vdavydov.dev@gmail.com


The patch titled
     Subject: mm: memcontrol: simplify value comparison between count and limit
has been added to the -mm tree.  Its filename is
     mm-memcontrol-simplify-value-comparison-between-count-and-limit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-simplify-value-comparison-between-count-and-limit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-simplify-value-comparison-between-count-and-limit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm: memcontrol: simplify value comparison between count and limit

When the variables count and limit have the same value(count == limit),
the result of min(margin, limit - count) statement should be 0 and the
variable margin is set to 0.  So in this case, the min() statement is not
necessary and we can directly set the variable margin to 0.

Link: http://lkml.kernel.org/r/1587479661-27237-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-simplify-value-comparison-between-count-and-limit
+++ a/mm/memcontrol.c
@@ -1314,7 +1314,7 @@ static unsigned long mem_cgroup_margin(s
 	if (do_memsw_account()) {
 		count = page_counter_read(&memcg->memsw);
 		limit = READ_ONCE(memcg->memsw.max);
-		if (count <= limit)
+		if (count < limit)
 			margin = min(margin, limit - count);
 		else
 			margin = 0;
_

Patches currently in -mm which might be from kaixuxia@tencent.com are

mm-memcontrol-simplify-value-comparison-between-count-and-limit.patch

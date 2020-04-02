From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 126/155] mm/vmscan.c: do_try_to_free_pages():
 clean code by removing unnecessary assignment
Date: Wed, 01 Apr 2020 21:10:21 -0700
Message-ID: <20200402041021.eHQMu6xra%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEKW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:10:22 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org, mateusznosek0@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/vmscan.c: do_try_to_free_pages(): clean code by removing unnecessary assignment

sc->memcg_low_skipped resets skipped_deactivate to 0 but this is not
needed as this code path is never reachable with skipped_deactivate != 0
due to previous sc->skipped_deactivate branch.

[mhocko@kernel.org: rewrite changelog]
Link: http://lkml.kernel.org/r/20200319165938.23354-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscanc-do_try_to_free_pages-clean-code-by-removing-unnecessary-assignment
+++ a/mm/vmscan.c
@@ -3093,7 +3093,6 @@ retry:
 	if (sc->memcg_low_skipped) {
 		sc->priority = initial_priority;
 		sc->force_deactivate = 0;
-		sc->skipped_deactivate = 0;
 		sc->memcg_low_reclaim = 1;
 		sc->memcg_low_skipped = 0;
 		goto retry;
_

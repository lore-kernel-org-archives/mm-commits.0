From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 080/128] mm/memcg: move penalty delay clamping out
 of calculate_high_delay()
Date: Mon, 01 Jun 2020 21:49:45 -0700
Message-ID: <20200602044945.p32KXPwUG%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgFBEtr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:49:47 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@chrisdown.name, hannes@cmpxchg.org, hughd@google.com, kuba@kernel.org, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org, torvalds@linux-foundation.org

From: Jakub Kicinski <kuba@kernel.org>
Subject: mm/memcg: move penalty delay clamping out of calculate_high_delay()

We will want to call calculate_high_delay() twice - once for memory and
once for swap, and we should apply the clamp value to sum of the
penalties.  Clamping has to be applied outside of calculate_high_delay().

Link: http://lkml.kernel.org/r/20200527195846.102707-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Down <chris@chrisdown.name>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/memcontrol.c~mm-move-penalty-delay-clamping-out-of-calculate_high_delay
+++ a/mm/memcontrol.c
@@ -2386,14 +2386,7 @@ static unsigned long calculate_high_dela
 	 * MEMCG_CHARGE_BATCH pages is nominal, so work out how much smaller or
 	 * larger the current charge patch is than that.
 	 */
-	penalty_jiffies = penalty_jiffies * nr_pages / MEMCG_CHARGE_BATCH;

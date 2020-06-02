From: akpm@linux-foundation.org
Subject: [merged]
 mm-move-penalty-delay-clamping-out-of-calculate_high_delay.patch removed
 from -mm tree
Date: Tue, 02 Jun 2020 14:40:54 -0700
Message-ID: <20200602214054.aCLllswU5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728080AbgFBVkz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:40:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, hannes@cmpxchg.org, hughd@google.com, kuba@kernel.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org


The patch titled
     Subject: mm/memcg: move penalty delay clamping out of calculate_high_delay()
has been removed from the -mm tree.  Its filename was
     mm-move-penalty-delay-clamping-out-of-calculate_high_delay.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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
-
-	/*
-	 * Clamp the max delay per usermode return so as to still keep the
-	 * application moving forwards and also permit diagnostics, albeit
-	 * extremely slowly.
-	 */
-	return min(penalty_jiffies, MEMCG_MAX_HIGH_DELAY_JIFFIES);
+	return penalty_jiffies * nr_pages / MEMCG_CHARGE_BATCH;
 }
 
 /*
@@ -2422,6 +2415,13 @@ void mem_cgroup_handle_over_high(void)
 					       mem_find_max_overage(memcg));
 
 	/*
+	 * Clamp the max delay per usermode return so as to still keep the
+	 * application moving forwards and also permit diagnostics, albeit
+	 * extremely slowly.
+	 */
+	penalty_jiffies = min(penalty_jiffies, MEMCG_MAX_HIGH_DELAY_JIFFIES);
+
+	/*
 	 * Don't sleep if the amount of jiffies this memcg owes us is so low
 	 * that it's not even worth doing, in an attempt to be nice to those who
 	 * go only a small amount over their memory.high value and maybe haven't
_

Patches currently in -mm which might be from kuba@kernel.org are

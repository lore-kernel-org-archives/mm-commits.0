Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD8CBE65
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739423; cv=none; b=AjwRRmPZQJoY8FjGzbZHdH4xxfswPhUP4PPAlGlNxnolbHSRfMdLJ90kVEJ1SOmn3k8GBIPsU1+Bo5PrWl+hxuzqfvAOVSUAEQ9DkcjzGTUAOwIxBATaoNkbcgFq+7XlHz34njKm8WmFxy0UN0B9jDHag73E6Ze4TYoGsjZvdX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739423; c=relaxed/simple;
	bh=SHfZWgWhkoOu6yqbdDcXa1Nl/M5/lYvO4WaEwGrxpWY=;
	h=Date:To:From:Subject:Message-Id; b=kepjJnmTx+Rv0LuUpePSRTvGrWSCv/0ndiCqFF0xONSPyIWtLo6bWr8frn6sum00enM1nYzlYjK/o3oTBWiljuXaKuVakOZSfMdKw3hFOwSFm3wCxPBA3EjyKrWxu5EU6MxpPk4P9cBcUV1w711SR8ekpeTbKuEdI9RKSIfV+mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vKK8LYws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vKK8LYws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5EFC43390;
	Sat, 24 Feb 2024 01:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739423;
	bh=SHfZWgWhkoOu6yqbdDcXa1Nl/M5/lYvO4WaEwGrxpWY=;
	h=Date:To:From:Subject:From;
	b=vKK8LYwsquMV9k+YhTVThu5+EYCdWB4Qc35mY+8lqcNAm1eYvWkW868HhlazeOZEA
	 5YqpG0M0PLHny43lmQs4KKtVeO7SHLcZ5gtdQseWQfuPslXIw8anJ/J/9rE6bNC9j3
	 G1z0fvSHr2520Qw3n/fef+acc3lqIgpoqSEFJh0g=
Date: Fri, 23 Feb 2024 17:50:22 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-implement-psi-metric-damos-quota-goal.patch removed from -mm tree
Message-Id: <20240224015022.EC5EFC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: implement PSI metric DAMOS quota goal
has been removed from the -mm tree.  Its filename was
     mm-damon-core-implement-psi-metric-damos-quota-goal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: implement PSI metric DAMOS quota goal
Date: Mon, 19 Feb 2024 11:44:24 -0800

Extend DAMOS quota goal metric with system wide memory pressure stall
time.  Specifically, the system level 'some' PSI for memory is used.  The
target value can be set in microseconds.  DAMOS measures the increased
amount of the PSI metric in last quota_reset_interval and use the ratio of
it versus the user-specified target PSI value as the score for the
auto-tuning feedback loop.

Link: https://lkml.kernel.org/r/20240219194431.159606-14-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    7 +++++++
 mm/damon/core.c       |   25 +++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-implement-psi-metric-damos-quota-goal
+++ a/include/linux/damon.h
@@ -130,12 +130,14 @@ enum damos_action {
  * enum damos_quota_goal_metric - Represents the metric to be used as the goal
  *
  * @DAMOS_QUOTA_USER_INPUT:	User-input value.
+ * @DAMOS_QUOTA_SOME_MEM_PSI_US:	System level some memory PSI in us.
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
  */
 enum damos_quota_goal_metric {
 	DAMOS_QUOTA_USER_INPUT,
+	DAMOS_QUOTA_SOME_MEM_PSI_US,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
@@ -144,6 +146,7 @@ enum damos_quota_goal_metric {
  * @metric:		Metric to be used for representing the goal.
  * @target_value:	Target value of @metric to achieve with the tuning.
  * @current_value:	Current value of @metric.
+ * @last_psi_total:	Last measured total PSI
  * @list:		List head for siblings.
  *
  * Data structure for getting the current score of the quota tuning goal.  The
@@ -159,6 +162,10 @@ struct damos_quota_goal {
 	enum damos_quota_goal_metric metric;
 	unsigned long target_value;
 	unsigned long current_value;
+	/* metric-dependent fields */
+	union {
+		u64 last_psi_total;
+	};
 	struct list_head list;
 };
 
--- a/mm/damon/core.c~mm-damon-core-implement-psi-metric-damos-quota-goal
+++ a/mm/damon/core.c
@@ -11,6 +11,7 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/mm.h>
+#include <linux/psi.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 
@@ -1125,6 +1126,25 @@ static unsigned long damon_feed_loop_nex
 	return min_input;
 }
 
+#ifdef CONFIG_PSI
+
+static u64 damos_get_some_mem_psi_total(void)
+{
+	if (static_branch_likely(&psi_disabled))
+		return 0;
+	return div_u64(psi_system.total[PSI_AVGS][PSI_MEM * 2],
+			NSEC_PER_USEC);
+}
+
+#else	/* CONFIG_PSI */
+
+static inline u64 damos_get_some_mem_psi_total(void)
+{
+	return 0;
+};
+
+#endif	/* CONFIG_PSI */
+
 static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 {
 	u64 now_psi_total;
@@ -1133,6 +1153,11 @@ static void damos_set_quota_goal_current
 	case DAMOS_QUOTA_USER_INPUT:
 		/* User should already set goal->current_value */
 		break;
+	case DAMOS_QUOTA_SOME_MEM_PSI_US:
+		now_psi_total = damos_get_some_mem_psi_total();
+		goal->current_value = now_psi_total - goal->last_psi_total;
+		goal->last_psi_total = now_psi_total;
+		break;
 	default:
 		break;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are



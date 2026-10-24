Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832316;
	b=XzTh9IZfVnV3lIaOpxnBKrOt2fR0YJtIN8Rv0QpsUraeSdnaUfcq4ETlAUExoplAwl/r
	 wziMEUbPVLofvK6UdoysbO3DiY1eb7fcJZ5mz/g/jBvckJBcLJpQpYcFDXoet2JaKRbLy
	 K5nAq7VgVmzVpug1iuQDX5AFGwLR1l5AWPebzw9vFcAafMG2MW8r/b7NoD6IhSKt7Jfsz
	 QbvZr/DCVZjle5hhVAS9GyOamwS6npl8dId2/7+BhQPWX6JB6Wv5XYxClbpDV4dgcucA0
	 HRG1so/Tj/JeFvO8gzrVVoY6hm3MY3guRyBR11HTaF4ExSh1+6oFTJ+oep9wbFwn2gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832316;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=b/fCudylhNG2X03gi/OdDh6oAFQmob1QlVJ8Rdk9N3s=;
	b=VHwaBn/F9/CpeV0iiN3Ul+0rz7UEc9WzGfw7aTAKyjd0vB/egvcdF1AITN2F06wnpJnK
	 qCDGhPoznvuRydKAmFrfJKR9kbpiShxs3z4G3gARB3LFmd8aZs9TeKL5HQw6v4SNF70qZ
	 /+f5QPCt+Fn4KKVbloVWN9gBbme64HpsAEoo19UQcjGM8aq1XQsQfMhHiDVltmD8qmmGd
	 RUFHzF5GgsHS4CfjXGFIc6y+TIBHqi34EHAQShIzZSTnF+D3UUDPCOz+/W5/kkCe9CN4K
	 Myu8MqkjH1mQRNPxlp1EACucXGpRv1dmaNBAG38n0cb6ap1R7plasGUjgit0Of9CzAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="urd/cxwA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88C2606A31F
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=urd/cxwA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7364C1F031E4;
	Sat, 24 Oct 2026 08:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832315;
	bh=b/fCudylhNG2X03gi/OdDh6oAFQmob1QlVJ8Rdk9N3s=;
	h=Date:To:From:Subject;
	b=urd/cxwAoPnxkd1amoTcs7Pjoy6+WFhevjyG3MJS0kB++D0UmQzzZtNlc/lO3ywX8
	 UKe6w5Vbtjc4+d4bqyOkv8kKbY6kHo+jynE7P5lhI2o64BKYN1YWlO33X747YSPrvC
	 FGJJOeiix6hCwNiqW7Qm7RPUVDMoz4LnPEs1tmfo=
Date: Sat, 24 Oct 2026 01:58:35 -0700
To: mm-commits@vger.kernel.org,gutierrez.asier@huawei-partners.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-introduce-damos_quota_goal-complement.patch removed from -mm tree
Message-Id: <20261024085835.7364C1F031E4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/core: introduce damos_quota_goal->complement
has been removed from the -mm tree.  Its filename was
     mm-damon-core-introduce-damos_quota_goal-complement.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: introduce damos_quota_goal->complement
Date: Tue, 29 Sep 2026 01:01:04 -0700

Patch series "mm/damon: introduce damos quota goal target metric
complement flag".

Aim-oriented DAMOS quota auto-tuning assumes the aggressiveness of the
scheme (quota) and the quota goal metric are directly proportional. 
Depending on the scheme setup and usage, keeping the relationship can be
challenging.

For example, let's suppose a memory tiering approach for higher upper tier
utilization.  One common idea for that (TPP) is utilizing two schemes, one
for promotion and the other one for demotion.  The promotion scheme
migrates hot pages from lower tier to upper tier, aiming for high
utilization of the upper tier.  The demotion scheme migrates cold pages
from upper tier to lower tier, aiming for head room free memory of the
upper tier.  Both schemes and their goals are in direct proportion. 
However, for this kind of use case, we need to implement two different
goal metrics (per-node memory utilization and free memory ratio) while
essentially the free memory ratio is just a complemented value of the
utilization.

To avoid adding too many new metrics, we are adding metrics that turn out
to be really needed for each found use case.  For example,
some_mem_psi_us, node_eligible_mem_bp and hugepage_mem_bp don't have their
complemented value version.  But it is not really difficult to expect use
cases that their complemented version can be useful.  For example,
hugepage_mem_bp use case may need a way to reduce the hugepage ratio. 
That would require a complemented version of hugepage_mem_bp.  Adding a
new metric for each of such use cases could make the number of metrics
unnecessarily high, and discourage flexible usages of DAMOS.

Add a new flag, quota goal complement, to allow flexible tuning goal setup
without unnecessarily increasing the number of metrics.  The flag
specifies whether to use the complemented value of the given goal metric
for the tuning.  For example, if the complement flag is set, the upper
tier memory utilization ratio metric works the same as the free memory
ratio metric for the tier.


This patch (of 8):

Introduce damos_quota_goal->complement for specifying whether to use a
complemented value of the given goal target metric.  Add the field to
the data structure and implement essential core support.  Handle the
flag in the quota goal commit and current quota goal metric value
retrieval.

[akpm@linux-foundation.org: fix comment tpyo, per Gutierrez]
Link: https://lore.kernel.org/20260929080113.41708-1-sj@kernel.org
Link: https://lore.kernel.org/20260929080113.41708-2-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
---

 include/linux/damon.h |    2 ++
 mm/damon/core.c       |   26 +++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-core-introduce-damos_quota_goal-complement
+++ a/include/linux/damon.h
@@ -169,6 +169,7 @@ enum damos_quota_goal_metric {
 /**
  * struct damos_quota_goal - DAMOS scheme quota auto-tuning goal.
  * @metric:		Metric to be used for representing the goal.
+ * @complement:		Use the complement of the metric.
  * @target_value:	Target value of @metric to achieve with the tuning.
  * @current_value:	Current value of @metric.
  * @nid:		Node id.
@@ -191,6 +192,7 @@ enum damos_quota_goal_metric {
  */
 struct damos_quota_goal {
 	enum damos_quota_goal_metric metric;
+	bool complement;
 	unsigned long target_value;
 	unsigned long current_value;
 	/* metric-dependent fields */
--- a/mm/damon/core.c~mm-damon-core-introduce-damos_quota_goal-complement
+++ a/mm/damon/core.c
@@ -1224,6 +1224,7 @@ static int damos_commit_quota_goal(
 	if (!src->target_value)
 		return  -EINVAL;
 	dst->metric = src->metric;
+	dst->complement = src->complement;
 	dst->target_value = src->target_value;
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
@@ -2960,10 +2961,18 @@ static void damos_set_psi_current_val(u6
 		struct damos_quota_goal *goal, struct damos *s)
 {
 	u64 last_psi_total = goal->last_psi_total;
+	unsigned long val;
 
 	goal->last_psi_total = now_psi_total;
 	if (last_psi_total != U64_MAX) {
-		goal->current_value = now_psi_total - last_psi_total;
+		val = now_psi_total - last_psi_total;
+		if (goal->complement) {
+			if (val < s->quota.reset_interval * 1000)
+				val = s->quota.reset_interval * 1000 - val;
+			else
+				val = 0;
+		}
+		goal->current_value = val;
 		return;
 	}
 	/* uninitialized last_psi_total; make no effect this round */
@@ -3255,6 +3264,21 @@ static void damos_set_quota_goal_current
 	default:
 		break;
 	}
+	if (!goal->complement)
+		return;
+
+	/* update current_value to complemented value */
+
+	/* for user_input, users set complemented value on their own */
+	if (goal->metric == DAMOS_QUOTA_USER_INPUT)
+		return;
+	/* damos_set_psi_current_val() handles complement flag itself */
+	if (goal->metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		return;
+	if (goal->current_value < 10000)
+		goal->current_value = 10000 - goal->current_value;
+	else
+		goal->current_value = 0;
 }
 
 /* Return the highest score since it makes schemes least aggressive */
_

Patches currently in -mm which might be from sj@kernel.org are



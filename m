Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF983B7752;
	Fri,  7 Aug 2026 02:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068127; cv=none; b=KH6JlX/rgU/AfaNExYtIvVYhg3bplwzojtomN4Th8ZbRMNsKPk5xSAO/re2smmBQgb7tNBna03L+xjkmT57p4lqEYZEZ7R/Amy+3qcmkDvsj/akrvHh4fPexeoYZ3AQTGGB6aEADUyqiG6a2I0nGoyC09QgYmBxDVnjPc3vbTnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068127; c=relaxed/simple;
	bh=4To70h559V1wJUi/RR+JsafMHNfyF52dFsfGy4QoSJY=;
	h=Date:To:From:Subject:Message-Id; b=Y3DAi49bL66TX7OtPeLooDaKhwi1TG7OJOY6c+kTTIuLMogHn24RxJAiwbU6aHYLS+xWGIW5lwiwyjqujBu98dY1pxnuHjlcXW9UMXDGEJaEPoNIWlnPjR7AxWTOrUIJWkPWix9PLBRhd8a5ACFldNwE5RlpT9pxaqyJe2HVQIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lXXqEaq3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lXXqEaq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F231F00A3D;
	Fri,  7 Aug 2026 02:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068126;
	bh=9IAeoR6WtryCBKd2IuPmvYGOH5m5VmpweHFe1BJ1jdk=;
	h=Date:To:From:Subject;
	b=lXXqEaq3hQtnQ+g0lU/e824dxm9lUxeImUQjrRUnaE1R9aDrV+pOs/emGUr5KBQoD
	 vIbWEm05A7mYVGueqn51ad3ta6xkLrBNI0iS2vtT4gFd2WeDEA1+1Oj+I4M+nxQx62
	 JurTHhplDt/RuYPPcdWF/bVVMnoPLLrBnG3jx6t0=
Date: Thu, 06 Aug 2026 19:02:05 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-ops-common-use-nr_accesses-moving-sum-for-quota-score.patch removed from -mm tree
Message-Id: <20260807020206.32F231F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/ops-common: use nr_accesses moving sum for quota score
has been removed from the -mm tree.  Its filename was
     mm-damon-ops-common-use-nr_accesses-moving-sum-for-quota-score.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/ops-common: use nr_accesses moving sum for quota score
Date: Sun, 19 Jul 2026 09:11:33 -0700

Since commit 42f994b71404 ("mm/damon/core: implement scheme-specific apply
interval"), DAMOS scheme can be applied at any time.  At that time,
nr_accesses may not be fully aggregated.  But the quota prioritization
score is calculated using the not fully aggregated count.  As a result,
the performance of DAMOS could be degraded.  Fix by using
damon_nr_accesses_mvsum() instead.

The user impact of the issue is suboptimum DAMOS performance under certain
setups.  Nonetheless, the bug was there from the beginning of the setup
availability.  In other words, the suboptimum performance is the baseline
of the setup and hence it didn't cause regression.  Also the extent of the
suboptimality was not big enough to be found from users and testers. 
Still, this is a clear bug that is better to be fixed, and can be easily
fixed.

Link: https://lore.kernel.org/20260719161136.90191-1-sj@kernel.org
Fixes: 42f994b71404 ("mm/damon/core: implement scheme-specific apply interval")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.7.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-use-nr_accesses-moving-sum-for-quota-score
+++ a/mm/damon/ops-common.c
@@ -111,8 +111,9 @@ int damon_hot_score(struct damon_ctx *c,
 	unsigned int age_weight = s->quota.weight_age;
 	int hotness;
 
-	freq_subscore = r->nr_accesses * DAMON_MAX_SUBSCORE /
-		damon_nr_samples_per_aggr(&c->attrs);
+	freq_subscore = mult_frac(damon_nr_accesses_mvsum(r, c),
+			DAMON_MAX_SUBSCORE,
+			damon_nr_samples_per_aggr(&c->attrs));
 
 	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
 	if (age_in_sec)
_

Patches currently in -mm which might be from sj@kernel.org are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65538C148
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739431; cv=none; b=TXCXvOAqHu4RlRbFicXrLVkOjoUgxGnjsXnp10KsfkvQL3mKRAKKahN1pqymT4BJT1k2LW1m06QoWkY4WQcFUww23OVArzxcSW8wMpMC7O/NU+c1SXt9mvI7pDnixWG2iruqaVROowSnQIo2Dr+jFrXBohWj9a7vYEXEHs+oLcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739431; c=relaxed/simple;
	bh=Mz/qbMdHZgX+eHT9dCOJ7GD9KV2RB/yedYaTHV1bYj4=;
	h=Date:To:From:Subject:Message-Id; b=Yaxt8uzpF3+FIuLPClcbR3sdw8Aj5YQOBMQ6AhF2cn0FyEWf1A3kF/01sGhprOGGp9ikGE/hmd9xuFP7YPnLLaRl5RsK442ql4xv2fvnQ6bCbIVEmHlsrA2g4c1crmFG9yHfrXYKscqr7X7aIR9bm9VSXIIoO4vPjMdGcblGDfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YrbJ2buw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YrbJ2buw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28238C433F1;
	Sat, 24 Feb 2024 01:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739430;
	bh=Mz/qbMdHZgX+eHT9dCOJ7GD9KV2RB/yedYaTHV1bYj4=;
	h=Date:To:From:Subject:From;
	b=YrbJ2buwQWizLUCTMPdRcjEm8dIblrQOB5gGi7WKn+BqIZdWGSe1KJ3upMGq8D1Rb
	 ZZ81CmvKrsC685/IUV+yqrZCQ4B2SNUn+tmAv6YKR+WqPP0/ljMbR79ncYskMGCvlp
	 nTJJBw5oISp9Htu1jBUGNfjZ7RufxEW3QWjZFlIw=
Date: Fri, 23 Feb 2024 17:50:29 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-reclaim-document-auto-tuning-parameters.patch removed from -mm tree
Message-Id: <20240224015030.28238C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/reclaim: document auto-tuning parameters
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-reclaim-document-auto-tuning-parameters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/reclaim: document auto-tuning parameters
Date: Mon, 19 Feb 2024 11:44:31 -0800

Update DAMON_RECLAIM usage document for the user/self feedback based
auto-tuning of the quota.

Link: https://lkml.kernel.org/r/20240219194431.159606-21-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/reclaim.rst |   27 +++++++++++++++
 1 file changed, 27 insertions(+)

--- a/Documentation/admin-guide/mm/damon/reclaim.rst~docs-admin-guide-mm-damon-reclaim-document-auto-tuning-parameters
+++ a/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -117,6 +117,33 @@ milliseconds.
 
 1 second by default.
 
+quota_mem_pressure_us
+---------------------
+
+Desired level of memory pressure-stall time in microseconds.
+
+While keeping the caps that set by other quotas, DAMON_RECLAIM automatically
+increases and decreases the effective level of the quota aiming this level of
+memory pressure is incurred.  System-wide ``some`` memory PSI in microseconds
+per quota reset interval (``quota_reset_interval_ms``) is collected and
+compared to this value to see if the aim is satisfied.  Value zero means
+disabling this auto-tuning feature.
+
+Disabled by default.
+
+quota_autotune_feedback
+-----------------------
+
+User-specifiable feedback for auto-tuning of the effective quota.
+
+While keeping the caps that set by other quotas, DAMON_RECLAIM automatically
+increases and decreases the effective level of the quota aiming receiving this
+feedback of value ``10,000`` from the user.  DAMON_RECLAIM assumes the feedback
+value and the quota are positively proportional.  Value zero means disabling
+this auto-tuning feature.
+
+Disabled by default.
+
 wmarks_interval
 ---------------
 
_

Patches currently in -mm which might be from sj@kernel.org are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F40D272
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739429; cv=none; b=gKyL9kEZzQYKkren01bp1eRvteRJpaUpGPAYVWEfQMPcsXYIUIX7Atk2NQrzZRNSbvGENeFeEnjFSEM8omdlJCEhOz2YyXAI+R00Ce44m+R9f2pA40hHUKlLqlNr34SYCCNJ8ZAm0xH2Ml8u8PtyI0YJcAnsQL7/hqBPwfnC74w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739429; c=relaxed/simple;
	bh=E7jQCVf0PvVrJvNn76YWeXPULMTjhGMZ5awXDdPW1YQ=;
	h=Date:To:From:Subject:Message-Id; b=emBnN3L8do4RIVTDlauDoBfbVgsCZthfff7c4VrN5Eyiwr/c2Iyq7oOjNyUJGL8/fEY4Om/Kecd03Uf9abWKNFbzgmdOEMlTNDSvDvCHlT3v7pxO97UGZr8/dg57JGHIzIm86SFADKDmBLO5LuX2TniAlYKTiN3YvJ21QEVSHaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eGXfHaVa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eGXfHaVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC51C433F1;
	Sat, 24 Feb 2024 01:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739429;
	bh=E7jQCVf0PvVrJvNn76YWeXPULMTjhGMZ5awXDdPW1YQ=;
	h=Date:To:From:Subject:From;
	b=eGXfHaVajpHnfOOpvzFm9Qek4LzXFOkMWfYxw5XaQj7lM8lavq1V7twsTeWkQmxW2
	 aX5uPgigU+z5N7mAUbkcRjLRRGTmfGZDnvvhOJwPGFus8W9f0LaW30aUKEIIhVMfdZ
	 96EMb6K/2ng3lz9GVxWgJcvH2Ti2uOw1b6ahFiEg=
Date: Fri, 23 Feb 2024 17:50:28 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch removed from -mm tree
Message-Id: <20240224015029.3BC51C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: implement memory PSI-driven quota self-tuning
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: implement memory PSI-driven quota self-tuning
Date: Mon, 19 Feb 2024 11:44:30 -0800

Support the PSI-driven quota self-tuning from DAMON_RECLAIM by introducing
yet another parameter, 'quota_mem_pressure_us'.  Users can set the desired
amount of memory pressure stall time per each quota reset interval using
the parameter.  Then DAMON_RECLAIM monitor the memory pressure stall time,
specifically system-wide memory 'some' PSI value that increased during the
given time interval, and self-tune the quota using the DAMOS core logic.

Link: https://lkml.kernel.org/r/20240219194431.159606-20-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning
+++ a/mm/damon/reclaim.c
@@ -63,6 +63,21 @@ static struct damos_quota damon_reclaim_
 DEFINE_DAMON_MODULES_DAMOS_QUOTAS(damon_reclaim_quota);
 
 /*
+ * Desired level of memory pressure-stall time in microseconds.
+ *
+ * While keeping the caps that set by other quotas, DAMON_RECLAIM automatically
+ * increases and decreases the effective level of the quota aiming this level of
+ * memory pressure is incurred.  System-wide ``some`` memory PSI in microseconds
+ * per quota reset interval (``quota_reset_interval_ms``) is collected and
+ * compared to this value to see if the aim is satisfied.  Value zero means
+ * disabling this auto-tuning feature.
+ *
+ * Disabled by default.
+ */
+static unsigned long quota_mem_pressure_us __read_mostly;
+module_param(quota_mem_pressure_us, ulong, 0600);
+
+/*
  * User-specifiable feedback for auto-tuning of the effective quota.
  *
  * While keeping the caps that set by other quotas, DAMON_RECLAIM automatically
@@ -198,6 +213,16 @@ static int damon_reclaim_apply_parameter
 					&old_scheme->quota);
 	}
 
+	if (quota_mem_pressure_us) {
+		goal = damos_new_quota_goal(DAMOS_QUOTA_SOME_MEM_PSI_US,
+				quota_mem_pressure_us);
+		if (!goal) {
+			damon_destroy_scheme(scheme);
+			return -ENOMEM;
+		}
+		damos_add_quota_goal(&scheme->quota, goal);
+	}
+
 	if (quota_autotune_feedback) {
 		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
 		if (!goal) {
_

Patches currently in -mm which might be from sj@kernel.org are



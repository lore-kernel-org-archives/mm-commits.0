Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC3A19D093
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744871; cv=none; b=hjEJrepyF8OLw7nTvMH93XdaNeotMAbAOR8YHbUXeRwK5JL0zbl7hZzKR+V0CMfr1r63WNSSi7+LK1W1M1i8aDLxe4guP4Yc6gM0YB81ppE7o8t9qywhEbCCFHhsMceI3nDvyK6bcMPu9gpdxg/H7m935FhAwnW5+at7+kd7oOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744871; c=relaxed/simple;
	bh=UBZ3TNmXV2B8RRWFOeLKbWhvvxKmNUnb4Razinls+Kc=;
	h=Date:To:From:Subject:Message-Id; b=tAvc+rzngqNirR+7c5c47OwK81cgNm7pAjvt5aCYsdVhgZ3gZPPqoReT9XHfnE3MBpQD/6IV4c0kvf2vbKo/LFLxOxM+e3ygnBnVQSfjo7r5rfG2S/qNedNbQ2KF+XwFFHViS3dplC/MEjoYSJgBw0k0mV/u+S3IazlYdwXebVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LNi2Ouiz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LNi2Ouiz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889ADC4CEF7;
	Sun, 29 Mar 2026 00:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744871;
	bh=UBZ3TNmXV2B8RRWFOeLKbWhvvxKmNUnb4Razinls+Kc=;
	h=Date:To:From:Subject:From;
	b=LNi2OuizHH9/Xj2lP0hsJVfFvT5WSpEZ2D+ER5UYR3TTXJnNJ7W7TpwAeuyJuVzfJ
	 ZciW23lmwZ61Dqv2adGZ3Ldat1DK0KVhqIJQB7GO5GWZf39XuCMkAFI5JYAP40dtVE
	 SSvUmzsBbpAJ/5PQkgsRDA8jvy76fPq95tqDjV0E=
Date: Sat, 28 Mar 2026 17:41:11 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-document-goal_tuner-sysfs-file.patch removed from -mm tree
Message-Id: <20260329004111.889ADC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document goal_tuner sysfs file
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-document-goal_tuner-sysfs-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: document goal_tuner sysfs file
Date: Mon, 9 Mar 2026 18:05:22 -0700

Update the DAMON usage document for the new sysfs file for the goal based
quota auto-tuning algorithm selection.

Link: https://lkml.kernel.org/r/20260310010529.91162-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-goal_tuner-sysfs-file
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -83,7 +83,7 @@ comma (",").
     │ │ │ │ │ │ │ │ sz/min,max
     │ │ │ │ │ │ │ │ nr_accesses/min,max
     │ │ │ │ │ │ │ │ age/min,max
-    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,effective_bytes
+    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,effective_bytes,goal_tuner
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
     │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid,path
@@ -377,9 +377,9 @@ schemes/<N>/quotas/
 The directory for the :ref:`quotas <damon_design_damos_quotas>` of the given
 DAMON-based operation scheme.
 
-Under ``quotas`` directory, four files (``ms``, ``bytes``,
-``reset_interval_ms``, ``effective_bytes``) and two directories (``weights`` and
-``goals``) exist.
+Under ``quotas`` directory, five files (``ms``, ``bytes``,
+``reset_interval_ms``, ``effective_bytes`` and ``goal_tuner``) and two
+directories (``weights`` and ``goals``) exist.
 
 You can set the ``time quota`` in milliseconds, ``size quota`` in bytes, and
 ``reset interval`` in milliseconds by writing the values to the three files,
@@ -390,6 +390,14 @@ apply the action to only up to ``bytes``
 quota limits unless at least one :ref:`goal <sysfs_schemes_quota_goals>` is
 set.
 
+You can set the goal-based effective quota auto-tuning algorithm to use, by
+writing the algorithm name to ``goal_tuner`` file.  Reading the file returns
+the currently selected tuner algorithm.  Refer to the design documentation of
+:ref:`automatic quota tuning goals <damon_design_damos_quotas_auto_tuning>` for
+the background design of the feature and the name of the selectable algorithms.
+Refer to :ref:`goals directory <sysfs_schemes_quota_goals>` for the goals
+setup.
+
 The time quota is internally transformed to a size quota.  Between the
 transformed size quota and user-specified size quota, smaller one is applied.
 Based on the user-specified :ref:`goal <sysfs_schemes_quota_goals>`, the
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F014A12
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739081; cv=none; b=eGLO3MN5W8n0kVgY3yKOBit1QLPUzUmLXTJtXkxxPZadzAD3sHU5NWTRUdPnOwHHfwn6s+tYFV6WHExVahICj5iJ8B8yXQI4YEc1KJI+ITFAC9sBrwBKD5Sk+NW3UUnfXWAujMGHUHdAKtPVa4ZcnTWpTEj92FdTvj5Fk9CQtRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739081; c=relaxed/simple;
	bh=ohzRyRa7WW72IXmLjeqhfX8MXkR16yy8viSek3t7pyE=;
	h=Date:To:From:Subject:Message-Id; b=IFqpb0wtwtWIbkuCBS6NCJMMJNWCiaHDXyr73xNdHe8EQCtOVjFrr08wOudNxdVnhvFPn7K5ZKSW/KR6m7jWFD6sTkgK9jw44WGdSTp2ANLGrVT0UchDjna8Ihl5C4Uwhu52ERRBucUX+8IXjNX21aHDQrtTZ9rKELu+aKEhYQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fSX2ZPsA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fSX2ZPsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D8AC433C7;
	Sat, 24 Feb 2024 01:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739080;
	bh=ohzRyRa7WW72IXmLjeqhfX8MXkR16yy8viSek3t7pyE=;
	h=Date:To:From:Subject:From;
	b=fSX2ZPsAWg9gQsx8Pr/GaojdTo8wgK6prKL9oqiZ4+uXkMIDlf3y0QKwLxluAZiiy
	 ScEV3g40q7CylVUHmcE+C5iU1wJQF3iovR4tQFYggN4SCTZYTtx0HETIjyq6hxd1xJ
	 BUaxB8LwjViK1E5rGkueWjAuiFWtEosdnNleg2Uc=
Date: Fri, 23 Feb 2024 17:44:40 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file-fix.patch removed from -mm tree
Message-Id: <20240224014440.C1D8AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: fix a typo on the auto-tuning design reference link
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file-fix.patch

This patch was dropped because it was folded into docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: fix a typo on the auto-tuning design reference link
Date: Wed, 21 Feb 2024 09:08:52 -0800

There was a typo on the quota auto-tuning design reference link that
caused below document build warning.  Fix it.

    WARNING: undefined label: 'damon_design_damos_quota_auto_tuning'

Link: https://lkml.kernel.org/r/20240221170852.55529-3-sj@kernel.org
Fixes: d50e871bd78b ("Docs/admin-guide/mm/damon/usage: document quota goal metric file")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lkml.kernel.org/r/20240221162745.4332955c@canb.auug.org.au
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file-fix
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -369,7 +369,7 @@ Among the multiple feedback, the best on
 Each goal directory contains three files, namely ``target_metric``,
 ``target_value`` and ``current_value``.  Users can set and get the three
 parameters for the quota auto-tuning goals that specified on the :ref:`design
-doc <damon_design_damos_quota_auto_tuning>` by writing to and reading from each
+doc <damon_design_damos_quotas_auto_tuning>` by writing to and reading from each
 of the files.  Note that users should further write
 ``commit_schemes_quota_goals`` to the ``state`` file of the :ref:`kdamond
 directory <sysfs_kdamond>` to pass the feedback to DAMON.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-set-damos_quota-esz-as-public-field-and-document.patch
mm-damon-sysfs-schemes-implement-quota-effective_bytes-file.patch
mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas.patch
docs-abi-damon-document-effective_bytes-sysfs-file.patch
docs-admin-guide-mm-damon-usage-document-effective_bytes-file.patch
mm-damon-move-comments-and-fields-for-damos-quota-prioritization-to-the-end.patch
mm-damon-core-split-out-quota-goal-related-fields-to-a-struct.patch
mm-damon-core-add-multiple-goals-per-damos_quota-and-helpers-for-those.patch
mm-damon-sysfs-use-only-quota-goals.patch
mm-damon-core-remove-goal-field-of-damos_quota.patch
mm-damon-core-let-goal-specified-with-only-target-and-current-values.patch
mm-damon-core-support-multiple-metrics-for-quota-goal.patch
mm-damon-core-implement-psi-metric-damos-quota-goal.patch
mm-damon-sysfs-schemes-support-psi-based-quota-auto-tune.patch
docs-mm-damon-design-document-quota-goal-self-tuning.patch
docs-abi-damon-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file.patch
mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch
mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch
docs-admin-guide-mm-damon-reclaim-document-auto-tuning-parameters.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E691B7E8
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644523; cv=none; b=pwkexLbvA83DYFIkx2RI8V1y0qy3LcVfzfrzCFcLw/fxj2ysHTAKO/9anDHmN6dO3g/05Cu6S29tnha/VGFYwjjes7u0OEuaD9iqqoQ4vHqkB3BtI8Yp7fLmtIf2Fej3cndymvhdmw+pktamOXzB1V+fNodq3w95LlOqpbc2w5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644523; c=relaxed/simple;
	bh=Y4P9hkGc5tBIDEVNstcLGoYG6E7pHAg69+5vVUhLZQU=;
	h=Date:To:From:Subject:Message-Id; b=XLN1UoCUf9nf8v6FUDEz/jRBalBOVKUKVyrYLywi5yt/xFGMWPBSxzZkjcmSO+kZTLRzOgP5F+sUerXHZNY4rC5XdN8g4wwd7nrBborMZEs9RLdRQPMtPSe7JoCQG/y3Enr3jqvD28lSBZ4XTZHouWjZ+nLLqtIS/VPRODD61W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q7dAskDo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q7dAskDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AE3C433C7;
	Thu, 22 Feb 2024 23:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644523;
	bh=Y4P9hkGc5tBIDEVNstcLGoYG6E7pHAg69+5vVUhLZQU=;
	h=Date:To:From:Subject:From;
	b=Q7dAskDoovMyWUsRz0oZURYEM3F0dYcJ22O2wLAP303jg8qaS7E0d/AXXtImGWeZ/
	 /pMkrJeCghq2utSxsGwPdJNUd3DZ7GkldIw6rUUJh3LsDx75KTtRwC43rydxFya7sH
	 6twcd0RUtJkFl93ocgE7oDYU5v7PiFZDEp5+bAVk=
Date: Thu, 22 Feb 2024 15:28:42 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-fix-wrong-quotas-diabling-condition.patch removed from -mm tree
Message-Id: <20240222232843.44AE3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: fix wrong quotas diabling condition
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-fix-wrong-quotas-diabling-condition.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: fix wrong quotas diabling condition
Date: Fri, 16 Feb 2024 16:58:42 -0800

After the introduction of DAMOS quotas, DAMOS quotas is not disabled if
both size and time quotas are zero but the quota goal is set.  The new
rule is also applied to DAMON sysfs interface, but the usage doc is not
updated.  Update it.

Link: https://lkml.kernel.org/r/20240217005842.87348-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-fix-wrong-quotas-diabling-condition
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -329,7 +329,8 @@ respectively.  Then, DAMON tries to use
 for applying the ``action`` to memory regions of the ``access_pattern``, and to
 apply the action to only up to ``bytes`` bytes of memory regions within the
 ``reset_interval_ms``.  Setting both ``ms`` and ``bytes`` zero disables the
-quota limits.
+quota limits unless at least one :ref:`goal <sysfs_schemes_quota_goals>` is
+set.
 
 Under ``weights`` directory, three files (``sz_permil``,
 ``nr_accesses_permil``, and ``age_permil``) exist.
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
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file-fix.patch
mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch
mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch
docs-admin-guide-mm-damon-reclaim-document-auto-tuning-parameters.patch


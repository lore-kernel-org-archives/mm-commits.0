Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67EE37187F
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439164; cv=none; b=pHixWSyFi6XOuRKo28L2Rh/4xEJK+vF3p88UWD/J9KnQdwXavAFlwCUgD9kbJyWVDmRXRXXImXxQ+huqUxwHaJDdREKqbHADx5BTam93sJx+0UCvo5Z80ffVOEXfmLgH7UIWbewQ8kyzkhvhR6r2V4Bfi3Ng427nqo0xIBUETaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439164; c=relaxed/simple;
	bh=Oans2eRU/fbxIFfeVp04bXkZ1pYC9WBGGR7ukmVhBZM=;
	h=Date:To:From:Subject:Message-Id; b=C9VIbbx7kZvdfnYEONNVkBNdK4qEK7bE25x8IGxrii1WYpI0qh1+fl0Vy+Kay4ER9VNVSsD0yEcFYd9eXfpzBLIap7yVh64bkNuiHX2B+Psv2tHn+vAkXruqPjVYAdtqO11kShLpdpyNecsFCjGHWFCwNAH4KiNfhoo3pw+ZSCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k9ylZgzI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k9ylZgzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF811F00893;
	Tue,  2 Jun 2026 22:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439163;
	bh=AQnoNTMXAZgtJQgZoUyUJ4xmx8Bks9kZR+VIFrFepUs=;
	h=Date:To:From:Subject;
	b=k9ylZgzI0b/krBZO7e03KfSjLNr0UdHxsI9X9i2zT3C5JocuugOOigLJDiH5w93T4
	 C05V4cPrh+dgauRjYYeC5Bab6Eyf9hdawNwY2wdUApsWrVtGfJGkfFqetVI+ph7ZbD
	 bV2ZfV8LMPrgKCW5tcabMLAikkQlFn9aq/DheOFg=
Date: Tue, 02 Jun 2026 15:26:03 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,maksym.shcherba@lnu.edu.ua,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-clarify-current_value-of-quota-goals.patch removed from -mm tree
Message-Id: <20260602222603.7BF811F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: clarify current_value of quota goals
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-clarify-current_value-of-quota-goals.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
Subject: Docs/admin-guide/mm/damon/usage: clarify current_value of quota goals
Date: Thu, 21 May 2026 23:20:20 +0300

The sysfs interface for DAMON quota goals includes a `current_value` file.
This file is not updated by the kernel and only serves to receive user
input.

Clarify in the documentation that the kernel does not update
`current_value`, and that reading it only has meaning when `target_metric`
is set to `user_input`.

While at it, fix missing commas in the goal files list.

Link: https://lore.kernel.org/20260521202020.126500-3-maksym.shcherba@lnu.edu.ua
Signed-off-by: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
Reviewed-by: SeongJae Park <sj@kernel.org>
Assisted-by: Antigravity:Gemini-3.1-Pro
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-clarify-current_value-of-quota-goals
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -474,10 +474,12 @@ to ``N-1``.  Each directory represents e
 Among the multiple feedback, the best one is used.
 
 Each goal directory contains five files, namely ``target_metric``,
-``target_value``, ``current_value`` ``nid`` and ``path``.  Users can set and
+``target_value``, ``current_value``, ``nid``, and ``path``.  Users can set and
 get the five parameters for the quota auto-tuning goals that specified on the
 :ref:`design doc <damon_design_damos_quotas_auto_tuning>` by writing to and
-reading from each of the files.  Note that users should further write
+reading from each of the files.  Because the kernel does not update
+``current_value``, reading it only makes sense when ``target_metric`` is
+``user_input``.  Note that users should further write
 ``commit_schemes_quota_goals`` to the ``state`` file of the :ref:`kdamond
 directory <sysfs_kdamond>` to pass the feedback to DAMON.
 
_

Patches currently in -mm which might be from maksym.shcherba@lnu.edu.ua are



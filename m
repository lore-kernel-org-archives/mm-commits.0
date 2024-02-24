Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C519DBA2D
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739426; cv=none; b=KAoV6GgkFYEsTWujOkvg1Jpsdhy5X8T1wpxXqFh0jZ15k9Bp95OHufhZ229GjWPDYz0J+POjvX6P44bycvNvWMVniJOIu4H08yPHlrkOSoEHPTAkswsJZ6B3s3zzhFX2oDz7SqyJ7gjj5OACB15Q5IPt6v8qe/r1wPXv2gY5kO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739426; c=relaxed/simple;
	bh=+azNhyPuBTZdYpxwIR0m0IodnoKkIAqgmbkzGXbqZDk=;
	h=Date:To:From:Subject:Message-Id; b=ga5vwufpjJA8ibd2Kcl4z5G1qeTTAJ0XVrDe1YghRRjpyee5cIV7XgvO2F4ivKjP2/k966nIimTPx1OG6XkKXNt896vY8p0C04zob2nZH9ST83jKUYs5bAzavMtexWDGLvXMpomm9L8mkdcOi5x8CX31pOnN8cBnkifZc11nDzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vNGz07Nx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vNGz07Nx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91600C433F1;
	Sat, 24 Feb 2024 01:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739426;
	bh=+azNhyPuBTZdYpxwIR0m0IodnoKkIAqgmbkzGXbqZDk=;
	h=Date:To:From:Subject:From;
	b=vNGz07NxXXMZVw7639+gGFFOvOxps3GCjr0MgU4BzvDLq9Yz35EaXd5S2mboXdlKR
	 EkOA+wQgp1BWQrgBnSb4A7O++FoaXkjPXEBiCvO3a1UBe4KKNFSRhI4urt7jsRZeuj
	 WeaOkEVEyGXx839dBY/+QyL//Qt39htNRnGowsok=
Date: Fri, 23 Feb 2024 17:50:26 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file.patch removed from -mm tree
Message-Id: <20240224015026.91600C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document quota goal metric file
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: document quota goal metric file
Date: Mon, 19 Feb 2024 11:44:28 -0800

Update DAMON usage document for the quota goal target_metric file.

[sj@kernel.org: fix a typo on the auto-tuning design reference link]
  Link: https://lkml.kernel.org/r/20240221170852.55529-3-sj@kernel.org
Link: https://lkml.kernel.org/r/20240219194431.159606-18-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -86,7 +86,7 @@ comma (",").
     │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,effective_bytes
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
-    │ │ │ │ │ │ │ │ │ 0/target_value,current_value
+    │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value
     │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
     │ │ │ │ │ │ │ :ref:`filters <sysfs_filters>`/nr_filters
     │ │ │ │ │ │ │ │ 0/type,matching,memcg_id
@@ -366,11 +366,11 @@ number (``N``) to the file creates the n
 to ``N-1``.  Each directory represents each goal and current achievement.
 Among the multiple feedback, the best one is used.
 
-Each goal directory contains two files, namely ``target_value`` and
-``current_value``.  Users can set and get any number to those files to set the
-feedback.  User space main workload's latency or throughput, system metrics
-like free memory ratio or memory pressure stall time (PSI) could be example
-metrics for the values.  Note that users should write
+Each goal directory contains three files, namely ``target_metric``,
+``target_value`` and ``current_value``.  Users can set and get the three
+parameters for the quota auto-tuning goals that specified on the :ref:`design
+doc <damon_design_damos_quotas_auto_tuning>` by writing to and reading from each
+of the files.  Note that users should further write
 ``commit_schemes_quota_goals`` to the ``state`` file of the :ref:`kdamond
 directory <sysfs_kdamond>` to pass the feedback to DAMON.
 
_

Patches currently in -mm which might be from sj@kernel.org are



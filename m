Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17471EB9E3
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119204; cv=none; b=e8FVe+IgR7uJXg4iGPNPS2Y8Ae6zasQtNMuIkdLzm6YDeP0uB57Njn+hLHri8PXEEVvNz6wj3eK/22SO7pTEm5K6BFR54QsO1RrSwzxPv1Cgrn8YOvpmnTZ/lA0qn5Ha5t4h/FkToFH9GWZ1N4Wtl5+Dss4Ada9aOZTb8HTa8EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119204; c=relaxed/simple;
	bh=zrwwZJUzlsxVziQi8a7XhcSVqEZ3JTuWzei6FnQ+jME=;
	h=Date:To:From:Subject:Message-Id; b=Xiut5A5zA9E7IF2wdCM0BHhps7nGEWsVXfuVl6TLk+1kK0pAqrA6zgD9nYVzffjPYg234mzd2Ps+qEHMqrazvWHqDfwga7NKI4iGWpHsgrXc3R+0UchGXK/3pdiUUHefNogjK3Flk9HFDRsLmnpHJXc4XqC0xVAy4+0cvEq33CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fn38c+Xr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fn38c+Xr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3810DC4CEE4;
	Tue, 13 May 2025 06:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119204;
	bh=zrwwZJUzlsxVziQi8a7XhcSVqEZ3JTuWzei6FnQ+jME=;
	h=Date:To:From:Subject:From;
	b=fn38c+XrF+PisTcbUrELO8Oqn6mJTsn2CsR4qvyTpGU6jG2MdBBsXe3nOOEEUL0YP
	 7aFBp8ehKPJ9eJ9IvQLyoNKcy6JWvjmX8wuQTRGDkksqepNwIY1Er3iOoJckVGwzz+
	 07aZ/UxKcCUomGvS1ZMAvA2oNcmLwGo0WGTSMzZA=
Date: Mon, 12 May 2025 23:53:23 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-node_mem_usedfree_bp.patch removed from -mm tree
Message-Id: <20250513065324.3810DC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: document node_mem_{used,free}_bp
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-node_mem_usedfree_bp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document node_mem_{used,free}_bp
Date: Sun, 20 Apr 2025 12:40:27 -0700

Add description of DAMOS quota goal metrics for NUMA node utilization on
the DAMON deesign document.

Link: https://lkml.kernel.org/r/20250420194030.75838-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Yunjeong Mun <yunjeong.mun@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-node_mem_usedfree_bp
+++ a/Documentation/mm/damon/design.rst
@@ -550,10 +550,10 @@ aggressiveness (the quota) of the corres
 is under achieving the goal, DAMOS automatically increases the quota.  If DAMOS
 is over achieving the goal, it decreases the quota.
 
-The goal can be specified with three parameters, namely ``target_metric``,
-``target_value``, and ``current_value``.  The auto-tuning mechanism tries to
-make ``current_value`` of ``target_metric`` be same to ``target_value``.
-Currently, two ``target_metric`` are provided.
+The goal can be specified with four parameters, namely ``target_metric``,
+``target_value``, ``current_value`` and ``nid``.  The auto-tuning mechanism
+tries to make ``current_value`` of ``target_metric`` be same to
+``target_value``.
 
 - ``user_input``: User-provided value.  Users could use any metric that they
   has interest in for the value.  Use space main workload's latency or
@@ -565,6 +565,11 @@ Currently, two ``target_metric`` are pro
   in microseconds that measured from last quota reset to next quota reset.
   DAMOS does the measurement on its own, so only ``target_value`` need to be
   set by users at the initial time.  In other words, DAMOS does self-feedback.
+- ``node_mem_used_bp``: Specific NUMA node's used memory ratio in bp (1/10,000).
+- ``node_mem_free_bp``: Specific NUMA node's free memory ratio in bp (1/10,000).
+
+``nid`` is optionally required for only ``node_mem_used_bp`` and
+``node_mem_free_bp`` to point the specific NUMA node.
 
 To know how user-space can set the tuning goal metric, the target value, and/or
 the current value via :ref:`DAMON sysfs interface <sysfs_interface>`, refer to
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-warn-and-fix-nr_accesses-corruption.patch
mm-damon-sysfs-schemes-fix-wrong-comment-on-damons_sysfs_quota_goal_metric_strs.patch
mm-damon-paddr-remove-unused-variable-folio_list-in-damon_pa_stat.patch
mm-damon-tests-core-kunit-add-a-test-for-damos_set_filters_default_reject.patch
selftests-damon-_damon_sysfs-read-tried-regions-directories-in-order.patch
docs-damon-update-titles-and-brief-introductions-to-explain-damos.patch


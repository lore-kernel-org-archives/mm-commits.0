Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930EF31AF07
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 22:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768343892; cv=none; b=lEv0YbfWIelBYXg4BhklF25Sydm4VVOyUg2lZKob5g8fuYYBoY+dCnuuG/BeSpfiajPZOLYARIpcPjWnsx5s8nqqGss8gqL1Ms3YDxUj7mQQ2LknUFasrXLb9c2bliVpbNKNIzdjTAlCdQeI4sKeO4v5S/OLZrA3wjo4VxvgiZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768343892; c=relaxed/simple;
	bh=CTGs6wL3ryBk2gk3JkLQOnPTGCb8Ew9jmeLhcJPiHL4=;
	h=Date:To:From:Subject:Message-Id; b=l9NJrc2Vo+aexaLAgAjUlZmOir7wwpasngDrsdlzvAWwJhoadDXkDHiXAQCuQXpIivSXyyobdGkfXhm9QzJokUn6UBciswx9kTamkCJ52uMPuUlTjsPLAe7X2k87dMqxrmEvdu3Sy+E9WU+1aqM1+1X83kcbEGpTrj9C/lqJMK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GErRtkcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GErRtkcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA9DC116C6;
	Tue, 13 Jan 2026 22:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768343892;
	bh=CTGs6wL3ryBk2gk3JkLQOnPTGCb8Ew9jmeLhcJPiHL4=;
	h=Date:To:From:Subject:From;
	b=GErRtkcXC0jztiHB56ORKRi17eGX2FWPDooZfzfry8fMbj2Dua142TiClL7LmgFYr
	 0GDdF+xrmMfmthO9wYml9kmty1B8C2BziXmAObB9lLiHu9eg8HRJTXwEeW8KdTA6QZ
	 W+qHBeLDkeWauL5HysDRDu2rqaUIUzqDqSAOqYWU=
Date: Tue, 13 Jan 2026 14:38:11 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch added to mm-new branch
Message-Id: <20260113223812.0DA9DC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/lru_sort: document filter_young_pages
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/lru_sort: document filter_young_pages
Date: Tue, 13 Jan 2026 07:27:12 -0800

Document the new DAMON_LRU_SORT parameter, filter_young_pages.  It can be
used to use page level access re-check for the LRU sorting.

Link: https://lkml.kernel.org/r/20260113152717.70459-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/lru_sort.rst |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/Documentation/admin-guide/mm/damon/lru_sort.rst~docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages
+++ a/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -79,6 +79,20 @@ of parametrs except ``enabled`` again.
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_LRU_SORT will be disabled.
 
+filter_young_pages
+------------------
+
+Filter [non-]young pages accordingly for LRU [de]prioritizations.
+
+If this is set, check page level access (youngness) once again before each
+LRU [de]prioritization operation.  LRU prioritization operation is skipped
+if the page has not accessed since the last check (not young).  LRU
+deprioritization operation is skipped if the page has accessed since the
+last check (young).  The feature is enabled or disabled if this parameter is
+set as ``Y`` or ``N``, respectively.
+
+Disabled by default.
+
 hot_thres_access_freq
 ---------------------
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch
mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix.patch
mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch
mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch
docs-mm-damon-design-document-damos_quota_active_mem_bp.patch
mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch
mm-damon-lru_sort-consider-age-for-quota-prioritization.patch
mm-damon-lru_sort-support-young-page-filters.patch
docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch
docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch
mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch


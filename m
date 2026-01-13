Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D5B2E266C
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 22:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768343880; cv=none; b=e85ZAF6+dr5AdAve3LnDwhZqVGyY4wZgUkX8vbu7NzhBvePWhHgtrHefaDuzjE/YWvWUm4ZnG7PBUKP0fKteMRb4uUYG9q7u6CsTESRb6yib2Q0tXL7zNAFaAhasPwSn8W6sZjvRD43pMMd1IAMIRvOMfTmvQkhx8C8PBcIBc7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768343880; c=relaxed/simple;
	bh=5xB/hfRyQLd59o8vO9g8mc4PGTLq9+B2k9PLjm0rUyk=;
	h=Date:To:From:Subject:Message-Id; b=Rq8Z8kOemfPmdb3CadwE+UZf0EpocBl0vdAqNlpXGmpZHOtgwYk55+UQ8XBiT5y7zDdatdEgMhEZdX3FAfhyhZFb6hvKkbpLwdno5mwoTCUb25KRLFQjBrleqNo4EfMzYaAe9t+66RT3nBjdAaH7lGa9+pCfk9esvatHAFtQL0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y1sOR6Mc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y1sOR6Mc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B94DC116C6;
	Tue, 13 Jan 2026 22:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768343879;
	bh=5xB/hfRyQLd59o8vO9g8mc4PGTLq9+B2k9PLjm0rUyk=;
	h=Date:To:From:Subject:From;
	b=y1sOR6McsGO3FvZotZCQ/rnSIqKlaM7McxcSPLV2GCAf1HVygD9k4sRzzDfFcvww1
	 CKS569oiqwMr2XUOFnxUvBfR1Jl2J3PwXvVwlvSl3jFWNATtRwwkNJJOkkd6F+iOgt
	 SBtWYdjPP6yRhQURmOMurZUDuP9MdlJVFOMTqGVc=
Date: Tue, 13 Jan 2026 14:37:58 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch added to mm-new branch
Message-Id: <20260113223759.8B94DC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: support DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch

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
Subject: mm/damon/sysfs-schemes: support DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
Date: Tue, 13 Jan 2026 07:27:07 -0800

Add support of DAMOS_QUOTA_[IN]ACTIVE_MEM_BP on DAMON sysfs interface. 
Users can use [in]active_mem_bp keyword input to the target_metric sysfs
file to use the new DAMOS quota auto-tune target metrics.

Link: https://lkml.kernel.org/r/20260113152717.70459-3-sj@kernel.org
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

 mm/damon/sysfs-schemes.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp
+++ a/mm/damon/sysfs-schemes.c
@@ -1079,6 +1079,14 @@ struct damos_sysfs_qgoal_metric_name dam
 		.metric = DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
 		.name = "node_memcg_free_bp",
 	},
+	{
+		.metric = DAMOS_QUOTA_ACTIVE_MEM_BP,
+		.name = "active_mem_bp",
+	},
+	{
+		.metric = DAMOS_QUOTA_INACTIVE_MEM_BP,
+		.name = "inactive_mem_bp",
+	},
 };
 
 static ssize_t target_metric_show(struct kobject *kobj,
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


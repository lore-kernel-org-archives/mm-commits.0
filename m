Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C71E3191B9
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486710; cv=none; b=QO1gUJ0NiFdgMy+i++M14KNSbSrzcSoo/Timq3vM5jBqozrUPiW7Ah48QngBoB0N2mo37wyczDpPrCXZOb1U6WksrYDjbHOUsJJcI35n3dRJ4V3C4aYU+XpuwTRG1JKYaIo4s3e8KvasBaAl7673tsq1Yd9ZDevwwrHU6p7hnTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486710; c=relaxed/simple;
	bh=FfUXAiQXwrweewWG14c62sP6IY68bmlc3gjxEwjQoyQ=;
	h=Date:To:From:Subject:Message-Id; b=jWTvBuxNn1SaGViaxpamIsRbZTtA7f2yqpkvp+ND8Z3J0RFx+JAquWxs8ewSv004Qdumnce2VHFYenzjtOrI1WX4FBPd2hU1EBooLmShfNd/nY2ibxF024R1F7aVHGcT2reJZd0pY01Jaj2NW+9as6wyXcCBxPvLlgnr+Evm9Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UHfxdD8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UHfxdD8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C504C116C6;
	Tue, 27 Jan 2026 04:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486710;
	bh=FfUXAiQXwrweewWG14c62sP6IY68bmlc3gjxEwjQoyQ=;
	h=Date:To:From:Subject:From;
	b=UHfxdD8RyiyanlGiJc2sfPZwa1Yp20FwRyIT7tRqroGzwukpb9PUQz/dV+QR4xQbB
	 ApauWoHCdG9syBubwRzNum3O6+xesXQ73F/XUQfEnEtU5yF0SVY5eBgHkujo//2vnV
	 nTWKwqqENkpldeDe9LAco3IaqfuDbXmCXMNml2wU=
Date: Mon, 26 Jan 2026 20:05:09 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch removed from -mm tree
Message-Id: <20260127040510.2C504C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: support DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: support DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
Date: Tue, 13 Jan 2026 07:27:07 -0800

Add support of DAMOS_QUOTA_[IN]ACTIVE_MEM_BP on DAMON sysfs interface. 
Users can use [in]active_mem_bp keyword input to the target_metric sysfs
file to use the new DAMOS quota auto-tune target metrics.

Link: https://lkml.kernel.org/r/20260113152717.70459-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: wang lian <lianux.mm@gmail.com>
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

selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch
selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch
selftests-damon-access_memory-add-repeat-mode.patch
selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch
selftests-damon-wss_estimation-deduplicate-failed-samples-output.patch
mm-damon-remove-damon_operations-cleanup.patch
mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination.patch
mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset.patch
mm-damon-core-process-damon_call_control-requests-on-a-local-list.patch
mm-damon-document-damon_call_control-dealloc_on_cancel-repeat-behavior.patch
mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out.patch
mm-damon-rename-damon_min_region-to-damon_min_region_sz.patch
mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz.patch
docs-mm-damon-index-simplify-the-intro.patch
docs-mm-damon-design-link-repology-instead-of-fedora-package.patch
docs-mm-damon-design-document-damon-sample-modules.patch
docs-mm-damon-design-add-reference-to-damon_stat-usage.patch
docs-admin-guide-mm-damon-usage-introduce-damon-modules-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-stats-update-process-for-refresh_ms.patch
docs-mm-damon-maintainer-profile-fix-wrong-maitnainers-section-name.patch
docs-mm-damon-maintainer-profile-remove-damon-tests-perf-suggestion.patch
maple_tree-start-using-maple-copy-node-for-destination-fix.patch


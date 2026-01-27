Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D7F3191B9
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486711; cv=none; b=EZ9o3HxFy9uK257fJdPy4SAiSiMA0Mo9xQaREVDhqcaNnqbiNwIYpJQwMC9TVU1pKcykq3it6OJm+wJYMZOLLKuI+5bCweGXBe/ogzqAVzKupwJlWAQd+qbZkqQE2448pn/w+74SMCR3U+SAfr6mn1fAscMHfp06cMWodwGISwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486711; c=relaxed/simple;
	bh=eVLLgkonRejKKAaMBqBEP5phPp22/a5LgiVE9nwhbrY=;
	h=Date:To:From:Subject:Message-Id; b=LoEaUrnrQErNs5y/dRvlPUbEdThXobPsqAF3bnMCkM2PnLuE66/HqEyaWcC9H7uCxarENrpuredzdDXVDVMP59J+Qmj21CkmM4ZNHrn9zwyNwpE8hNlP5QZ7VlwXPwLgz5OuUIy5iuDQ/9huaZ+acvyE+zohIn+TulPrTMFzc2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=03HF1D1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="03HF1D1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A86C116C6;
	Tue, 27 Jan 2026 04:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486711;
	bh=eVLLgkonRejKKAaMBqBEP5phPp22/a5LgiVE9nwhbrY=;
	h=Date:To:From:Subject:From;
	b=03HF1D1MWcnB0ROyLSymRDMWXw4dySnRn+CnZiluPXD3LcORmDI88YgtOUC4l2wyP
	 byzqZdSkSE6gD+ehGCSn0bcOseb481JPrFxt0nQBBojUT/O9evSd3JgvDNkVItERPS
	 trapv2S301Rsg/bSEgakAN70yZCokzU3b+Uu+SOw=
Date: Mon, 26 Jan 2026 20:05:10 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-damos_quota_active_mem_bp.patch removed from -mm tree
Message-Id: <20260127040511.63A86C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: document DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-damos_quota_active_mem_bp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
Date: Tue, 13 Jan 2026 07:27:08 -0800

Update design document for newly added DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
metrics.  Note that API document is automatically updated by kernel-doc
comment, and the usage document points to the design document which uses
keywords same to that for sysfs inputs.  Hence updating only design
document is sufficient.

Link: https://lkml.kernel.org/r/20260113152717.70459-4-sj@kernel.org
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

 Documentation/mm/damon/design.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-damos_quota_active_mem_bp
+++ a/Documentation/mm/damon/design.rst
@@ -585,6 +585,10 @@ mechanism tries to make ``current_value`
   specific NUMA node, in bp (1/10,000).
 - ``node_memcg_free_bp``: Specific cgroup's node unused memory ratio for a
   specific NUMA node, in bp (1/10,000).
+- ``active_mem_bp``: Active to active + inactive (LRU) memory size ratio in bp
+  (1/10,000).
+- ``inactive_mem_bp``: Inactive to active + inactive (LRU) memory size ratio in
+  bp (1/10,000).
 
 ``nid`` is optionally required for only ``node_mem_used_bp``,
 ``node_mem_free_bp``, ``node_memcg_used_bp`` and ``node_memcg_free_bp`` to
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


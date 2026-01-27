Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7153191B9
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486714; cv=none; b=Jcly0Sbrjh3nRwMxt+VUo/iR9UtOylO38qDOWg0Eh3Lx3xCuZx7h0cJuRdeqCgfVx/TG0eYb6FGnC2N23IGaTerlPoDQi4WdTDHV4Sec+2JX1XT2+oMcyeeiDYwwnvrMS1JH0GYilkLnJiFmtyNxbtabaKuI418y/HVFK8z/shg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486714; c=relaxed/simple;
	bh=uzUb3lGCQ8oMlOcEMoJ7Aelgi4GXVffvGdr4GsttRrs=;
	h=Date:To:From:Subject:Message-Id; b=SE4fUDcGVxJVzeBpTAn5z/xXRT1VuiSXBVWyo7bfa8BI5HLwrB9ntUktOy6KOaHHFY8oI4NvgE0oR/qBfq3774bcWPVK4CPyLVRt946Y2dNRwFXm/UPmXTLuXjgXGZsPOwgCs9NM9oHKDfoWASRz2p8M8IdQtMYa9vLuKCCcks0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d05wjFgE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d05wjFgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B3BC116C6;
	Tue, 27 Jan 2026 04:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486713;
	bh=uzUb3lGCQ8oMlOcEMoJ7Aelgi4GXVffvGdr4GsttRrs=;
	h=Date:To:From:Subject:From;
	b=d05wjFgEWvy3EboVCiXuX/LiBKEI/PyXMqAQfyMBtdKPf0PpkIG4BmbLXmHzD9muo
	 UVmYXeB7MxjroqGX3Mtb+eJMIG01hRCj33kGZ+8LV0nhN26K8tVW597c6m9kalH+0b
	 eilgeez37u4lJ+a4J33mgzVv7n/DzVe3AyvOHEf8=
Date: Mon, 26 Jan 2026 20:05:13 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-consider-age-for-quota-prioritization.patch removed from -mm tree
Message-Id: <20260127040513.C3B3BC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: consider age for quota prioritization
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-consider-age-for-quota-prioritization.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/lru_sort: consider age for quota prioritization
Date: Tue, 13 Jan 2026 07:27:10 -0800

DAMON_LRU_SORT is doing under-quota access pattern based regions
prioritization using only access frequency.  Age of regions is another
useful information for distinguishing hot and cold regions.  Use it for
prioritization, too.

Link: https://lkml.kernel.org/r/20260113152717.70459-6-sj@kernel.org
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

 mm/damon/lru_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-consider-age-for-quota-prioritization
+++ a/mm/damon/lru_sort.c
@@ -71,7 +71,7 @@ static struct damos_quota damon_lru_sort
 	/* Within the quota, mark hotter regions accessed first. */
 	.weight_sz = 0,
 	.weight_nr_accesses = 1,
-	.weight_age = 0,
+	.weight_age = 1,
 };
 DEFINE_DAMON_MODULES_DAMOS_TIME_QUOTA(damon_lru_sort_quota);
 
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


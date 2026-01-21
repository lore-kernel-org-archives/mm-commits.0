Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9F23612D2
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966073; cv=none; b=tqPY77DOxa+3ta8+NGJlr5sWX0+j6OsTcNE4s8/B/GTgimUHcGd+hsjcQrZvFL4m69QclGphNv+W9dt1vJ742fHI+j1LnxEHXVOYHh+/ARMCVhOWacMfzd6HwCTovZLM3NAh/+RM7v5ghhghmk/VRJxqWgTl7XnQlY6l0fy9ZGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966073; c=relaxed/simple;
	bh=j/W+q02qRNFRuVxt6N//KLZKBMu53LZvPsHqVKtd9sA=;
	h=Date:To:From:Subject:Message-Id; b=VN5pLRhPwQ80M00OO4SqaFHfkJCGgpmOHBf3s0mhrkIHRdt+XqMtjjmmeaRm6yMrK9LCHezrxmh2Xy4dL8y4BYKMtDkXgfi/2/GAjMmQXsu6fozU3Us85waaO+YM8YDJDw1/qLiHQMDGDrCiPLTrSCiNx4qRyuYUmhoODBJgcbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N+3bQRjZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N+3bQRjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F85C16AAE;
	Wed, 21 Jan 2026 03:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966073;
	bh=j/W+q02qRNFRuVxt6N//KLZKBMu53LZvPsHqVKtd9sA=;
	h=Date:To:From:Subject:From;
	b=N+3bQRjZSZNfInGwOZLXKpFa59E1wZxlw+qG2yWtM1yc2CDh6M6SMULSYioNISiBm
	 A45c5QgjTgVChAqMD+VjSjoFTH7w8Jpgv+1pbsYFi44j0KcMhPnBqL8GLcsvxlsj53
	 UwGzUI71j1zSHa5fsGqhlYxRIe5dnFTx5tkeyodo=
Date: Tue, 20 Jan 2026 19:27:53 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-update-damos-kerneldoc-for-stat-field.patch removed from -mm tree
Message-Id: <20260121032753.95F85C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: update damos kerneldoc for stat field
has been removed from the -mm tree.  Its filename was
     mm-damon-update-damos-kerneldoc-for-stat-field.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: update damos kerneldoc for stat field
Date: Tue, 16 Dec 2025 00:01:19 -0800

Commit 0e92c2ee9f45 ("mm/damon/schemes: account scheme actions that
successfully applied") has replaced ->stat_count and ->stat_sz of 'struct
damos' with ->stat.  The commit mistakenly did not update the related
kernel doc comment, though.  Update the comment.

Link: https://lkml.kernel.org/r/20251216080128.42991-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-update-damos-kerneldoc-for-stat-field
+++ a/include/linux/damon.h
@@ -532,9 +532,7 @@ struct damos_migrate_dests {
  * unsets @last_applied when each regions walking for applying the scheme is
  * finished.
  *
- * After applying the &action to each region, &stat_count and &stat_sz is
- * updated to reflect the number of regions and total size of regions that the
- * &action is applied.
+ * After applying the &action to each region, &stat is updated.
  */
 struct damos {
 	struct damos_access_pattern pattern;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch
mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch
docs-mm-damon-design-document-damos_quota_active_mem_bp.patch
mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch
mm-damon-lru_sort-consider-age-for-quota-prioritization.patch
mm-damon-lru_sort-support-young-page-filters.patch
docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning-fix.patch
docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch
mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch
mm-damon-core-implement-damon_kdamond_pid.patch
mm-damon-sysfs-use-damon_kdamond_pid.patch
mm-damon-lru_sort-use-damon_kdamond_pid.patch
mm-damon-reclaim-use-damon_kdamond_pid.patch
mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch
mm-vma-temporary-build-fix.patch
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13733191B9
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486720; cv=none; b=ZRjvsluNhjuXyFmr0PVH+gUeCUY3O+hnQlG/KjzMbVOdHvHJMt8PzXMjISQhvZZVEZaK+aObVH+pFdqvVhMJXatH17vWcwtjWOLyx4zKOYIY3a7McWkLH19kkhFRUa0a7ahCPpZ7ygJwkU+Mshyu7mt2RFYcDHBSxbP3A4QeyLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486720; c=relaxed/simple;
	bh=gmJZNLZXU/J5tLPstl5tqwDvG3/n/In+7wPQtlnFcJ8=;
	h=Date:To:From:Subject:Message-Id; b=SnDqNOM/3m6jrsHllqTK/ZeA8XgWTO/BtLMYX5/bi2/9VPCk4tRb9rLC1pbbPCTjjIhwpYOua/ahuT/uZjzFlxNHPX55FEbFdvpapH/8waKU27QndXCIAiSyqxF/0u5KKXVq49XniCc7JGd5L63ZMP6XcWLyEm1hTWBkiPzkXJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YQu1K8dz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YQu1K8dz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F29AC116C6;
	Tue, 27 Jan 2026 04:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486720;
	bh=gmJZNLZXU/J5tLPstl5tqwDvG3/n/In+7wPQtlnFcJ8=;
	h=Date:To:From:Subject:From;
	b=YQu1K8dzkczeqgfHDag5IimUYoPU4vMS5NPgdTmxtyHcbqnAOvc3p0DucKCslJWVY
	 b3wC2RP4PdqfEcbs8eFEVAYqIgjUhz0FcDj+b++kui28j7ayhzcF46EkzQDeBmdATH
	 bponBZHi52WvSjK6/0HBumG+ps3ElX440+k8+3Fk=
Date: Mon, 26 Jan 2026 20:05:20 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch removed from -mm tree
Message-Id: <20260127040520.8F29AC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/lru_sort: document active_mem_bp parameter
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/lru_sort: document active_mem_bp parameter
Date: Tue, 13 Jan 2026 07:27:14 -0800

Document a newly added DAMON_LRU_SORT parameter for doing auto-tuning
aiming an active to inactive memory size ratio.

Link: https://lkml.kernel.org/r/20260113152717.70459-10-sj@kernel.org
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

 Documentation/admin-guide/mm/damon/lru_sort.rst |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/Documentation/admin-guide/mm/damon/lru_sort.rst~docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter
+++ a/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -79,6 +79,18 @@ of parametrs except ``enabled`` again.
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_LRU_SORT will be disabled.
 
+active_mem_bp
+-------------
+
+Desired active to [in]active memory ratio in bp (1/10,000).
+
+While keeping the caps that set by other quotas, DAMON_LRU_SORT automatically
+increases and decreases the effective level of the quota aiming the LRU
+[de]prioritizations of the hot and cold memory resulting in this active to
+[in]active memory ratio.  Value zero means disabling this auto-tuning feature.
+
+Disabled by default.
+
 filter_young_pages
 ------------------
 
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


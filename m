Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552EF3191B9
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486716; cv=none; b=oOcXGuYXka52AqYPzkekfO4tZFSUyW1f00P7ApLxhsTxWULc1Zi7uxq/jcLT0NkBGe6IAtWx8EdKMVS2AUUl4AplsawEkZJlVrP6W87FQBzp1kTMX4v6wmMtwoAEXGp1YkNngPgsLKbLW0fPLLJPTJ9XqfHlqzjJ3Tfgo9rIIFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486716; c=relaxed/simple;
	bh=kI6PuxYf+57oapxGQV5zPN+9uAY3t9oTkAvmEe8Kasc=;
	h=Date:To:From:Subject:Message-Id; b=f3QsmZ/YZQ61BN5I5kLfqI0LLG+K/CaFrhKlGU3qDX/mZpbJlojeEh5vlVMJrjYvQ3dqw2/CXj1ZOft6LHAWaf4qftZgYurY1BdBYLcKAYMF4BXh7XsdTX/8794xFZ43qbeYwhzlqTaBwGXpMJpHnvtPomkbqdlLg1kjJHB8hOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uYEapCxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uYEapCxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA98C116C6;
	Tue, 27 Jan 2026 04:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486716;
	bh=kI6PuxYf+57oapxGQV5zPN+9uAY3t9oTkAvmEe8Kasc=;
	h=Date:To:From:Subject:From;
	b=uYEapCxCef7MVnExg/Dzo7o0Gp9i3Jf0z2Fv5x3RGx0fFqlUj3PMHkikotUHqTtXW
	 VCRXjaNG79m82JX1Efc5LQanRmXfzSf/x8hf/3khQAALYqErxyZoHprSw3/lCbmIrY
	 LuwCbRskYkNlfizRJvPVOSc9ENQZCEW75O0NraGU=
Date: Mon, 26 Jan 2026 20:05:15 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch removed from -mm tree
Message-Id: <20260127040516.2EA98C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/lru_sort: document filter_young_pages
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/lru_sort: document filter_young_pages
Date: Tue, 13 Jan 2026 07:27:12 -0800

Document the new DAMON_LRU_SORT parameter, filter_young_pages.  It can be
used to use page level access re-check for the LRU sorting.

Link: https://lkml.kernel.org/r/20260113152717.70459-8-sj@kernel.org
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


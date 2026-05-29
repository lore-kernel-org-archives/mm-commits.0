Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F642370AE0
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027684; cv=none; b=eJzobWDLUxNvjkfWZECs4bpw1fwpYvLJ8Lp/WJ5lLA15F9D4kZR2e8ZYw0hC6oz7vqanxHwLn4GRDVmHrwTgJGkYVWfDkyWxwYAQ+DIGWFg544sNZ2xbh9lQlrKVo61hkz8UHgClmKfYdGpy477VC0xk/PiK4V21b9HJtYUKHec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027684; c=relaxed/simple;
	bh=amb+hpTQebYpHRZlf/gRJf6EJQtuwqBd5s5BLnJ8td0=;
	h=Date:To:From:Subject:Message-Id; b=sWlBUaUQY6ppS+kO2hodYZKYN53UFf3VhLWm/I+vj+A56XN70QyHDaaabA4dDgsSdpkvmX1fmtRbYuIbA0Z9/+/l8rQN/v3kaOVtSkUJulmKUi3WwdAX2aSfg1xVR3tACp2M4ZWKYZrdn/nqDl6A92xbmcoHvEgatXcypAYNKn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z+el5Lih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z+el5Lih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150ED1F00898;
	Fri, 29 May 2026 04:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027683;
	bh=W1funQXENWrqOavxxMBIxDXgwOdbmMAEsnr3vhnzAe8=;
	h=Date:To:From:Subject;
	b=z+el5LihqEyJhgjH+HJ163qEiDN7bAlJFTWOCcJWn5NKLtXezM5nsHACznjn9Sm6G
	 pmR9OUbNCO386mtE0rk5Sixc/DgyjHqhOPlDjfPwb6wuqDP60TMyvrndvH5vUvLzx/
	 AlnAxlfN+a06EG6+rz2hu/y7iRkQe8wtojz2yxUY=
Date: Thu, 28 May 2026 21:08:02 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-lru_sort-update-for-entire-memory-monitoring.patch removed from -mm tree
Message-Id: <20260529040803.150ED1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/lru_sort: update for entire memory monitoring
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-lru_sort-update-for-entire-memory-monitoring.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/lru_sort: update for entire memory monitoring
Date: Tue, 28 Apr 2026 21:12:29 -0700

Update DAMON_LRU_SORT usage document for the changed default monitoring
target region selection.

Link: https://lore.kernel.org/20260429041232.90257-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/lru_sort.rst |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/damon/lru_sort.rst~docs-admin-guide-mm-damon-lru_sort-update-for-entire-memory-monitoring
+++ a/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -246,7 +246,8 @@ monitor_region_start
 Start of target memory region in physical address.
 
 The start physical address of memory region that DAMON_LRU_SORT will do work
-against.  By default, biggest System RAM is used as the region.
+against.  By default, the system's entire physical memory is used as the
+region.
 
 monitor_region_end
 ------------------
@@ -254,7 +255,8 @@ monitor_region_end
 End of target memory region in physical address.
 
 The end physical address of memory region that DAMON_LRU_SORT will do work
-against.  By default, biggest System RAM is used as the region.
+against.  By default, the system's entire physical memory is used as the
+region.
 
 addr_unit
 ---------
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-ops-common-call-folio_test_lru-after-folio_get.patch
mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
mm-damon-core-introduce-struct-damon_probe.patch
mm-damon-core-embed-damon_probe-objects-in-damon_ctx.patch
mm-damon-core-introduce-damon_filter.patch
mm-damon-core-commit-probes.patch
mm-damon-core-introduce-damon_region-probe_hits.patch
mm-damon-core-introduce-damon_ops-apply_probes.patch
mm-damon-core-do-data-attributes-monitoring.patch
mm-damon-paddr-support-data-attributes-monitoring.patch
mm-damon-sysfs-implement-probes-dir.patch
mm-damon-sysfs-implement-probe-dir.patch
mm-damon-sysfs-implement-filters-directory.patch
mm-damon-sysfs-implement-filter-dir.patch
mm-damon-sysfs-implement-filter-dir-files.patch
mm-damon-sysfs-setup-probes-on-damon-core-api-parameters.patch
mm-damon-sysfs-schemes-implement-tried_regions-r-probes.patch
mm-damon-sysfs-schemes-implement-probe-dir.patch
mm-damon-sysfs-schemes-implement-probe-hits-file.patch
mm-damon-trace-probe_hits.patch
selftests-damon-sysfssh-test-probes-dir.patch
docs-mm-damon-design-document-data-attributes-monitoring.patch
docs-admin-guide-mm-damon-usage-document-data-attributes-monitoring.patch
mm-damon-core-introduce-damon_filter_type_memcg.patch
mm-damon-paddr-support-damon_filter_type_memcg.patch
mm-damon-sysfs-add-filters-f-path-file.patch
mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common.patch
mm-damon-sysfs-setup-damon_filter-memcg_id-from-path.patch
docs-mm-damon-design-update-for-memcg-damon-filter.patch
docs-admin-guide-mm-damon-usage-update-for-memcg-damon-filter.patch
mm-damon-core-safely-handle-no-region-case-in-damon_set_regions.patch
mm-damon-core-do-not-use-region-out-of-a-loop-in-damon_set_regions.patch
samples-damon-mtier-replace-damon_add_region-with-damon_set_regions.patch
mm-damon-tests-vaddr-kunit-replace-damon_add_region-with-damon_set_regions.patch
mm-damon-core-hide-damon_add_region.patch
mm-damon-core-hide-damon_insert_region.patch
mm-damon-core-hide-damon_destroy_region.patch
mm-damon-core-add-kdamond_call-debug_sanity-check.patch
mm-damon-core-remove-damon_verify_nr_regions.patch
mm-damon-tests-core-kunit-add-damon_set_regions-test-cases.patch
selftests-damon-sysfspy-stop-kdamonds-before-failing.patch
selftests-damon-sysfssh-test-monitoring-intervals-goal-dir.patch
selftests-damon-sysfssh-test-addr_unit-file-existence.patch
selftests-damon-sysfssh-test-pause-file-existence.patch
mm-damon-core-trace-esz-at-first-setup.patch


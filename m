Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203261D63E4
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343099; cv=none; b=hmMybmqmVFTC5E+H9Y8cx5Pt+WxM2ceh4YWseKOhHmFYWFAAa1WFOtocWqmf0JojtBU2BrxLdtPC9Npe1SNrU/6f6q+Y1XYJQ2JZQGlkMiBfrD+PFj4fHDv6ggfm+wjWiiiop2GBugryfnPXCulPTp3SBV2g90Q2t3nmynjgMGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343099; c=relaxed/simple;
	bh=oGIkwWEWLsvOFyddZBjeF51f8m6G/WQ9HRtEbx63+lU=;
	h=Date:To:From:Subject:Message-Id; b=Zquyz7IyLwZYdfC+ODOHpXpEYY4eixbnB9Z786we8xV/FtHhX6pvukOUswbh0joGccl95WL2YZDIlx3a2/DdTFW77uHeGZWo8bjk34gW7+cF0KV8xr+BDGXVXW95XAcq40IYdKMAkN4NMLTXnWGAXrc5aGQ5Hf18VY6f6gzh0Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bYFF6Dv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bYFF6Dv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8AAC4CEF5;
	Mon, 17 Nov 2025 01:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343098;
	bh=oGIkwWEWLsvOFyddZBjeF51f8m6G/WQ9HRtEbx63+lU=;
	h=Date:To:From:Subject:From;
	b=bYFF6Dv3SBSUyTM3NZy4qCkOn92SJa+x4ODf3pAMPIQcJEHE3cKWTYsnoGCrSkErN
	 GpkBVKG6ZhCV694HNY/hSVM5cZW1I44MBG6SZJeVPGeD9d+Ypx6vJovquJXXbdt5AW
	 6wg6dDEyxHUuRxjgyc1vovYrG4Gs8ztfOapF2iRg=
Date: Sun, 16 Nov 2025 17:31:38 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,chrisl@kernel.org,chengming.zhou@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch removed from -mm tree
Message-Id: <20251117013138.8C8AAC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: remove unnecessary dlen writes for incompressible pages
has been removed from the -mm tree.  Its filename was
     mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/zswap: remove unnecessary dlen writes for incompressible pages
Date: Fri, 3 Oct 2025 13:38:48 -0700

Patch series "mm/zswap: misc cleanup of code and documentations".

Clean up an unnecessary local variable write in incompressible pages
handling, typos (s/zwap/zswap/) and outdated comments/documentations about
the zswap's red-black tree, which is replaced by xarray.


This patch (of 4):

Incompressible pages handling logic in zswap_compress() is setting 'dlen'
as PAGE_SIZE twice.  Once before deciding whether to save the content as
is, and once again after it is decided to save it as is.  But the value of
'dlen' is used only if it is decided to save the content as is, so the
first write is unnecessary.  It is not causing real user issues, but
making code confusing to read.  Remove the unnecessary write operation.

Link: https://lkml.kernel.org/r/20251003203851.43128-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20251003203851.43128-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Chris Li <chrisl@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages
+++ a/mm/zswap.c
@@ -894,7 +894,6 @@ static bool zswap_compress(struct page *
 	 * to the active LRU list in the case.
 	 */
 	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
-		dlen = PAGE_SIZE;
 		if (!mem_cgroup_zswap_writeback_enabled(
 					folio_memcg(page_folio(page)))) {
 			comp_ret = comp_ret ? comp_ret : -EINVAL;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-split-out-damos_test_commit_filter-core-logic.patch
mm-damon-tests-core-kunit-extend-damos_test_commit_filter_for-for-union-fields.patch
mm-damon-tests-core-kunit-add-test-cases-to-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goal-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goals-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota-test.patch
mm-damon-core-pass-migrate_dests-to-damos_commit_dests.patch
mm-damon-tests-core-kunit-add-damos_commit_dests-test.patch
mm-damon-tests-core-kunit-add-damos_commit-test.patch
mm-damon-tests-core-kunit-add-damon_commit_target_regions-test.patch
mm-damon-rename-damos-core-filter-helpers-to-have-word-core.patch
mm-damon-rename-damos-filters-to-damos-core_filters.patch
mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch
mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch
mm-damon-vaddr-consistently-use-only-pmd_entry-for-damos_migrate.patch
mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch
selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch
docs-mm-damon-maintainer-profile-fix-a-typo-on-mm-untable-link.patch
docs-mm-damon-maintainer-profile-fix-grammartical-errors.patch


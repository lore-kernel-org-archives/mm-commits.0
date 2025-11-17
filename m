Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8A32116F6
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343103; cv=none; b=uCzw0x7SLthdSiQhAwUgLK7E5DZytDMQXgbErT8BcPiK3H3qyMTWCoq5clvRWvcgD3cnGa7kS0o/AJZSQKVsTx7LHD9uDQ+/tRq5OUt8NjD74QeN8fMKWB5pVmizW6ynR/yOE3JvtFTtAobsZgurfmM0VFrqEe5gaWGkiinqTMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343103; c=relaxed/simple;
	bh=uIAPajihOz3oczQfmNFrWTyoUbuDdL7oSroEAjlwNko=;
	h=Date:To:From:Subject:Message-Id; b=qRsibVwC3erZy09ZQpiJW42+fcEFjzR+rh9HmTehdSTqw9ixr14NaDDZjJny2CpDJJDUWRnA0iS83WBAL4dzUQqou9yT8k3yDChV/jTnWHLzI/j1xKkABJym6KNK2+iuaXpe2tVyjOekIWSFiScdZrGeD3ZBkVlP7rLr1Tk1bAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m6eSfGeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m6eSfGeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5AEC4CEF5;
	Mon, 17 Nov 2025 01:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343103;
	bh=uIAPajihOz3oczQfmNFrWTyoUbuDdL7oSroEAjlwNko=;
	h=Date:To:From:Subject:From;
	b=m6eSfGeJw5F5Sq+TneQqP073RI3diMhdXUkwLv3WjEwyOUDyU4E4voZc1cgONuXO/
	 QYjc0SzdsogktNh15eYIcN0KRhm9VWlJdbdJVnu3c+Hk+mK2MiNjN4SOYpJcuW2krG
	 SDIPLXidDJhccncvfaJIXVGffHZk9K/ijFk5yudY=
Date: Sun, 16 Nov 2025 17:31:42 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,chrisl@kernel.org,chengming.zhou@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch removed from -mm tree
Message-Id: <20251117013143.1F5AEC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/zswap: s/red-black tree/xarray/
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/zswap: s/red-black tree/xarray/
Date: Fri, 3 Oct 2025 13:38:51 -0700

The change from commit 796c2c23e14e ("zswap: replace RB tree with xarray")
is not reflected on the document.  Update the document.

Link: https://lkml.kernel.org/r/20251003203851.43128-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/zswap.rst |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/mm/zswap.rst~docs-admin-guide-mm-zswap-s-red-black-tree-xarray
+++ a/Documentation/admin-guide/mm/zswap.rst
@@ -59,11 +59,11 @@ returned by the allocation routine and t
 accessed.  The compressed memory pool grows on demand and shrinks as compressed
 pages are freed.  The pool is not preallocated.
 
-When a swap page is passed from swapout to zswap, zswap maintains a mapping
-of the swap entry, a combination of the swap type and swap offset, to the
-zsmalloc handle that references that compressed swap page.  This mapping is
-achieved with a red-black tree per swap type.  The swap offset is the search
-key for the tree nodes.
+When a swap page is passed from swapout to zswap, zswap maintains a mapping of
+the swap entry, a combination of the swap type and swap offset, to the zsmalloc
+handle that references that compressed swap page.  This mapping is achieved
+with an xarray per swap type.  The swap offset is the search key for the xarray
+nodes.
 
 During a page fault on a PTE that is a swap entry, the swapin code calls the
 zswap load function to decompress the page into the page allocated by the page
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


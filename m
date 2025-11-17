Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291A42135B8
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343100; cv=none; b=nYcENR+oKse6VRp27Dmpd3x/yInQ95yY7UljjHTulgQ8X/cgJIdOhva0kfIpZVfXG88VErNViyv5AGhdyreMmJEjYnsAUUn44EbXdR1ltJ0RD+xPYD3KkFGqs1yygylhS3w0QJ6I/kaPuzHAuGoALJ927MpIc3JiQVxHbfX/5WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343100; c=relaxed/simple;
	bh=9GeLQzdKjt5KaDRwZY3JQM9fmQqsmHCjpbBV7/qjgeA=;
	h=Date:To:From:Subject:Message-Id; b=BeKpiQxKNy1EiI0dq4Ysa/y+prcuItIUSxKhc8S0s+puJunO1qU9PpyTexLjpyldqQOQYCvhFpzcdHYMvSuXcgfwQLZeP5cS7xdNiG5NwaY+7JIM386r7fCbUOxSXJ8QTFtjnePrKirkc0xwiMeeGVErM1bXL43AFuhyWzViVKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a6mHGq5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a6mHGq5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC058C19421;
	Mon, 17 Nov 2025 01:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343100;
	bh=9GeLQzdKjt5KaDRwZY3JQM9fmQqsmHCjpbBV7/qjgeA=;
	h=Date:To:From:Subject:From;
	b=a6mHGq5L6vpPZJyRFuKW94kvgKbw2+VtPKpeSv1dC1ug6flXMCdeo71kRvnmP5iHa
	 LXuiDaPDXet0MfqwqgDPwLk6NBAOqEhxaHbXdeN4jCPluE9X8hgq5T6ExfpaxeogZY
	 HqQGKFN0DbCiNwCMuyFmMU05VEDP2IQrIUSVJYCk=
Date: Sun, 16 Nov 2025 17:31:39 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,chrisl@kernel.org,chengming.zhou@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-fix-typos-s-zwap-zswap.patch removed from -mm tree
Message-Id: <20251117013139.EC058C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: fix typos: s/zwap/zswap/
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-typos-s-zwap-zswap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/zswap: fix typos: s/zwap/zswap/
Date: Fri, 3 Oct 2025 13:38:49 -0700

As the subject says.

Link: https://lkml.kernel.org/r/20251003203851.43128-3-sj@kernel.org
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

 mm/memcontrol.c |    2 +-
 mm/zswap.c      |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-zswap-fix-typos-s-zwap-zswap
+++ a/mm/memcontrol.c
@@ -5443,7 +5443,7 @@ bool obj_cgroup_may_zswap(struct obj_cgr
  * @size: size of compressed object
  *
  * This forces the charge after obj_cgroup_may_zswap() allowed
- * compression and storage in zwap for this cgroup to go ahead.
+ * compression and storage in zswap for this cgroup to go ahead.
  */
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
 {
--- a/mm/zswap.c~mm-zswap-fix-typos-s-zwap-zswap
+++ a/mm/zswap.c
@@ -879,7 +879,7 @@ static bool zswap_compress(struct page *
 	 * acomp instance, then get those requests done simultaneously. but in this
 	 * case, zswap actually does store and load page by page, there is no
 	 * existing method to send the second page before the first page is done
-	 * in one thread doing zwap.
+	 * in one thread doing zswap.
 	 * but in different threads running on different cpu, we have different
 	 * acomp instance, so multiple threads can do (de)compression in parallel.
 	 */
@@ -1128,7 +1128,7 @@ static enum lru_status shrink_memcg_cb(s
 	 *
 	 * 1. We extract the swp_entry_t to the stack, allowing
 	 *    zswap_writeback_entry() to pin the swap entry and
-	 *    then validate the zwap entry against that swap entry's
+	 *    then validate the zswap entry against that swap entry's
 	 *    tree using pointer value comparison. Only when that
 	 *    is successful can the entry be dereferenced.
 	 *
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


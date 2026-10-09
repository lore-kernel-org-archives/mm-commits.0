Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CA4409103
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525481; cv=none; b=oDVWIvhYl4PGiBT7Uh6kCz0n76Ouoi7WCHUz1H3Z9qcXBoXJcQa4WGC6OfblNAUeebQFZBvNeECAgn+EvkcAYXljHsrCfzhuwl8NfgYPo8xmKXGEC/dVrsE3vO1nNS5TlEGGxkHSRl1cZoxHSS+3AGKSEyO/FapT9/jHbupZrFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525481; c=relaxed/simple;
	bh=eIfq8ZEDTEQuGZVY+3YbpZgGqr/W0gdsRyV6GP5nlcs=;
	h=Date:To:From:Subject:Message-Id; b=mGYyfls/zaYBBNkmkKzU9ePFYKgdyfOalIuE7N0HsE7pbmL0Nw2MhH0YrgLc2geukzAXibdQHXyTyqcH7O1FRh71nK7mGijivQu8KIwzFwxLRJZ29R5dUG/HAgNMnPErhfVxfzVxFX6YplAS5mlzbqXRg3FR8VZVDBkdKS6vIIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XCNTZeR+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XCNTZeR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014D81F000FF;
	Fri,  9 Oct 2026 05:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525479;
	bh=PRbBzIReZbrWC+Bh5be1rn9hztD579LfkstsJG2JKfM=;
	h=Date:To:From:Subject;
	b=XCNTZeR+Y/Q46o2y7REXl7ivC4MN6sRZ6bS9FEya+nxPBIF/E7KsMQzW0nvv6eL81
	 o62IE6emsvwjjls0ZrsKVkTnI8xWc2/pIR4FL49MY7yzFV5URoEjkUuqKSaPIpYUEl
	 paeNbhfhfIMnPFk7deFBmBDAia3lDwUjN5P1LZ2s=
Date: Thu, 08 Oct 2026 22:57:58 -0700
To: mm-commits@vger.kernel.org,gutierrez.asier@huawei-partners.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-move-probe-filter-handling-to-ops-common.patch removed from -mm tree
Message-Id: <20261009055759.014D81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: move probe filter handling to ops-common
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-move-probe-filter-handling-to-ops-common.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/paddr: move probe filter handling to ops-common
Date: Wed, 9 Sep 2026 07:04:04 -0700

Probe filter matching logic for anon and memcg type filters in DAMON's
physical address space operation set (paddr) can be reused by virtual
address space operation set (vaddr) in future.  Prepare the future by
moving the code to ops-common.c

Link: https://lore.kernel.org/20260909140408.104699-3-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
---

 mm/damon/ops-common.c |   32 ++++++++++++++++++++++++++++++++
 mm/damon/ops-common.h |    2 ++
 mm/damon/paddr.c      |   23 +----------------------
 3 files changed, 35 insertions(+), 22 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-paddr-move-probe-filter-handling-to-ops-common
+++ a/mm/damon/ops-common.c
@@ -531,3 +531,35 @@ bool damos_ops_has_filter(struct damos *
 		return true;
 	return false;
 }
+
+bool damon_ops_filter_match(struct damon_filter *filter, struct folio *folio)
+{
+	bool matched = false;
+	struct mem_cgroup *memcg;
+
+	switch (filter->type) {
+	case DAMON_FILTER_TYPE_ANON:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		matched = folio_test_anon(folio);
+		break;
+	case DAMON_FILTER_TYPE_MEMCG:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		rcu_read_lock();
+		memcg = folio_memcg_check(folio);
+		if (!memcg)
+			matched = false;
+		else
+			matched = filter->memcg_id == mem_cgroup_id(memcg);
+		rcu_read_unlock();
+		break;
+	default:
+		break;
+	}
+	return matched == filter->matching;
+}
--- a/mm/damon/ops-common.h~mm-damon-paddr-move-probe-filter-handling-to-ops-common
+++ a/mm/damon/ops-common.h
@@ -31,3 +31,5 @@ bool damos_folio_filter_match(struct dam
 unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid);
 
 bool damos_ops_has_filter(struct damos *s);
+
+bool damon_ops_filter_match(struct damon_filter *filter, struct folio *folio);
--- a/mm/damon/paddr.c~mm-damon-paddr-move-probe-filter-handling-to-ops-common
+++ a/mm/damon/paddr.c
@@ -143,29 +143,8 @@ static bool damon_pa_filter_match(struct
 		struct folio *folio)
 {
 	bool matched = false;
-	struct mem_cgroup *memcg;
 
 	switch (filter->type) {
-	case DAMON_FILTER_TYPE_ANON:
-		if (!folio) {
-			matched = false;
-			break;
-		}
-		matched = folio_test_anon(folio);
-		break;
-	case DAMON_FILTER_TYPE_MEMCG:
-		if (!folio) {
-			matched = false;
-			break;
-		}
-		rcu_read_lock();
-		memcg = folio_memcg_check(folio);
-		if (!memcg)
-			matched = false;
-		else
-			matched = filter->memcg_id == mem_cgroup_id(memcg);
-		rcu_read_unlock();
-		break;
 	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
 		if (!folio)
 			matched = false;
@@ -173,7 +152,7 @@ static bool damon_pa_filter_match(struct
 			matched = damon_folio_young(folio);
 		break;
 	default:
-		break;
+		return damon_ops_filter_match(filter, folio);
 	}
 	return matched == filter->matching;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-read-sysfs_filter-addr_range-only-once.patch
mm-damon-sysfs-schemes-read-sysfs_filter-sz_range-only-once.patch
mm-damon-core-return-an-error-from-damos_commit_filter_arg.patch
mm-damon-core-disallow-max-min-damos-filter-range-arguments-commit.patch
mm-damon-sysfs-schemes-drop-centralized-filter-range-arg-validations.patch
mm-damon-sysfs-schemes-use-switch-case-in-add_scheme_filters.patch
mm-damon-core-kunit-extend-damos_commit_filter_for-for-wrong-input.patch
mm-damon-core-kunit-test-invalid-damos-filter-commits.patch
mm-damon-api-introduce-damon_filter_type_hugepage_size.patch
mm-damon-core-commit-hugepage_size-type-damon-filter.patch
mm-damon-ops-common-support-hugepage_size-damon-filter-matching.patch
mm-damon-sysfs-add-minmax-files-under-probe-filter-directory.patch
mm-damon-sysfs-support-hugepage_size-probe-filter.patch
docs-mm-damon-design-update-for-hugepage_size-probe-filter.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size.patch
docs-abi-damon-update-for-hugepage_size-probe-filter.patch
mm-damon-api-remove-nr_damos_filter_types.patch
mm-damon-core-use-abs_diff-in-damon_feed_loop_next_input.patch
mm-damon-core-use-mult_frac-in-damon_feed_loop_next_input.patch
mm-damon-core-set-damon_ctx-walk_control_obsolete-in-damon_new_ctx.patch
mm-damon-core-document-damon_call-damon_start-race-hang-issue.patch
mm-damon-paddr-remove-pa-parameter-from-damon_pa_filter_pass.patch
mm-damon-tests-core-kunit-test-eligible_mem_bp-commitment.patch
mm-damon-tests-core-kunit-add-probe_hits_wsum-damos-filter-commit-test.patch
selftests-damon-sysfs_memcg_path_leak-fail-only-for-real-damon-leak.patch
docs-mm-damon-design-clarify-bp-is-basis-point.patch
mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch


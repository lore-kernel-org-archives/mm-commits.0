Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EACA411FBE
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525553; cv=none; b=VlDEKixKrMcEMDxv36HTab1vtcqyzp8289pSlU7PF98RdlbeySpYyTVn7EE9e4T31nBP8STuk0hgVwe2mWftAgnyNL57XqnMzQUh/GC1yMs3LCPilpYMxhu2Wn674YUY8VyP8nW2GOtMn0Yb3Om08Wvp0LAKznzVdwEqmDpBZOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525553; c=relaxed/simple;
	bh=tA8m2l89uBQp6oSy3jcNoxOMQ7SDq9GHUvnkC/udnyU=;
	h=Date:To:From:Subject:Message-Id; b=AB4/inZcu2EFviaQ6Q6gta2zVOO+QbUZpF0800fEgjvXlhoF4tSBRcx57+ZxTI8E9wcOgQhj+Xvp4hRm5S5qn+ljpOyG31DjCkeB1L3OEJc5NikT9TuLgW+OTg04FqywU0hCuJqEaFQdi+bk+hKW9y5+R6BNvvbms/ZEHuWVgDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tudD2bY5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tudD2bY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1901F00893;
	Fri,  9 Oct 2026 05:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525551;
	bh=BJuqRN7KC4u85JL3llKii7WA/MZvOYyF9ZrP4u8TLbA=;
	h=Date:To:From:Subject;
	b=tudD2bY5Ju44yRUYNJ0/J038H62xK57YIPwS9NSy/HxWgwyJvYVSfg4QiTR3gph5D
	 1UsM2m++/uQQFz1RDT2KghjXnVqId3iFRvBhOGALD/oQuB7ogCz/xCkJPecRhWAtK1
	 5Y5y1CM9PasDaqqBGM2o1gcWk3E4A4Ms8YXNkOGk=
Date: Thu, 08 Oct 2026 22:59:10 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-extend-probe_hits_wsum-for-moving-sum-based-calculation.patch removed from -mm tree
Message-Id: <20261009055911.3D1901F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: extend probe_hits_wsum() for moving sum based calculation
has been removed from the -mm tree.  Its filename was
     mm-damon-core-extend-probe_hits_wsum-for-moving-sum-based-calculation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: extend probe_hits_wsum() for moving sum based calculation
Date: Fri, 11 Sep 2026 06:55:04 -0700

damon_probe_hits_wsum() is being called only in aggregation time.  In
future, it could also be used by DAMOS.  In this case, since DAMOS uses
its own apply_interval, it could be called in sampling time.  Then using
the not yet fully aggregated probe_hits could result in suboptimum
outcomes.  Extend damon_probe_hits_wsum() to get the weighted sum based on
moving sum to prepare the DAMOS usage.

Link: https://lore.kernel.org/20260911135510.96914-3-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 include/linux/damon.h |    2 +-
 mm/damon/core.c       |    8 ++++++--
 mm/damon/paddr.c      |    2 +-
 mm/damon/vaddr.c      |    2 +-
 4 files changed, 9 insertions(+), 5 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-extend-probe_hits_wsum-for-moving-sum-based-calculation
+++ a/include/linux/damon.h
@@ -1075,7 +1075,7 @@ unsigned int damon_nr_accesses_mvsum(str
 		struct damon_ctx *ctx);
 unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
 		struct damon_ctx *ctx);
-unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
+unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last, bool mv,
 		struct damon_ctx *ctx);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
--- a/mm/damon/core.c~mm-damon-core-extend-probe_hits_wsum-for-moving-sum-based-calculation
+++ a/mm/damon/core.c
@@ -469,11 +469,12 @@ static bool damon_is_last_region(struct
  * damon_probe_hits_wsum() - Returns probe hits weighted sum of a region.
  * @r:		region to get the weighted sum of.
  * @last:	if the request is for last-window aggregated probe hits.
+ * @mv:		use moving sum.
  * @ctx:	context of &r.
  *
  * Return: the weighted sum of probe hits of the region.
  */
-unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
+unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last, bool mv,
 		struct damon_ctx *ctx)
 {
 	struct damon_probe *probe;
@@ -483,6 +484,9 @@ unsigned int damon_probe_hits_wsum(struc
 	damon_for_each_probe(probe, ctx) {
 		if (last)
 			sum += r->last_probe_hits[i++] * probe->weight;
+		else if (mv)
+			sum += damon_probe_hits_mvsum(i++, r, ctx) *
+				probe->weight;
 		else
 			sum += r->probe_hits[i++] * probe->weight;
 	}
@@ -3472,7 +3476,7 @@ static unsigned int damon_merge_score(st
 		struct damon_ctx *ctx, bool use_probe_hits)
 {
 	if (use_probe_hits)
-		return damon_probe_hits_wsum(r, last, ctx);
+		return damon_probe_hits_wsum(r, last, false, ctx);
 	if (last)
 		return r->last_nr_accesses;
 	return r->nr_accesses;
--- a/mm/damon/paddr.c~mm-damon-core-extend-probe_hits_wsum-for-moving-sum-based-calculation
+++ a/mm/damon/paddr.c
@@ -208,7 +208,7 @@ static unsigned int damon_pa_apply_probe
 				folio_put(folio);
 			if (return_max_wsum)
 				max_wsum = max(damon_probe_hits_wsum(r, false,
-							ctx), max_wsum);
+							false, ctx), max_wsum);
 		}
 	}
 	return max_wsum;
--- a/mm/damon/vaddr.c~mm-damon-core-extend-probe_hits_wsum-for-moving-sum-based-calculation
+++ a/mm/damon/vaddr.c
@@ -711,7 +711,7 @@ static unsigned int damon_va_apply_probe
 			__damon_va_apply_probes(ctx, mm, r);
 			if (return_max_wsum)
 				max_wsum = max(damon_probe_hits_wsum(r, false,
-							ctx), max_wsum);
+							false, ctx), max_wsum);
 		}
 		if (mm)
 			mmput(mm);
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


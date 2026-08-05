Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201923BFE47
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896710; cv=none; b=AOaaYUMJOz3RWsZgdn4A0AZ4BxTtviKVHM8BlyeiZZY3citrgCjYfGcVB/nyQw7Zt7DOQbk6SO+B3ToCrgRLc3/3jRWiuxzJKpRBIAYZ+wuaFneL8F1a3erFAQVXB/+OACb1sUnBCSkjYZsx0l69AiUFV8BdNpBgGIVV7PykXG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896710; c=relaxed/simple;
	bh=VgpFR5J/2iZmlSHJTucoxs81h2jUB3f4LojwAJok1U8=;
	h=Date:To:From:Subject:Message-Id; b=apz2clbJuWGFwWUa/6yMFIdm8VJsz+t4HpcMwAcD1escXXPhFzAaBhnS9GBFFpwNJIAln8MYMOISOBxTmGMrGU574itAuPSzSNWW+YXH5Ts1O2KeYsAVGDH22wYg9CYKaPk25SFF7IP5WO3uQIHKRpgS/62VhNAr828Z0WD1mZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bf89wpvH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bf89wpvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3691F00A3A;
	Wed,  5 Aug 2026 02:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896709;
	bh=q4KcH2elV7Ypd10o0VEK4s8TXxGc7WSd0TtnBF04oQ4=;
	h=Date:To:From:Subject;
	b=Bf89wpvHOEXy+jsjGKVPhAuCjALwXFXaecyGQX/4A9TB76HrnTMRqn94lP9BpYq1W
	 h3/ZWjxx6TtpOsHtt7+yt8qSot7w5n052iY3AhAq+K5Hh9qSchwvWaGQF4i1m0X+9M
	 ZfnXXmbk7Y1JnKDaMhiBCa7YHw+k4sLvt28VK4a0=
Date: Tue, 04 Aug 2026 19:25:08 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-respect-return_max_wsum.patch removed from -mm tree
Message-Id: <20260805022508.DE3691F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: respect return_max_wsum
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-respect-return_max_wsum.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/paddr: respect return_max_wsum
Date: Fri, 10 Jul 2026 06:46:35 -0700

apply_probes() ops implementation in DAMON_PADDR is ignoring
return_max_wsum.  Respect it.

Link: https://lore.kernel.org/20260710134651.18084-7-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
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

 mm/damon/paddr.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-respect-return_max_wsum
+++ a/mm/damon/paddr.c
@@ -172,6 +172,7 @@ static unsigned int damon_pa_apply_probe
 	struct damon_target *t;
 	struct damon_region *r;
 	struct damon_probe *p;
+	unsigned int max_wsum = 0;
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t) {
@@ -182,7 +183,6 @@ static unsigned int damon_pa_apply_probe
 			if (set_samples)
 				r->sampling_addr = damon_rand(ctx, r->ar.start,
 						r->ar.end);
-
 			pa = damon_pa_phys_addr(r->sampling_addr,
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
@@ -193,9 +193,12 @@ static unsigned int damon_pa_apply_probe
 			}
 			if (folio)
 				folio_put(folio);
+			if (return_max_wsum)
+				max_wsum = max(damon_probe_hits_wsum(r, false,
+							ctx), max_wsum);
 		}
 	}
-	return 0;
+	return max_wsum;
 }
 
 /*
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-adjust-isolated-pages-stat-for-damos_migrate_hotcold.patch
samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch
mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch
mm-damon-reclaim-skip-damon_call-if-ctx-has-not-started.patch
mm-damon-lru_sort-skip-damon_call-if-ctx-has-not-started.patch
mm-damon-core-skip-aging-from-repeated-aggressive-merging.patch
mm-damon-core-hide-private-damon_region-fields.patch
mm-damon-core-hide-private-damon_target-fields.patch
mm-damon-core-hide-private-damos_quota_goal-fields.patch
mm-damon-core-hide-private-damos_quota-fields.patch
mm-damon-core-hide-private-damos_filter-fields.patch
mm-damon-core-hide-private-damos-fields.patch
mm-damon-core-hide-private-damon_filter-fields.patch
mm-damon-core-hide-private-damon_probe-fields.patch
mm-damon-sysfs-do-not-directly-access-damon_ctx-ops.patch
mm-damon-core-hide-core-private-damon_ctx-fields.patch
mm-damon-core-avoid-infinite-kdamond_merge_regions-internal-loop.patch
mm-damon-tests-core-kunit-catch-test-failure-in-test_merge_regions_of.patch
mm-damon-vaddr-drop-last-same-folio-access-check-optimization.patch
mm-damon-paddr-drop-last-same-folio-access-check-reuse-optimization.patch
mm-damon-sysfs-read-addr_unit-only-once-in-damon_sysfs_apply_inputs.patch
mm-damon-sysfs-read-ops_id-only-once-in-damon_sysfs_apply_inputs.patch
mm-damon-core-initialize-damos-last_applied.patch
mm-damon-core-kunit-check-region-count-before-testing-in-split_at.patch
mm-damon-vaddr-kunit-check-region-count-in-three_regions-test.patch
mm-damon-core-kunit-handle-region-split-failure-in-filter_out.patch
mm-damon-core-kunit-skip-wrong-dest-walk-in-commit_dests_for.patch
mm-damon-core-kunit-skip-wrong-quota-goal-walk-in-commit_quota_goals.patch
mm-damon-core-kunit-skip-wrong-region-walk-in-commit_target_regions.patch
mm-damon-ops-common-use-nr_accesses-moving-sum-for-quota-score.patch
mm-damon-core-handle-region-split-failure-in-apply_min_nr_regions.patch


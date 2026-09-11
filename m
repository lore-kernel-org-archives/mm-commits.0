Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86303ED5CD
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 23:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789168775; cv=none; b=EH6yZOke74RX/igfCIQH+LVoY3N/Jpg8mcvTIc263vLuvhyKc7OYXwkYJFFxkBkW5CMYGV8zmmpyzh8zzr9Tr9jkN0wjZsYttfd337dG5fazUSik0caXVAYuJcoVBsZCIEOavtJFvOaXdSMbmzM9r3VBkO5kcrDNmC2I/OM5E+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789168775; c=relaxed/simple;
	bh=4IFMZ9r3U33RMHIJRfGnTbmsYmIiQ6tq5FDhjYKb608=;
	h=Date:To:From:Subject:Message-Id; b=MO/Ccsd87gY6kAViuGO6QwEUP34Fz2OsLSGLImuR2CtTdl/U1EbryA68t/SsWntR/BDPJ5zt3tJJar7rHzsrdZDkDF8S0aJnwrG3BD9Ve+kZZburcNB6VASDYkrecHSN2uSFpEerjOZSvN2m1H6Ghd5XNgyO9FE51vYiNKa6fEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KpAzQRtC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KpAzQRtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6E51F000FF;
	Fri, 11 Sep 2026 23:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789168773;
	bh=m6hMLy8JBcsLci0tsKxyM006JsQbEEU+Ap/ZadJgsA8=;
	h=Date:To:From:Subject;
	b=KpAzQRtCAR2dKJbxh5gvbgQhMgvGHIDsLXuwcaj1vGKhW9ZeovriKsbMu3HzqWmnp
	 Q4ZhE2QIPAk0xJNVnirf10Md3wWqKQ/+/TYDD+FVeB3xC2KOlfKwfZpRJ6+NCsoi27
	 VETYIxtTwYs1ZddLcaXLBqViQKAyPjRJ/QfWMOnE=
Date: Fri, 11 Sep 2026 16:19:33 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-extend-probe_hits_wsum-for-moving-sum-based-calculation.patch added to mm-new branch
Message-Id: <20260911231933.AC6E51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: extend probe_hits_wsum() for moving sum based calculation
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-extend-probe_hits_wsum-for-moving-sum-based-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-extend-probe_hits_wsum-for-moving-sum-based-calculation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
@@ -3456,7 +3460,7 @@ static unsigned int damon_merge_score(st
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

mm-damon-vaddr-avoid-hw-driven-pte-updates-during-damon_hugetlb_mkold.patch
mm-damon-core-reset-invalid-quota-charge_target_from.patch
mm-damon-core-skip-applying-scheme-if-region-split-for-quota-fails.patch
mm-damon-paddr-respect-folio-end-for-damos_stat.patch
mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold.patch
mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch
mm-damon-core-introduce-damon_filter_type_pgidle_unset.patch
mm-damon-paddr-support-pgidle_unset-probe-filter-type.patch
mm-damon-sysfs-support-pgidle_unset-probe-filter-type.patch
docs-mm-damon-design-document-pgidle_unset-probe-filter-type.patch
mm-damon-core-introduce-damon_prep-struct.patch
mm-damon-core-commit-preps.patch
mm-damon-core-introduce-damon_operations-prep_probes.patch
mm-damon-paddr-support-damon_prep.patch
mm-damon-sysfs-implement-preps-directory.patch
mm-damon-sysfs-implement-preps-nr_preps-file.patch
mm-damon-sysfs-create-directories-for-nr_preps-writes.patch
mm-damon-sysfs-implement-prep_action-file.patch
mm-damon-sysfs-pass-preps-to-damon-core.patch
selftests-damon-sysfssh-test-probe-prep-sysfs-files.patch
docs-mm-damon-design-document-probe-preps.patch
docs-admin-guide-mm-damon-usage-document-probe-preps-sysfs-files.patch
docs-abi-damon-document-probe-prep-sysfs-files.patch
mm-damon-tests-core-kunit-test-committing-psi-goal-to-psi-goal.patch
mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total.patch
mm-damon-core-copy-nid-for-eligible_mem_bp-damos-quota-goal-commit.patch
mm-damon-sysfs-set-next-refresh-jiffies-per-sysfs-context.patch
mm-damon-tests-core-kunit-test-damon_commit_filter.patch
mm-damon-tests-core-kunit-add-damon_commit_probes-test.patch
selftests-damon-_damon_sysfs-implement-damonprobes.patch
selftests-damon-drgn_dump_damon_status-dump-probes.patch
selftests-damon-sysfspy-extend-commit-assertion-function-for-probes.patch
selftests-damon-sysfspy-test-damon-probes.patch
mm-damon-core-use-damon_nr_samples_per_aggr-for-max-merge-threshold.patch
mm-damon-core-remove-debug-messages.patch
mm-damon-core-remove-debug-messages-fix.patch
mm-damon-vaddr-remove-a-debug-message.patch
mm-damon-core-validate-number-of-probes-in-valid_probe_params.patch
mm-damon-sysfs-remove-probes-number-validation.patch
mm-damon-tests-core-kunit-extend-set_regions-test-for-error-case.patch
mm-damon-tests-core-kunit-test-=0-size-damon_set_regions-inputs.patch
mm-damon-tests-core-kunit-test-overlapping-ranges-for-set_regions.patch
mm-damon-tests-core-kunit-test-damon_nr_samples_per_aggr.patch
selftests-damon-sysfssh-test-hugepage_mem_bp-quota-goal.patch
docs-mm-damon-maintainer-profile-update-ai-review-for-sashiko-replies.patch
docs-abi-damon-recommend-subsystem-doc-instead-of-admin-guide.patch
mm-damon-core-error-damos_commit_quota_goal-for-zero-target_value.patch
revert-mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch
revert-samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch
mm-damon-core-handle-null-ctx-parameter-in-damon_call.patch
mm-damon-core-set-ctx-call_controls_obsolete-in-damon_new_ctx.patch
mm-damon-reclaim-remove-unnecessary-damon_call-param-validation.patch
mm-damon-lru_sort-remove-unnecessary-damon_call-param-validation.patch
mm-damon-vaddr-support-prep_probes.patch
mm-damon-paddr-move-probe-filter-handling-to-ops-common.patch
mm-damon-vaddr-support-apply_probe.patch
mm-damon-vaddr-extend-apply_probes-for-hugetlb.patch
mm-damon-vaddr-support-pgidle_unset-probe-filter-type.patch
mm-damon-api-introduce-damon_filter_type_pgidle_set.patch
mm-damon-paddr-support-damon_filter_type_pgidle_set.patch
mm-damon-vaddr-support-damon_filter_type_pgidle_set.patch
mm-damon-sysfs-support-damon_filter_type_pgidle_set.patch
docs-mm-damon-design-update-for-pgidle_set-probe-filter.patch
mm-damon-api-introduce-damos_filter_type_probe_hits_wsum.patch
mm-damon-api-introduce-damos_filter_type_probe_hits_wsum-fix.patch
mm-damon-core-extend-probe_hits_wsum-for-moving-sum-based-calculation.patch
mm-damon-core-support-probe_hits_wsum-damos-core-filter.patch
mm-damon-sysfs-schemes-rename-sysfs_filter-sz_range-to-range_minmax.patch
mm-damon-sysfs-schemes-support-probe_hits_wsum-damos-core-filter.patch
docs-mm-damon-design-update-for-probe_hits_wsum-damos-core-filter.patch
docs-admin-guide-mm-damon-usage-update-for-probe_hits_wsum-damos-filter.patch


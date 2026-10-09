Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DD13F58CC
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525365; cv=none; b=AAYf9MtPkvRN6U3qrGhBffecAA+N0p+aa5P528aoI6qE/kEXyTb/5A5U9P8rMz8SntyzI6SXKyPqWLwUsvgMq9gR3FhhFnBnZ4sog7wWseo4u3iIPhua0ERswH6V+61PGQRGH2Bs79IOXgzo84irKG9aNRV8AVheS47RQP0hpeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525365; c=relaxed/simple;
	bh=b631lZh9ouwBXLbqPUfwGQlJ/KvAiAMYvguVGPSpiRE=;
	h=Date:To:From:Subject:Message-Id; b=iDcqN78RFDZNApY8JsEhrJXepvVbMmifJuPiu/BjZ9BRz49GRU1+Adjq+XPucWZoAYPVYLhehzDfbjnNZ1fWHjURKnQiZB6E2JvNMNQPMd5aX/RRB2V12f4N03P9tUdNXwxE7cL2xeXYFkiTlp/0uuxvREjFjs0AnqbLOUwENLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A+kPHqaE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A+kPHqaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F311F00893;
	Fri,  9 Oct 2026 05:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525364;
	bh=q7foOfv8NH2OKLmQhISVEB+biYAK4VmRijtBYjYcDkk=;
	h=Date:To:From:Subject;
	b=A+kPHqaEICeWPR+jr58fnxVXp5fSstuVNRcuvJr1Zem5+bXmgmZagZBkHsvHA4Ylj
	 DjnLJI9SMPmZTv4v25QBm4Xd0PDY+tLBxZO9lYcAlZP5wnhjNw+77eA9mXsSD1JALx
	 UOWj/L2i83gwZkWKaaaay8YfYOWen1+4O377WmwM=
Date: Thu, 08 Oct 2026 22:56:03 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kunwu.chan@gmail.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-use-damon_nr_samples_per_aggr-for-max-merge-threshold.patch removed from -mm tree
Message-Id: <20261009055604.10F311F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: use damon_nr_samples_per_aggr() for max merge threshold
has been removed from the -mm tree.  Its filename was
     mm-damon-core-use-damon_nr_samples_per_aggr-for-max-merge-threshold.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: use damon_nr_samples_per_aggr() for max merge threshold
Date: Tue, 1 Sep 2026 22:47:34 -0700

Patch series "mm/damon: cleanup code, add test cases, and update guidances
in docs".

Misc cleanup, improvements and updates of code, test, and documents.

Patches 1-5 cleanup DAMON code.  Patches 6-10 adds kunit and selftest test
cases for recently fixed bugs and a new feature.  Patches 11 and 12 update
guidelines for AI review and what document to read, on DAMON documents.


This patch (of 12):

kdamond_merge_regions() open-codes max region merge threshold calculation.
What it does is fundamentally the same as damon_nr_samples_per_aggr() but
missing a few corner cases.  The unhandled corner cases should be rare and
make only a negligible level of monitoring results degradation.  But
having the inconsistency could increase future maintenance burden.  Use
the dedicated function.

Link: https://lore.kernel.org/20260902054747.99370-1-sj@kernel.org
Link: https://lore.kernel.org/20260902054747.99370-2-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/damon/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-use-damon_nr_samples_per_aggr-for-max-merge-threshold
+++ a/mm/damon/core.c
@@ -3533,8 +3533,7 @@ static void kdamond_merge_regions(struct
 	unsigned int max_thres;
 	bool count_age = true;
 
-	max_thres = c->attrs.aggr_interval /
-		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
+	max_thres = damon_nr_samples_per_aggr(&c->attrs);
 	while (true) {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
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


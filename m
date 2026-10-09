Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0833F54C6
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525369; cv=none; b=iWWRFXgfDE1/dUajTdqhf8YE54tow8YBtuMILMOl68FZlb1AE/8LMCUPJLp3SuiU47r7NpqxlkOM0V9cv1i8wHPZE9UxQ8meCXOHz/OityLC9nix0mOdufPSvps9TBu7kAV9WBt+LvcKkfscvk4NENkslMAiHcOVdgf+6piLqmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525369; c=relaxed/simple;
	bh=IzmS4KIJPbjBCwOfffd4tGGhnqGot+ySEMSOQ0vUFP8=;
	h=Date:To:From:Subject:Message-Id; b=DHyD90KpJUY2zOToRZvy5+GZO/UfrGFqTFIaIy9DP4WjjUNIIIhcxUNh3RAdSqX+lb6h3ijdaBztWrnURRu+A+5CAfsrDHBsBFanZ9eimF0Ji677hC7UBhGB8fSX1rK7VXeHWpt+MWK2SyDqe++BiJr4JnjVumtkyhHDtNqJ+54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MR+Uoi8R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MR+Uoi8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2F71F000FF;
	Fri,  9 Oct 2026 05:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525367;
	bh=koC84JH8nCi3wjlJ/t8KPw9Ut9ec7LdciX7wyyi+s20=;
	h=Date:To:From:Subject;
	b=MR+Uoi8RZUhAr6LCKGYmJA+viMle9X74bTE1wuhI021WpgEyve04pL6IbCjIXSvg+
	 gG5B978hYYYim0i1dS87O04+JH34cRyv4YUCCrz0ddzlxOcsLvJ3LmG75cMcJou+B0
	 yD1B03Je774MPwexpG65sX3BRuafi07LDEu319fw=
Date: Thu, 08 Oct 2026 22:56:07 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kunwu.chan@gmail.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-remove-a-debug-message.patch removed from -mm tree
Message-Id: <20261009055607.8F2F71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: remove a debug message
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-remove-a-debug-message.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/vaddr: remove a debug message
Date: Tue, 1 Sep 2026 22:47:36 -0700

There is a debug message in the DAMON virtual address space operation set.
It has not really been used in a meaningful way for the last few years,
though.  Remove it.

Link: https://lore.kernel.org/20260902054747.99370-4-sj@kernel.org
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

 mm/damon/vaddr.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-remove-a-debug-message
+++ a/mm/damon/vaddr.c
@@ -189,22 +189,12 @@ static int damon_va_three_regions(struct
  *   <BIG UNMAPPED REGION 2>
  *   <stack>
  */
-static void __damon_va_init_regions(struct damon_ctx *ctx,
-				     struct damon_target *t)
+static void __damon_va_init_regions(struct damon_target *t)
 {
-	struct damon_target *ti;
 	struct damon_addr_range regions[3];
-	int tidx = 0;
 
-	if (damon_va_three_regions(t, regions)) {
-		damon_for_each_target(ti, ctx) {
-			if (ti == t)
-				break;
-			tidx++;
-		}
-		pr_debug("Failed to get three regions of %dth target\n", tidx);
+	if (damon_va_three_regions(t, regions))
 		return;
-	}
 
 	damon_set_regions(t, regions, 3, DAMON_MIN_REGION_SZ);
 }
@@ -217,7 +207,7 @@ static void damon_va_init(struct damon_c
 	damon_for_each_target(t, ctx) {
 		/* the user may set the target regions as they want */
 		if (!damon_nr_regions(t))
-			__damon_va_init_regions(ctx, t);
+			__damon_va_init_regions(t);
 	}
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


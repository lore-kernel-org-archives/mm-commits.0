Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A328415B79
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525524; cv=none; b=kneUetxj3GaBKcotLsT72XW6GOziF7HWT3dAdTGvq5GLwMDkxWLMS3VU/PiLfByVEwGafKG1VA2zhqxjuDhb5RtxI8hcIdFeTLas+1S0HHXQLu+8Q7Qg3EZ4LHCdnBOwdxDmpaK4JLoxGbZbwSci2iDNGk/L3c8OrpbdkKj/owI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525524; c=relaxed/simple;
	bh=oiMiI7HyC8kR+5Cw7RTOXfuMIj/ed9iTH5nQptplPso=;
	h=Date:To:From:Subject:Message-Id; b=nuO1DWx7zwJwr7ypYYzKFnCQUkhBiILApE2T+nRKKtvyYG5VWQmCNajwtA1KmIRy5+/svpaNB/aBih4WzVO0B2VAqMmGzpkzSj3ZCCEehAvkSLFgIFaKPm2C0albHJw2Qi0YSgZkZceTVEIVUj2Ta5Fp2gYmuYiQUjInYWSmYDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fRWc67vL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fRWc67vL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD1B1F00893;
	Fri,  9 Oct 2026 05:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525523;
	bh=U4Hwu/jfEWosNZ9/j72FO6sWlyPeIQSEeXSl9yA3g6c=;
	h=Date:To:From:Subject;
	b=fRWc67vL0VsSFrp+DmFn5WwijYaEzgvXWHtrhaN6cJyQLzxkkqtJqa/vJDocdu82T
	 7S+H09SAwy+gVuehCdNsAGY5YapLhl9ScZndSjAt2VbaFdMVjqs56Bc7NafrU5P/KF
	 47FUE/jUSwV3G5r7XWcxODkdP7IyUcebsNp+yQYY=
Date: Thu, 08 Oct 2026 22:58:42 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-api-introduce-damon_filter_type_pgidle_set.patch removed from -mm tree
Message-Id: <20261009055843.3CD1B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/api: introduce DAMON_FILTER_TYPE_PGIDLE_SET
has been removed from the -mm tree.  Its filename was
     mm-damon-api-introduce-damon_filter_type_pgidle_set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/api: introduce DAMON_FILTER_TYPE_PGIDLE_SET
Date: Thu, 10 Sep 2026 07:22:28 -0700

Patch series "mm/damon: introduce pgidle_set probe filter type".

Users can do effective access monitoring with DAMON, using set_pgidle
probe prep operation and pgidle_unset allowing probe filter.  In the
setup, high probe_hits means the region was accessed frequently.  Zero
probe_hits means the region was not accessed.  The filter, however,
matches only the memory that can show the idleness.  Regions of zero
probe_hits may contain memory that was just unable to show the idleness. 
On virtual address space based monitoring, for example, non-present pages
are reported as cold.  It is truly cold, but if the purpose is to make
some operations like reclaiming or compressing the data, this is not
really useful.  Introduce a new probe filter type, pgidle_set, that
confirms the page is marked as idle.  Using it instead of pgidle_unset,
users can find cold pages that can effectively be processed.

Patch 1 introduces the pgidle_set probe filter type to DAMON kernel API. 
Patches 2 and 3 add support for it on physical and virtual address space
operation sets, respectively.  Patch 4 adds support for it on the DAMON
sysfs interface.  Finally, patch 5 updates the documentation for the new
filter type.


This patch (of 5):

DAMON_FILTER_TYPE_PGIDLE_UNSET matches only memory that was able to
confirm if it is marked as idle.  If the memory cannot be marked as idle,
it simply doesn't match.  Hence, finding memory that was marked as idle
with only DAMON_FILTER_TYPE_PGIDLE_UNSET is impossible.  Introduce a new
filter for the purpose, DAMON_FILTER_TYPE_PGIDLE_SET.

Link: https://lore.kernel.org/20260910142234.171562-1-sj@kernel.org
Link: https://lore.kernel.org/20260910142234.171562-2-sj@kernel.org
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

 include/linux/damon.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/damon.h~mm-damon-api-introduce-damon_filter_type_pgidle_set
+++ a/include/linux/damon.h
@@ -774,11 +774,13 @@ struct damon_prep {
  * @DAMON_FILTER_TYPE_ANON:		Anonymous pages.
  * @DAMON_FILTER_TYPE_MEMCG:		Specific memcg's pages.
  * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
+ * @DAMON_FILTER_TYPE_PGIDLE_SET:	Pgidle is set.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
 	DAMON_FILTER_TYPE_MEMCG,
 	DAMON_FILTER_TYPE_PGIDLE_UNSET,
+	DAMON_FILTER_TYPE_PGIDLE_SET,
 };
 
 /**
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


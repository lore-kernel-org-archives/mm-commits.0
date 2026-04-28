Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9A22BD030
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 14:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777387738; cv=none; b=XbvqgDpqqHqwx9V7NCRX7xNxXa2klZNsZqANR/NVBrR0ubXCwJGX4UG0aWMooJDv4dyO5A201NCgnRidrxHbU4IoNaqSv9fxoCKMtURL7JeEBtBSESLauXUAymPUMJ9czOJg1ON3djKTVgeToPGHqGUI4upDv2GzxU0QL5tQnsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777387738; c=relaxed/simple;
	bh=0/fNivY6Vh3ihZokST1hay4bWWx0QoOxUCBC4yaq7SA=;
	h=Date:To:From:Subject:Message-Id; b=HAcq7NvGCF6Vl5qqU5Q73mqMcA709KeBJyvYNNyepHxluZuBKF/LyDF5O4yXqggbEmOdl3WxaWef3jB1w2/9J8D3PwCEoL7FUPwgucUT8eo6wS7HrhSmqrueM4WMsl2V3YCYT76aJe+qzFAYD00ctLSvRKw1WMRjF2zHpELUV18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j7TfGVPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j7TfGVPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C94AC2BCAF;
	Tue, 28 Apr 2026 14:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777387738;
	bh=0/fNivY6Vh3ihZokST1hay4bWWx0QoOxUCBC4yaq7SA=;
	h=Date:To:From:Subject:From;
	b=j7TfGVPx8RhDysdKRo9pT1zFqVFlwYJgjkpMKtcgz6eCbHLNPFNxLHUxV+7vVdsc0
	 aLGP2G2K1g0auPv5pwfpVskBJLWEAMjYveMtys866a8AVrcUU54GKyLCNUEC0BKq86
	 BO009YxeMUBf/XnR/X19+K1UsZOn7sdzeu5hNSNY=
Date: Tue, 28 Apr 2026 07:48:57 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-merge-regions-after-applying-damos-schemes.patch added to mm-new branch
Message-Id: <20260428144858.1C94AC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: merge regions after applying DAMOS schemes
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-merge-regions-after-applying-damos-schemes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-merge-regions-after-applying-damos-schemes.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: merge regions after applying DAMOS schemes
Date: Mon, 27 Apr 2026 18:33:51 -0700

damos_apply_scheme() could split the given region if applying the scheme's
action to the entire region can result in violating the quota-set upper
limit.  Keeping regions that are created by such split operations is
unnecessary overhead.

The overhead would be negligible in the common case because such split
operations could happen only up to the number of installed schemes per
scheme apply interval.  The following commit could make the impact larger,
though.  The following commit will allow the action-failed region to be
charged in a different ratio.  If both the ratio and the remaining quota
is quite small while the region to apply the scheme is quite large and the
action is nearly always failing, a high number of split operations could
happen.

Remove the unnecessary overhead by merging regions after applying schemes
is done for each region.  The merge operation is made only if it will not
lose monitoring information and keep min_nr_regions constraint.  In the
worst case, the max_nr_regions could still be violated until the next
per-aggregation interval merge operation is made.

Link: https://lore.kernel.org/20260428013402.115171-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   59 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-merge-regions-after-applying-damos-schemes
+++ a/mm/damon/core.c
@@ -2184,6 +2184,58 @@ static void damon_do_apply_schemes(struc
 }
 
 /*
+ * damos_apply_target() - Apply DAMOS schemes to a given target.
+ * @c:			monitoring context to apply its DAMOS schemes to..
+ * @t:			monitoring target to apply the schemes to.
+ * @max_region_sz:	maximum region size for @c.
+ *
+ * This function could split regions for keeping the quota.  To minimize
+ * overhead from the split operations increased number of regions, this
+ * function will also merge regions after the schemes applying attempt is done,
+ * for each region.  The merge operation is made only when it doesn't lose the
+ * monitoring information and not violating @max_region_sz.
+ *
+ * Hence, after this function is called, the total number of regions could
+ * be increased or reduced.  The increase could make max_nr_regions temporarily
+ * be violated, until the next per-aggregation interval regions merge operation
+ * is executed.  The decrease will not violate min_nr_regions though, since it
+ * keeps @max_region_sz.
+ */
+static void damos_apply_target(struct damon_ctx *c, struct damon_target *t,
+		unsigned long max_region_sz)
+{
+	struct damon_region *r;
+
+	damon_for_each_region(r, t) {
+		struct damon_region *prev_r;
+
+		damon_do_apply_schemes(c, t, r);
+		/*
+		 * damon_do_apply_scheems() could split the region for the
+		 * quota.  Keeping the new slices is an overhead.  Merge back
+		 * the slices into the previous region if it doesn't lose any
+		 * information and not violating the max_region_sz.
+		 */
+		if (damon_first_region(t) == r)
+			continue;
+		prev_r = damon_prev_region(r);
+		if (prev_r->ar.end != r->ar.start)
+			continue;
+		if (prev_r->age != r->age)
+			continue;
+		if (prev_r->last_nr_accesses != r->last_nr_accesses)
+			continue;
+		if (prev_r->nr_accesses != r->nr_accesses)
+			continue;
+		if (r->ar.end - prev_r->ar.start > max_region_sz)
+			continue;
+		prev_r->ar.end = r->ar.end;
+		damon_destroy_region(r, t);
+		r = prev_r;
+	}
+}
+
+/*
  * damon_feed_loop_next_input() - get next input to achieve a target score.
  * @last_input	The last input.
  * @score	Current score that made with @last_input.
@@ -2675,9 +2727,9 @@ static void damos_trace_stat(struct damo
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
-	struct damon_region *r;
 	struct damos *s;
 	bool has_schemes_to_apply = false;
+	unsigned long max_region_sz;
 
 	damon_for_each_scheme(s, c) {
 		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
@@ -2694,13 +2746,12 @@ static void kdamond_apply_schemes(struct
 	if (!has_schemes_to_apply)
 		return;
 
+	max_region_sz = damon_region_sz_limit(c);
 	mutex_lock(&c->walk_control_lock);
 	damon_for_each_target(t, c) {
 		if (c->ops.target_valid && c->ops.target_valid(t) == false)
 			continue;
-
-		damon_for_each_region(r, t)
-			damon_do_apply_schemes(c, t, r);
+		damos_apply_target(c, t, max_region_sz);
 	}
 
 	damon_for_each_scheme(s, c) {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch
mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch
mm-damon-core-make-charge_addr_from-aware-of-end-address-exclusivity.patch
docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch
mm-damon-core-introduce-damon_ctx-paused.patch
mm-damon-sysfs-add-pause-file-under-context-dir.patch
docs-mm-damon-design-update-for-context-pause-resume-feature.patch
docs-admin-guide-mm-damon-usage-update-for-pause-file.patch
docs-abi-damon-update-for-pause-sysfs-file.patch
mm-damon-tests-core-kunit-test-pause-commitment.patch
selftests-damon-_damon_sysfs-support-pause-file-staging.patch
selftests-damon-drgn_dump_damon_status-dump-pause.patch
selftests-damon-sysfspy-check-pause-on-assert_ctx_committed.patch
selftests-damon-sysfspy-pause-damon-before-dumping-status.patch
mm-damon-core-handle-min_region_sz-remaining-quota-as-empty.patch
mm-damon-core-merge-regions-after-applying-damos-schemes.patch
mm-damon-core-introduce-failed-region-quota-charge-ratio.patch
mm-damon-sysfs-schemes-implement-fail_charge_numdenom-files.patch
docs-mm-damon-design-document-fail_charge_numdenom.patch
docs-admin-guide-mm-damon-usage-document-fail_charge_numdenom-files.patch
docs-abi-damon-document-fail_charge_numdenom.patch
mm-damon-tests-core-kunit-test-fail_charge_numdenom-committing.patch
selftests-damon-_damon_sysfs-support-failed-region-quota-charge-ratio.patch
selftests-damon-drgn_dump_damon_status-support-failed-region-quota-charge-ratio.patch
selftests-damon-sysfspy-test-failed-region-quota-charge-ratio.patch


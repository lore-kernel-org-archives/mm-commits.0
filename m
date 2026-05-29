Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBB336D9EE
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027577; cv=none; b=Ed4OxpnwZulnXZEhE3HoAywokyOOJGwVtuKPb45aN6OhIDqj+1/wAtGsd0bn49kH/Qq9T5S4y69G2ZljqXnaRQzhEer1DSW1JaeEuur4gPc+8pOeFcQhhPYUKRV1IT8o7J0wGcUT/PYkV5a32UQBaUPHk5AsE/byyJbS4pfxXME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027577; c=relaxed/simple;
	bh=s83guR8scBhM0yds4lJvgZvpUUCW8pq4JxoW3GEm63Y=;
	h=Date:To:From:Subject:Message-Id; b=LDMHMKfnkKPtbS+6clXFRp0RBOB4zKOm9IBonbhmAk2DmGOI9meqzbEQxjxpJOMNrEBlwzNmTkvDV4/swtvqNXLszcckhETXEkHkEliFBrUf90WhiY48t4h4o/40vzAD5c0j7na5F/YrmHGo6f0hmu5V5ikTnlTpJE7+DelT58I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nldAh0LA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nldAh0LA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1701F00893;
	Fri, 29 May 2026 04:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027575;
	bh=2rX8QVDMsYLIQ5Qa9V45JLmCRCzUmZKg39HdeR4PL90=;
	h=Date:To:From:Subject;
	b=nldAh0LAg/nWNtu3U77r1OMR4kQd8sn6XoSglgNelGi0SL26tJPOPMs+P6XYMhFm3
	 LWEb3nrTFNBiT8jc8lrwZAcGl4xPk9r3toHG7sinmBQfjczOYBTt/GbTk0g+id4+M6
	 dEGCs3qZ9CGNUmVNP11cQPv07SOj/QiaDHUeUvDU=
Date: Thu, 28 May 2026 21:06:15 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-merge-regions-after-applying-damos-schemes.patch removed from -mm tree
Message-Id: <20260529040615.CC1701F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: merge regions after applying DAMOS schemes
has been removed from the -mm tree.  Its filename was
     mm-damon-core-merge-regions-after-applying-damos-schemes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2183,6 +2183,58 @@ static void damon_do_apply_schemes(struc
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
@@ -2674,9 +2726,9 @@ static void damos_trace_stat(struct damo
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
-	struct damon_region *r;
 	struct damos *s;
 	bool has_schemes_to_apply = false;
+	unsigned long max_region_sz;
 
 	damon_for_each_scheme(s, c) {
 		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
@@ -2693,13 +2745,12 @@ static void kdamond_apply_schemes(struct
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

mm-damon-ops-common-call-folio_test_lru-after-folio_get.patch
mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
mm-damon-core-introduce-struct-damon_probe.patch
mm-damon-core-embed-damon_probe-objects-in-damon_ctx.patch
mm-damon-core-introduce-damon_filter.patch
mm-damon-core-commit-probes.patch
mm-damon-core-introduce-damon_region-probe_hits.patch
mm-damon-core-introduce-damon_ops-apply_probes.patch
mm-damon-core-do-data-attributes-monitoring.patch
mm-damon-paddr-support-data-attributes-monitoring.patch
mm-damon-sysfs-implement-probes-dir.patch
mm-damon-sysfs-implement-probe-dir.patch
mm-damon-sysfs-implement-filters-directory.patch
mm-damon-sysfs-implement-filter-dir.patch
mm-damon-sysfs-implement-filter-dir-files.patch
mm-damon-sysfs-setup-probes-on-damon-core-api-parameters.patch
mm-damon-sysfs-schemes-implement-tried_regions-r-probes.patch
mm-damon-sysfs-schemes-implement-probe-dir.patch
mm-damon-sysfs-schemes-implement-probe-hits-file.patch
mm-damon-trace-probe_hits.patch
selftests-damon-sysfssh-test-probes-dir.patch
docs-mm-damon-design-document-data-attributes-monitoring.patch
docs-admin-guide-mm-damon-usage-document-data-attributes-monitoring.patch
mm-damon-core-introduce-damon_filter_type_memcg.patch
mm-damon-paddr-support-damon_filter_type_memcg.patch
mm-damon-sysfs-add-filters-f-path-file.patch
mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common.patch
mm-damon-sysfs-setup-damon_filter-memcg_id-from-path.patch
docs-mm-damon-design-update-for-memcg-damon-filter.patch
docs-admin-guide-mm-damon-usage-update-for-memcg-damon-filter.patch
mm-damon-core-safely-handle-no-region-case-in-damon_set_regions.patch
mm-damon-core-do-not-use-region-out-of-a-loop-in-damon_set_regions.patch
samples-damon-mtier-replace-damon_add_region-with-damon_set_regions.patch
mm-damon-tests-vaddr-kunit-replace-damon_add_region-with-damon_set_regions.patch
mm-damon-core-hide-damon_add_region.patch
mm-damon-core-hide-damon_insert_region.patch
mm-damon-core-hide-damon_destroy_region.patch
mm-damon-core-add-kdamond_call-debug_sanity-check.patch
mm-damon-core-remove-damon_verify_nr_regions.patch
mm-damon-tests-core-kunit-add-damon_set_regions-test-cases.patch
selftests-damon-sysfspy-stop-kdamonds-before-failing.patch
selftests-damon-sysfssh-test-monitoring-intervals-goal-dir.patch
selftests-damon-sysfssh-test-addr_unit-file-existence.patch
selftests-damon-sysfssh-test-pause-file-existence.patch
mm-damon-core-trace-esz-at-first-setup.patch


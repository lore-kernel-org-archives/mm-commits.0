Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9616346797
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 20:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773002176; cv=none; b=DfksXfKMdV6MudEiSZv08ecLIATpLcZZPQDgJCrHt2i+MQQOLUUyeFBcGxvjVfeeeMJtYKGCz9aBhYoB2yE6QUqhR5nH4jXkRS8W2FpG38enNkBBbygwfGQI9wrAtCy4JXlr5wcQdzLLigibThFyG1slOdYkhOxWT/azP6aiqJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773002176; c=relaxed/simple;
	bh=xr9rT9Qv50mw8hgy9aXTNyM9zfaqEFvUIJQ/nD8rp7I=;
	h=Date:To:From:Subject:Message-Id; b=reYzsweO0vpiPh1pCFadX4QX46ibEijfyLfoH3nykuy//HBbmyufJG96Kaa7XospFq1zZt5fcy1SHj1Hjgu0gHipDDz+pCkLxPOqmLbtA1fKUC0kj8zKiwu3qCcdUDZm+e47DOcIB9EJRD3qGH5Lm+StlkkLwWo+g9I9KUADfAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2f6+CW2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2f6+CW2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5793DC116C6;
	Sun,  8 Mar 2026 20:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773002176;
	bh=xr9rT9Qv50mw8hgy9aXTNyM9zfaqEFvUIJQ/nD8rp7I=;
	h=Date:To:From:Subject:From;
	b=2f6+CW2n5jVcoHUE5r3RZAk7z3vuXgVHoEDsMRfp7oaEPbDUv3Y02S80F9GmcHbXP
	 33G6r1XQVBmUmWagD0uORb8/rENcbTM9mh41+8PcIt6jSwc68YIWdjeMJHHnUi4xhV
	 A+IIcVZ/5d69JljwHDR2hAtvYCyetOs9tlWAvSXk=
Date: Sun, 08 Mar 2026 13:36:15 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch added to mm-new branch
Message-Id: <20260308203616.5793DC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: add a test for damon_is_last_region()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch

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
Subject: mm/damon/tests/core-kunit: add a test for damon_is_last_region()
Date: Sat, 7 Mar 2026 11:53:50 -0800

There was a bug [1] in damon_is_last_region().  Add a kunit test to not
reintroduce the bug.

Link: https://lkml.kernel.org/r/20260307195356.203753-3-sj@kernel.org
Link: https://lore.kernel.org/20260114152049.99727-1-sj@kernel.org/ [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region
+++ a/mm/damon/tests/core-kunit.h
@@ -1311,6 +1311,28 @@ static void damon_test_apply_min_nr_regi
 	damon_test_apply_min_nr_regions_for(test, 10, 2, 10, 2, 5);
 }
 
+static void damon_test_is_last_region(struct kunit *test)
+{
+	struct damon_region *r;
+	struct damon_target *t;
+	int i;
+
+	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "target alloc fail\n");
+
+	for (i = 0; i < 4; i++) {
+		r = damon_new_region(i * 2, (i + 1) * 2);
+		if (!r) {
+			damon_free_target(t);
+			kunit_skip(test, "region alloc %d fail\n", i);
+		}
+		damon_add_region(r, t);
+		KUNIT_EXPECT_TRUE(test, damon_is_last_region(r, t));
+	}
+	damon_free_target(t);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -1339,6 +1361,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
 	KUNIT_CASE(damon_test_apply_min_nr_regions),
+	KUNIT_CASE(damon_test_is_last_region),
 	{},
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-set-quota-score-histogram-with-core-filters.patch
mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch
mm-damon-core-split-regions-for-min_nr_regions.patch
mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch
mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch
mm-damon-add-config_damon_debug_sanity.patch
mm-damon-core-add-damon_new_region-debug_sanity-check.patch
mm-damon-core-add-damon_del_region-debug_sanity-check.patch
mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch
mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch
mm-damon-core-add-damon_reset_aggregated-debug_sanity-check.patch
mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch
selftests-damon-config-enable-damon_debug_sanity.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch
docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch
mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch
mm-damon-core-use-time_before-for-next_apply_sis.patch
mm-damon-core-use-time_after_eq-in-kdamond_fn.patch
mm-damon-core-use-mult_frac.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch
mm-damon-core-clarify-damon_set_attrs-usages.patch
mm-damon-document-non-zero-length-damon_region-assumption.patch
docs-admin-guide-mm-damn-lru_sort-fix-intervals-autotune-parameter-name.patch
docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch
docs-mm-damon-index-fix-typo-autoamted-automated.patch


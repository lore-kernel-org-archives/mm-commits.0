Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7B8EED618
	for <mm-commits@archiver.kernel.org>; Fri, 15 Sep 2023 16:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235470AbjIOQhO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Sep 2023 12:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234981AbjIOQgo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2023 12:36:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D680E69
        for <mm-commits@vger.kernel.org>; Fri, 15 Sep 2023 09:36:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8901EC433C7;
        Fri, 15 Sep 2023 16:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694795798;
        bh=Ff+8lVVEuaaTCeGRKpSzeJVicvqYEqGFxOFEt/002xM=;
        h=Date:To:From:Subject:From;
        b=cxiTw3+siV3dvyjA3VZwVqQsNCzLsF5K7sDqM1LoAl+lEa9hxzDDLpfaM5Mvwsgzc
         XQxaRw7ImbOrWjMh7Sa0OqX/3rYNbCoklwXIGu9Wo5eMAJgovAqT00O+XVdy5HBq6W
         Lq/cUkf5GP3lMAN+UL9pgZgqlA3BYjydFKqQQfuY=
Date:   Fri, 15 Sep 2023 09:36:37 -0700
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-introduce-nr_accesses_bp.patch added to mm-unstable branch
Message-Id: <20230915163638.8901EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: introduce nr_accesses_bp
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-introduce-nr_accesses_bp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-nr_accesses_bp.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: introduce nr_accesses_bp
Date: Fri, 15 Sep 2023 02:52:48 +0000

Add yet another representation of the access rate of each region, namely
nr_accesses_bp.  It is just same to the nr_accesses but represents the
value in basis point (1 in 10,000), and updated at once in every
aggregation interval.  That is, moving_accesses_bp is just nr_accesses *
10000.  This may seems useless at the moment.  However, it will be useful
for representing less than one nr_accesses value that will be needed to
make moving sum-based nr_accesses.

Link: https://lkml.kernel.org/r/20230915025251.72816-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    5 +++++
 mm/damon/core-test.h  |    5 +++++
 mm/damon/core.c       |    6 ++++++
 3 files changed, 16 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-introduce-nr_accesses_bp
+++ a/include/linux/damon.h
@@ -40,6 +40,7 @@ struct damon_addr_range {
  * @ar:			The address range of the region.
  * @sampling_addr:	Address of the sample for the next access check.
  * @nr_accesses:	Access frequency of this region.
+ * @nr_accesses_bp:	@nr_accesses in basis point (0.01%).
  * @list:		List head for siblings.
  * @age:		Age of this region.
  *
@@ -49,6 +50,9 @@ struct damon_addr_range {
  * not be done with direct access but with the helper function,
  * damon_update_region_access_rate().
  *
+ * @nr_accesses_bp is another representation of @nr_accesses in basis point
+ * (1 in 10,000) that updated every aggregation interval.
+ *
  * @age is initially zero, increased for each aggregation interval, and reset
  * to zero again if the access frequency is significantly changed.  If two
  * regions are merged into a new region, both @nr_accesses and @age of the new
@@ -58,6 +62,7 @@ struct damon_region {
 	struct damon_addr_range ar;
 	unsigned long sampling_addr;
 	unsigned int nr_accesses;
+	unsigned int nr_accesses_bp;
 	struct list_head list;
 
 	unsigned int age;
--- a/mm/damon/core.c~mm-damon-core-introduce-nr_accesses_bp
+++ a/mm/damon/core.c
@@ -128,6 +128,7 @@ struct damon_region *damon_new_region(un
 	region->ar.start = start;
 	region->ar.end = end;
 	region->nr_accesses = 0;
+	region->nr_accesses_bp = 0;
 	INIT_LIST_HEAD(&region->list);
 
 	region->age = 0;
@@ -508,6 +509,7 @@ static void damon_update_monitoring_resu
 {
 	r->nr_accesses = damon_nr_accesses_for_new_attrs(r->nr_accesses,
 			old_attrs, new_attrs);
+	r->nr_accesses_bp = r->nr_accesses * 10000;
 	r->age = damon_age_for_new_attrs(r->age, old_attrs, new_attrs);
 }
 
@@ -1115,6 +1117,7 @@ static void damon_merge_two_regions(stru
 
 	l->nr_accesses = (l->nr_accesses * sz_l + r->nr_accesses * sz_r) /
 			(sz_l + sz_r);
+	l->nr_accesses_bp = l->nr_accesses * 10000;
 	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
 	l->ar.end = r->ar.end;
 	damon_destroy_region(r, t);
@@ -1138,6 +1141,8 @@ static void damon_merge_regions_of(struc
 		else
 			r->age++;
 
+		r->nr_accesses_bp = r->nr_accesses * 10000;
+
 		if (prev && prev->ar.end == r->ar.start &&
 		    abs(prev->nr_accesses - r->nr_accesses) <= thres &&
 		    damon_sz_region(prev) + damon_sz_region(r) <= sz_limit)
@@ -1186,6 +1191,7 @@ static void damon_split_region_at(struct
 
 	new->age = r->age;
 	new->last_nr_accesses = r->last_nr_accesses;
+	new->nr_accesses_bp = r->nr_accesses_bp;
 
 	damon_insert_region(new, r, damon_next_region(r), t);
 }
--- a/mm/damon/core-test.h~mm-damon-core-introduce-nr_accesses_bp
+++ a/mm/damon/core-test.h
@@ -94,6 +94,7 @@ static void damon_test_aggregate(struct
 		for (ir = 0; ir < 3; ir++) {
 			r = damon_new_region(saddr[it][ir], eaddr[it][ir]);
 			r->nr_accesses = accesses[it][ir];
+			r->nr_accesses_bp = accesses[it][ir] * 10000;
 			damon_add_region(r, t);
 		}
 		it++;
@@ -147,9 +148,11 @@ static void damon_test_merge_two(struct
 	t = damon_new_target();
 	r = damon_new_region(0, 100);
 	r->nr_accesses = 10;
+	r->nr_accesses_bp = 100000;
 	damon_add_region(r, t);
 	r2 = damon_new_region(100, 300);
 	r2->nr_accesses = 20;
+	r2->nr_accesses_bp = 200000;
 	damon_add_region(r2, t);
 
 	damon_merge_two_regions(t, r, r2);
@@ -196,6 +199,7 @@ static void damon_test_merge_regions_of(
 	for (i = 0; i < ARRAY_SIZE(sa); i++) {
 		r = damon_new_region(sa[i], ea[i]);
 		r->nr_accesses = nrs[i];
+		r->nr_accesses_bp = nrs[i] * 10000;
 		damon_add_region(r, t);
 	}
 
@@ -297,6 +301,7 @@ static void damon_test_update_monitoring
 	struct damon_region *r = damon_new_region(3, 7);
 
 	r->nr_accesses = 15;
+	r->nr_accesses_bp = 150000;
 	r->age = 20;
 
 	new_attrs = (struct damon_attrs){
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-fixup-missed-ref-keyword.patch
docs-admin-guide-mm-damon-usage-place-debugfs-usage-at-the-bottom.patch
docs-admin-guide-mm-damon-usage-move-debugfs-intro-to-the-bottom-of-the-section.patch
docs-mm-damon-design-explicitly-introduce-nr_accesses.patch
docs-admin-guide-mm-damon-usage-explain-the-format-of-damon_aggregate-tracepoint.patch
docs-mm-damon-design-add-a-section-for-kdamond-and-damon-context.patch
docs-admin-guide-mm-damon-usage-link-design-doc-for-details-of-kdamond-and-context.patch
mm-damon-core-fix-a-comment-about-damon_set_attrs-call-timings.patch
mm-damon-core-add-more-comments-for-nr_accesses.patch
mm-damon-core-remove-duplicated-comment-for-watermarks-based-deactivation.patch
mm-damon-core-remove-struct-target-parameter-from-damon_aggregated-tracepoint.patch
mm-damon-core-add-a-tracepoint-for-damos-apply-target-regions.patch
docs-admin-guide-mm-damon-usage-document-damos_before_apply-tracepoint.patch
mm-damon-core-use-number-of-passed-access-sampling-as-a-timer.patch
mm-damon-core-define-and-use-a-dedicated-function-for-region-access-rate-update.patch
mm-damon-vaddr-call-damon_update_region_access_rate-always.patch
mm-damon-core-implement-a-pseudo-moving-sum-function.patch
mm-damon-core-test-add-a-unit-test-for-damon_moving_sum.patch
mm-damon-core-introduce-nr_accesses_bp.patch
mm-damon-core-use-pseudo-moving-sum-for-nr_accesses_bp.patch
mm-damon-core-skip-updating-nr_accesses_bp-for-each-aggregation-interval.patch
mm-damon-core-mark-damon_moving_sum-as-a-static-function.patch


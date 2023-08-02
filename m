Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D44DCC04A94
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 21:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbjHBVwJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 17:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbjHBVwD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 17:52:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8FDE7D
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 14:52:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65B3B61B23
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 21:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B795EC433C8;
        Wed,  2 Aug 2023 21:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691013120;
        bh=fGBrREuA7BKOzYcQkPjnonV1FYMoFWhQnWWzyrRjGvk=;
        h=Date:To:From:Subject:From;
        b=p7lByZrtsb31CHXvtaTxg+6nt3fnqWOUxMjTQwMG92gUn3RBnOwBvYOIs70Mizr5T
         EbqDT3U5lJALz0QnM/Eqma8qYSjCH1b4AY1HtSvEBAAPZJ1MNSa1ZHvcLEwroAlJzi
         UBU4Zk00UNv2pN4b52qHf23dTV6bZAjB7gwfsSg0=
Date:   Wed, 02 Aug 2023 14:51:59 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-implement-target-type-damos-filter.patch added to mm-unstable branch
Message-Id: <20230802215200.B795EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: implement target type damos filter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-implement-target-type-damos-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-implement-target-type-damos-filter.patch

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
Subject: mm/damon/core: implement target type damos filter
Date: Wed, 2 Aug 2023 21:43:07 +0000

One DAMON context can have multiple monitoring targets, and DAMOS schemes
are applied to all targets.  In some cases, users need to apply different
scheme to different targets.  Retrieving monitoring results via DAMON
sysfs interface' 'tried_regions' directory could be one good example. 
Also, there could be cases that cgroup DAMOS filter is not enough.  All
such use cases can be worked around by having multiple DAMON contexts
having only single target, but it is inefficient in terms of resource
usage, thogh the overhead is not estimated to be huge.

Implement DAMON monitoring target based DAMOS filter for the case.  Like
address range target DAMOS filter, handle these filters in the DAMON core
layer, since it is more efficient than doing in operations set layer. 
This also means that regions that filtered out by monitoring target type
DAMOS filters are counted as not tried by the scheme.  Hence, target
granularity monitoring results retrieval via DAMON sysfs interface becomes
available.

Link: https://lkml.kernel.org/r/20230802214312.110532-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    6 ++++++
 mm/damon/core.c       |   22 ++++++++++++++++------
 2 files changed, 22 insertions(+), 6 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-implement-target-type-damos-filter
+++ a/include/linux/damon.h
@@ -227,6 +227,7 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_ANON:	Anonymous pages.
  * @DAMOS_FILTER_TYPE_MEMCG:	Specific memcg's pages.
  * @DAMOS_FILTER_TYPE_ADDR:	Address range.
+ * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
  * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
  *
  * The anon pages type and memcg type filters are handled by underlying
@@ -244,6 +245,7 @@ enum damos_filter_type {
 	DAMOS_FILTER_TYPE_ANON,
 	DAMOS_FILTER_TYPE_MEMCG,
 	DAMOS_FILTER_TYPE_ADDR,
+	DAMOS_FILTER_TYPE_TARGET,
 	NR_DAMOS_FILTER_TYPES,
 };
 
@@ -253,6 +255,9 @@ enum damos_filter_type {
  * @matching:	If the matching page should filtered out or in.
  * @memcg_id:	Memcg id of the question if @type is DAMOS_FILTER_MEMCG.
  * @addr_range:	Address range if @type is DAMOS_FILTER_TYPE_ADDR.
+ * @target_idx:	Index of the &struct damon_target of
+ *		&damon_ctx->adaptive_targets if @type is
+ *		DAMOS_FILTER_TYPE_TARGET.
  * @list:	List head for siblings.
  *
  * Before applying the &damos->action to a memory region, DAMOS checks if each
@@ -266,6 +271,7 @@ struct damos_filter {
 	union {
 		unsigned short memcg_id;
 		struct damon_addr_range addr_range;
+		int target_idx;
 	};
 	struct list_head list;
 };
--- a/mm/damon/core.c~mm-damon-core-implement-target-type-damos-filter
+++ a/mm/damon/core.c
@@ -878,13 +878,23 @@ static void damos_update_stat(struct dam
 	s->stat.sz_applied += sz_applied;
 }
 
-static bool __damos_filter_out(struct damon_target *t, struct damon_region *r,
-		struct damos_filter *filter)
+static bool __damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
+		struct damon_region *r, struct damos_filter *filter)
 {
 	bool matched = false;
+	struct damon_target *ti;
+	int target_idx = 0;
 	unsigned long start, end;
 
 	switch (filter->type) {
+	case DAMOS_FILTER_TYPE_TARGET:
+		damon_for_each_target(ti, ctx) {
+			if (ti == t)
+				break;
+			target_idx++;
+		}
+		matched = target_idx == filter->target_idx;
+		break;
 	case DAMOS_FILTER_TYPE_ADDR:
 		start = ALIGN_DOWN(filter->addr_range.start, DAMON_MIN_REGION);
 		end = ALIGN_DOWN(filter->addr_range.end, DAMON_MIN_REGION);
@@ -916,13 +926,13 @@ static bool __damos_filter_out(struct da
 	return matched == filter->matching;
 }
 
-static bool damos_filter_out(struct damon_target *t, struct damon_region *r,
-		struct damos *s)
+static bool damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
+		struct damon_region *r, struct damos *s)
 {
 	struct damos_filter *filter;
 
 	damos_for_each_filter(filter, s) {
-		if (__damos_filter_out(t, r, filter))
+		if (__damos_filter_out(ctx, t, r, filter))
 			return true;
 	}
 	return false;
@@ -945,7 +955,7 @@ static void damos_apply_scheme(struct da
 				goto update_stat;
 			damon_split_region_at(t, r, sz);
 		}
-		if (damos_filter_out(t, r, s))
+		if (damos_filter_out(c, t, r, s))
 			return;
 		ktime_get_coarse_ts64(&begin);
 		if (c->callback.before_damos_apply)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damo_filter-list-from-damos_new_filter.patch
mm-damon-core-test-add-a-test-for-damos_new_filter.patch
mm-damon-sysfs-schemes-implement-damos-tried-total-bytes-file.patch
mm-damon-sysfs-implement-a-command-for-updating-only-schemes-tried-total-bytes.patch
selftests-damon-sysfs-test-tried_regions-total_bytes-file.patch
docs-abi-damon-update-for-tried_regions-total_bytes.patch
docs-admin-guide-mm-damon-usage-update-for-tried_regions-total_bytes.patch
mm-damon-core-introduce-address-range-type-damos-filter.patch
mm-damon-sysfs-schemes-support-address-range-type-damos-filter.patch
mm-damon-core-test-add-a-unit-test-for-__damos_filter_out.patch
selftests-damon-sysfs-test-address-range-damos-filter.patch
docs-mm-damon-design-update-for-address-range-filters.patch
docs-abi-damon-update-for-address-range-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-address-range-type-damos-filter.patch
mm-damon-core-implement-target-type-damos-filter.patch
mm-damon-sysfs-schemes-support-target-damos-filter.patch
selftests-damon-sysfs-test-damon_target-filter.patch
docs-mm-damon-design-update-for-damon-monitoring-target-type-damos-filter.patch
docs-abi-damon-update-for-damon-monitoring-target-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-damon-monitoring-target-type-damos-filter.patch


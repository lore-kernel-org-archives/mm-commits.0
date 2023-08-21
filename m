Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9255EEE49AF
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjHUUkn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbjHUUkT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E70180
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0F5364A7B
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D21FC433C7;
        Mon, 21 Aug 2023 20:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650390;
        bh=/zgL6sKyZoySuddnmlYqhTT8YHpWhE9pAZ1vWarN/ZY=;
        h=Date:To:From:Subject:From;
        b=K78JExQOhM6TqvGATIQrKB2DfD33eyP4odFr9o3jwr13lbHxlfab+CaSGpRrPGEvJ
         bZU+ZHvmbr/ubzK6Auq9oKIlI3nFgAvmaDKWK7Fy8z6uIpZf+QvOMXaiW3rji3B0a8
         tMQbGEWCRv1OW/3yAa8pkMFwj1XUMyWmSeWB1Mws=
Date:   Mon, 21 Aug 2023 13:39:49 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-implement-target-type-damos-filter.patch removed from -mm tree
Message-Id: <20230821203950.3D21FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: implement target type damos filter
has been removed from the -mm tree.  Its filename was
     mm-damon-core-implement-target-type-damos-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -877,13 +877,23 @@ static void damos_update_stat(struct dam
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
@@ -915,13 +925,13 @@ static bool __damos_filter_out(struct da
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
@@ -944,7 +954,7 @@ static void damos_apply_scheme(struct da
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



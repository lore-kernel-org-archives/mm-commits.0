Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03611C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJCVLp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiJCVK1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:10:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9585072F
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0425B81123
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975A3C43470;
        Mon,  3 Oct 2022 21:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831210;
        bh=ugsPre63nQJj2d+uPyP/p1Nxi9vwK0iK+FwINHCcKDo=;
        h=Date:To:From:Subject:From;
        b=wby6uD8uiL+pGqeUz7VSSS6gL1k1br6mGeEJee7fBGpVM1ydkqGXCRritta5kQp6w
         luHjL+TuHFfKCy+V8KKRaMqcg8uvoG8SB6Xh5FAeYdEijdxfKnvZXlSKLnhASK8MLO
         BTqcdo7KA5CYZLvGPy0ICNxNw3TewjfIuEb5ri68=
Date:   Mon, 03 Oct 2022 14:06:49 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, ppbuk5246@gmail.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges.patch removed from -mm tree
Message-Id: <20221003210650.975A3C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: avoid holes in newly set monitoring target ranges
has been removed from the -mm tree.  Its filename was
     mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: avoid holes in newly set monitoring target ranges
Date: Fri, 9 Sep 2022 20:28:56 +0000

When there are two or more non-contiguous regions intersecting with given
new ranges, 'damon_set_regions()' does not fill the holes.  This commit
makes the function to fill the holes with newly created regions.

[sj@kernel.org: handle error from 'damon_fill_regions_holes()']
  Link: https://lkml.kernel.org/r/20220913215420.57761-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20220909202901.57977-3-sj@kernel.org
Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Yun Levi <ppbuk5246@gmail.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges
+++ a/mm/damon/core.c
@@ -169,6 +169,30 @@ static bool damon_intersect(struct damon
 }
 
 /*
+ * Fill holes in regions with new regions.
+ */
+static int damon_fill_regions_holes(struct damon_region *first,
+		struct damon_region *last, struct damon_target *t)
+{
+	struct damon_region *r = first;
+
+	damon_for_each_region_from(r, t) {
+		struct damon_region *next, *newr;
+
+		if (r == last)
+			break;
+		next = damon_next_region(r);
+		if (r->ar.end != next->ar.start) {
+			newr = damon_new_region(r->ar.end, next->ar.start);
+			if (!newr)
+				return -ENOMEM;
+			damon_insert_region(newr, r, next, t);
+		}
+	}
+	return 0;
+}
+
+/*
  * damon_set_regions() - Set regions of a target for given address ranges.
  * @t:		the given target.
  * @ranges:	array of new monitoring target ranges.
@@ -184,6 +208,7 @@ int damon_set_regions(struct damon_targe
 {
 	struct damon_region *r, *next;
 	unsigned int i;
+	int err;
 
 	/* Remove regions which are not in the new ranges */
 	damon_for_each_region_safe(r, next, t) {
@@ -226,6 +251,11 @@ int damon_set_regions(struct damon_targe
 			first->ar.start = ALIGN_DOWN(range->start,
 					DAMON_MIN_REGION);
 			last->ar.end = ALIGN(range->end, DAMON_MIN_REGION);
+
+			/* fill possible holes in the range */
+			err = damon_fill_regions_holes(first, last, t);
+			if (err)
+				return err;
 		}
 	}
 	return 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 246B2C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiJCVKp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiJCVIo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:08:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D614F392
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44490B81123
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC9DC433D6;
        Mon,  3 Oct 2022 21:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831192;
        bh=dtU7G7yLKx837ufBGS06ftzEDlmnuzqhcpGrpguDs2k=;
        h=Date:To:From:Subject:From;
        b=MzP9pt3StDKJYTHprR+csR01Ggv7EWcno1mo6iakJf2IdjarPrCErokbXKeex/x9x
         /fFUUNfFFLYmRSlNWnWvoeE7PBUZONvaRUnwLlv1YbrCG2BWgERZbufXatXF8kzHH9
         +/RXkkKiorIZV5NI/5EVBpGIpZR9fDfTZWBpOpCs=
Date:   Mon, 03 Oct 2022 14:06:31 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch removed from -mm tree
Message-Id: <20221003210631.DBC9DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: iterate the regions list from current point in damon_set_regions()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm/damon/core: iterate the regions list from current point in damon_set_regions()
Date: Tue, 6 Sep 2022 23:18:47 +0800

We iterate the whole regions list every time to get the first/last regions
intersecting with the specific range in damon_set_regions(), in order to
add new region or resize existing regions to fit in the specific range. 
Actually, it is unnecessary to iterate the new added regions and the front
regions that have been checked.  Just iterate the regions list from the
current point using list_for_each_entry_from() every time to improve
performance.

The kunit tests passed:
 [PASSED] damon_test_apply_three_regions1
 [PASSED] damon_test_apply_three_regions2
 [PASSED] damon_test_apply_three_regions3
 [PASSED] damon_test_apply_three_regions4

Link: https://lkml.kernel.org/r/1662477527-13003-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    8 ++++++++
 mm/damon/core.c       |    3 ++-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions
+++ a/include/linux/damon.h
@@ -463,9 +463,17 @@ static inline struct damon_region *damon
 	return list_last_entry(&t->regions_list, struct damon_region, list);
 }
 
+static inline struct damon_region *damon_first_region(struct damon_target *t)
+{
+	return list_first_entry(&t->regions_list, struct damon_region, list);
+}
+
 #define damon_for_each_region(r, t) \
 	list_for_each_entry(r, &t->regions_list, list)
 
+#define damon_for_each_region_from(r, t) \
+	list_for_each_entry_from(r, &t->regions_list, list)
+
 #define damon_for_each_region_safe(r, next, t) \
 	list_for_each_entry_safe(r, next, &t->regions_list, list)
 
--- a/mm/damon/core.c~mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions
+++ a/mm/damon/core.c
@@ -195,6 +195,7 @@ int damon_set_regions(struct damon_targe
 			damon_destroy_region(r, t);
 	}
 
+	r = damon_first_region(t);
 	/* Add new regions or resize existing regions to fit in the ranges */
 	for (i = 0; i < nr_ranges; i++) {
 		struct damon_region *first = NULL, *last, *newr;
@@ -202,7 +203,7 @@ int damon_set_regions(struct damon_targe
 
 		range = &ranges[i];
 		/* Get the first/last regions intersecting with the range */
-		damon_for_each_region(r, t) {
+		damon_for_each_region_from(r, t) {
 			if (damon_intersect(r, range)) {
 				if (!first)
 					first = r;
_

Patches currently in -mm which might be from kaixuxia@tencent.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C8EECAAA1
	for <mm-commits@archiver.kernel.org>; Wed,  7 Sep 2022 00:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiIGARt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Sep 2022 20:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIGARs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2022 20:17:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF2B8050C
        for <mm-commits@vger.kernel.org>; Tue,  6 Sep 2022 17:17:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F1A1B81AD6
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 00:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA64C433C1;
        Wed,  7 Sep 2022 00:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662509865;
        bh=gQaCi5M4G+0WBrM3WBM4LjzTiS/9R2PSFHrl6r9QUUU=;
        h=Date:To:From:Subject:From;
        b=cmhtTZ895f88GSD+V/XWd6bPK1Qs8H6XUKW6OWeHf0K7d62gKnvrRRHRRgwn+p+Jj
         RKNo7P+TxWJaUNTkSd40YKCeLfqRGumPf8agRaIHH4DD25OvioiYAll4NbuWPaiQLP
         SFKAPoDJJ7+gVoeQ5LR+uqsCc+fmdzrCeIKnCThA=
Date:   Tue, 06 Sep 2022 17:17:44 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch added to mm-unstable branch
Message-Id: <20220907001745.0BA64C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: iterate the regions list from current point in damon_set_regions()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch

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

mm-damon-core-simplify-the-parameter-passing-for-region-split-operation.patch
mm-damon-simplify-the-parameter-passing-for-check_accesses.patch
mm-damon-vaddr-remove-comparison-between-mm-and-last_mm-when-checking-region-accesses.patch
mm-damon-get-the-hotness-from-damon_hot_score-in-damon_pageout_score.patch
mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch
mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch


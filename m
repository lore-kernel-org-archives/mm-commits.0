Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CE2C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiJCVQg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiJCVOg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:14:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4BA1C902
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1A33B811BF
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C49DC433D6;
        Mon,  3 Oct 2022 21:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831386;
        bh=jxfB6Y9XztGQFc1/SG+p6WWdFs4uNv7C15fEStU/RDw=;
        h=Date:To:From:Subject:From;
        b=0SWwTQFBPOEA5+uJW/YgTg1VI6HreYoqspU8qr8fK0usPT+lXxgk8o1L+w8aPca8f
         3IJrz8i/9uqGOEi8YHRB6T3o/mkeQkqNjgo98y5NAFhIkCdbPbY8YTqX8fAb97gWlW
         tl/MotKN8c0aPHdR4pcO+5zcvujDeXs7NPyYCyUg=
Date:   Mon, 03 Oct 2022 14:09:45 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-rename-damon_pageout_score-to-damon_cold_score.patch removed from -mm tree
Message-Id: <20221003210946.7C49DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: rename damon_pageout_score() to damon_cold_score()
has been removed from the -mm tree.  Its filename was
     mm-damon-rename-damon_pageout_score-to-damon_cold_score.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm/damon: rename damon_pageout_score() to damon_cold_score()
Date: Sat, 17 Sep 2022 21:56:54 +0800

In the beginning there is only one damos_action 'DAMOS_PAGEOUT' that need
to get the coldness score of a region for a scheme, which using
damon_pageout_score() to do that.  But now there are also other
damos_action actions need the coldness score, so rename it to
damon_cold_score() to make more sense.

Link: https://lkml.kernel.org/r/1663423014-28907-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    2 +-
 mm/damon/ops-common.h |    2 +-
 mm/damon/paddr.c      |    4 ++--
 mm/damon/vaddr.c      |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-rename-damon_pageout_score-to-damon_cold_score
+++ a/mm/damon/ops-common.c
@@ -130,7 +130,7 @@ int damon_hot_score(struct damon_ctx *c,
 	return hotness;
 }
 
-int damon_pageout_score(struct damon_ctx *c, struct damon_region *r,
+int damon_cold_score(struct damon_ctx *c, struct damon_region *r,
 			struct damos *s)
 {
 	int hotness = damon_hot_score(c, r, s);
--- a/mm/damon/ops-common.h~mm-damon-rename-damon_pageout_score-to-damon_cold_score
+++ a/mm/damon/ops-common.h
@@ -12,7 +12,7 @@ struct page *damon_get_page(unsigned lon
 void damon_ptep_mkold(pte_t *pte, struct mm_struct *mm, unsigned long addr);
 void damon_pmdp_mkold(pmd_t *pmd, struct mm_struct *mm, unsigned long addr);
 
-int damon_pageout_score(struct damon_ctx *c, struct damon_region *r,
+int damon_cold_score(struct damon_ctx *c, struct damon_region *r,
 			struct damos *s);
 int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 			struct damos *s);
--- a/mm/damon/paddr.c~mm-damon-rename-damon_pageout_score-to-damon_cold_score
+++ a/mm/damon/paddr.c
@@ -287,11 +287,11 @@ static int damon_pa_scheme_score(struct
 {
 	switch (scheme->action) {
 	case DAMOS_PAGEOUT:
-		return damon_pageout_score(context, r, scheme);
+		return damon_cold_score(context, r, scheme);
 	case DAMOS_LRU_PRIO:
 		return damon_hot_score(context, r, scheme);
 	case DAMOS_LRU_DEPRIO:
-		return damon_pageout_score(context, r, scheme);
+		return damon_cold_score(context, r, scheme);
 	default:
 		break;
 	}
--- a/mm/damon/vaddr.c~mm-damon-rename-damon_pageout_score-to-damon_cold_score
+++ a/mm/damon/vaddr.c
@@ -673,7 +673,7 @@ static int damon_va_scheme_score(struct
 
 	switch (scheme->action) {
 	case DAMOS_PAGEOUT:
-		return damon_pageout_score(context, r, scheme);
+		return damon_cold_score(context, r, scheme);
 	default:
 		break;
 	}
_

Patches currently in -mm which might be from kaixuxia@tencent.com are



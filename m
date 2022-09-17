Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0011C6FA82
	for <mm-commits@archiver.kernel.org>; Sat, 17 Sep 2022 22:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiIQWQG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Sep 2022 18:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiIQWQF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 17 Sep 2022 18:16:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0ECB2AC45
        for <mm-commits@vger.kernel.org>; Sat, 17 Sep 2022 15:16:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4C92FCE0B6F
        for <mm-commits@vger.kernel.org>; Sat, 17 Sep 2022 22:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBE3C433D7;
        Sat, 17 Sep 2022 22:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663452959;
        bh=GtC2mBOlE0eJNryfOkVMY5581z0DEmMgz9twBxjusn0=;
        h=Date:To:From:Subject:From;
        b=xasBcFE9JyJrmF81yvMce2veEgiCm/FeBgEbwzN/2NRybXkU1q4e/mLdg1gIkOW0z
         sOS8o5aZmGiMsMIZueDQ2DsPkns7dKZghMez707D8AHHAVNt+FfwUwfZYsfGLQScWU
         I9EuZMF8irAt14g+JuquSsfpyP+d9CFco5T5jgmE=
Date:   Sat, 17 Sep 2022 15:15:58 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-rename-damon_pageout_score-to-damon_cold_score.patch added to mm-unstable branch
Message-Id: <20220917221559.7CBE3C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: rename damon_pageout_score() to damon_cold_score()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-rename-damon_pageout_score-to-damon_cold_score.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-rename-damon_pageout_score-to-damon_cold_score.patch

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

mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch
mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch
mm-damon-sysfs-use-the-wrapper-directly-to-check-if-the-kdamond-is-running.patch
mm-damon-simplify-the-parameter-passing-for-prepare_access_checks.patch
mm-damon-sysfs-simplify-the-variable-pid-assignment-operation.patch
mm-damon-core-simplify-the-kdamond-stop-mechanism-by-removing-done.patch
mm-damon-use-struct-damon_target-instead-of-void-in-target_valid.patch
mm-damon-return-void-from-damon_set_schemes.patch
mm-damon-rename-damon_pageout_score-to-damon_cold_score.patch


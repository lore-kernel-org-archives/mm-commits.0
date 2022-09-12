Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7808EC6FA82
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 20:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiILU2K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 16:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiILU2E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 16:28:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3562DA9F
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 13:28:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB0DCB80C68
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 20:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849FAC433D6;
        Mon, 12 Sep 2022 20:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663014479;
        bh=adhn0qs3uMKQ4bz8xLFprBehpW/rryEADER/cBtMrY4=;
        h=Date:To:From:Subject:From;
        b=iTB48YIDIrVCEUMW0mgMZHhveWUeCHnUnY7jxCyp3I0Fq98Rm+oDoFksxkyFIFMtU
         /UOnLbcoye0MWTcqZtZfT5PmF41f0H5urp+XsFTuwx1+0VzXh6j5RYfyKXINIQENBj
         RHJw1hP+MFMv9SU2c6ciYdtfcZ8HoO6L+mruzkMc=
Date:   Mon, 12 Sep 2022 13:27:59 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-simplify-scheme-create-in-damon_lru_sort_apply_parameters.patch added to mm-unstable branch
Message-Id: <20220912202759.849FAC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: simplify scheme create in damon_lru_sort_apply_parameters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-simplify-scheme-create-in-damon_lru_sort_apply_parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-simplify-scheme-create-in-damon_lru_sort_apply_parameters.patch

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
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon: simplify scheme create in damon_lru_sort_apply_parameters
Date: Sun, 11 Sep 2022 08:59:17 +0800

In damon_lru_sort_apply_parameters(), we can use damon_set_schemes() to
replace the way of creating the first 'scheme' in original code, this
makes the code look cleaner.

Link: https://lkml.kernel.org/r/20220911005917.835-1-xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-simplify-scheme-create-in-damon_lru_sort_apply_parameters
+++ a/mm/damon/lru_sort.c
@@ -350,7 +350,7 @@ static struct damos *damon_lru_sort_new_
 
 static int damon_lru_sort_apply_parameters(void)
 {
-	struct damos *scheme, *next_scheme;
+	struct damos *scheme;
 	struct damon_addr_range addr_range;
 	unsigned int hot_thres, cold_thres;
 	int err = 0;
@@ -360,17 +360,15 @@ static int damon_lru_sort_apply_paramete
 	if (err)
 		return err;
 
-	/* free previously set schemes */
-	damon_for_each_scheme_safe(scheme, next_scheme, ctx)
-		damon_destroy_scheme(scheme);
-
 	/* aggr_interval / sample_interval is the maximum nr_accesses */
 	hot_thres = aggr_interval / sample_interval * hot_thres_access_freq /
 		1000;
 	scheme = damon_lru_sort_new_hot_scheme(hot_thres);
 	if (!scheme)
 		return -ENOMEM;
-	damon_add_scheme(ctx, scheme);
+	err = damon_set_schemes(ctx, &scheme, 1);
+	if (err)
+		return err;
 
 	cold_thres = cold_min_age / aggr_interval;
 	scheme = damon_lru_sort_new_cold_scheme(cold_thres);
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-simply-damon_ctx-check-in-damon_sysfs_before_terminate.patch
mm-damon-remove-duplicate-get_monitoring_region-definitions.patch
mm-damon-sysfs-change-few-functions-execute-order.patch
mm-damon-simplify-scheme-create-in-damon_lru_sort_apply_parameters.patch


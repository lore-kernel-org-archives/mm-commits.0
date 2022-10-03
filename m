Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B62C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiJCVNQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0EC51A1B
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B16F611FB
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAC2C433D7;
        Mon,  3 Oct 2022 21:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831231;
        bh=vIk8z1SUJndpaLNKz3puSNcTcztBntbY73F7QqVNPvo=;
        h=Date:To:From:Subject:From;
        b=ndMHCgeTCgjzKsDr/QsI9kVSWhYLtZE+atLfQvk0TK0Tw5J+5+LNcGptL2hZUGuh/
         3XlR/GRMGHcvGVQuarcFD/xxzMTizlYZaGqKy1sdcpz8tg9rEJnv6fflb5NGZc1iFn
         MZlrDjs2TKK6ul+oAL+V6TI2gODolUq+M0sTIFzU=
Date:   Mon, 03 Oct 2022 14:07:11 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-simplify-scheme-create-in-damon_lru_sort_apply_parameters.patch removed from -mm tree
Message-Id: <20221003210711.CBAC2C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: simplify scheme create in damon_lru_sort_apply_parameters
has been removed from the -mm tree.  Its filename was
     mm-damon-simplify-scheme-create-in-damon_lru_sort_apply_parameters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-move-sz_damon_region-to-damon_sz_region.patch
mm-damon-use-damon_sz_region-in-appropriate-place.patch


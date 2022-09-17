Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0584C54EE9
	for <mm-commits@archiver.kernel.org>; Sat, 17 Sep 2022 22:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiIQWPZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Sep 2022 18:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiIQWPX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 17 Sep 2022 18:15:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CEC1D0F0
        for <mm-commits@vger.kernel.org>; Sat, 17 Sep 2022 15:15:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56D49611E6
        for <mm-commits@vger.kernel.org>; Sat, 17 Sep 2022 22:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D542C433D6;
        Sat, 17 Sep 2022 22:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663452921;
        bh=mhAXIoT/d4O+QBL3yQBKa/yxKe4a7HsEBNb7Em176KA=;
        h=Date:To:From:Subject:From;
        b=zDNwBJuesHHJ567sxcyUzuhH96d/yXrUWf/gYG09OC8mVJXWCrzQYS+DbYqvln8Z9
         EO7MANf2xCo/WIjw39GK++8+xqito5DdGwyRknfJa6rCWszue0YcSW413CBTcMRJv6
         en+ZC5y+MrKWsiq9KV7yDeKFOFT6jYg9FTyL69v0=
Date:   Sat, 17 Sep 2022 15:15:20 -0700
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com, sj@kernel.org,
        yangyingliang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-simplify-scheme-create-in-lru_sortc-fix.patch added to mm-unstable branch
Message-Id: <20220917221521.9D542C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: change damon_lru_sort_stub_pattern to static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-simplify-scheme-create-in-lru_sortc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-simplify-scheme-create-in-lru_sortc-fix.patch

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
From: Yang Yingliang <yangyingliang@huawei.com>
Subject: mm/damon: change damon_lru_sort_stub_pattern to static
Date: Sat, 17 Sep 2022 20:12:28 +0800

damon_lru_sort_stub_pattern is only used in lru_sort.c now, change it to
static.

Link: https://lkml.kernel.org/r/20220917121228.1889699-1-yangyingliang@huawei.com
Fixes: 27812ec2a990 ("mm/damon: simplify scheme create in lru_sort.c")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/lru_sort.c~mm-damon-simplify-scheme-create-in-lru_sortc-fix
+++ a/mm/damon/lru_sort.c
@@ -132,7 +132,7 @@ DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(
 		lru_sort_tried_cold_regions, lru_sorted_cold_regions,
 		cold_quota_exceeds);
 
-struct damos_access_pattern damon_lru_sort_stub_pattern = {
+static struct damos_access_pattern damon_lru_sort_stub_pattern = {
 	/* Find regions having PAGE_SIZE or larger size */
 	.min_sz_region = PAGE_SIZE,
 	.max_sz_region = ULONG_MAX,
_

Patches currently in -mm which might be from yangyingliang@huawei.com are

mm-damon-simplify-scheme-create-in-lru_sortc-fix.patch
mm-damon-reclaim-change-damon_reclaim_wmarks-to-static.patch
mm-damon-lru_sort-change-damon_lru_sort_wmarks-to-static.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A2F6C32771
	for <mm-commits@archiver.kernel.org>; Thu, 15 Sep 2022 22:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiIOWHM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Sep 2022 18:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiIOWHM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2022 18:07:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9E84F693
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 15:07:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFFFCB8228A
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 22:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F950C433D6;
        Thu, 15 Sep 2022 22:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663279628;
        bh=ZLUoVKOx9XSnDhWW15XsHoZk5NrY0/iv2kF9inF1eXg=;
        h=Date:To:From:Subject:From;
        b=bQsl5b2iYcx4bD6PkOg/qyZJ9Li9e//BNq0TrqZ+ASDL1+fAvlQgUYQUaRXP6KmPm
         5PGQdkAfWUMHAmllcJBYxiC67dykV1KQOb0X+l4LjVJVUdXGPJbYmUtpAH7gPlnMGl
         zHC767sF+DHemcoE6VF+FeXtfxMHDSytv4hfsc2s=
Date:   Thu, 15 Sep 2022 15:07:08 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        yangyingliang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-change-damon_reclaim_wmarks-to-static.patch added to mm-unstable branch
Message-Id: <20220915220708.8F950C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/reclaim: change damon_reclaim_wmarks to static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-reclaim-change-damon_reclaim_wmarks-to-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-change-damon_reclaim_wmarks-to-static.patch

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
Subject: mm/damon/reclaim: change damon_reclaim_wmarks to static
Date: Thu, 15 Sep 2022 10:10:23 +0800

damon_reclaim_wmarks is only used in reclaim.c now, change it to static.

Link: https://lkml.kernel.org/r/20220915021024.4177940-1-yangyingliang@huawei.com
Fixes: 89dd02d8abd1 ("mm/damon/reclaim: use watermarks parameters generator macro")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-change-damon_reclaim_wmarks-to-static
+++ a/mm/damon/reclaim.c
@@ -64,7 +64,7 @@ static struct damos_quota damon_reclaim_
 };
 DEFINE_DAMON_MODULES_DAMOS_QUOTAS(damon_reclaim_quota);
 
-struct damos_watermarks damon_reclaim_wmarks = {
+static struct damos_watermarks damon_reclaim_wmarks = {
 	.metric = DAMOS_WMARK_FREE_MEM_RATE,
 	.interval = 5000000,	/* 5 seconds */
 	.high = 500,		/* 50 percent */
_

Patches currently in -mm which might be from yangyingliang@huawei.com are

mm-damon-reclaim-change-damon_reclaim_wmarks-to-static.patch
mm-damon-lru_sort-change-damon_lru_sort_wmarks-to-static.patch


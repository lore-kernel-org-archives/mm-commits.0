Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D2BC32771
	for <mm-commits@archiver.kernel.org>; Thu, 15 Sep 2022 22:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiIOWHQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Sep 2022 18:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiIOWHO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2022 18:07:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4D64B0F9
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 15:07:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AE2CB8228B
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 22:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431A0C433B5;
        Thu, 15 Sep 2022 22:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663279630;
        bh=IkuL2+QatQ5mN1TiYH96WpExoDUCjXmsD4v7M1iW6Lk=;
        h=Date:To:From:Subject:From;
        b=2q5Uw1u+UOX6V+CeBW+i4/rob371Y3an5KwcY0B5TmdgOyn/OHbXBDMciF0Hwx8DD
         uWGugEqkShi3LXhOZ3AFbm+V3j+FJdS8TlS8/mhsrS4/oPhjlrO0kHDNlFTJGuVEZR
         BsnMo3F/7l8tfycSp5XooyMdCiTH0xjcjVPTJsy4=
Date:   Thu, 15 Sep 2022 15:07:09 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        yangyingliang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-change-damon_lru_sort_wmarks-to-static.patch added to mm-unstable branch
Message-Id: <20220915220710.431A0C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/lru_sort: change damon_lru_sort_wmarks to static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-lru_sort-change-damon_lru_sort_wmarks-to-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-change-damon_lru_sort_wmarks-to-static.patch

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
Subject: mm/damon/lru_sort: change damon_lru_sort_wmarks to static
Date: Thu, 15 Sep 2022 10:10:24 +0800

damon_lru_sort_wmarks is only used in lru_sort.c now, change it to static.

Link: https://lkml.kernel.org/r/20220915021024.4177940-2-yangyingliang@huawei.com
Fixes: 189aa3d58206 ("mm/damon/lru_sort: use watermarks parameters generator macro")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-change-damon_lru_sort_wmarks-to-static
+++ a/mm/damon/lru_sort.c
@@ -77,7 +77,7 @@ static struct damos_quota damon_lru_sort
 };
 DEFINE_DAMON_MODULES_DAMOS_TIME_QUOTA(damon_lru_sort_quota);
 
-struct damos_watermarks damon_lru_sort_wmarks = {
+static struct damos_watermarks damon_lru_sort_wmarks = {
 	.metric = DAMOS_WMARK_FREE_MEM_RATE,
 	.interval = 5000000,	/* 5 seconds */
 	.high = 200,		/* 20 percent */
_

Patches currently in -mm which might be from yangyingliang@huawei.com are

mm-damon-reclaim-change-damon_reclaim_wmarks-to-static.patch
mm-damon-lru_sort-change-damon_lru_sort_wmarks-to-static.patch


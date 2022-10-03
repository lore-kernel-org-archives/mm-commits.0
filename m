Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF88C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiJCVP2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiJCVN5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6312F4DB69
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B5D93CE0E70
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B329C433C1;
        Mon,  3 Oct 2022 21:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831362;
        bh=XHZ01sPAuVcyZYqluF6s5nqms2UrCPla+gaztCywNkA=;
        h=Date:To:From:Subject:From;
        b=fjHv1oYkJsvmOB5JF9SSaG0T9jgpU5UpocGurjX1MphCsVwR+JZFoZvEfYzZKC/KP
         pb8fU9iFBNwnv86IwIRgXZKTaVm4uAW0RTtIiR8/9rFvMrRqyWwEssk2s3bSp8C56q
         GPe02vkFDtVMWLuQNNM01P2C3IpJ8XBGmnQAdEJo=
Date:   Mon, 03 Oct 2022 14:09:21 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        yangyingliang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-change-damon_lru_sort_wmarks-to-static.patch removed from -mm tree
Message-Id: <20221003210922.1B329C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/lru_sort: change damon_lru_sort_wmarks to static
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-change-damon_lru_sort_wmarks-to-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



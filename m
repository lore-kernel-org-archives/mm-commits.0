Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAAC9C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiJCVP0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiJCVN5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FF15467D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ADE8611CB
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0EEC433B5;
        Mon,  3 Oct 2022 21:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831361;
        bh=u3TxXDdf1wiX34xXM3CFBPDhRSH3EfbtWYgrU3D22SA=;
        h=Date:To:From:Subject:From;
        b=fJ+UfqggWqqJMDQWY44VSoP6fJ+feC7f/6TSVUpwe2bmYHkOPVn9czF6IhY5mds8s
         n1Zk0msDEP87lQDh1o0JD8I4jZwGekgHrkvUqiilTEeNwSkjEXk7jL8DRNtCrMg06R
         rVwl/XwcJJXbPa236StQvfM9ORwfAaruszkQyuPk=
Date:   Mon, 03 Oct 2022 14:09:20 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        yangyingliang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-change-damon_reclaim_wmarks-to-static.patch removed from -mm tree
Message-Id: <20221003210920.EF0EEC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/reclaim: change damon_reclaim_wmarks to static
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-change-damon_reclaim_wmarks-to-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



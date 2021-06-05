Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20531C4743D
	for <mm-commits@archiver.kernel.org>; Sat,  5 Jun 2021 03:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D6C761414
	for <mm-commits@archiver.kernel.org>; Sat,  5 Jun 2021 03:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhFEDDf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Jun 2021 23:03:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231609AbhFEDDe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Jun 2021 23:03:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D80DA61008;
        Sat,  5 Jun 2021 03:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622862094;
        bh=jlk86gmrt7J0TYtzbcMnAc6Hw6gKq/rWYCd/mP0HUDs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pqgcLH6ayH1Zk5ZqnOLvJfWVykN0DT1wIfqfEjq1WBEe6wB8Cw27MP8KUuXNAW8m7
         potzr5F0mnZg22dUpdIsXkmOkz997LJ3BJMxJyeNeoQ6WJLB8zV1x9FvylKBOqgYvq
         DdObaL1vfwO2fGtIqGozDO/v9j2QyaUpq3yoM1qU=
Date:   Fri, 04 Jun 2021 20:01:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        torvalds@linux-foundation.org, yi.zhang@huawei.com,
        yukuai3@huawei.com
Subject:  [patch 09/13] mm/kasan/init.c: fix doc warning
Message-ID: <20210605030133.cWoXYluQS%akpm@linux-foundation.org>
In-Reply-To: <20210604200040.d8d0406caf195525620c0f3d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>
Subject: mm/kasan/init.c: fix doc warning

Fix gcc W=1 warning:

mm/kasan/init.c:228: warning: Function parameter or member 'shadow_start' not described in 'kasan_populate_early_shadow'
mm/kasan/init.c:228: warning: Function parameter or member 'shadow_end' not described in 'kasan_populate_early_shadow'

Link: https://lkml.kernel.org/r/20210603140700.3045298-1-yukuai3@huawei.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kasan/init.c~kasan-fix-doc-warning-in-initc
+++ a/mm/kasan/init.c
@@ -220,8 +220,8 @@ static int __ref zero_p4d_populate(pgd_t
 /**
  * kasan_populate_early_shadow - populate shadow memory region with
  *                               kasan_early_shadow_page
- * @shadow_start - start of the memory range to populate
- * @shadow_end   - end of the memory range to populate
+ * @shadow_start: start of the memory range to populate
+ * @shadow_end: end of the memory range to populate
  */
 int __ref kasan_populate_early_shadow(const void *shadow_start,
 					const void *shadow_end)
_

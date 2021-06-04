Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8D7C47096
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 00:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3633F6140C
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 00:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhFDAfW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Jun 2021 20:35:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFDAfV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Jun 2021 20:35:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF4826140C;
        Fri,  4 Jun 2021 00:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622766802;
        bh=k79Y69eiF/1BGfZfwyqe61ItzZpMxQhGHjfeXJDEJGE=;
        h=Date:From:To:Subject:From;
        b=YpoFpxb9fFnFz+aPQ9CsbAza5Z/dybtRlsKCGK/tS8S591V11kgcvKvHvVJ4ZHrTt
         K1XVIhquHjnx2yKe6BQnwq6Q7WLrYlz0CkMkMj5Rmjl/wkYs2li1XM72CvRRAaHcgX
         l53cGG/DNzPZFSlR7ZPy0KEVHiVsqSATm3MiOZ28=
Date:   Thu, 03 Jun 2021 17:33:22 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        yi.zhang@huawei.com, yukuai3@huawei.com
Subject:  + kasan-fix-doc-warning-in-initc.patch added to -mm tree
Message-ID: <20210604003322.0Luu3MRjN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan/init.c: fix doc warning
has been added to the -mm tree.  Its filename is
     kasan-fix-doc-warning-in-initc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-doc-warning-in-initc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-doc-warning-in-initc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from yukuai3@huawei.com are

kasan-fix-doc-warning-in-initc.patch
lib-decompressors-remove-set-but-not-used-variabled-level.patch


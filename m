Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B4FFC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 22:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24BE161158
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 22:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235647AbhIHWTN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 18:19:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235377AbhIHWTM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Sep 2021 18:19:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57D7C6113A;
        Wed,  8 Sep 2021 22:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631139484;
        bh=jxRHyJpmTENjx6i+ZllWxqh/yXNJJvVdtZLL/Yj5CU0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oqsr0s/4w2SDcTTmaY2QyhQuFy3804MLkj/Y216H/P53tKLtB7M/U/3KvivbkW473
         MToD2R2LGkNk5mc86MkiyKGq8AjF/vlzxnqnrI1uAgF17AjpQiS6fclADylfROZmF2
         doZuuwEjsA7/KcNyetQWxCvmfUZRlv/olWg+ryFE=
Date:   Wed, 08 Sep 2021 15:18:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com,
        baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 03/10] mm: migrate: fix the incorrect function
 name in comments
Message-ID: <20210908221803.0x8d2OSQg%akpm@linux-foundation.org>
In-Reply-To: <20210908151729.c9a15a9508ba0aed22289c76@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: migrate: fix the incorrect function name in comments

since commit a98a2f0c8ce1 ("mm/rmap: split migration into its own
function"), the migration ptes establishment has been split into a
separate try_to_migrate() function, thus update the related comments.

Link: https://lkml.kernel.org/r/5b824bad6183259c916ae6cf42f81d14c6118b06.1629447552.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-fix-the-incorrect-function-name-in-comments
+++ a/mm/migrate.c
@@ -1008,7 +1008,7 @@ static int __unmap_and_move(struct page
 	}
 
 	/*
-	 * By try_to_unmap(), page->mapcount goes down to 0 here. In this case,
+	 * By try_to_migrate(), page->mapcount goes down to 0 here. In this case,
 	 * we cannot notice that anon_vma is freed while we migrates a page.
 	 * This get_anon_vma() delays freeing anon_vma pointer until the end
 	 * of migration. File cache pages are no problem because of page_lock()
_

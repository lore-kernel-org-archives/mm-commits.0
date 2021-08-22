Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8AB1C4338F
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 20:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9361C61284
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 20:23:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhHVUYf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 22 Aug 2021 16:24:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229654AbhHVUYe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 22 Aug 2021 16:24:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82F736128A;
        Sun, 22 Aug 2021 20:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629663833;
        bh=mWFNWtRDSre7vPqe0iFa91f3OmnRsq/fBlAmBWGvIwA=;
        h=Date:From:To:Subject:From;
        b=aWGmHPJ5NTlbUxLt6dSjY+AiWY/dQMEh49QCUKkXi0SehbeU60tqsN77ezKL86455
         T5EdksE4aHTtZEYerwebpq0KLuwcGQiIIGWprGFbsYI+OeIQCI3DUv67Zgm7pj9kaa
         mpdqD6uw9yh4ExAclYL6FIle7ZZv6fgfKcuErUFw=
Date:   Sun, 22 Aug 2021 13:23:53 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, apopple@nvidia.com,
        baolin.wang@linux.alibaba.com
Subject:  +
 mm-migrate-fix-the-incorrect-function-name-in-comments.patch added to -mm
 tree
Message-ID: <20210822202353.eEpyo%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: fix the incorrect function name in comments
has been added to the -mm tree.  Its filename is
     mm-migrate-fix-the-incorrect-function-name-in-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-fix-the-incorrect-function-name-in-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-fix-the-incorrect-function-name-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1001,7 +1001,7 @@ static int __unmap_and_move(struct page
 	}
 
 	/*
-	 * By try_to_unmap(), page->mapcount goes down to 0 here. In this case,
+	 * By try_to_migrate(), page->mapcount goes down to 0 here. In this case,
 	 * we cannot notice that anon_vma is freed while we migrates a page.
 	 * This get_anon_vma() delays freeing anon_vma pointer until the end
 	 * of migration. File cache pages are no problem because of page_lock()
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-memcontrol-set-the-correct-memcg-swappiness-restriction.patch
mm-mempolicy-use-readable-numa_no_node-macro-instead-of-magic-numer.patch
mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch
mm-migrate-introduce-a-local-variable-to-get-the-number-of-pages.patch
mm-migrate-fix-the-incorrect-function-name-in-comments.patch
mm-migrate-change-to-use-bool-type-for-page_was_mapped.patch


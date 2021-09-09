Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD2BC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F408611C3
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347875AbhIIVHJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:07:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347076AbhIIVGy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A915611AF;
        Thu,  9 Sep 2021 21:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221544;
        bh=cNxZDNPx4nwje2gShAZF0YqCk7rp2903uo4P1ehCBlM=;
        h=Date:From:To:Subject:From;
        b=jn2a5q2zgVtuKkXH+BgoPAAGmHlhaFMM6iCrzLtN2JF9d1e/A2iXjJCT0DxAejiRB
         bM8WuvbdYoJu5PiVE0QRzy8U1yH3usjDpA40hjYTfZUNP//UybSIW6umDJaBZMboqp
         gbmzix57DoS0bYCrdM9VpKjyH3DPEfn8XtYICyL8=
Date:   Thu, 09 Sep 2021 14:05:44 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, baolin.wang@linux.alibaba.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        willy@infradead.org
Subject:  [merged]
 mm-migrate-fix-the-incorrect-function-name-in-comments.patch removed from
 -mm tree
Message-ID: <20210909210544.5NYYriZ53%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: fix the incorrect function name in comments
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-the-incorrect-function-name-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1008,7 +1008,7 @@ static int __unmap_and_move(struct page
 	}
 
 	/*
-	 * By try_to_unmap(), page->mapcount goes down to 0 here. In this case,
+	 * By try_to_migrate(), page->mapcount goes down to 0 here. In this case,
 	 * we cannot notice that anon_vma is freed while we migrates a page.
 	 * This get_anon_vma() delays freeing anon_vma pointer until the end
 	 * of migration. File cache pages are no problem because of page_lock()
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch


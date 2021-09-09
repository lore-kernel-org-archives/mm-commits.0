Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A236FC433FE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B5AA611C3
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348104AbhIIVHL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:07:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348275AbhIIVG4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85951611C1;
        Thu,  9 Sep 2021 21:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221546;
        bh=2vQEGNO5zfaP572xOqITOZARxwmKpnPamzamcmrWmFA=;
        h=Date:From:To:Subject:From;
        b=bhAccKmaQFNh/Zi8M3nvkaiwQ8nSqObDAnFqkVsSp/hHPuQyw6YHEmyySjnoOrcx8
         nhHWyPfTnlug+jU7UcAVY32QvxJGsyui4APUR2gyd5dtyvX7bqsZq3bs7EmpOCY+54
         V7WUaidRgOVXLSIOYNF9PuZWMmSKe9T9JPRoVlo4=
Date:   Thu, 09 Sep 2021 14:05:46 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, baolin.wang@linux.alibaba.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        willy@infradead.org
Subject:  [merged]
 mm-migrate-change-to-use-bool-type-for-page_was_mapped.patch removed from
 -mm tree
Message-ID: <20210909210546.n3wou8lnu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: change to use bool type for 'page_was_mapped'
has been removed from the -mm tree.  Its filename was
     mm-migrate-change-to-use-bool-type-for-page_was_mapped.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: migrate: change to use bool type for 'page_was_mapped'

Change to use bool type for 'page_was_mapped' variable making it more
readable.

Link: https://lkml.kernel.org/r/ce1279df18d2c163998c403e0b5ec6d3f6f90f7a.1629447552.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-migrate-change-to-use-bool-type-for-page_was_mapped
+++ a/mm/migrate.c
@@ -960,7 +960,7 @@ static int __unmap_and_move(struct page
 				int force, enum migrate_mode mode)
 {
 	int rc = -EAGAIN;
-	int page_was_mapped = 0;
+	bool page_was_mapped = false;
 	struct anon_vma *anon_vma = NULL;
 	bool is_lru = !__PageMovable(page);
 
@@ -1063,7 +1063,7 @@ static int __unmap_and_move(struct page
 		VM_BUG_ON_PAGE(PageAnon(page) && !PageKsm(page) && !anon_vma,
 				page);
 		try_to_migrate(page, 0);
-		page_was_mapped = 1;
+		page_was_mapped = true;
 	}
 
 	if (!page_mapped(page))
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch


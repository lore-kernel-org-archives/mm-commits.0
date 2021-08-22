Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D6C2C4338F
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 20:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C20B61354
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 20:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhHVUYi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 22 Aug 2021 16:24:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229654AbhHVUYh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 22 Aug 2021 16:24:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8395661284;
        Sun, 22 Aug 2021 20:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629663835;
        bh=5Eua7WTkQcp3GbR88xQ2GJ3jqWYjqhFJ8kyYBTCUtM8=;
        h=Date:From:To:Subject:From;
        b=ud/RuwVm+CBOk0fwuozrOkxif3V84FT2plegHu3qVz90t5MfWmR8xQrOTSpWtyOYQ
         Yq6aP4QrYASTlRDFsHq0og27ahu0BN4SLtWgzY1wAsaJPS4nW893y2yF77amsQSefp
         uc2bWha0E35a44ny8+RulpM0qVePr3dhZVGrKWAI=
Date:   Sun, 22 Aug 2021 13:23:55 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, apopple@nvidia.com,
        baolin.wang@linux.alibaba.com
Subject:  +
 mm-migrate-change-to-use-bool-type-for-page_was_mapped.patch added to -mm
 tree
Message-ID: <20210822202355.ZBIGB%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: change to use bool type for 'page_was_mapped'
has been added to the -mm tree.  Its filename is
     mm-migrate-change-to-use-bool-type-for-page_was_mapped.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-change-to-use-bool-type-for-page_was_mapped.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-change-to-use-bool-type-for-page_was_mapped.patch

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
@@ -953,7 +953,7 @@ static int __unmap_and_move(struct page
 				int force, enum migrate_mode mode)
 {
 	int rc = -EAGAIN;
-	int page_was_mapped = 0;
+	bool page_was_mapped = false;
 	struct anon_vma *anon_vma = NULL;
 	bool is_lru = !__PageMovable(page);
 
@@ -1056,7 +1056,7 @@ static int __unmap_and_move(struct page
 		VM_BUG_ON_PAGE(PageAnon(page) && !PageKsm(page) && !anon_vma,
 				page);
 		try_to_migrate(page, 0);
-		page_was_mapped = 1;
+		page_was_mapped = true;
 	}
 
 	if (!page_mapped(page))
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-memcontrol-set-the-correct-memcg-swappiness-restriction.patch
mm-mempolicy-use-readable-numa_no_node-macro-instead-of-magic-numer.patch
mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch
mm-migrate-introduce-a-local-variable-to-get-the-number-of-pages.patch
mm-migrate-fix-the-incorrect-function-name-in-comments.patch
mm-migrate-change-to-use-bool-type-for-page_was_mapped.patch


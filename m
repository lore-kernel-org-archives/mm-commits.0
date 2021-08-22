Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457E3C4338F
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 20:23:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A29861284
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 20:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbhHVUYb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 22 Aug 2021 16:24:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229654AbhHVUYb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 22 Aug 2021 16:24:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B770D611C8;
        Sun, 22 Aug 2021 20:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629663829;
        bh=7XtC/V+bXrfUAGEKJlt8lo666uOn+xy0pOBG5UnRsrE=;
        h=Date:From:To:Subject:From;
        b=Wuy/qZplZoWWT4M57Je/j/l7jZasym7yp+f9kmt7ZWtJz649i6/DQeIfZvJFCqFtq
         DT/asFOA7mukdu3iVO0rQkvGS608NgErW6rlO+WzfEBYoKBe08BgIrdTS8Uh6prvi5
         S8rNEwvLAAazwOcAjJPCKiIRVnA1a0gNxD8U3ybY=
Date:   Sun, 22 Aug 2021 13:23:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, apopple@nvidia.com,
        baolin.wang@linux.alibaba.com
Subject:  +
 =?us-ascii?Q?mm-migrate-simplify-the-file-backed-pages-validation-when?=
 =?us-ascii?Q?-migrating-its-mapping.patch?= added to -mm tree
Message-ID: <20210822202349.p65ql%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: simplify the file-backed pages validation when migrating its mapping
has been added to the -mm tree.  Its filename is
     mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch

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
Subject: mm: migrate: simplify the file-backed pages validation when migrating its mapping

Patch series "Some cleanup for page migration", v3.

This patchset does some cleanups and improvements for page migration.


This patch (of 4):

There is no need to validate the file-backed page's refcount before trying
to freeze the page's expected refcount, instead we can rely on the
folio_ref_freeze() to validate if the page has the expected refcount
before migrating its mapping.

Moreover we are always under the page lock when migrating the page
mapping, which means nowhere else can remove it from the page cache, so we
can remove the xas_load() validation under the i_pages lock.

Link: https://lkml.kernel.org/r/cover.1629447552.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/df4c129fd8e86a95dbc55f4663d77441cc0d3bd1.1629447552.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/migrate.c~mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping
+++ a/mm/migrate.c
@@ -404,12 +404,6 @@ int folio_migrate_mapping(struct address
 	newzone = folio_zone(newfolio);
 
 	xas_lock_irq(&xas);
-	if (folio_ref_count(folio) != expected_count ||
-	    xas_load(&xas) != folio) {
-		xas_unlock_irq(&xas);
-		return -EAGAIN;
-	}
-
 	if (!folio_ref_freeze(folio, expected_count)) {
 		xas_unlock_irq(&xas);
 		return -EAGAIN;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-memcontrol-set-the-correct-memcg-swappiness-restriction.patch
mm-mempolicy-use-readable-numa_no_node-macro-instead-of-magic-numer.patch
mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch
mm-migrate-introduce-a-local-variable-to-get-the-number-of-pages.patch
mm-migrate-fix-the-incorrect-function-name-in-comments.patch
mm-migrate-change-to-use-bool-type-for-page_was_mapped.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD125C77B7C
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 23:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240100AbjELXT1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 19:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239987AbjELXT0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 19:19:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA88A2720
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 16:19:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76C9365926
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 23:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5339C433D2;
        Fri, 12 May 2023 23:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683933563;
        bh=f0kiR4jVwmwF8zPzU/wOnGeldW9Eo/tJdoTzpourwcU=;
        h=Date:To:From:Subject:From;
        b=DFFE3plKU+ZsF+hB9LoYX1EXWr/ntuBzH2//zJgqCoreMGqDGL/kVbZqyNqDJs3oE
         ipVKV8NrDorPVHdJ/N2XiECct7CB/2R9gaE0ikZIyuekhUQI+DNN5ONH6OOONX+uqG
         e55Yz7mwz9tSsFyFGFdU3B6sy+sknkIrGmCEPqs8=
Date:   Fri, 12 May 2023 16:19:23 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, mcgrof@kernel.org,
        hch@lst.de, p.raghav@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-remove-page_endio.patch added to mm-unstable branch
Message-Id: <20230512231923.C5339C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: remove page_endio()
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-remove-page_endio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-remove-page_endio.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: filemap: remove page_endio()
Date: Wed, 10 May 2023 14:47:16 +0200

page_endio() is not used anymore. Remove it.

Link: https://lkml.kernel.org/r/20230510124716.73655-1-p.raghav@samsung.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 --
 mm/filemap.c            |   30 ------------------------------
 2 files changed, 32 deletions(-)

--- a/include/linux/pagemap.h~filemap-remove-page_endio
+++ a/include/linux/pagemap.h
@@ -1078,8 +1078,6 @@ int filemap_migrate_folio(struct address
 #else
 #define filemap_migrate_folio NULL
 #endif
-void page_endio(struct page *page, bool is_write, int err);
-
 void folio_end_private_2(struct folio *folio);
 void folio_wait_private_2(struct folio *folio);
 int folio_wait_private_2_killable(struct folio *folio);
--- a/mm/filemap.c~filemap-remove-page_endio
+++ a/mm/filemap.c
@@ -1628,36 +1628,6 @@ void folio_end_writeback(struct folio *f
 }
 EXPORT_SYMBOL(folio_end_writeback);
 
-/*
- * After completing I/O on a page, call this routine to update the page
- * flags appropriately
- */
-void page_endio(struct page *page, bool is_write, int err)
-{
-	struct folio *folio = page_folio(page);
-
-	if (!is_write) {
-		if (!err) {
-			folio_mark_uptodate(folio);
-		} else {
-			folio_clear_uptodate(folio);
-			folio_set_error(folio);
-		}
-		folio_unlock(folio);
-	} else {
-		if (err) {
-			struct address_space *mapping;
-
-			folio_set_error(folio);
-			mapping = folio_mapping(folio);
-			if (mapping)
-				mapping_set_error(mapping, err);
-		}
-		folio_end_writeback(folio);
-	}
-}
-EXPORT_SYMBOL_GPL(page_endio);
-
 /**
  * __folio_lock - Get a lock on the folio, assuming we need to sleep to get it.
  * @folio: The folio to lock
_

Patches currently in -mm which might be from p.raghav@samsung.com are

filemap-remove-page_endio.patch


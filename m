Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B61FBC7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:27:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbjFIX1t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbjFIX1S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294BC30CD
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAA8360FCA
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E637C433D2;
        Fri,  9 Jun 2023 23:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353236;
        bh=gxYMox3GU8McTq81R6ALs/EycSEVMDcKN2whStQVhl8=;
        h=Date:To:From:Subject:From;
        b=FbsxVntX8osrmjliaIX5w3AlKoxOIN2+X1ubNV65tfY8IIEUAjRrQbucPl1kTMcD9
         bqz+YD+yBg3kF8tNILYBQthM7OrG+TwUMC7TVmCKIRf+0iqRcN5f/Jv8LUl0nwskQO
         A0Ya5lxS33Oxy/qPWjjoIr5NL4QsW1pB5seKCpi0=
Date:   Fri, 09 Jun 2023 16:27:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, mcgrof@kernel.org,
        hch@lst.de, p.raghav@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-remove-page_endio.patch removed from -mm tree
Message-Id: <20230609232716.1E637C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: remove page_endio()
has been removed from the -mm tree.  Its filename was
     filemap-remove-page_endio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



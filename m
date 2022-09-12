Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C37C6FA8A
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiILD24 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiILD2Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CCD2613F
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9278761170
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57FBC433D6;
        Mon, 12 Sep 2022 03:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953304;
        bh=3dXxVBmvQfc6hBuItyfaPEWZW7jppcWL3hSTGeZC1So=;
        h=Date:To:From:Subject:From;
        b=m8KMpLWvv2fi25Bar+vXqdPE8oPjKyYB2tP1j1I/UsY9SWLDuV2VQILk/xnvGYhPo
         sOxC6/lW694y/PxyT+quw4exrN5h2e0eE2gt/qpWhtkVVofOZ1SHWNyLfLuLOeK2Bu
         vmsFsNjCYI0Hqpd6WdOMBCb+LzGIANPyw5V0JRgA=
Date:   Sun, 11 Sep 2022 20:28:23 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shaoqin.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-convert-page_endio-to-use-a-folio.patch removed from -mm tree
Message-Id: <20220912032823.E57FBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/filemap.c: convert page_endio() to use a folio
has been removed from the -mm tree.  Its filename was
     filemap-convert-page_endio-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shaoqin Huang <shaoqin.huang@intel.com>
Subject: mm/filemap.c: convert page_endio() to use a folio
Date: Tue, 9 Aug 2022 10:32:56 +0800

Replace three calls to compound_head() with one.

Link: https://lkml.kernel.org/r/20220809023256.178194-1-shaoqin.huang@intel.com
Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/filemap.c~filemap-convert-page_endio-to-use-a-folio
+++ a/mm/filemap.c
@@ -1633,24 +1633,26 @@ EXPORT_SYMBOL(folio_end_writeback);
  */
 void page_endio(struct page *page, bool is_write, int err)
 {
+	struct folio *folio = page_folio(page);
+
 	if (!is_write) {
 		if (!err) {
-			SetPageUptodate(page);
+			folio_mark_uptodate(folio);
 		} else {
-			ClearPageUptodate(page);
-			SetPageError(page);
+			folio_clear_uptodate(folio);
+			folio_set_error(folio);
 		}
-		unlock_page(page);
+		folio_unlock(folio);
 	} else {
 		if (err) {
 			struct address_space *mapping;
 
-			SetPageError(page);
-			mapping = page_mapping(page);
+			folio_set_error(folio);
+			mapping = folio_mapping(folio);
 			if (mapping)
 				mapping_set_error(mapping, err);
 		}
-		end_page_writeback(page);
+		folio_end_writeback(folio);
 	}
 }
 EXPORT_SYMBOL_GPL(page_endio);
_

Patches currently in -mm which might be from shaoqin.huang@intel.com are



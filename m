Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71317C00140
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 00:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiHKADC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Aug 2022 20:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiHKADC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2022 20:03:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD2152FFC
        for <mm-commits@vger.kernel.org>; Wed, 10 Aug 2022 17:03:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42F1EB81E19
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 00:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D971BC433D6;
        Thu, 11 Aug 2022 00:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660176178;
        bh=bZ49JUc3LqWdhDOpKIq7IyH1IlPqaifUjM3JPONsLNg=;
        h=Date:To:From:Subject:From;
        b=mvo3kBK6JJEOT4utr3iskyWhJM86W7+dznl3FhTwqphsS+hq3ygMqXc9prrLFlMdR
         2mUy+HpRG4aC6lCsurdsqd5uBMfi7WNJ3ndPb+F8LA6GAiGGsKBqfo06nckT2L60C9
         UcDCdbw0vaN6ZCwpoMWDnNdGvIWIHhpGUM5mb56M=
Date:   Wed, 10 Aug 2022 17:02:58 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shaoqin.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-convert-page_endio-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20220811000258.D971BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap.c: convert page_endio() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-convert-page_endio-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-convert-page_endio-to-use-a-folio.patch

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

filemap-convert-page_endio-to-use-a-folio.patch


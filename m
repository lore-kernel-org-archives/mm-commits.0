Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12928C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 19 Oct 2022 23:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiJSXFf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Oct 2022 19:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiJSXFU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2022 19:05:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C596715788E
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 16:05:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2472B82624
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 23:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802CAC433D6;
        Wed, 19 Oct 2022 23:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666220684;
        bh=Sg4bJ+UfoZKpu5z1FQZE/jyWBtDVnPpzOth+mQn+PvI=;
        h=Date:To:From:Subject:From;
        b=KUkdoWNyhTheD/UAr3dMPlejoZGEnd2p6MXeBh6OW0oEsD7t2QkIk2T99R/9FCGWn
         nyAGp5FqgozJMPXCiesdWKH0+eCEsGhR/5WrhG/stp2zDrjEHPYsKNJrpTsGXkZKmW
         HTBn33XgKlBTJmR7hTUeGu096RiCByUMNnqaoRdQ=
Date:   Wed, 19 Oct 2022 16:04:43 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-fgp_head.patch added to mm-unstable branch
Message-Id: <20221019230444.802CAC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove FGP_HEAD
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-fgp_head.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-fgp_head.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove FGP_HEAD
Date: Wed, 19 Oct 2022 19:33:32 +0100

This is no longer used; all callers have been converted to use folios
instead.  Somehow this manages to save 11 bytes of text.

Link: https://lkml.kernel.org/r/20221019183332.2802139-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    5 ++---
 mm/folio-compat.c       |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-fgp_head
+++ a/include/linux/pagemap.h
@@ -504,9 +504,8 @@ pgoff_t page_cache_prev_miss(struct addr
 #define FGP_NOFS		0x00000010
 #define FGP_NOWAIT		0x00000020
 #define FGP_FOR_MMAP		0x00000040
-#define FGP_HEAD		0x00000080
-#define FGP_ENTRY		0x00000100
-#define FGP_STABLE		0x00000200
+#define FGP_ENTRY		0x00000080
+#define FGP_STABLE		0x00000100
 
 struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
 		int fgp_flags, gfp_t gfp);
--- a/mm/folio-compat.c~mm-remove-fgp_head
+++ a/mm/folio-compat.c
@@ -108,7 +108,7 @@ struct page *pagecache_get_page(struct a
 	struct folio *folio;
 
 	folio = __filemap_get_folio(mapping, index, fgp_flags, gfp);
-	if ((fgp_flags & FGP_HEAD) || !folio || xa_is_value(folio))
+	if (!folio || xa_is_value(folio))
 		return &folio->page;
 	return folio_file_page(folio, index);
 }
_

Patches currently in -mm which might be from willy@infradead.org are

mm-huge_memory-convert-split_huge_pages_in_file-to-use-a-folio.patch
mm-swap-convert-find_get_incore_page-to-use-folios.patch
mm-convert-find_get_incore_page-to-filemap_get_incore_folio.patch
mm-remove-fgp_head.patch


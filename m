Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0F3CEB64D9
	for <mm-commits@archiver.kernel.org>; Thu,  6 Jul 2023 20:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjGFUKK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Jul 2023 16:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjGFUKJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2023 16:10:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC73110EA
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 13:10:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B10F611A6
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 20:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E1BC433C8;
        Thu,  6 Jul 2023 20:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688674207;
        bh=4xRIW4lBUGEIuFd4gDn3xwsLxCEdIn56Ys+rFTx2PvQ=;
        h=Date:To:From:Subject:From;
        b=lDRYeNC5zQn6W3rDHpYhUzggCZ+vxPC5onOEyCdufVb8yHWD7UR69N6MLk1+wieLk
         hlj4pESVZQTof6pnjnWpXQh68ebZQQZao1oLg1N9gSZ5LaybHWCHBRa7hAjhbthbMF
         qxldRqLBWoor2XdnvsMGJAOac6OdlXITWE89Lr+s=
Date:   Thu, 06 Jul 2023 13:10:06 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + rmap-pass-the-folio-to-__page_check_anon_rmap.patch added to mm-unstable branch
Message-Id: <20230706201007.87E1BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rmap: pass the folio to __page_check_anon_rmap()
has been added to the -mm mm-unstable branch.  Its filename is
     rmap-pass-the-folio-to-__page_check_anon_rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rmap-pass-the-folio-to-__page_check_anon_rmap.patch

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
Subject: rmap: pass the folio to __page_check_anon_rmap()
Date: Thu, 6 Jul 2023 20:52:51 +0100

The lone caller already has the folio, so pass it in instead of deriving
it from the page again.

Link: https://lkml.kernel.org/r/20230706195251.2707542-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/rmap.c~rmap-pass-the-folio-to-__page_check_anon_rmap
+++ a/mm/rmap.c
@@ -1175,14 +1175,14 @@ out:
 
 /**
  * __page_check_anon_rmap - sanity check anonymous rmap addition
- * @page:	the page to add the mapping to
+ * @folio:	The folio containing @page.
+ * @page:	the page to check the mapping of
  * @vma:	the vm area in which the mapping is added
  * @address:	the user virtual address mapped
  */
-static void __page_check_anon_rmap(struct page *page,
+static void __page_check_anon_rmap(struct folio *folio, struct page *page,
 	struct vm_area_struct *vma, unsigned long address)
 {
-	struct folio *folio = page_folio(page);
 	/*
 	 * The page's anon-rmap details (mapping and index) are guaranteed to
 	 * be set up correctly at this point.
@@ -1262,7 +1262,7 @@ void page_add_anon_rmap(struct page *pag
 			__page_set_anon_rmap(folio, page, vma, address,
 					     !!(flags & RMAP_EXCLUSIVE));
 		else
-			__page_check_anon_rmap(page, vma, address);
+			__page_check_anon_rmap(folio, page, vma, address);
 	}
 
 	mlock_vma_folio(folio, vma, compound);
_

Patches currently in -mm which might be from willy@infradead.org are

writeback-account-the-number-of-pages-written-back.patch
rmap-pass-the-folio-to-__page_check_anon_rmap.patch


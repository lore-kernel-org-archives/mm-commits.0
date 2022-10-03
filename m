Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E05F4C46467
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiJCVR7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiJCVPp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:15:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014C9558E7
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4EA3B811C4
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5714BC433D6;
        Mon,  3 Oct 2022 21:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831414;
        bh=EALv5WYfvwkNAU2KDg6TaQzGuB4VOJjh19hyHOugioU=;
        h=Date:To:From:Subject:From;
        b=txR1Uesdiul/++bs/HzRC75cZ16T4YwUurHSGCjknqzmHAOsA77WyJRIjYELL0ILs
         himd716P00ZmHvqXZ1GUI1/soPaiJq3YPgHOB5eQj03tjcZBsq9gJ3c1eo+2skMHKn
         F2AtqtiaQWqeunWJcCJ2IH0DOseSfLqVkPEsE/dM=
Date:   Mon, 03 Oct 2022 14:10:13 -0700
To:     mm-commits@vger.kernel.org, cuigaosheng1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unused-inline-functions-from-include-linux-mm_inlineh.patch removed from -mm tree
Message-Id: <20221003211014.5714BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove unused inline functions from include/linux/mm_inline.h
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-inline-functions-from-include-linux-mm_inlineh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gaosheng Cui <cuigaosheng1@huawei.com>
Subject: mm: remove unused inline functions from include/linux/mm_inline.h
Date: Thu, 22 Sep 2022 19:09:35 +0800

Remove the following unused inline functions from mm_inline.h:

1.  All uses of add_page_to_lru_list_tail() have been removed since
   commit 7a3dbfe8a52b ("mm/swap: convert lru_deactivate_file to a
   folio_batch"), and it can be replaced by lruvec_add_folio_tail().

2.  All uses of __clear_page_lru_flags() have been removed since commit
   188e8caee968 ("mm/swap: convert __page_cache_release() to use a
   folio"), and it can be replaced by __folio_clear_lru_flags().

They are useless, so remove them.

Link: https://lkml.kernel.org/r/20220922110935.1495099-1-cuigaosheng1@huawei.com
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   11 -----------
 1 file changed, 11 deletions(-)

--- a/include/linux/mm_inline.h~mm-remove-unused-inline-functions-from-include-linux-mm_inlineh
+++ a/include/linux/mm_inline.h
@@ -76,11 +76,6 @@ static __always_inline void __folio_clea
 	__folio_clear_unevictable(folio);
 }
 
-static __always_inline void __clear_page_lru_flags(struct page *page)
-{
-	__folio_clear_lru_flags(page_folio(page));
-}
-
 /**
  * folio_lru_list - Which LRU list should a folio be on?
  * @folio: The folio to test.
@@ -348,12 +343,6 @@ void lruvec_add_folio_tail(struct lruvec
 	list_add_tail(&folio->lru, &lruvec->lists[lru]);
 }
 
-static __always_inline void add_page_to_lru_list_tail(struct page *page,
-				struct lruvec *lruvec)
-{
-	lruvec_add_folio_tail(lruvec, page_folio(page));
-}
-
 static __always_inline
 void lruvec_del_folio(struct lruvec *lruvec, struct folio *folio)
 {
_

Patches currently in -mm which might be from cuigaosheng1@huawei.com are



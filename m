Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F79C04A95
	for <mm-commits@archiver.kernel.org>; Sun, 25 Sep 2022 19:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiIYTgZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 25 Sep 2022 15:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbiIYTgZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 25 Sep 2022 15:36:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F782AC7A
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 12:36:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9155B80C9F
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 19:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF2DC433D6;
        Sun, 25 Sep 2022 19:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664134581;
        bh=o94rgjWv7BKsqOvgdy1QFk5a97AXJySB21uypheID30=;
        h=Date:To:From:Subject:From;
        b=0/o+39Jo37x3+qgBsupjW7YTUATP5RFm9srSkZB4eqa3NFEddh+hbB10SJZWsOpOy
         INr6qaVSmWnfqUMYgjrDkjVD8S9lK8LpKrsaj/7B+mT/uR3oc+/wynuGE1Ozup2H9X
         x2pU97qWdX5QbmD6lQ4SAScOD6Shx6cmrYg08cmM=
Date:   Sun, 25 Sep 2022 12:36:19 -0700
To:     mm-commits@vger.kernel.org, cuigaosheng1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unused-inline-functions-from-include-linux-mm_inlineh.patch added to mm-unstable branch
Message-Id: <20220925193621.1CF2DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unused inline functions from include/linux/mm_inline.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-unused-inline-functions-from-include-linux-mm_inlineh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unused-inline-functions-from-include-linux-mm_inlineh.patch

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

mm-remove-unused-inline-functions-from-include-linux-mm_inlineh.patch


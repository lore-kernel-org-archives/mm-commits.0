Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7914C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 10 Nov 2023 17:42:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345621AbjKJRm4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Nov 2023 12:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235202AbjKJRl5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Nov 2023 12:41:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41BE446CE
        for <mm-commits@vger.kernel.org>; Fri, 10 Nov 2023 09:25:54 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB39C433C8;
        Fri, 10 Nov 2023 17:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699637154;
        bh=dacW/wU3EjAkaG3eWWTbkSst5OR/lCOA/3fNQaVgifk=;
        h=Date:To:From:Subject:From;
        b=BinlndFla8yQHSuqSOdwlp58i/RM+SA0z1JvD8uj965HMwXo4dgEOz7h9dYCmvbXK
         y68ENXob4X9j8oMrCV9AyNRKdXR96QqHOaAKqjGmiIt2ptvf1tHYoWbc7Ta9J3w5fG
         xmjtnMO8vRWUysh22s3o1yxM9gUg3mLGT/lmatNU=
Date:   Fri, 10 Nov 2023 09:25:53 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        gregory.price@memverge.com, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + page_idle-kill-page-idle-and-young-wrapper.patch added to mm-unstable branch
Message-Id: <20231110172554.3BB39C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: page_idle: kill page idle and young wrapper
has been added to the -mm mm-unstable branch.  Its filename is
     page_idle-kill-page-idle-and-young-wrapper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/page_idle-kill-page-idle-and-young-wrapper.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: page_idle: kill page idle and young wrapper
Date: Fri, 10 Nov 2023 11:33:24 +0800

Since all the calls of page idle and young functions are gone, let's
remove all the wrappers.

Link: https://lkml.kernel.org/r/20231110033324.2455523-8-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gregory.price@memverge.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_idle.h |   25 -------------------------
 1 file changed, 25 deletions(-)

--- a/include/linux/page_idle.h~page_idle-kill-page-idle-and-young-wrapper
+++ a/include/linux/page_idle.h
@@ -119,29 +119,4 @@ static inline void folio_clear_idle(stru
 }
 
 #endif /* CONFIG_PAGE_IDLE_FLAG */
-
-static inline bool page_is_young(struct page *page)
-{
-	return folio_test_young(page_folio(page));
-}
-
-static inline void set_page_young(struct page *page)
-{
-	folio_set_young(page_folio(page));
-}
-
-static inline bool test_and_clear_page_young(struct page *page)
-{
-	return folio_test_clear_young(page_folio(page));
-}
-
-static inline bool page_is_idle(struct page *page)
-{
-	return folio_test_idle(page_folio(page));
-}
-
-static inline void set_page_idle(struct page *page)
-{
-	folio_set_idle(page_folio(page));
-}
 #endif /* _LINUX_MM_PAGE_IDLE_H */
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

fs-proc-page-remove-unneeded-pagetail-pageslab-check.patch
fs-proc-page-use-a-folio-in-stable_page_flags.patch
fs-proc-page-respect-folio-head-page-flag-placement.patch
mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail.patch
mm-task_mmu-use-a-folio-in-smaps_account.patch
mm-task_mmu-use-a-folio-in-clear_refs_pte_range.patch
page_idle-kill-page-idle-and-young-wrapper.patch


Return-Path: <SRS0=BOB0=CX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBAE7C433E2
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 00:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 801ED20771
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 00:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600042961;
	bh=YU/x9RjJUXSr8iR9UO6FyVFnLzjXMtL6dzKdtiybVIA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=wcE5sxZEln/Du+lkpX+1JDHBRuqw73P5HuWFHo9S/lOkxATaPMSrqelhzSVFE3rzV
	 Tdyw8BIM7zTrHfeJZ9uF4m2ShWgotT28S/he8sBmXIBFgNQoz92SYh8dtLPt9RZe+P
	 kKQVb321FL0Jbq71WSIcFMu+HcUAJf1/F+i4atr4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgINAWk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Sep 2020 20:22:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbgINAWj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 13 Sep 2020 20:22:39 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B484B20756;
        Mon, 14 Sep 2020 00:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600042958;
        bh=YU/x9RjJUXSr8iR9UO6FyVFnLzjXMtL6dzKdtiybVIA=;
        h=Date:From:To:Subject:From;
        b=2DnflQghJXktXFSkFnVKI1/Mt8bNeaAAmJllw7u+VhoeQZPbA04d8l9VqcwQfnEcP
         plqxZU8Sp2p0kPiSOPOeLminuY7+J/BGOoHDuLFM7SN4vS0QzQwk9y23iq2Dh7+9oZ
         kiCnSk8iFEw6snlfb0bwRh/28n2sWpQJc3Uj77Z4=
Date:   Sun, 13 Sep 2020 17:22:38 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com
Subject:  + mm-fix-some-broken-comments.patch added to -mm tree
Message-ID: <20200914002238.K9wQ_%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix some broken comments
has been added to the -mm tree.  Its filename is
     mm-fix-some-broken-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-some-broken-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-some-broken-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: fix some broken comments

Fix some broken comments including typo, grammar error and wrong function
name.

Link: https://lkml.kernel.org/r/20200913095456.54873-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c    |    4 ++--
 mm/swap_state.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/filemap.c~mm-fix-some-broken-comments
+++ a/mm/filemap.c
@@ -1347,7 +1347,7 @@ static inline bool clear_bit_unlock_is_n
  * unlock_page - unlock a locked page
  * @page: the page
  *
- * Unlocks the page and wakes up sleepers in ___wait_on_page_locked().
+ * Unlocks the page and wakes up sleepers in wait_on_page_locked().
  * Also wakes sleepers in wait_on_page_writeback() because the wakeup
  * mechanism between PageLocked pages and PageWriteback pages is shared.
  * But that's OK - sleepers in wait_on_page_writeback() just go back to sleep.
@@ -2902,7 +2902,7 @@ filler:
 		goto out;
 
 	/*
-	 * Page is not up to date and may be locked due one of the following
+	 * Page is not up to date and may be locked due to one of the following
 	 * case a: Page is being filled and the page lock is held
 	 * case b: Read/write error clearing the page uptodate status
 	 * case c: Truncation in progress (page locked)
--- a/mm/swap_state.c~mm-fix-some-broken-comments
+++ a/mm/swap_state.c
@@ -246,7 +246,7 @@ int add_to_swap(struct page *page)
 		goto fail;
 	/*
 	 * Normally the page will be dirtied in unmap because its pte should be
-	 * dirty. A special case is MADV_FREE page. The page'e pte could have
+	 * dirty. A special case is MADV_FREE page. The page's pte could have
 	 * dirty bit cleared but the page's SwapBacked bit is still set because
 	 * clearing the dirty bit and SwapBacked bit has no lock protected. For
 	 * such page, unmap will not set dirty bit for it, so page reclaim will
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swap-fix-confusing-comment-in-release_pages.patch
mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch
mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch


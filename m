Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6BAC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C20421775
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881532;
	bh=2qYc3yJ1imeDYGPg1LZi2Z8mFG/yRuRxv+boQ0SAJd8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Gdra2+uRhUhegJTdmuHM6cgN8oD9wmruZdNCrWj+K2aK5znY1S1N3/LcPllVYHFVs
	 Rcb+oeQogmIzF+1/JfGLvHoagJcZO+cPNGzAc8IlnnRMKhy+f8nZwSJnFQHsJcFe53
	 fW13J8Uy4z1FuI92jPkiWgQD2/7tQr+kUB7ZtR9E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408430AbgJPUwL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732579AbgJPUwL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:52:11 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99FD82145D;
        Fri, 16 Oct 2020 20:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881530;
        bh=2qYc3yJ1imeDYGPg1LZi2Z8mFG/yRuRxv+boQ0SAJd8=;
        h=Date:From:To:Subject:From;
        b=AJnxiA6uxyPBJCdQmJECd2OGDYiQLgCWSBcZcxUWrcs5G3KI55tgfh2ORrm3Ng4a5
         iTdKb0ujXl2c3ffrNMHLtPhVIiYorwFNsCgg26WINWsYhO9fGa/UZiI9Jv7j5YX4NG
         6w7EyJ6CBpUI0CLTQJ0uLibk6GzqwhpnuzET/ACo=
Date:   Fri, 16 Oct 2020 13:52:10 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged] mm-fix-some-broken-comments.patch removed from
 -mm tree
Message-ID: <20201016205210.aptG8t9Ba%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix some broken comments
has been removed from the -mm tree.  Its filename was
     mm-fix-some-broken-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1445,7 +1445,7 @@ static inline bool clear_bit_unlock_is_n
  * unlock_page - unlock a locked page
  * @page: the page
  *
- * Unlocks the page and wakes up sleepers in ___wait_on_page_locked().
+ * Unlocks the page and wakes up sleepers in wait_on_page_locked().
  * Also wakes sleepers in wait_on_page_writeback() because the wakeup
  * mechanism between PageLocked pages and PageWriteback pages is shared.
  * But that's OK - sleepers in wait_on_page_writeback() just go back to sleep.
@@ -3004,7 +3004,7 @@ filler:
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

mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch


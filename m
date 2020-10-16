Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E25C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67F4D20897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817800;
	bh=1cFqFlxLdsd8ECw4tArY5VpgQCvCd6b88P+ZowjKZwk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=F8QqviByUSbdE4ZF4hnhWy6uLdem7pZZdXQYE25KN6/KkZGXXSa4GmeF+h0/znllj
	 4UUXRxBXZ+IMyRqgPM5MYj822KKLB2Rjn5clUVVsrHZ3s7e7VEhrJWwOoCKoysQeZd
	 dcHOOa2iMUYZPsvq3ud0c0THbFVE05WhWbO7n/BA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732993AbgJPDKA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:10:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgJPDJ7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:09:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52DAA2087D;
        Fri, 16 Oct 2020 03:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817799;
        bh=1cFqFlxLdsd8ECw4tArY5VpgQCvCd6b88P+ZowjKZwk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uckoNOCzDLuYuCmc3A2HPvaj1igEC2CcWMNVVnRbyt5AG1D+rStIZEfn4jvtenj1x
         b8lYkuLtH9Xk2J+zxRrKN3tJyyBZhLnenf8X9Jz9uvLzsXl8zw40RZDsfpqqTlZEKs
         wXj2x9dSmHIfNeQe8Q2A1Ucs9st6SxIi3ycYgqlI=
Date:   Thu, 15 Oct 2020 20:09:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 089/156] mm: fix some broken comments
Message-ID: <20201016030958.gY_d3S3oa%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C65BBC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACF656126A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbhKEUnQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233000AbhKEUnL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:43:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4DC561284;
        Fri,  5 Nov 2021 20:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144831;
        bh=SjisieUTqCjhiTEM6vcVSU74YHf/mekk/+PYp9VXgEo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oyPyt1LDMiicWc3y85oiLsYtU8YS9nKuXvWpWUZgSbACn9Rv6SlrKQKInoMPakLdC
         QiMZ4AB/jXy+0WAwjwfiZQUeuonqw2tUJR6eIsbWWoxBCHM3QSMA69nWdNcYpt+0ax
         6Dd9Mo6ZWTSomWdGTg5GV35XPOYG0jRKw/bREsd4=
Date:   Fri, 05 Nov 2021 13:40:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, edumazet@google.com, hughd@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 112/262] mm/page_alloc.c: do not acquire zone lock
 in is_free_buddy_page()
Message-ID: <20211105204031.LpK4bsEk0%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Subject: mm/page_alloc.c: do not acquire zone lock in is_free_buddy_page()

Grabbing zone lock in is_free_buddy_page() gives a wrong sense of safety,
and has potential performance implications when zone is experiencing lock
contention.

In any case, if a caller needs a stable result, it should grab zone lock
before calling this function.

Link: https://lkml.kernel.org/r/20210922152833.4023972-1-eric.dumazet@gmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-do-not-acquire-zone-lock-in-is_free_buddy_page
+++ a/mm/page_alloc.c
@@ -9356,21 +9356,21 @@ void __offline_isolated_pages(unsigned l
 }
 #endif
 
+/*
+ * This function returns a stable result only if called under zone lock.
+ */
 bool is_free_buddy_page(struct page *page)
 {
-	struct zone *zone = page_zone(page);
 	unsigned long pfn = page_to_pfn(page);
-	unsigned long flags;
 	unsigned int order;
 
-	spin_lock_irqsave(&zone->lock, flags);
 	for (order = 0; order < MAX_ORDER; order++) {
 		struct page *page_head = page - (pfn & ((1 << order) - 1));
 
-		if (PageBuddy(page_head) && buddy_order(page_head) >= order)
+		if (PageBuddy(page_head) &&
+		    buddy_order_unsafe(page_head) >= order)
 			break;
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
 
 	return order < MAX_ORDER;
 }
_

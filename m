Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F28DC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46D486103C
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbhKKCq7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:46:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:52088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234032AbhKKCq6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:46:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A21360F46;
        Thu, 11 Nov 2021 02:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598650;
        bh=zUe+7ZlhKXcXnAA/4dWVRjfper8ckRwYE3NWR061IDE=;
        h=Date:From:To:Subject:From;
        b=M+gaO4ZqgDTgi5H7hfXYeb0h8ceTWggpsC8ebeqEeIWbG2sWI2dWpG77Q8E3wuB5i
         K/Tg2nHehj1WDDJHusPwk/fsCO+YOG/0j42rt9FRvdJu3W4xWabl3IN+3D4HsFb4iX
         8HFpGSuklrhpFbyTqyoknvV+pdP0ltJISD5Gpf3w=
Date:   Wed, 10 Nov 2021 18:44:10 -0800
From:   akpm@linux-foundation.org
To:     edumazet@google.com, hughd@google.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-do-not-acquire-zone-lock-in-is_free_buddy_page.patch removed from -mm
 tree
Message-ID: <20211111024410.QxSmP1CuJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: do not acquire zone lock in is_free_buddy_page()
has been removed from the -mm tree.  Its filename was
     mm-do-not-acquire-zone-lock-in-is_free_buddy_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from edumazet@google.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558C5C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 02:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3489061108
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 02:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243907AbhIXCbl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 22:31:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243813AbhIXCbl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 22:31:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CD1E60F4B;
        Fri, 24 Sep 2021 02:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632450608;
        bh=4/lYaVpUqDcQq/hN1s1jG30wPUK7Oulx+WO6T4cSklM=;
        h=Date:From:To:Subject:From;
        b=PS4q6YN/7b0X+QpdvLeJR5IEbK+p2EKTD9DM8/1j/Ooj79ebC9cYwRwqQqlK5yAJa
         copEYccARHAJ76CWH6I5c5nFp7O7ZcEiUJt4z4HdCLhSgCwL8VpBBWAGpMxug8Vd1k
         jAqXO5frTfMULwvZ0jpGgUC+Z9yEuklqNpFbDWgY=
Date:   Thu, 23 Sep 2021 19:30:08 -0700
From:   akpm@linux-foundation.org
To:     edumazet@google.com, hughd@google.com, mm-commits@vger.kernel.org
Subject:  + mm-do-not-acquire-zone-lock-in-is_free_buddy_page.patch
 added to -mm tree
Message-ID: <20210924023008.d_zBrunW0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: do not acquire zone lock in is_free_buddy_page()
has been added to the -mm tree.  Its filename is
     mm-do-not-acquire-zone-lock-in-is_free_buddy_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-do-not-acquire-zone-lock-in-is_free_buddy_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-do-not-acquire-zone-lock-in-is_free_buddy_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -9350,21 +9350,21 @@ void __offline_isolated_pages(unsigned l
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

mm-large-system-hash-avoid-possible-null-deref-in-alloc_large_system_hash.patch
mm-do-not-acquire-zone-lock-in-is_free_buddy_page.patch


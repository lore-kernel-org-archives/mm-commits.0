Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4FAFC47435
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C69622D2B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbgLOX7d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:59720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728227AbgLOXZG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:25:06 -0500
Date:   Tue, 15 Dec 2020 15:22:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074540;
        bh=JgY9+9EKK31EP7qE4ww/u79bM9jbQJxaPRfPbY55CGc=;
        h=From:To:Subject:From;
        b=uVPR41XZ8Zs7DLRPXco6SrKCvgB2PCm/fzYXsai/RgCpQjR3YODn8FnikQEj2FNRu
         GpZ/zsJ3IVuUNdnGTtfMDWYc1ABgby6DZR3PoB4PA9GJ6lvzY482armELXQzr2a52Q
         hGi9hWHwq3oE98Lx1bWNm6IeDQT3Pn79YiJZqp/Q=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, qcai@redhat.com, vbabka@suse.cz
Subject:  [merged]
 mmhwpoison-remove-drain_all_pages-from-shake_page.patch removed from -mm
 tree
Message-ID: <20201215232220.KUc6aKSp1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: remove drain_all_pages from shake_page
has been removed from the -mm tree.  Its filename was
     mmhwpoison-remove-drain_all_pages-from-shake_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: remove drain_all_pages from shake_page

get_hwpoison_page already drains pcplists, previously disabling them when
trying to grab a refcount.  We do not need shake_page to take care of it
anymore.

Link: https://lkml.kernel.org/r/20201204102558.31607-4-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Qian Cai <qcai@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-remove-drain_all_pages-from-shake_page
+++ a/mm/memory-failure.c
@@ -263,8 +263,8 @@ static int kill_proc(struct to_kill *tk,
 }
 
 /*
- * When a unknown page type is encountered drain as many buffers as possible
- * in the hope to turn the page into a LRU or free page, which we can handle.
+ * Unknown page type encountered. Try to check whether it can turn PageLRU by
+ * lru_add_drain_all, or a free page by reclaiming slabs when possible.
  */
 void shake_page(struct page *p, int access)
 {
@@ -273,9 +273,6 @@ void shake_page(struct page *p, int acce
 
 	if (!PageSlab(p)) {
 		lru_add_drain_all();
-		if (PageLRU(p))
-			return;
-		drain_all_pages(page_zone(p));
 		if (PageLRU(p) || is_free_buddy_page(p))
 			return;
 	}
_

Patches currently in -mm which might be from osalvador@suse.de are



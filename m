Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB2FC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B15F223E0
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgLODPQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:15:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:36830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727558AbgLODMy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:54 -0500
Date:   Mon, 14 Dec 2020 19:11:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001906;
        bh=3RFDvv86usBIA4vkJx/E9cHf2f4ncmK3DX1az5cUfQc=;
        h=From:To:Subject:In-Reply-To:From;
        b=Tw7gNzqGi72nbqXA2KZ65M79sowsJEMh6mB90IlfrrpFlTCvb/QX5bKJy0egm066i
         p7q5w6b+naYkAU/wiUbybDpjO/Frhn0rKuAz6gwJjYMD+x9jWmRVwYgG9bjeqxPiaU
         wvJY/ZUtni4C8nP5BUEtATsWZwQ19JhCnwRVVEOU=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, qcai@redhat.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 143/200] mm,hwpoison: remove drain_all_pages from
 shake_page
Message-ID: <20201215031145.gnGYH2Pe3%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

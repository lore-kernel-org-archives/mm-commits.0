Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C845C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 061CD64F28
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234840AbhBYTfB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:35:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:41316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235052AbhBYTc7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:32:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B599864FAA;
        Thu, 25 Feb 2021 19:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280681;
        bh=yCvfYPvOb63OVeDUO6Q3CAL+0JZz5i5SFbD7m0+jYrg=;
        h=Date:From:To:Subject:From;
        b=q0GPybuoxnZHl+p2tahUKPUZ2z9GW6zD4wJn+zdSUpftqiPAY7DGjxhDVDTgXjKz6
         pwS881NmyX/MltjZqAR3rmJKiK1TAf/8Zm84lSv+mvT2f2sxfOuQrZsqVPAp/AMxvv
         HxMlrNc7JvUIAcnYdPlBsXMuKvSrzLVy8GjFxJ5o=
Date:   Thu, 25 Feb 2021 11:18:00 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, guro@fb.com, hannes@cmpxchg.org,
        hughd@google.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, willy@infradead.org,
        yuzhao@google.com
Subject:  [merged]
 mm-fold-page_lru_base_type-into-its-sole-caller.patch removed from -mm tree
Message-ID: <20210225191800.gyMCLHDMv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mm_inline.h: fold page_lru_base_type() into its sole caller
has been removed from the -mm tree.  Its filename was
     mm-fold-page_lru_base_type-into-its-sole-caller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: include/linux/mm_inline.h: fold page_lru_base_type() into its sole caller

We've removed all other references to this function.

Link: https://lore.kernel.org/linux-mm/20201207220949.830352-9-yuzhao@google.com/
Link: https://lkml.kernel.org/r/20210122220600.906146-9-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

--- a/include/linux/mm_inline.h~mm-fold-page_lru_base_type-into-its-sole-caller
+++ a/include/linux/mm_inline.h
@@ -46,21 +46,6 @@ static __always_inline void update_lru_s
 }
 
 /**
- * page_lru_base_type - which LRU list type should a page be on?
- * @page: the page to test
- *
- * Used for LRU list index arithmetic.
- *
- * Returns the base LRU type - file or anon - @page should be on.
- */
-static inline enum lru_list page_lru_base_type(struct page *page)
-{
-	if (page_is_file_lru(page))
-		return LRU_INACTIVE_FILE;
-	return LRU_INACTIVE_ANON;
-}
-
-/**
  * __clear_page_lru_flags - clear page lru flags before releasing a page
  * @page: the page that was on lru and now has a zero reference
  */
@@ -92,12 +77,12 @@ static __always_inline enum lru_list pag
 	VM_BUG_ON_PAGE(PageActive(page) && PageUnevictable(page), page);
 
 	if (PageUnevictable(page))
-		lru = LRU_UNEVICTABLE;
-	else {
-		lru = page_lru_base_type(page);
-		if (PageActive(page))
-			lru += LRU_ACTIVE;
-	}
+		return LRU_UNEVICTABLE;
+
+	lru = page_is_file_lru(page) ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON;
+	if (PageActive(page))
+		lru += LRU_ACTIVE;
+
 	return lru;
 }
 
_

Patches currently in -mm which might be from yuzhao@google.com are



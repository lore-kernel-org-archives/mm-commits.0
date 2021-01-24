Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD22C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80D7322BE8
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbhAXBX1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:23:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbhAXBXW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:23:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6689B22D50;
        Sun, 24 Jan 2021 01:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611451335;
        bh=ApLqW2+BEhy+79enKAbW5aVEyisqQ0QyQSGISOtOj3k=;
        h=Date:From:To:Subject:From;
        b=uGXFYs3q3ZXK9HYDNDVrtx3NpAsRKAOqWuUYuu1PvEM3n3JuHI6qGid2YghkKmeTw
         6uDB2Sc3GMLYkHLdmRbA0ZlQQmKJoXDCsGyDctt+AINOQ/Ffetr6VcrDNv+zjMM3yg
         CrXlUfcSDpY4Md7Xn8F3bpb+0ASbcJa2KxxZuwNg=
Date:   Sat, 23 Jan 2021 17:22:13 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, guro@fb.com, hannes@cmpxchg.org,
        hughd@google.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, willy@infradead.org,
        yuzhao@google.com
Subject:  + mm-fold-page_lru_base_type-into-its-sole-caller.patch
 added to -mm tree
Message-ID: <20210124012213.bp9LX2g5i%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mm_inline.h: fold page_lru_base_type() into its sole caller
has been added to the -mm tree.  Its filename is
     mm-fold-page_lru_base_type-into-its-sole-caller.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fold-page_lru_base_type-into-its-sole-caller.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fold-page_lru_base_type-into-its-sole-caller.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-swap-dont-setpageworkingset-unconditionally-during-swapin.patch
mm-use-add_page_to_lru_list.patch
mm-shuffle-lru-list-addition-and-deletion-functions.patch
mm-dont-pass-enum-lru_list-to-lru-list-addition-functions.patch
mm-dont-pass-enum-lru_list-to-trace_mm_lru_insertion.patch
mm-dont-pass-enum-lru_list-to-del_page_from_lru_list.patch
mm-add-__clear_page_lru_flags-to-replace-page_off_lru.patch
mm-vm_bug_on-lru-page-flags.patch
mm-fold-page_lru_base_type-into-its-sole-caller.patch
mm-fold-__update_lru_size-into-its-sole-caller.patch
mm-make-lruvec_lru_size-static.patch


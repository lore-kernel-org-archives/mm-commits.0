Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD112C433E6
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A16AD22BEF
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbhAXBXL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:23:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbhAXBXJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:23:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A1A522D49;
        Sun, 24 Jan 2021 01:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611451330;
        bh=BCJZ9TgpKL9B1m1l4rkl9Q1S5esLfsz/ntcQZ/XwZPM=;
        h=Date:From:To:Subject:From;
        b=ayHgxZPe+L52agfxHzqQMG04PCMXMwwkVUNwwwMFgTkVchfWMtMrqPUiVhRtcaLOI
         11m0sR9tzABdwVXyC5oudZBRw4gG6UIsM7KXJH7w3lK8zBG0b3w9HaNvbriOWIInBL
         cVnGxwoN/WWxW3neodW9QarmFLAUE33d+JpbS+Yw=
Date:   Sat, 23 Jan 2021 17:22:09 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, guro@fb.com, hannes@cmpxchg.org,
        hughd@google.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, willy@infradead.org,
        yuzhao@google.com
Subject:  + mm-vm_bug_on-lru-page-flags.patch added to -mm tree
Message-ID: <20210124012209.S1kV6S4FT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: VM_BUG_ON lru page flags
has been added to the -mm tree.  Its filename is
     mm-vm_bug_on-lru-page-flags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vm_bug_on-lru-page-flags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vm_bug_on-lru-page-flags.patch

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
Subject: mm: VM_BUG_ON lru page flags

Move scattered VM_BUG_ONs to two essential places that cover all
lru list additions and deletions.

Link: https://lore.kernel.org/linux-mm/20201207220949.830352-8-yuzhao@google.com/
Link: https://lkml.kernel.org/r/20210122220600.906146-8-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    4 ++++
 mm/swap.c                 |    2 --
 mm/vmscan.c               |    1 -
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/mm_inline.h~mm-vm_bug_on-lru-page-flags
+++ a/include/linux/mm_inline.h
@@ -66,6 +66,8 @@ static inline enum lru_list page_lru_bas
  */
 static __always_inline void __clear_page_lru_flags(struct page *page)
 {
+	VM_BUG_ON_PAGE(!PageLRU(page), page);
+
 	__ClearPageLRU(page);
 
 	/* this shouldn't happen, so leave the flags to bad_page() */
@@ -87,6 +89,8 @@ static __always_inline enum lru_list pag
 {
 	enum lru_list lru;
 
+	VM_BUG_ON_PAGE(PageActive(page) && PageUnevictable(page), page);
+
 	if (PageUnevictable(page))
 		lru = LRU_UNEVICTABLE;
 	else {
--- a/mm/swap.c~mm-vm_bug_on-lru-page-flags
+++ a/mm/swap.c
@@ -83,7 +83,6 @@ static void __page_cache_release(struct
 		unsigned long flags;
 
 		lruvec = lock_page_lruvec_irqsave(page, &flags);
-		VM_BUG_ON_PAGE(!PageLRU(page), page);
 		del_page_from_lru_list(page, lruvec);
 		__clear_page_lru_flags(page);
 		unlock_page_lruvec_irqrestore(lruvec, flags);
@@ -909,7 +908,6 @@ void release_pages(struct page **pages,
 			if (prev_lruvec != lruvec)
 				lock_batch = 0;
 
-			VM_BUG_ON_PAGE(!PageLRU(page), page);
 			del_page_from_lru_list(page, lruvec);
 			__clear_page_lru_flags(page);
 		}
--- a/mm/vmscan.c~mm-vm_bug_on-lru-page-flags
+++ a/mm/vmscan.c
@@ -4281,7 +4281,6 @@ void check_move_unevictable_pages(struct
 
 		lruvec = relock_page_lruvec_irq(page, lruvec);
 		if (page_evictable(page) && PageUnevictable(page)) {
-			VM_BUG_ON_PAGE(PageActive(page), page);
 			del_page_from_lru_list(page, lruvec);
 			ClearPageUnevictable(page);
 			add_page_to_lru_list(page, lruvec);
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


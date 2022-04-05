Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75DF9C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355082AbiDFB4d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573226AbiDES1K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 14:27:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A68525C2
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 11:25:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BA79618BF
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 18:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E658FC385A0;
        Tue,  5 Apr 2022 18:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649183111;
        bh=Di/2dJFRQOaw+Q7I5Qs2jEm3TFbA8MCCp5Bpd9o1+Qs=;
        h=Date:To:From:Subject:From;
        b=jE6V2kBkL0sW4ZUqzXkKizkFRGY7gNXoOThmLB86pLVh32cyt5r3vxncdELhcb6yo
         kq2yUmlwV4nRe6bRJpQgJ2IhL+wnxMGYUk6t/TVJXcE4OqVtAG0zJxi0I8SlBmfb9M
         Ucf9+nJsKF2vRKgIbHt7U7Y2qMQODNVSO5YfsjzM=
Date:   Tue, 05 Apr 2022 11:25:10 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, rppt@kernel.org,
        rostedt@goodmis.org, osalvador@suse.de,
        mgorman@techsingularity.net, david@redhat.com, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation-v4.patch added to -mm tree
Message-Id: <20220405182510.E658FC385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation-v4
has been added to the -mm tree.  Its filename is
     mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation-v4.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation-v4.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation-v4

updates per David

Link: https://lkml.kernel.org/r/20220401230804.1658207-2-zi.yan@sent.com
Link: https://lore.kernel.org/linux-mm/CAHk-=3Dwji_AmYygZMTsPMdJ7XksMt7kO=
ur8oDfDdniBRMjm4VkQ@mail.gmail.com/
Link: https://lkml.kernel.org/r/7236E7CA-B5F1-4C04-AB85-E86FA3E9A54B@nvidia.com
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    4 ++--
 mm/page_alloc.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/internal.h~mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation-v4
+++ a/mm/internal.h
@@ -252,7 +252,7 @@ static inline unsigned int buddy_order(s
  * For recording page's order, we use page_private(page).
  */
 static inline bool page_is_buddy(struct page *page, struct page *buddy,
-							unsigned int order)
+				 unsigned int order)
 {
 	if (!page_is_guard(buddy) && !PageBuddy(buddy))
 		return false;
@@ -312,8 +312,8 @@ __find_buddy_pfn(unsigned long page_pfn,
 static inline struct page *find_buddy_page_pfn(struct page *page,
 			unsigned long pfn, unsigned int order, unsigned long *buddy_pfn)
 {
-	struct page *buddy;
 	unsigned long __buddy_pfn = __find_buddy_pfn(pfn, order);
+	struct page *buddy;
 
 	buddy = page + (__buddy_pfn - pfn);
 	if (buddy_pfn)
--- a/mm/page_alloc.c~mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation-v4
+++ a/mm/page_alloc.c
@@ -976,8 +976,8 @@ static inline bool
 buddy_merge_likely(unsigned long pfn, unsigned long buddy_pfn,
 		   struct page *page, unsigned int order)
 {
-	struct page *higher_page;
 	unsigned long higher_page_pfn;
+	struct page *higher_page;
 
 	if (order >= MAX_ORDER - 2)
 		return false;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-migrate-use-thp_order-instead-of-hpage_pmd_order-for-new-page-allocation.patch
mm-page_alloc-simplify-pageblock-migratetype-check-in-__free_one_page.patch
mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation.patch
mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation-v4.patch


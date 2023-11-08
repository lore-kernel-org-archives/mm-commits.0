Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88394C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  8 Nov 2023 21:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjKHVo4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Nov 2023 16:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjKHVo4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Nov 2023 16:44:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE442586
        for <mm-commits@vger.kernel.org>; Wed,  8 Nov 2023 13:44:54 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7342CC433C8;
        Wed,  8 Nov 2023 21:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699479893;
        bh=fOGxChVR/bSghbCDPX6FHIg7ncfcw9p6VtegVM6DH+I=;
        h=Date:To:From:Subject:From;
        b=vTW5b7+UfdZcdf91BF3Gcb6HYbC95dU5ZKbBtclW5b5zrV7A/uX29UFq1MjXSA/Nx
         kCAcA7pFbWAixoQ4B6LikKRO/IJAUmC4CFxpXMENhOEjYCj/6GrkGOHfQ0Yz33CaiH
         RSlxyz6/02P/4rWZul/zGzJ4NObedKSeMr2JfBeI=
Date:   Wed, 08 Nov 2023 13:44:52 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        jackmanb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-dedupe-some-memcg-uncharging-logic.patch added to mm-unstable branch
Message-Id: <20231108214453.7342CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: dedupe some memcg uncharging logic
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-dedupe-some-memcg-uncharging-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-dedupe-some-memcg-uncharging-logic.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: dedupe some memcg uncharging logic
Date: Wed, 8 Nov 2023 16:49:20 +0000

The duplication makes it seem like some work is required before uncharging
in the !PageHWPoison case.  But it isn't, so we can simplify the code a
little.

Note the PageMemcgKmem check is redundant, but I've left it in as it
avoids an unnecessary function call.

Link: https://lkml.kernel.org/r/20231108164920.3401565-1-jackmanb@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-dedupe-some-memcg-uncharging-logic
+++ a/mm/page_alloc.c
@@ -1086,13 +1086,11 @@ static __always_inline bool free_pages_p
 	trace_mm_page_free(page, order);
 	kmsan_free_page(page, order);
 
+	if (memcg_kmem_online() && PageMemcgKmem(page))
+		__memcg_kmem_uncharge_page(page, order);
+
 	if (unlikely(PageHWPoison(page)) && !order) {
-		/*
-		 * Do not let hwpoison pages hit pcplists/buddy
-		 * Untie memcg state and reset page's owner
-		 */
-		if (memcg_kmem_online() && PageMemcgKmem(page))
-			__memcg_kmem_uncharge_page(page, order);
+		/* Do not let hwpoison pages hit pcplists/buddy */
 		reset_page_owner(page, order);
 		page_table_check_free(page, order);
 		return false;
@@ -1123,8 +1121,6 @@ static __always_inline bool free_pages_p
 	}
 	if (PageMappingFlags(page))
 		page->mapping = NULL;
-	if (memcg_kmem_online() && PageMemcgKmem(page))
-		__memcg_kmem_uncharge_page(page, order);
 	if (is_check_pages_enabled()) {
 		if (free_page_is_bad(page))
 			bad++;
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-dedupe-some-memcg-uncharging-logic.patch


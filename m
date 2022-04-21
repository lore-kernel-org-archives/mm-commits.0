Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA7EC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 21:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387065AbiDUVgk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 17:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiDUVgk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 17:36:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7411C49FA2
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 14:33:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D15C7CE268D
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 21:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07715C385AA;
        Thu, 21 Apr 2022 21:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650576826;
        bh=chYBLQGyoSkWy7KUq7UqEgStVE+n5CEeV75NpxrqEdY=;
        h=Date:To:From:Subject:From;
        b=t8p0VJnZX24OVEXoHnMXBtVRm9O7pCuxjkrpRY6yFKZm/4GIoSQBD3U/+Trpu9f9W
         CvxpiT9wXTdYBxK+kycC0jsOH246wCJnsHrlTZDUfsaDrLSMjZlbcVtlHhTChPHjHZ
         fChh/G5BBWbMr5xiSQuoHtC092NVlaP5ltVaJtLw=
Date:   Thu, 21 Apr 2022 14:33:45 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sfr@canb.auug.org.au, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-munlock-remove-fields-to-fix-htmldocs-warnings.patch removed from -mm tree
Message-Id: <20220421213346.07715C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/munlock: remove fields to fix htmldocs warnings
has been removed from the -mm tree.  Its filename was
     mm-munlock-remove-fields-to-fix-htmldocs-warnings.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/munlock: remove fields to fix htmldocs warnings

Stephen reports that 'make htmldocs' currently issues two warnings:

include/linux/mm_types.h:275: warning: Function parameter or member
'__filler' not described in 'folio'
include/linux/mm_types.h:275: warning: Function parameter or member
'mlock_count' not described in 'folio'

Certainly __filler doesn't want documenting there, and all but one use of
mlock_count is through page->mlock_count at present: so I think it's best
just to remove them both from struct folio for now, and sort out the right
way to document folio->mlock_count once that is the one true way.

Link: https://lkml.kernel.org/r/d2c8f66d-be8e-7c91-b0c8-b2f7ffb08bec@google.com
Fixes: 07ca76067308 ("mm/munlock: maintain page->mlock_count while unevictable")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    8 +-------
 mm/swap.c                |    4 ++--
 2 files changed, 3 insertions(+), 9 deletions(-)

--- a/include/linux/mm_types.h~mm-munlock-remove-fields-to-fix-htmldocs-warnings
+++ a/include/linux/mm_types.h
@@ -253,13 +253,7 @@ struct folio {
 		struct {
 	/* public: */
 			unsigned long flags;
-			union {
-				struct list_head lru;
-				struct {
-					void *__filler;
-					unsigned int mlock_count;
-				};
-			};
+			struct list_head lru;
 			struct address_space *mapping;
 			pgoff_t index;
 			void *private;
--- a/mm/swap.c~mm-munlock-remove-fields-to-fix-htmldocs-warnings
+++ a/mm/swap.c
@@ -1028,13 +1028,13 @@ static void __pagevec_lru_add_fn(struct
 		folio_clear_active(folio);
 		folio_set_unevictable(folio);
 		/*
-		 * folio->mlock_count = !!folio_test_mlocked(folio)?
+		 * page->mlock_count = !!PageMlocked(page)?
 		 * But that leaves __mlock_page() in doubt whether another
 		 * actor has already counted the mlock or not.  Err on the
 		 * safe side, underestimate, let page reclaim fix it, rather
 		 * than leaving a page on the unevictable LRU indefinitely.
 		 */
-		folio->mlock_count = 0;
+		folio_page(folio, 0)->mlock_count = 0;
 		if (!was_unevictable)
 			__count_vm_events(UNEVICTABLE_PGCULLED, nr_pages);
 	}
_

Patches currently in -mm which might be from hughd@google.com are



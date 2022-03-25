Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82386C4321E
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbiCYWn6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiCYWnZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E29208C20
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF0BB614BD
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567B5C36AE2;
        Fri, 25 Mar 2022 22:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248109;
        bh=kkucyzKtTOfe7FH0x7ydWAMHiePiBH+2aYyKAaQ61mw=;
        h=Date:To:From:Subject:From;
        b=euwDRYzTLjnpcoFgWs+II93hTczmUG2sx8tUbuyvANe3oOo5j0CwBQWe623D7XTsL
         10kvtALMEc1yatL/G3yD+ycxQufWFuUCRC5JoEfQ/gszaPETjKa6hoPABvAo09ts2l
         nA7DcxYEzqlQLBdRTY5GekdPY4B+kV1LGL9SzOUY=
Date:   Fri, 25 Mar 2022 15:41:48 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        shy828301@gmail.com, npiggin@gmail.com, mhocko@suse.com,
        david@redhat.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-delete-__clearpagewaiters.patch removed from -mm tree
Message-Id: <20220325224149.567B5C36AE2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: delete __ClearPageWaiters()
has been removed from the -mm tree.  Its filename was
     mm-delete-__clearpagewaiters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: delete __ClearPageWaiters()

The PG_waiters bit is not included in PAGE_FLAGS_CHECK_AT_FREE, and
vmscan.c's free_unref_page_list() callers rely on that not to generate
bad_page() alerts.  So __page_cache_release(), put_pages_list() and
release_pages() (and presumably copy-and-pasted free_zone_device_page())
are redundant and misleading to make a special point of clearing it (as
the "__" implies, it could only safely be used on the freeing path).

Delete __ClearPageWaiters().  Remark on this in one of the "possible"
comments in folio_wake_bit(), and delete the superfluous comments.

Link: https://lkml.kernel.org/r/3eafa969-5b1a-accf-88fe-318784c791a@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 mm/filemap.c               |   23 ++++++++---------------
 mm/memremap.c              |    2 --
 mm/swap.c                  |    4 ----
 4 files changed, 9 insertions(+), 22 deletions(-)

--- a/include/linux/page-flags.h~mm-delete-__clearpagewaiters
+++ a/include/linux/page-flags.h
@@ -481,7 +481,7 @@ static inline int TestClearPage##uname(s
 	TESTSETFLAG_FALSE(uname, lname) TESTCLEARFLAG_FALSE(uname, lname)
 
 __PAGEFLAG(Locked, locked, PF_NO_TAIL)
-PAGEFLAG(Waiters, waiters, PF_ONLY_HEAD) __CLEARPAGEFLAG(Waiters, waiters, PF_ONLY_HEAD)
+PAGEFLAG(Waiters, waiters, PF_ONLY_HEAD)
 PAGEFLAG(Error, error, PF_NO_TAIL) TESTCLEARFLAG(Error, error, PF_NO_TAIL)
 PAGEFLAG(Referenced, referenced, PF_HEAD)
 	TESTCLEARFLAG(Referenced, referenced, PF_HEAD)
--- a/mm/filemap.c~mm-delete-__clearpagewaiters
+++ a/mm/filemap.c
@@ -1185,24 +1185,17 @@ static void folio_wake_bit(struct folio
 	}
 
 	/*
-	 * It is possible for other pages to have collided on the waitqueue
-	 * hash, so in that case check for a page match. That prevents a long-
-	 * term waiter
+	 * It's possible to miss clearing waiters here, when we woke our page
+	 * waiters, but the hashed waitqueue has waiters for other pages on it.
+	 * That's okay, it's a rare case. The next waker will clear it.
 	 *
-	 * It is still possible to miss a case here, when we woke page waiters
-	 * and removed them from the waitqueue, but there are still other
-	 * page waiters.
+	 * Note that, depending on the page pool (buddy, hugetlb, ZONE_DEVICE,
+	 * other), the flag may be cleared in the course of freeing the page;
+	 * but that is not required for correctness.
 	 */
-	if (!waitqueue_active(q) || !key.page_match) {
+	if (!waitqueue_active(q) || !key.page_match)
 		folio_clear_waiters(folio);
-		/*
-		 * It's possible to miss clearing Waiters here, when we woke
-		 * our page waiters, but the hashed waitqueue has waiters for
-		 * other pages on it.
-		 *
-		 * That's okay, it's a rare case. The next waker will clear it.
-		 */
-	}
+
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 
--- a/mm/memremap.c~mm-delete-__clearpagewaiters
+++ a/mm/memremap.c
@@ -456,8 +456,6 @@ void free_zone_device_page(struct page *
 	if (WARN_ON_ONCE(!page->pgmap->ops || !page->pgmap->ops->page_free))
 		return;
 
-	__ClearPageWaiters(page);
-
 	mem_cgroup_uncharge(page_folio(page));
 
 	/*
--- a/mm/swap.c~mm-delete-__clearpagewaiters
+++ a/mm/swap.c
@@ -97,7 +97,6 @@ static void __page_cache_release(struct
 		mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
 		count_vm_events(UNEVICTABLE_PGCLEARED, nr_pages);
 	}
-	__ClearPageWaiters(page);
 }
 
 static void __put_single_page(struct page *page)
@@ -152,7 +151,6 @@ void put_pages_list(struct list_head *pa
 			continue;
 		}
 		/* Cannot be PageLRU because it's passed to us using the lru */
-		__ClearPageWaiters(page);
 	}
 
 	free_unref_page_list(pages);
@@ -971,8 +969,6 @@ void release_pages(struct page **pages,
 			count_vm_event(UNEVICTABLE_PGCLEARED);
 		}
 
-		__ClearPageWaiters(page);
-
 		list_add(&page->lru, &pages_to_free);
 	}
 	if (lruvec)
_

Patches currently in -mm which might be from hughd@google.com are



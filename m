Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE39C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237462AbiCYBLd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357146AbiCYBL0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:11:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFABA62A3F
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:09:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A07ADB82708
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8DDC340ED;
        Fri, 25 Mar 2022 01:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170590;
        bh=EEBzXX9FqejaMH4HLz4mbN6zJ46CBwBkgiWCFAKq4r4=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=Mjz8eu+amio4lsxBq2Ni0P1xfkdb0jjua+i8/eEHmJ6GoiVmHS5gD01Vmku2NsH22
         OEAsl30nPWYGuB0xJJKwjWGEiMMxxTyWH3PRyIp2F54aoVUXvevBf5XPPKwlM1j40D
         EalQJWs/tkoLYEolU7ufRfszNgW416DUYWSntnjs=
Date:   Thu, 24 Mar 2022 18:09:49 -0700
To:     yuzhao@google.com, willy@infradead.org, shy828301@gmail.com,
        npiggin@gmail.com, mhocko@suse.com, david@redhat.com,
        hughd@google.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 025/114] mm: delete __ClearPageWaiters()
Message-Id: <20220325010950.3E8DDC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

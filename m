Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C78AC433FE
	for <mm-commits@archiver.kernel.org>; Sun,  6 Mar 2022 23:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbiCFXwR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 18:52:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbiCFXwP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 18:52:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC18346B21
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 15:51:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74164B80F9A
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 23:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206F0C340EF;
        Sun,  6 Mar 2022 23:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646610679;
        bh=fTdbdyhbF3w3mncUUBtskrGkyq5MCle8Vw9rCsbCoTY=;
        h=Date:To:From:Subject:From;
        b=EQk3O4SQwVlmhRPdSsv0+UE17peep6fXbovi2AQVtSDsjvFV9cVEz1Fr4k9HYFLX6
         N1YW59bbLgvSHBnvbQfj1n8lShN1EApamxY1E7+DjoknGcaMXNxS7xcPpVZWY0JMNl
         D1sL/kFE/MV1XzG+cCrTef9tTW5yY35pDshUglHk=
Date:   Sun, 06 Mar 2022 15:51:18 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        shy828301@gmail.com, npiggin@gmail.com, mhocko@suse.com,
        david@redhat.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-delete-__clearpagewaiters.patch added to -mm tree
Message-Id: <20220306235119.206F0C340EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: delete __ClearPageWaiters()
has been added to the -mm tree.  Its filename is
     mm-delete-__clearpagewaiters.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-delete-__clearpagewaiters.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-delete-__clearpagewaiters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Yang Shi <shy828301@gmail.com>
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
@@ -412,7 +412,7 @@ static inline int TestClearPage##uname(s
 	TESTSETFLAG_FALSE(uname, lname) TESTCLEARFLAG_FALSE(uname, lname)
 
 __PAGEFLAG(Locked, locked, PF_NO_TAIL)
-PAGEFLAG(Waiters, waiters, PF_ONLY_HEAD) __CLEARPAGEFLAG(Waiters, waiters, PF_ONLY_HEAD)
+PAGEFLAG(Waiters, waiters, PF_ONLY_HEAD)
 PAGEFLAG(Error, error, PF_NO_TAIL) TESTCLEARFLAG(Error, error, PF_NO_TAIL)
 PAGEFLAG(Referenced, referenced, PF_HEAD)
 	TESTCLEARFLAG(Referenced, referenced, PF_HEAD)
--- a/mm/filemap.c~mm-delete-__clearpagewaiters
+++ a/mm/filemap.c
@@ -1174,24 +1174,17 @@ static void folio_wake_bit(struct folio
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
@@ -495,8 +495,6 @@ void free_devmap_managed_page(struct pag
 		return;
 	}
 
-	__ClearPageWaiters(page);
-
 	mem_cgroup_uncharge(page_folio(page));
 
 	/*
--- a/mm/swap.c~mm-delete-__clearpagewaiters
+++ a/mm/swap.c
@@ -89,7 +89,6 @@ static void __page_cache_release(struct
 		__clear_page_lru_flags(page);
 		unlock_page_lruvec_irqrestore(lruvec, flags);
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
@@ -969,8 +967,6 @@ void release_pages(struct page **pages,
 			__clear_page_lru_flags(page);
 		}
 
-		__ClearPageWaiters(page);
-
 		list_add(&page->lru, &pages_to_free);
 	}
 	if (lruvec)
_

Patches currently in -mm which might be from hughd@google.com are

mm-delete-__clearpagewaiters.patch
tmpfs-support-for-file-creation-time-fix.patch
mm-_install_special_mapping-apply-vm_locked_clear_mask.patch
mm-thp-refix-__split_huge_pmd_locked-for-migration-pmd.patch
mm-thp-clearpagedoublemap-in-first-page_add_file_rmap.patch
mm-thp-fix-nr_file_mapped-accounting-in-page__file_rmap.patch


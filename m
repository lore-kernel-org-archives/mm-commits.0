Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0985EC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbjFIXdf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbjFIXc2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4AD49C7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B057560D2C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FBCC433D2;
        Fri,  9 Jun 2023 23:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353395;
        bh=RmULitMMKAL/K7BsPxihLEFo15HZf26FaQtY5VR3wME=;
        h=Date:To:From:Subject:From;
        b=PAg7KdQnJGkl5uJuQNMTvNRWTxXJqKyzPRPD1H9ZDgzbnZO0HJs/W4zyHrGoJfmiG
         mwqg8m1ILtPaqtenvzCKnWsGJTpar7RTwi9r36d8wF8QJ3ieU2/UG8+t2w694VJhzw
         UUuTs0MW/Yn8JaEnxdBjpWUpoYUqazPYoQ4WwJsM=
Date:   Fri, 09 Jun 2023 16:29:54 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        yosryahmed@google.com, willy@infradead.org,
        tim.c.chen@linux.intel.com, shy828301@gmail.com,
        minchan@kernel.org, mhocko@suse.com, hughd@google.com,
        hannes@cmpxchg.org, david@redhat.com, chrisl@kernel.org,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swap-remove-__swp_swapcount.patch removed from -mm tree
Message-Id: <20230609232955.14FBCC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap: remove __swp_swapcount()
has been removed from the -mm tree.  Its filename was
     swap-remove-__swp_swapcount.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: swap: remove __swp_swapcount()
Date: Mon, 29 May 2023 14:13:53 +0800

__swp_swapcount() just encloses the calling to swap_swapcount() with
get/put_swap_device().  It is called in __read_swap_cache_async() only,
which encloses the calling with get/put_swap_device() already.  So,
__read_swap_cache_async() can call swap_swapcount() directly.

Link: https://lkml.kernel.org/r/20230529061355.125791-4-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Chris Li (Google) <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++--
 mm/swap_state.c      |    2 +-
 mm/swapfile.c        |   20 +-------------------
 3 files changed, 4 insertions(+), 22 deletions(-)

--- a/include/linux/swap.h~swap-remove-__swp_swapcount
+++ a/include/linux/swap.h
@@ -513,7 +513,7 @@ int find_first_swap(dev_t *device);
 extern unsigned int count_swap_pages(int, int);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int __swap_count(swp_entry_t entry);
-extern int __swp_swapcount(swp_entry_t entry);
+extern int swap_swapcount(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *page_swap_info(struct page *);
 extern struct swap_info_struct *swp_swap_info(swp_entry_t entry);
@@ -591,7 +591,7 @@ static inline int __swap_count(swp_entry
 	return 0;
 }
 
-static inline int __swp_swapcount(swp_entry_t entry)
+static inline int swap_swapcount(struct swap_info_struct *si, swp_entry_t entry)
 {
 	return 0;
 }
--- a/mm/swapfile.c~swap-remove-__swp_swapcount
+++ a/mm/swapfile.c
@@ -1444,7 +1444,7 @@ int __swap_count(swp_entry_t entry)
  * This does not give an exact answer when swap count is continued,
  * but does include the high COUNT_CONTINUED flag to allow for that.
  */
-static int swap_swapcount(struct swap_info_struct *si, swp_entry_t entry)
+int swap_swapcount(struct swap_info_struct *si, swp_entry_t entry)
 {
 	pgoff_t offset = swp_offset(entry);
 	struct swap_cluster_info *ci;
@@ -1456,24 +1456,6 @@ static int swap_swapcount(struct swap_in
 	return count;
 }
 
-/*
- * How many references to @entry are currently swapped out?
- * This does not give an exact answer when swap count is continued,
- * but does include the high COUNT_CONTINUED flag to allow for that.
- */
-int __swp_swapcount(swp_entry_t entry)
-{
-	int count = 0;
-	struct swap_info_struct *si;
-
-	si = get_swap_device(entry);
-	if (si) {
-		count = swap_swapcount(si, entry);
-		put_swap_device(si);
-	}
-	return count;
-}
-
 /*
  * How many references to @entry are currently swapped out?
  * This considers COUNT_CONTINUED so it returns exact answer.
--- a/mm/swap_state.c~swap-remove-__swp_swapcount
+++ a/mm/swap_state.c
@@ -447,7 +447,7 @@ struct page *__read_swap_cache_async(swp
 		 * as SWAP_HAS_CACHE.  That's done in later part of code or
 		 * else swap_off will be aborted if we return NULL.
 		 */
-		if (!__swp_swapcount(entry) && swap_slot_cache_enabled)
+		if (!swap_swapcount(si, entry) && swap_slot_cache_enabled)
 			goto fail_put_swap;
 
 		/*
_

Patches currently in -mm which might be from ying.huang@intel.com are



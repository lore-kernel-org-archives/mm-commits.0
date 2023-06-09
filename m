Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53799C83005
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbjFIXdd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbjFIXc2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B333AAC
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92C2D63E4A
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EECC433D2;
        Fri,  9 Jun 2023 23:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353394;
        bh=xrs/Fu3ysj5KFwcDtmNBp7Xvh9FL7V8XEUIZRvPjt2E=;
        h=Date:To:From:Subject:From;
        b=ezhSr3vQPk8iiaObFm+1F0QudGdczP9tQ7MESFgLjdQrv4t8IrdDB9KaWOPo2x3QV
         8RBHrajcb7E4dWY7Eio1sb/w4MHAzciaYAe9nDZxHCMeJP6M9W+LAiCbLhA6nv3A8/
         Dp7uqNFDhFVUvOthsKnW8Hn23UdGUU7fXOgM3faY=
Date:   Fri, 09 Jun 2023 16:29:53 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        yosryahmed@google.com, willy@infradead.org,
        tim.c.chen@linux.intel.com, shy828301@gmail.com,
        minchan@kernel.org, mhocko@suse.com, hughd@google.com,
        hannes@cmpxchg.org, david@redhat.com, chrisl@kernel.org,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swap-__read_swap_cache_async-enlarge-get-put_swap_device-protection-range.patch removed from -mm tree
Message-Id: <20230609232953.E3EECC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap, __read_swap_cache_async(): enlarge get/put_swap_device protection range
has been removed from the -mm tree.  Its filename was
     swap-__read_swap_cache_async-enlarge-get-put_swap_device-protection-range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: swap, __read_swap_cache_async(): enlarge get/put_swap_device protection range
Date: Mon, 29 May 2023 14:13:52 +0800

This makes the function a little easier to be understood because we don't
need to consider swapoff.  And this makes it possible to remove
get/put_swap_device() calling in some functions called by
__read_swap_cache_async().

Link: https://lkml.kernel.org/r/20230529061355.125791-3-ying.huang@intel.com
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

 mm/swap_state.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

--- a/mm/swap_state.c~swap-__read_swap_cache_async-enlarge-get-put_swap_device-protection-range
+++ a/mm/swap_state.c
@@ -417,9 +417,13 @@ struct page *__read_swap_cache_async(swp
 {
 	struct swap_info_struct *si;
 	struct folio *folio;
+	struct page *page;
 	void *shadow = NULL;
 
 	*new_page_allocated = false;
+	si = get_swap_device(entry);
+	if (!si)
+		return NULL;
 
 	for (;;) {
 		int err;
@@ -428,14 +432,12 @@ struct page *__read_swap_cache_async(swp
 		 * called after swap_cache_get_folio() failed, re-calling
 		 * that would confuse statistics.
 		 */
-		si = get_swap_device(entry);
-		if (!si)
-			return NULL;
 		folio = filemap_get_folio(swap_address_space(entry),
 						swp_offset(entry));
-		put_swap_device(si);
-		if (!IS_ERR(folio))
-			return folio_file_page(folio, swp_offset(entry));
+		if (!IS_ERR(folio)) {
+			page = folio_file_page(folio, swp_offset(entry));
+			goto got_page;
+		}
 
 		/*
 		 * Just skip read ahead for unused swap slot.
@@ -446,7 +448,7 @@ struct page *__read_swap_cache_async(swp
 		 * else swap_off will be aborted if we return NULL.
 		 */
 		if (!__swp_swapcount(entry) && swap_slot_cache_enabled)
-			return NULL;
+			goto fail_put_swap;
 
 		/*
 		 * Get a new page to read into from swap.  Allocate it now,
@@ -455,7 +457,7 @@ struct page *__read_swap_cache_async(swp
 		 */
 		folio = vma_alloc_folio(gfp_mask, 0, vma, addr, false);
 		if (!folio)
-			return NULL;
+                        goto fail_put_swap;
 
 		/*
 		 * Swap entry may have been freed since our caller observed it.
@@ -466,7 +468,7 @@ struct page *__read_swap_cache_async(swp
 
 		folio_put(folio);
 		if (err != -EEXIST)
-			return NULL;
+			goto fail_put_swap;
 
 		/*
 		 * We might race against __delete_from_swap_cache(), and
@@ -500,12 +502,17 @@ struct page *__read_swap_cache_async(swp
 	/* Caller will initiate read into locked folio */
 	folio_add_lru(folio);
 	*new_page_allocated = true;
-	return &folio->page;
+	page = &folio->page;
+got_page:
+	put_swap_device(si);
+	return page;
 
 fail_unlock:
 	put_swap_folio(folio, entry);
 	folio_unlock(folio);
 	folio_put(folio);
+fail_put_swap:
+	put_swap_device(si);
 	return NULL;
 }
 
@@ -514,6 +521,10 @@ fail_unlock:
  * and reading the disk if it is not already cached.
  * A failure return means that either the page allocation failed or that
  * the swap entry is no longer in use.
+ *
+ * get/put_swap_device() aren't needed to call this function, because
+ * __read_swap_cache_async() call them and swap_readpage() holds the
+ * swap cache folio lock.
  */
 struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 				   struct vm_area_struct *vma,
_

Patches currently in -mm which might be from ying.huang@intel.com are



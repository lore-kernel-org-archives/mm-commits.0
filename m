Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F3C4C77B73
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 20:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjE3UvW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 16:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjE3UvU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 16:51:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FD911D
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 13:51:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C58A160F08
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 20:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6ABC433D2;
        Tue, 30 May 2023 20:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685479862;
        bh=BHxeZu4RSRXKeyDS470jAj3/QBpFq45EqKwvXQVT0x4=;
        h=Date:To:From:Subject:From;
        b=AwAa+oRKSqOlz30Svmz+ZWyG0wfGcxZbJI9Xm5nntD3L4KXef7881dSbJRgxMkCuN
         DnMxaBMD540ME6zoyLM/m2z6nhie68z8y6LLdjyxA5uP2HbqKSZ3SF4idWBPMdBr32
         O0z8xOQdkFXFobMkswlndoN339mPuvRoJAwtVcRU=
Date:   Tue, 30 May 2023 13:51:01 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        yosryahmed@google.com, willy@infradead.org,
        tim.c.chen@linux.intel.com, shy828301@gmail.com,
        minchan@kernel.org, mhocko@suse.com, hughd@google.com,
        hannes@cmpxchg.org, david@redhat.com, chrisl@kernel.org,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + swap-__read_swap_cache_async-enlarge-get-put_swap_device-protection-range.patch added to mm-unstable branch
Message-Id: <20230530205102.1F6ABC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap, __read_swap_cache_async(): enlarge get/put_swap_device protection range
has been added to the -mm mm-unstable branch.  Its filename is
     swap-__read_swap_cache_async-enlarge-get-put_swap_device-protection-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/swap-__read_swap_cache_async-enlarge-get-put_swap_device-protection-range.patch

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
From: Huang Ying <ying.huang@intel.com>
Subject: swap, __read_swap_cache_async(): enlarge get/put_swap_device protection range
Date: Mon, 29 May 2023 14:13:52 +0800

This makes the function a little easier to be understood because we don't
need to consider swapoff.  And this makes it possible to remove
get/put_swap_device() calling in some functions called by
__read_swap_cache_async().

Link: https://lkml.kernel.org/r/20230529061355.125791-3-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Chris Li <chrisl@kernel.org>
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

migrate_pages_batch-simplify-retrying-and-failure-counting-of-large-folios.patch
swap-remove-get-put_swap_device-in-__swap_count.patch
swap-__read_swap_cache_async-enlarge-get-put_swap_device-protection-range.patch
swap-remove-__swp_swapcount.patch
swap-remove-get-put_swap_device-in-__swap_duplicate.patch
swap-comments-get_swap_device-with-usage-rule.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB0CC6FA8F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbjHXXVo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237176AbjHXXVG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1B9A1
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E0A1646AB
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF3FC433C7;
        Thu, 24 Aug 2023 23:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919262;
        bh=OSH2QDT92aJWDEHMptoZKt7GkWs/ZRacTgP2cjiTWuk=;
        h=Date:To:From:Subject:From;
        b=szgtkE4tksYxaMhXsudoP81vp+QZatRChHDwtz925PZrFZxE9ykxix1UYTtSLrVOj
         xxcNOM64K22u4spxO/Le/WWsdq9G3jBsMwSJF76RT50C9friLKxndCHsLLRHaznYtO
         l52omj8nowgdfET5k5F4GST4ck1sRHJ7Ten/02p4=
Date:   Thu, 24 Aug 2023 16:21:01 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, viro@zeniv.linux.org.uk,
        vbabka@suse.cz, punit.agrawal@bytedance.com, peterx@redhat.com,
        pasha.tatashin@soleen.com, minchan@google.com,
        michel@lespinasse.org, mhocko@suse.com, lstoakes@gmail.com,
        Liam.Howlett@oracle.com, ldufour@linux.ibm.com,
        josef@toxicpanda.com, jack@suse.cz, hughd@google.com,
        hdanton@sina.com, hch@lst.de, hannes@cmpxchg.org,
        dhowells@redhat.com, david@redhat.com, dave@stgolabs.net,
        brauner@kernel.org, apopple@nvidia.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swap-remove-remnants-of-polling-from-read_swap_cache_async.patch removed from -mm tree
Message-Id: <20230824232102.6DF3FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap: remove remnants of polling from read_swap_cache_async
has been removed from the -mm tree.  Its filename was
     swap-remove-remnants-of-polling-from-read_swap_cache_async.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: swap: remove remnants of polling from read_swap_cache_async
Date: Fri, 30 Jun 2023 14:19:52 -0700

Patch series "Per-VMA lock support for swap and userfaults", v7.

When per-VMA locks were introduced in [1] several types of page faults
would still fall back to mmap_lock to keep the patchset simple.  Among
them are swap and userfault pages.  The main reason for skipping those
cases was the fact that mmap_lock could be dropped while handling these
faults and that required additional logic to be implemented.  Implement
the mechanism to allow per-VMA locks to be dropped for these cases.

First, change handle_mm_fault to drop per-VMA locks when returning
VM_FAULT_RETRY or VM_FAULT_COMPLETED to be consistent with the way
mmap_lock is handled.  Then change folio_lock_or_retry to accept vm_fault
and return vm_fault_t which simplifies later patches.  Finally allow swap
and uffd page faults to be handled under per-VMA locks by dropping per-VMA
and retrying, the same way it's done under mmap_lock.  Naturally, once VMA
lock is dropped that VMA should be assumed unstable and can't be used.


This patch (of 6):

Commit [1] introduced IO polling support duding swapin to reduce swap read
latency for block devices that can be polled.  However later commit [2]
removed polling support.  Therefore it seems safe to remove do_poll
parameter in read_swap_cache_async and always call swap_readpage with
synchronous=false waiting for IO completion in folio_lock_or_retry.

[1] commit 23955622ff8d ("swap: add block io poll in swapin path")
[2] commit 9650b453a3d4 ("block: ignore RWF_HIPRI hint for sync dio")

Link: https://lkml.kernel.org/r/20230630211957.1341547-1-surenb@google.com
Link: https://lkml.kernel.org/r/20230630211957.1341547-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Minchan Kim <minchan@google.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c    |    4 ++--
 mm/swap.h       |    1 -
 mm/swap_state.c |   12 +++++-------
 3 files changed, 7 insertions(+), 10 deletions(-)

--- a/mm/madvise.c~swap-remove-remnants-of-polling-from-read_swap_cache_async
+++ a/mm/madvise.c
@@ -217,7 +217,7 @@ static int swapin_walk_pmd_entry(pmd_t *
 		ptep = NULL;
 
 		page = read_swap_cache_async(entry, GFP_HIGHUSER_MOVABLE,
-					     vma, addr, false, &splug);
+					     vma, addr, &splug);
 		if (page)
 			put_page(page);
 	}
@@ -262,7 +262,7 @@ static void shmem_swapin_range(struct vm
 		rcu_read_unlock();
 
 		page = read_swap_cache_async(entry, mapping_gfp_mask(mapping),
-					     vma, addr, false, &splug);
+					     vma, addr, &splug);
 		if (page)
 			put_page(page);
 
--- a/mm/swap.h~swap-remove-remnants-of-polling-from-read_swap_cache_async
+++ a/mm/swap.h
@@ -46,7 +46,6 @@ struct folio *filemap_get_incore_folio(s
 struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 				   struct vm_area_struct *vma,
 				   unsigned long addr,
-				   bool do_poll,
 				   struct swap_iocb **plug);
 struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 				     struct vm_area_struct *vma,
--- a/mm/swap_state.c~swap-remove-remnants-of-polling-from-read_swap_cache_async
+++ a/mm/swap_state.c
@@ -526,15 +526,14 @@ fail_put_swap:
  */
 struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 				   struct vm_area_struct *vma,
-				   unsigned long addr, bool do_poll,
-				   struct swap_iocb **plug)
+				   unsigned long addr, struct swap_iocb **plug)
 {
 	bool page_was_allocated;
 	struct page *retpage = __read_swap_cache_async(entry, gfp_mask,
 			vma, addr, &page_was_allocated);
 
 	if (page_was_allocated)
-		swap_readpage(retpage, do_poll, plug);
+		swap_readpage(retpage, false, plug);
 
 	return retpage;
 }
@@ -629,7 +628,7 @@ struct page *swap_cluster_readahead(swp_
 	struct swap_info_struct *si = swp_swap_info(entry);
 	struct blk_plug plug;
 	struct swap_iocb *splug = NULL;
-	bool do_poll = true, page_allocated;
+	bool page_allocated;
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long addr = vmf->address;
 
@@ -637,7 +636,6 @@ struct page *swap_cluster_readahead(swp_
 	if (!mask)
 		goto skip;
 
-	do_poll = false;
 	/* Read a page_cluster sized and aligned cluster around offset. */
 	start_offset = offset & ~mask;
 	end_offset = offset | mask;
@@ -669,7 +667,7 @@ struct page *swap_cluster_readahead(swp_
 	lru_add_drain();	/* Push any new pages onto the LRU now */
 skip:
 	/* The page was likely read above, so no need for plugging here */
-	return read_swap_cache_async(entry, gfp_mask, vma, addr, do_poll, NULL);
+	return read_swap_cache_async(entry, gfp_mask, vma, addr, NULL);
 }
 
 int init_swap_address_space(unsigned int type, unsigned long nr_pages)
@@ -837,7 +835,7 @@ static struct page *swap_vma_readahead(s
 skip:
 	/* The page was likely read above, so no need for plugging here */
 	return read_swap_cache_async(fentry, gfp_mask, vma, vmf->address,
-				     ra_info.win == 1, NULL);
+				     NULL);
 }
 
 /**
_

Patches currently in -mm which might be from surenb@google.com are



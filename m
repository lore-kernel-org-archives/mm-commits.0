Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E87CC11F67
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4899961D07
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhF2CjR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:39:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231398AbhF2CjR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:39:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC6D561D0A;
        Tue, 29 Jun 2021 02:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934211;
        bh=50nm4GS07lA7oIMgrteoY9Z68coyq+CY1pBUUjCQ8iI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QNgP5DxXM2cOrSVM9cpfUOk3NHVl1II3e/gbZhrt2o4gterU9+mABpuUP+XQ7XUM6
         4MT20NCoqZa67DEP+n4QqFyXsp6NabFnONykfVERh/bh2YpqGyjHoWEEiLAQcmk3Tg
         n5NY6Lbm913NJiGSs/J33tT0ob19uVRmf23ZQE5c=
Date:   Mon, 28 Jun 2021 19:36:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexs@kernel.org, david@redhat.com,
        dennis@kernel.org, hannes@cmpxchg.org, hughd@google.com,
        iamjoonsoo.kim@lge.com, linmiaohe@huawei.com, linux-mm@kvack.org,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, shy828301@gmail.com,
        tim.c.chen@linux.intel.com, torvalds@linux-foundation.org,
        willy@infradead.org, ying.huang@intel.com, yuzhao@google.com
Subject:  [patch 068/192] swap: fix do_swap_page() race with
 swapoff
Message-ID: <20210629023650.JFozrw5UE%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: swap: fix do_swap_page() race with swapoff

When I was investigating the swap code, I found the below possible race
window:

CPU 1                                   	CPU 2
-----                                   	-----
do_swap_page
  if (data_race(si->flags & SWP_SYNCHRONOUS_IO)
  swap_readpage
    if (data_race(sis->flags & SWP_FS_OPS)) {
                                        	swapoff
					  	  ..
					  	  p->swap_file = NULL;
					  	  ..
    struct file *swap_file = sis->swap_file;
    struct address_space *mapping = swap_file->f_mapping;[oops!]

Note that for the pages that are swapped in through swap cache, this isn't
an issue. Because the page is locked, and the swap entry will be marked
with SWAP_HAS_CACHE, so swapoff() can not proceed until the page has been
unlocked.

Fix this race by using get/put_swap_device() to guard against concurrent
swapoff.

Link: https://lkml.kernel.org/r/20210426123316.806267-3-linmiaohe@huawei.com
Fixes: 0bcac06f27d7 ("mm,swap: skip swapcache for swapin of synchronous device")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    9 +++++++++
 mm/memory.c          |   11 +++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/include/linux/swap.h~swap-fix-do_swap_page-race-with-swapoff
+++ a/include/linux/swap.h
@@ -527,6 +527,15 @@ static inline struct swap_info_struct *s
 	return NULL;
 }
 
+static inline struct swap_info_struct *get_swap_device(swp_entry_t entry)
+{
+	return NULL;
+}
+
+static inline void put_swap_device(struct swap_info_struct *si)
+{
+}
+
 #define swap_address_space(entry)		(NULL)
 #define get_nr_swap_pages()			0L
 #define total_swap_pages			0L
--- a/mm/memory.c~swap-fix-do_swap_page-race-with-swapoff
+++ a/mm/memory.c
@@ -3353,6 +3353,7 @@ vm_fault_t do_swap_page(struct vm_fault
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page = NULL, *swapcache;
+	struct swap_info_struct *si = NULL;
 	swp_entry_t entry;
 	pte_t pte;
 	int locked;
@@ -3380,14 +3381,16 @@ vm_fault_t do_swap_page(struct vm_fault
 		goto out;
 	}
 
+	/* Prevent swapoff from happening to us. */
+	si = get_swap_device(entry);
+	if (unlikely(!si))
+		goto out;
 
 	delayacct_set_flag(current, DELAYACCT_PF_SWAPIN);
 	page = lookup_swap_cache(entry, vma, vmf->address);
 	swapcache = page;
 
 	if (!page) {
-		struct swap_info_struct *si = swp_swap_info(entry);
-
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO) &&
 		    __swap_count(entry) == 1) {
 			/* skip swapcache */
@@ -3556,6 +3559,8 @@ vm_fault_t do_swap_page(struct vm_fault
 unlock:
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 out:
+	if (si)
+		put_swap_device(si);
 	return ret;
 out_nomap:
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
@@ -3567,6 +3572,8 @@ out_release:
 		unlock_page(swapcache);
 		put_page(swapcache);
 	}
+	if (si)
+		put_swap_device(si);
 	return ret;
 }
 
_

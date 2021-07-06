Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F04C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DC0B61C78
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhGFTN3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231766AbhGFTN3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:13:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAE3D61C72;
        Tue,  6 Jul 2021 19:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598650;
        bh=+Zcho/wxJK0mvs1KR4X7iTVQx3hOScYKiQ+vhyzYD1U=;
        h=Date:From:To:Subject:From;
        b=Mtil5Y0KmTTOwaWC4OTXu6VfCyH8hDv4Y08Ak5Oj3Ml07cCr97HiiCKApid0aXV7h
         YzzFMCQRGyWv80eY8Zo2ZhX+fe3xKmb8zRzLI0W0M7DvkoBvckaqi4lnrT2OhixqBK
         fU8Xv6uJ1E7zAjzT+lDZe6XnYj4rAPfJWUemEWog=
Date:   Tue, 06 Jul 2021 12:10:49 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, david@redhat.com, dennis@kernel.org,
        hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com,
        linmiaohe@huawei.com, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        shy828301@gmail.com, tim.c.chen@linux.intel.com,
        willy@infradead.org, ying.huang@intel.com, yuzhao@google.com
Subject:  [merged] swap-fix-do_swap_page-race-with-swapoff.patch
 removed from -mm tree
Message-ID: <20210706191049.hCn7r-_mA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap: fix do_swap_page() race with swapoff
has been removed from the -mm tree.  Its filename was
     swap-fix-do_swap_page-race-with-swapoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch


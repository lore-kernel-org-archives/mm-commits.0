Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97402C11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79A8B61D08
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbhF2CjZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231848AbhF2CjZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:39:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B7DE61D07;
        Tue, 29 Jun 2021 02:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934218;
        bh=PGH0dS7XtzQQJfpDkXc/Qx/bumd83MEOLPnuYzaVTWo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rQfSi5FZTW5Bu42i+T/byWbRnfGgceIb7UFmxAnacBx9ExNhTRyo+egoIh++IwjAf
         SwDsD+S8BETJCNOOgTj1cJPDn3s1o77Q6BKGSqCpxTlyXbLftsu+mu5LDCXsEgFjh9
         Zv4obcotxje+FXIkSy1UiZtyCL9X1OEfQCVwKIdI=
Date:   Mon, 28 Jun 2021 19:36:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexs@kernel.org, david@redhat.com,
        dennis@kernel.org, hannes@cmpxchg.org, hughd@google.com,
        iamjoonsoo.kim@lge.com, linmiaohe@huawei.com, linux-mm@kvack.org,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, shy828301@gmail.com,
        tim.c.chen@linux.intel.com, torvalds@linux-foundation.org,
        willy@infradead.org, ying.huang@intel.com, yuzhao@google.com
Subject:  [patch 070/192] mm/shmem: fix shmem_swapin() race with
 swapoff
Message-ID: <20210629023657.aGOursF6g%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/shmem: fix shmem_swapin() race with swapoff

When I was investigating the swap code, I found the below possible race
window:

CPU 1                                         CPU 2
-----                                         -----
shmem_swapin
  swap_cluster_readahead
    if (likely(si->flags & (SWP_BLKDEV | SWP_FS_OPS))) {
                                              swapoff
                                                ..
                                                si->swap_file = NULL;
                                                ..
    struct inode *inode = si->swap_file->f_mapping->host;[oops!]

Close this race window by using get/put_swap_device() to guard against
concurrent swapoff.

Link: https://lkml.kernel.org/r/20210426123316.806267-5-linmiaohe@huawei.com
Fixes: 8fd2e0b505d1 ("mm: swap: check if swap backing device is congested or not")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-fix-shmem_swapin-race-with-swapoff
+++ a/mm/shmem.c
@@ -1696,7 +1696,8 @@ static int shmem_swapin_page(struct inod
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct mm_struct *charge_mm = vma ? vma->vm_mm : current->mm;
-	struct page *page;
+	struct swap_info_struct *si;
+	struct page *page = NULL;
 	swp_entry_t swap;
 	int error;
 
@@ -1704,6 +1705,12 @@ static int shmem_swapin_page(struct inod
 	swap = radix_to_swp_entry(*pagep);
 	*pagep = NULL;
 
+	/* Prevent swapoff from happening to us. */
+	si = get_swap_device(swap);
+	if (!si) {
+		error = EINVAL;
+		goto failed;
+	}
 	/* Look it up and read it in.. */
 	page = lookup_swap_cache(swap, NULL, 0);
 	if (!page) {
@@ -1765,6 +1772,8 @@ static int shmem_swapin_page(struct inod
 	swap_free(swap);
 
 	*pagep = page;
+	if (si)
+		put_swap_device(si);
 	return 0;
 failed:
 	if (!shmem_confirm_swap(mapping, index, swap))
@@ -1775,6 +1784,9 @@ unlock:
 		put_page(page);
 	}
 
+	if (si)
+		put_swap_device(si);
+
 	return error;
 }
 
_

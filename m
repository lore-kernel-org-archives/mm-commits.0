Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F948C433B4
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 00:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D048613D2
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 00:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhEJAuR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 20:50:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229973AbhEJAuR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 20:50:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A8BB61026;
        Mon, 10 May 2021 00:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620607752;
        bh=kSAS3XooarVF4soX3SuZVH7lSd1EqOW5suo3xRuIZkU=;
        h=Date:From:To:Subject:From;
        b=L5DE6klXkSiUc/VbHi1y0VjZrLv0kEF2/qwS5taL/sr667nliDGa/eYB64rw6knZH
         04CvGb9/5/Xdp1IyV2au2jaPX+re31P+9vC4Q0Ms7oGHS+7elSuGpHmjSxt1dmMPI9
         NpDs4/LZH+DbUC+Lkp0YQTh+VlC4/qDkhddaZtdY=
Date:   Sun, 09 May 2021 17:49:11 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, david@redhat.com, dennis@kernel.org,
        hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com,
        linmiaohe@huawei.com, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        shy828301@gmail.com, tim.c.chen@linux.intel.com,
        willy@infradead.org, ying.huang@intel.com, yuzhao@google.com
Subject:  + mm-shmem-fix-shmem_swapin-race-with-swapoff.patch added
 to -mm tree
Message-ID: <20210510004911.nlQrRzRZM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: fix shmem_swapin() race with swapoff
has been added to the -mm tree.  Its filename is
     mm-shmem-fix-shmem_swapin-race-with-swapoff.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-fix-shmem_swapin-race-with-swapoff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-use-percpu_ref-to-serialize-against-concurrent-swapoff.patch
swap-fix-do_swap_page-race-with-swapoff.patch
mm-swap-remove-confusing-checking-for-non_swap_entry-in-swap_ra_info.patch
mm-shmem-fix-shmem_swapin-race-with-swapoff.patch


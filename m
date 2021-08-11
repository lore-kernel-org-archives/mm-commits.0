Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC20C4338F
	for <mm-commits@archiver.kernel.org>; Wed, 11 Aug 2021 01:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02A7E60EC0
	for <mm-commits@archiver.kernel.org>; Wed, 11 Aug 2021 01:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhHKBPF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Aug 2021 21:15:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:32946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229723AbhHKBPE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Aug 2021 21:15:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 034FB60EDF;
        Wed, 11 Aug 2021 01:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628644481;
        bh=4mMj1BWTGOInhhFag0i3rEx5EzqT5htcZlRzP1kj8Gk=;
        h=Date:From:To:Subject:From;
        b=oNPc2HKtuuJk8ZPV671INrFoo1tzLYJ/7QQkwoIqz2lVTCm2Ctw5x4f+xMbqqFWKw
         rf7ChHy+tP2i/8SDKmZT2JtguYqqTZqWohxym7Am4KEpWLtHqPoOUwtGoB8dDi6qKQ
         bWGCTRp6hc1UaXzVwU1rBMk7kyned5z281xQ4P5w=
Date:   Tue, 10 Aug 2021 18:14:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, minchan@kernel.org, mhocko@suse.com,
        linmiaohe@huawei.com, iamjoonsoo.kim@lge.com, hughd@google.com,
        hannes@cmpxchg.org, david@redhat.com, shy828301@gmail.com
Subject:  + revert-mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
 added to -mm tree
Message-ID: <20210811011440.YM3NW%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm/shmem: fix shmem_swapin() race with swapoff"
has been added to the -mm tree.  Its filename is
     revert-mm-shmem-fix-shmem_swapin-race-with-swapoff.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/revert-mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-shmem-fix-shmem_swapin-race-with-swapoff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: Revert "mm/shmem: fix shmem_swapin() race with swapoff"

Due to the change about how block layer detects congestion the
justification of commit 8fd2e0b505d1 ("mm: swap: check if swap backing device
is congested or not") doesn't stand anymore, so the commit could be just
reverted in order to solve the race reported by commit 2efa33fc7f6e ("mm/shmem:
fix shmem_swapin() race with swapoff"), so the fix commit could be just
reverted as well.

And that fix is also kind of buggy as discussed by [1] and [2].

[1] https://lore.kernel.org/linux-mm/24187e5e-069-9f3f-cefe-39ac70783753@google.com/
[2] https://lore.kernel.org/linux-mm/e82380b9-3ad4-4a52-be50-6d45c7f2b5da@google.com/

Link: https://lkml.kernel.org/r/20210810202936.2672-2-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

--- a/mm/shmem.c~revert-mm-shmem-fix-shmem_swapin-race-with-swapoff
+++ a/mm/shmem.c
@@ -1696,8 +1696,7 @@ static int shmem_swapin_page(struct inod
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct mm_struct *charge_mm = vma ? vma->vm_mm : NULL;
-	struct swap_info_struct *si;
-	struct page *page = NULL;
+	struct page *page;
 	swp_entry_t swap;
 	int error;
 
@@ -1705,12 +1704,6 @@ static int shmem_swapin_page(struct inod
 	swap = radix_to_swp_entry(*pagep);
 	*pagep = NULL;
 
-	/* Prevent swapoff from happening to us. */
-	si = get_swap_device(swap);
-	if (!si) {
-		error = EINVAL;
-		goto failed;
-	}
 	/* Look it up and read it in.. */
 	page = lookup_swap_cache(swap, NULL, 0);
 	if (!page) {
@@ -1772,8 +1765,6 @@ static int shmem_swapin_page(struct inod
 	swap_free(swap);
 
 	*pagep = page;
-	if (si)
-		put_swap_device(si);
 	return 0;
 failed:
 	if (!shmem_confirm_swap(mapping, index, swap))
@@ -1784,9 +1775,6 @@ unlock:
 		put_page(page);
 	}
 
-	if (si)
-		put_swap_device(si);
-
 	return error;
 }
 
_

Patches currently in -mm which might be from shy828301@gmail.com are

revert-mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
revert-mm-swap-check-if-swap-backing-device-is-congested-or-not.patch


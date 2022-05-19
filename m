Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB87C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245539AbiESW0T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245482AbiESWZw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:25:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E74595B7
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1C1461698
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3809AC385B8;
        Thu, 19 May 2022 22:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999146;
        bh=WyYuH5WRubwDFGrExYQmrCKaR2psXKZNjJqHwJ77VFI=;
        h=Date:To:From:Subject:From;
        b=G223vSJYqQBlOVG7+p7f1QK6ADn7QghzVwLfqueWBNi1ZnlmFLUxov+Dkopig6RLm
         7xtqHI/PdhfXgP/1Nt3XNiDAOo3jAIg5FTDz97NkOT1/kRik+cw906rQ6e8u+3G3+A
         okqC6ipY6r9E+Qa0LwHb+wzlIST5Ba8HcBShKOGs=
Date:   Thu, 19 May 2022 15:25:45 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, osalvador@suse.de,
        neilb@suse.de, naoya.horiguchi@nec.com, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-clean-up-the-comment-of-find_next_to_unuse.patch removed from -mm tree
Message-Id: <20220519222546.3809AC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: clean up the comment of find_next_to_unuse
has been removed from the -mm tree.  Its filename was
     mm-swap-clean-up-the-comment-of-find_next_to_unuse.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap: clean up the comment of find_next_to_unuse

Since commit 10a9c496789f ("mm: simplify try_to_unuse"), frontswap
parameter is removed.  Update the corresponding comment.

Link: https://lkml.kernel.org/r/20220509131416.17553-14-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-clean-up-the-comment-of-find_next_to_unuse
+++ a/mm/swapfile.c
@@ -1990,9 +1990,9 @@ static int unuse_mm(struct mm_struct *mm
 }
 
 /*
- * Scan swap_map (or frontswap_map if frontswap parameter is true)
- * from current position to next entry still in use. Return 0
- * if there are no inuse entries after prev till end of the map.
+ * Scan swap_map from current position to next entry still in use.
+ * Return 0 if there are no inuse entries after prev till end of
+ * the map.
  */
 static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 					unsigned int prev)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-z3fold-fix-sheduling-while-atomic.patch
mm-z3fold-fix-possible-null-pointer-dereferencing.patch
mm-z3fold-remove-buggy-use-of-stale-list-for-allocation.patch
mm-z3fold-throw-warning-on-failure-of-trylock_page-in-z3fold_alloc.patch
revert-mm-z3foldc-allow-__gfp_highmem-in-z3fold_alloc.patch
mm-z3fold-put-z3fold-page-back-into-unbuddied-list-when-reclaim-or-migration-fails.patch
mm-z3fold-always-clear-page_claimed-under-z3fold-page-lock.patch
mm-z3fold-fix-z3fold_reclaim_page-races-with-z3fold_free.patch
mm-z3fold-fix-z3fold_page_migrate-races-with-z3fold_map.patch
mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch
mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range.patch
mm-shmem-fix-infinite-loop-when-swap-in-shmem-error-at-swapoff-time.patch
mm-filter-out-swapin-error-entry-in-shmem-mapping.patch


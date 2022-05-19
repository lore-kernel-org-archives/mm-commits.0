Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C4F7C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245437AbiESWZk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245423AbiESWZg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:25:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EE766234
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2B386166C
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548AAC385AA;
        Thu, 19 May 2022 22:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999134;
        bh=zMqMLvPG0MSfWuiI3A/suPpQ9ORpCPXYj7TBjDh9yC8=;
        h=Date:To:From:Subject:From;
        b=OpDjaMglxePBzcvVpN8FEbWBXPbEbVAoO/47T9EozFUbOq62lIm5IGlJlEfS6zNy3
         JS+/cKYVpyx9sr08GpicmHfDMZlFbgUH8p+idI47kwPQjV4zqVkk1HcgZazXCx1lH7
         Gdk2Ip/Lgkcs2LjpLz9XBEs+uPqtT3wxziKh3noM=
Date:   Thu, 19 May 2022 15:25:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, osalvador@suse.de,
        neilb@suse.de, naoya.horiguchi@nec.com, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-use-helper-is_swap_pte-in-swap_vma_readahead.patch removed from -mm tree
Message-Id: <20220519222534.548AAC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: use helper is_swap_pte() in swap_vma_readahead
has been removed from the -mm tree.  Its filename was
     mm-swap-use-helper-is_swap_pte-in-swap_vma_readahead.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap: use helper is_swap_pte() in swap_vma_readahead

Patch series "A few cleanup patches for swap".

This series contains a few patches to fix the comment, remove unneeded
return value, use some helpers and so on.  More details can be found in
the respective changelogs.


This patch (of 14):

Use helper is_swap_pte() to check whether pte is swap entry to make code
more clear.  Minor readability improvement.

Link: https://lkml.kernel.org/r/20220509131416.17553-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220509131416.17553-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Howells <dhowells@redhat.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/swap_state.c~mm-swap-use-helper-is_swap_pte-in-swap_vma_readahead
+++ a/mm/swap_state.c
@@ -818,9 +818,7 @@ static struct page *swap_vma_readahead(s
 	for (i = 0, pte = ra_info.ptes; i < ra_info.nr_pte;
 	     i++, pte++) {
 		pentry = *pte;
-		if (pte_none(pentry))
-			continue;
-		if (pte_present(pentry))
+		if (!is_swap_pte(pentry))
 			continue;
 		entry = pte_to_swp_entry(pentry);
 		if (unlikely(non_swap_entry(entry)))
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


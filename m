Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD6DC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245542AbiESW0U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245485AbiESWZw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:25:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14304A18C
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8C7261693
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBDBC385AA;
        Thu, 19 May 2022 22:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999147;
        bh=iDFitrCieBvPYA2JCWjHhWktxHGSAsfgVHyJm2Gb94Q=;
        h=Date:To:From:Subject:From;
        b=0FxvPDPOovWLlZV1emc0b5I5OfzwCWO8aKB6rZUvh44biCi/TOTio3PP1IDkH061P
         nJkNAQp88UbyD+XavPO/6rmFFoU1kzH0RH5geJ35bP3XLizHnKOt44Y1l4GKPtaR1B
         M1u8bZvoFDfy8ADCdng/P8mDfJ8t/siBvSW4+K8M=
Date:   Thu, 19 May 2022 15:25:46 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, osalvador@suse.de,
        neilb@suse.de, naoya.horiguchi@nec.com, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-fix-the-comment-of-get_kernel_pages.patch removed from -mm tree
Message-Id: <20220519222547.4DBDBC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: fix the comment of get_kernel_pages
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-the-comment-of-get_kernel_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap: fix the comment of get_kernel_pages

If no pages were pinned, 0 is returned in fact.  Fix the corresponding
comment.

[akpm@linux-foundation.org: s/nr_pages/nr_segs/ also, per David, reflow comment]
Link: https://lkml.kernel.org/r/20220509131416.17553-15-linmiaohe@huawei.com
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

 mm/swap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/swap.c~mm-swap-fix-the-comment-of-get_kernel_pages
+++ a/mm/swap.c
@@ -166,10 +166,10 @@ EXPORT_SYMBOL(put_pages_list);
  * @pages:	array that receives pointers to the pages pinned.
  *		Should be at least nr_segs long.
  *
- * Returns number of pages pinned. This may be fewer than the number
- * requested. If nr_pages is 0 or negative, returns 0. If no pages
- * were pinned, returns -errno. Each page returned must be released
- * with a put_page() call when it is finished with.
+ * Returns number of pages pinned. This may be fewer than the number requested.
+ * If nr_segs is 0 or negative, returns 0.  If no pages were pinned, returns 0.
+ * Each page returned must be released with a put_page() call when it is
+ * finished with.
  */
 int get_kernel_pages(const struct kvec *kiov, int nr_segs, int write,
 		struct page **pages)
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


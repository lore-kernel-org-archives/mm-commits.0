Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1174C48BE8
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 02:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3B35611CE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 02:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhFOCsi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 22:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230084AbhFOCsh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Jun 2021 22:48:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 272FF613F5;
        Tue, 15 Jun 2021 02:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623724833;
        bh=GjDBjUdxX1kUUQxhBG8gRzvq2SBuJDTmrVpEFV9UHiI=;
        h=Date:From:To:Subject:From;
        b=F/bKwqvymINaLu2TdjVzLKrMlapT/fJjCaJ+XMLGCWgra7CinjGirkvEzaArSoZCC
         XPuee7cLcILWwrLJ+NQsAEvY+x7UHSEvhGDePIkBCauRjNA+Fa7eq5q7ldtS/x8DHD
         Md80H+NCtog2JHqTbo5oqw5/sYHnS6aj33WRYHms=
Date:   Mon, 14 Jun 2021 19:40:32 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [obsolete]
 mm-swap-remove-unused-global-variable-nr_swapper_spaces.patch removed from
 -mm tree
Message-ID: <20210615024032.oPKLCETLn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: remove unused global variable nr_swapper_spaces
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-unused-global-variable-nr_swapper_spaces.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap: remove unused global variable nr_swapper_spaces

Since commit b6038942480e ("mm: memcg: add swapcache stat for memcg v2"),
the last user of nr_swapper_spaces is gone.  So we remove this unused one.

Link: https://lkml.kernel.org/r/20210520134022.1370406-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/swap_state.c~mm-swap-remove-unused-global-variable-nr_swapper_spaces
+++ a/mm/swap_state.c
@@ -37,7 +37,6 @@ static const struct address_space_operat
 };
 
 struct address_space *swapper_spaces[MAX_SWAPFILES] __read_mostly;
-static unsigned int nr_swapper_spaces[MAX_SWAPFILES] __read_mostly;
 static bool enable_vma_readahead __read_mostly = true;
 
 #define SWAP_RA_WIN_SHIFT	(PAGE_SHIFT / 2)
@@ -685,7 +684,6 @@ int init_swap_address_space(unsigned int
 		/* swap cache doesn't use writeback related tags */
 		mapping_set_no_writeback_tags(space);
 	}
-	nr_swapper_spaces[type] = nr;
 	swapper_spaces[type] = spaces;
 
 	return 0;
@@ -694,7 +692,6 @@ int init_swap_address_space(unsigned int
 void exit_swap_address_space(unsigned int type)
 {
 	kvfree(swapper_spaces[type]);
-	nr_swapper_spaces[type] = 0;
 	swapper_spaces[type] = NULL;
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-use-percpu_ref-to-serialize-against-concurrent-swapoff.patch
swap-fix-do_swap_page-race-with-swapoff.patch
mm-swap-remove-confusing-checking-for-non_swap_entry-in-swap_ra_info.patch
mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix-2.patch
mm-swap-remove-unused-local-variable-nr_shadows.patch
mm-swap_slotsc-delete-meaningless-forward-declarations.patch
mm-huge_memoryc-remove-dedicated-macro-hpage_cache_index_mask.patch
mm-huge_memoryc-use-page-deferred_list.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4.patch
mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd.patch
mm-huge_memoryc-dont-discard-hugepage-if-other-processes-are-mapping-it.patch
mm-zbud-reuse-unbuddied-as-buddied-in-zbud_pool.patch
mm-zbud-dont-export-any-zbud-api.patch
mm-zswapc-remove-unused-function-zswap_debugfs_exit.patch
mm-zswapc-avoid-unnecessary-copy-in-at-map-time.patch
mm-zswapc-fix-two-bugs-in-zswap_writeback_entry.patch


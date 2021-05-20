Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5547C433B4
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 20:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9863B613BE
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 20:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhETUrV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 May 2021 16:47:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229565AbhETUrT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 May 2021 16:47:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D332E613E4;
        Thu, 20 May 2021 20:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621543558;
        bh=9XPHoFfTOjeSQTTermJIThVJyeQtfjTaOEUE9ubKdhI=;
        h=Date:From:To:Subject:From;
        b=aq+qCb1JjlkMLLp21VpbuKvl9GVVfhR9BxD13Jod3waoKlqM0yF4EJqrqohWh7iD2
         I3zqUM+76OzsuvHF1TvZZzqZNWM0IBAZhnMw7x6q/scujuDTx342KjlmdqRBGggbuh
         bro2+/WmZSL//eBrZ5CEdoc3dasxfwaUh6j1ghCE=
Date:   Thu, 20 May 2021 13:45:57 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  +
 mm-swap-remove-unused-global-variable-nr_swapper_spaces.patch added to -mm
 tree
Message-ID: <20210520204557.5ip1URrnk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: remove unused global variable nr_swapper_spaces
has been added to the -mm tree.  Its filename is
     mm-swap-remove-unused-global-variable-nr_swapper_spaces.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swap-remove-unused-global-variable-nr_swapper_spaces.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-remove-unused-global-variable-nr_swapper_spaces.patch

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
mm-swap-remove-unused-local-variable-nr_shadows.patch
mm-swap_slotsc-delete-meaningless-forward-declarations.patch
mm-swap-remove-unused-global-variable-nr_swapper_spaces.patch
mm-huge_memoryc-remove-dedicated-macro-hpage_cache_index_mask.patch
mm-huge_memoryc-use-page-deferred_list.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4.patch
mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd.patch
mm-huge_memoryc-dont-discard-hugepage-if-other-processes-are-mapping-it.patch


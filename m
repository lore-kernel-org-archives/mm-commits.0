Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D04BC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 20:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62B8A613E4
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 20:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhETUrS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 May 2021 16:47:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229455AbhETUrQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 May 2021 16:47:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAFAA613E4;
        Thu, 20 May 2021 20:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621543554;
        bh=F+XKSHeUWl1tj1TeKuk8zNa9S2NlhdVBaP7+E4g7u9k=;
        h=Date:From:To:Subject:From;
        b=damYbWNM9foubADIDW6ZoWMA+4INo4patxdYOwSmbc0JIbp1fSGDvQkvEQnelAYiC
         6lw1pPKXrP7uzi9ybhSvjY1F8EtlnVVO5dOOyq7XyZcbZfNv3HVbL+ad7Tqik+2Ar5
         yeHbRE/j4Uj3qkpeWUEjhObq4NlI8l7ILwZC/qek=
Date:   Thu, 20 May 2021 13:45:53 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  + mm-swap-remove-unused-local-variable-nr_shadows.patch
 added to -mm tree
Message-ID: <20210520204553.-caeVBome%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: remove unused local variable nr_shadows
has been added to the -mm tree.  Its filename is
     mm-swap-remove-unused-local-variable-nr_shadows.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swap-remove-unused-local-variable-nr_shadows.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-remove-unused-local-variable-nr_shadows.patch

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
Subject: mm/swap: remove unused local variable nr_shadows

Since commit 55c653b71e8c ("mm: stop accounting shadow entries"),
nr_shadows is not used anymore.

Link: https://lkml.kernel.org/r/20210520134022.1370406-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/swap_state.c~mm-swap-remove-unused-local-variable-nr_shadows
+++ a/mm/swap_state.c
@@ -114,8 +114,6 @@ int add_to_swap_cache(struct page *page,
 	SetPageSwapCache(page);
 
 	do {
-		unsigned long nr_shadows = 0;
-
 		xas_lock_irq(&xas);
 		xas_create_range(&xas);
 		if (xas_error(&xas))
@@ -124,7 +122,6 @@ int add_to_swap_cache(struct page *page,
 			VM_BUG_ON_PAGE(xas.xa_index != idx + i, page);
 			old = xas_load(&xas);
 			if (xa_is_value(old)) {
-				nr_shadows++;
 				if (shadowp)
 					*shadowp = old;
 			}
@@ -260,7 +257,6 @@ void clear_shadow_from_swap_cache(int ty
 	void *old;
 
 	for (;;) {
-		unsigned long nr_shadows = 0;
 		swp_entry_t entry = swp_entry(type, curr);
 		struct address_space *address_space = swap_address_space(entry);
 		XA_STATE(xas, &address_space->i_pages, curr);
@@ -270,7 +266,6 @@ void clear_shadow_from_swap_cache(int ty
 			if (!xa_is_value(old))
 				continue;
 			xas_store(&xas, NULL);
-			nr_shadows++;
 		}
 		xa_unlock_irq(&address_space->i_pages);
 
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


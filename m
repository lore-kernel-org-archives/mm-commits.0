Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A89C433B4
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 20:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70100613E1
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 20:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbhETUrS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 May 2021 16:47:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229565AbhETUrR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 May 2021 16:47:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9EB7613E6;
        Thu, 20 May 2021 20:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621543555;
        bh=x5S0Mz3b/5xdn0ZrdaYn6lEZ4bm4Y/hiJeocCxvwC7Y=;
        h=Date:From:To:Subject:From;
        b=Nbmmui8tV+XMeRUC/HUpSt51jSg8LW2RbBbkb+KleRp5MH30lDM4ADXVdg345KoJn
         atB26VlVl3ri+TzTbLgQoQPHD3UMcpWVsBnZ/mm2UZXkPAzEQZizmDb9S9yKLmH2Lp
         GLO/4Pijvp7BJYHjPO0nbo2k4bziBzP9SeaEv+9w=
Date:   Thu, 20 May 2021 13:45:55 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  +
 mm-swap_slotsc-delete-meaningless-forward-declarations.patch added to -mm
 tree
Message-ID: <20210520204555.t5JPblLwc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_slots.c: delete meaningless forward declarations
has been added to the -mm tree.  Its filename is
     mm-swap_slotsc-delete-meaningless-forward-declarations.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swap_slotsc-delete-meaningless-forward-declarations.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swap_slotsc-delete-meaningless-forward-declarations.patch

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
Subject: mm/swap_slots.c: delete meaningless forward declarations

deactivate_swap_slots_cache() and reactivate_swap_slots_cache() are only
called below their implementations.  So these forward declarations are
meaningless and should be removed.

Link: https://lkml.kernel.org/r/20210520134022.1370406-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/swap_slots.c~mm-swap_slotsc-delete-meaningless-forward-declarations
+++ a/mm/swap_slots.c
@@ -43,8 +43,6 @@ static DEFINE_MUTEX(swap_slots_cache_mut
 static DEFINE_MUTEX(swap_slots_cache_enable_mutex);
 
 static void __drain_swap_slots_cache(unsigned int type);
-static void deactivate_swap_slots_cache(void);
-static void reactivate_swap_slots_cache(void);
 
 #define use_swap_slot_cache (swap_slot_cache_active && swap_slot_cache_enabled)
 #define SLOTS_CACHE 0x1
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


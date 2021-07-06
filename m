Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE68C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 924A461C6C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbhGFTNj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:13:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231628AbhGFTNj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:13:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82ABE61C6D;
        Tue,  6 Jul 2021 19:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598660;
        bh=CcLUBAt2BJc/JKg1pPm1V30bCWCxO4woBSGvffSuXLM=;
        h=Date:From:To:Subject:From;
        b=X7jF0cfrrZx0thFpPULAIRiDNBzyykGLVX3DAICDF+EN0uVwB7fKaQC68bZAlctB3
         B+47QNSND2r3CksAQOvd/DDgngehGdckxbLEU4M3COEsENqZupcbMyAmo31zccAoap
         HTunZM+ZyKMFUZh+O6I/KA0X7eW/hv4CJVqrrHzs=
Date:   Tue, 06 Jul 2021 12:11:00 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [merged]
 mm-swap-remove-unused-local-variable-nr_shadows.patch removed from -mm tree
Message-ID: <20210706191100.XHgPby9O1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: remove unused local variable nr_shadows
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-unused-local-variable-nr_shadows.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch


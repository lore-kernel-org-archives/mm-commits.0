Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D433C001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbjHKW6q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236604AbjHKW6o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235E430EE
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B44196554C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B230C433C8;
        Fri, 11 Aug 2023 22:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794719;
        bh=L9+HChXmEUaoqZuGegcI9h5bg1cn3ustPV/yuOYS4N8=;
        h=Date:To:From:Subject:From;
        b=yLpwDXkcHjieYOGSreje3pUIg/ZVs9PvSYYBBpX1orwyVaM9xWTwH4yPtlJ6/yDrE
         ZKThMRf4m6mADd1qrTCjFneEhgpprDjn9U+P1z28Ui6pm5s+L7wdh2l84oOBlejKha
         NGwaC85IJc7AsrpxWYg6OQ9+7YRNe4F58g897SC8=
Date:   Fri, 11 Aug 2023 15:58:38 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, will@kernel.org,
        vincenzo.frascino@arm.com, surenb@google.com, steven.price@arm.com,
        qun-wei.lin@mediatek.com, Kuan-Ying.Lee@mediatek.com,
        kasan-dev@googlegroups.com, gregkh@linuxfoundation.org,
        eugenis@google.com, david@redhat.com, chinwen.chang@mediatek.com,
        catalin.marinas@arm.com, alexandru.elisei@arm.com, pcc@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mte-simplify-swap-tag-restoration-logic.patch removed from -mm tree
Message-Id: <20230811225839.1B230C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64: mte: simplify swap tag restoration logic
has been removed from the -mm tree.  Its filename was
     arm64-mte-simplify-swap-tag-restoration-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Collingbourne <pcc@google.com>
Subject: arm64: mte: simplify swap tag restoration logic
Date: Mon, 22 May 2023 17:43:10 -0700

As a result of the patches "mm: Call arch_swap_restore() from
do_swap_page()" and "mm: Call arch_swap_restore() from unuse_pte()", there
are no circumstances in which a swapped-in page is installed in a page
table without first having arch_swap_restore() called on it.  Therefore,
we no longer need the logic in set_pte_at() that restores the tags, so
remove it.

Link: https://lkml.kernel.org/r/20230523004312.1807357-4-pcc@google.com
Link: https://linux-review.googlesource.com/id/I8ad54476f3b2d0144ccd8ce0c1d7a2963e5ff6f3
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kasan-dev@googlegroups.com
Cc: kasan-dev <kasan-dev@googlegroups.com>
Cc: "Kuan-Ying Lee (李冠穎)" <Kuan-Ying.Lee@mediatek.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/mte.h     |    4 +--
 arch/arm64/include/asm/pgtable.h |   14 +---------
 arch/arm64/kernel/mte.c          |   37 +++++------------------------
 3 files changed, 11 insertions(+), 44 deletions(-)

--- a/arch/arm64/include/asm/mte.h~arm64-mte-simplify-swap-tag-restoration-logic
+++ a/arch/arm64/include/asm/mte.h
@@ -90,7 +90,7 @@ static inline bool try_page_mte_tagging(
 }
 
 void mte_zero_clear_page_tags(void *addr);
-void mte_sync_tags(pte_t old_pte, pte_t pte);
+void mte_sync_tags(pte_t pte);
 void mte_copy_page_tags(void *kto, const void *kfrom);
 void mte_thread_init_user(void);
 void mte_thread_switch(struct task_struct *next);
@@ -122,7 +122,7 @@ static inline bool try_page_mte_tagging(
 static inline void mte_zero_clear_page_tags(void *addr)
 {
 }
-static inline void mte_sync_tags(pte_t old_pte, pte_t pte)
+static inline void mte_sync_tags(pte_t pte)
 {
 }
 static inline void mte_copy_page_tags(void *kto, const void *kfrom)
--- a/arch/arm64/include/asm/pgtable.h~arm64-mte-simplify-swap-tag-restoration-logic
+++ a/arch/arm64/include/asm/pgtable.h
@@ -337,18 +337,8 @@ static inline void __set_pte_at(struct m
 	 * don't expose tags (instruction fetches don't check tags).
 	 */
 	if (system_supports_mte() && pte_access_permitted(pte, false) &&
-	    !pte_special(pte)) {
-		pte_t old_pte = READ_ONCE(*ptep);
-		/*
-		 * We only need to synchronise if the new PTE has tags enabled
-		 * or if swapping in (in which case another mapping may have
-		 * set tags in the past even if this PTE isn't tagged).
-		 * (!pte_none() && !pte_present()) is an open coded version of
-		 * is_swap_pte()
-		 */
-		if (pte_tagged(pte) || (!pte_none(old_pte) && !pte_present(old_pte)))
-			mte_sync_tags(old_pte, pte);
-	}
+	    !pte_special(pte) && pte_tagged(pte))
+		mte_sync_tags(pte);
 
 	__check_safe_pte_update(mm, ptep, pte);
 
--- a/arch/arm64/kernel/mte.c~arm64-mte-simplify-swap-tag-restoration-logic
+++ a/arch/arm64/kernel/mte.c
@@ -35,41 +35,18 @@ DEFINE_STATIC_KEY_FALSE(mte_async_or_asy
 EXPORT_SYMBOL_GPL(mte_async_or_asymm_mode);
 #endif
 
-static void mte_sync_page_tags(struct page *page, pte_t old_pte,
-			       bool check_swap, bool pte_is_tagged)
-{
-	if (check_swap && is_swap_pte(old_pte)) {
-		swp_entry_t entry = pte_to_swp_entry(old_pte);
-
-		if (!non_swap_entry(entry))
-			mte_restore_tags(entry, page);
-	}
-
-	if (!pte_is_tagged)
-		return;
-
-	if (try_page_mte_tagging(page)) {
-		mte_clear_page_tags(page_address(page));
-		set_page_mte_tagged(page);
-	}
-}
-
-void mte_sync_tags(pte_t old_pte, pte_t pte)
+void mte_sync_tags(pte_t pte)
 {
 	struct page *page = pte_page(pte);
 	long i, nr_pages = compound_nr(page);
-	bool check_swap = nr_pages == 1;
-	bool pte_is_tagged = pte_tagged(pte);
-
-	/* Early out if there's nothing to do */
-	if (!check_swap && !pte_is_tagged)
-		return;
 
 	/* if PG_mte_tagged is set, tags have already been initialised */
-	for (i = 0; i < nr_pages; i++, page++)
-		if (!page_mte_tagged(page))
-			mte_sync_page_tags(page, old_pte, check_swap,
-					   pte_is_tagged);
+	for (i = 0; i < nr_pages; i++, page++) {
+		if (try_page_mte_tagging(page)) {
+			mte_clear_page_tags(page_address(page));
+			set_page_mte_tagged(page);
+		}
+	}
 
 	/* ensure the tags are visible before the PTE is set */
 	smp_wmb();
_

Patches currently in -mm which might be from pcc@google.com are



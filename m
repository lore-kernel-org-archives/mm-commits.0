Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E143AC6FD1D
	for <mm-commits@archiver.kernel.org>; Mon, 20 Mar 2023 22:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjCTWMY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Mar 2023 18:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjCTWMO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Mar 2023 18:12:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFF626CD6
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 15:11:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40FA2B810C0
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 22:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECD1C433D2;
        Mon, 20 Mar 2023 22:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679350306;
        bh=ozNEclKPfq0MNZ4WXV+rTTCUR1ze2QS612XRjbpYrXI=;
        h=Date:To:From:Subject:From;
        b=LvYTMhpP7JZbUYWiKm/F9Dtw1Y8uV+d/eVmuLejlvGnD1lJ+INXrsG0NLBIw8fqSH
         huuWR5bIsBAP8+B4j4AjfEaXhvyVYab2eGpj69tVsSeYP4FZiymCRue0S9KwE4HwdX
         gPnXTMlzXbNAlcJIyaUBxnBBU5wpHGxkhMfp7uWg=
Date:   Mon, 20 Mar 2023 15:11:45 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, mhocko@kernel.org, mgorman@suse.de,
        david@redhat.com, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-pgtable_init-to-mm-mm_initc-and-make-it-static.patch added to mm-unstable branch
Message-Id: <20230320221145.EECD1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move pgtable_init() to mm/mm_init.c and make it static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-pgtable_init-to-mm-mm_initc-and-make-it-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-pgtable_init-to-mm-mm_initc-and-make-it-static.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mm: move pgtable_init() to mm/mm_init.c and make it static
Date: Mon, 20 Mar 2023 00:00:02 +0200

pgtable_init() is only called from mm_core_init().

Move it close to the caller and make it static.

Link: https://lkml.kernel.org/r/20230319220008.2138576-10-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-move-pgtable_init-to-mm-mm_initc-and-make-it-static
+++ a/include/linux/mm.h
@@ -2782,12 +2782,6 @@ static inline bool ptlock_init(struct pa
 static inline void ptlock_free(struct page *page) {}
 #endif /* USE_SPLIT_PTE_PTLOCKS */
 
-static inline void pgtable_init(void)
-{
-	ptlock_cache_init();
-	pgtable_cache_init();
-}
-
 static inline bool pgtable_pte_page_ctor(struct page *page)
 {
 	if (!ptlock_init(page))
--- a/mm/mm_init.c~mm-move-pgtable_init-to-mm-mm_initc-and-make-it-static
+++ a/mm/mm_init.c
@@ -2511,6 +2511,12 @@ void __init memblock_free_pages(struct p
 	__free_pages_core(page, order);
 }
 
+static void __init pgtable_init(void)
+{
+	ptlock_cache_init();
+	pgtable_cache_init();
+}
+
 /* Report memory auto-initialization states for this boot. */
 static void __init report_meminit(void)
 {
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-move-get_page_from_free_area-to-mm-page_allocc.patch
mips-fix-comment-about-pgtable_init.patch
mm-cma-move-init_cma_reserved_pages-to-cmac-and-make-it-static.patch
mm-page_alloc-add-helper-for-checking-if-check_pages_enabled.patch
mm-move-most-of-core-mm-initialization-to-mm-mm_initc.patch
mm-handle-hashdist-initialization-in-mm-mm_initc.patch
mm-page_alloc-rename-page_alloc_init-to-page_alloc_init_cpuhp.patch
init-fold-build_all_zonelists-and-page_alloc_init_cpuhp-to-mm_init.patch
initmm-move-mm_init-to-mm-mm_initc-and-rename-it-to-mm_core_init.patch
mm-move-pgtable_init-to-mm-mm_initc-and-make-it-static.patch
mm-move-init_mem_debugging_and_hardening-to-mm-mm_initc.patch
initmm-fold-late-call-to-page_ext_init-to-page_alloc_init_late.patch
mm-move-mem_init_print_info-to-mm_initc.patch
mm-move-kmem_cache_init-declaration-to-mm-slabh.patch
mm-move-vmalloc_init-declaration-to-mm-internalh.patch
maintainers-extend-memblock-entry-to-include-mm-initialization.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3476C6FD1D
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 19:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjCUTjA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 15:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjCUTis (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 15:38:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7A7D333
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 12:38:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6035261DAF
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 19:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FE4C433D2;
        Tue, 21 Mar 2023 19:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679427439;
        bh=zXR5SNbFPxdnApWqdumFdgpFj0K7piih/9TYe/8/ur0=;
        h=Date:To:From:Subject:From;
        b=iU4oXeOS9Zob3cNkS09qcc4/VcBG91tIPRj7ZVrZdpCVVIrVEovyoBSRm/OfvOXsy
         1VJYbuk1xpDdgpykqOU0iVd2jVs+qSU5G9reRg4Pf0OamV2mVyE/uJkhcXbQFEOYD8
         xkrSesBujELxSo9WWbaLCenBR4LxLY1vNTySJmuU=
Date:   Tue, 21 Mar 2023 12:37:19 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, opendmb@gmail.com, mhocko@kernel.org,
        mgorman@suse.de, david@redhat.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-call-ptlockpgtable_cache_init-directly-from-mm_core_init.patch added to mm-unstable branch
Message-Id: <20230321193719.B4FE4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: call {ptlock,pgtable}_cache_init() directly from mm_core_init()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-call-ptlockpgtable_cache_init-directly-from-mm_core_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-call-ptlockpgtable_cache_init-directly-from-mm_core_init.patch

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
Subject: mm: call {ptlock,pgtable}_cache_init() directly from mm_core_init()
Date: Tue, 21 Mar 2023 19:05:07 +0200

and drop pgtable_init() as it has no real value and it's name is
misleading.

Link: https://lkml.kernel.org/r/20230321170513.2401534-9-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ------
 mm/mm_init.c       |    3 ++-
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-call-ptlockpgtable_cache_init-directly-from-mm_core_init
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
--- a/mm/mm_init.c~mm-call-ptlockpgtable_cache_init-directly-from-mm_core_init
+++ a/mm/mm_init.c
@@ -2584,7 +2584,8 @@ void __init mm_core_init(void)
 	 */
 	page_ext_init_flatmem_late();
 	kmemleak_init();
-	pgtable_init();
+	ptlock_cache_init();
+	pgtable_cache_init();
 	debug_objects_mem_init();
 	vmalloc_init();
 	/* If no deferred init page_ext now, as vmap is fully initialized */
_

Patches currently in -mm which might be from rppt@kernel.org are

mips-fix-comment-about-pgtable_init.patch
mm-page_alloc-add-helper-for-checking-if-check_pages_enabled.patch
mm-move-most-of-core-mm-initialization-to-mm-mm_initc.patch
mm-handle-hashdist-initialization-in-mm-mm_initc.patch
mm-page_alloc-rename-page_alloc_init-to-page_alloc_init_cpuhp.patch
init-fold-build_all_zonelists-and-page_alloc_init_cpuhp-to-mm_init.patch
initmm-move-mm_init-to-mm-mm_initc-and-rename-it-to-mm_core_init.patch
mm-call-ptlockpgtable_cache_init-directly-from-mm_core_init.patch
mm-move-init_mem_debugging_and_hardening-to-mm-mm_initc.patch
initmm-fold-late-call-to-page_ext_init-to-page_alloc_init_late.patch
mm-move-mem_init_print_info-to-mm_initc.patch
mm-move-kmem_cache_init-declaration-to-mm-slabh.patch
mm-move-vmalloc_init-declaration-to-mm-internalh.patch
maintainers-extend-memblock-entry-to-include-mm-initialization.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBEC2C761A6
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 19:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjCUTk2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 15:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjCUTkE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 15:40:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0EE2FCDE
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 12:39:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 946C2B81986
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 19:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32288C433D2;
        Tue, 21 Mar 2023 19:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679427451;
        bh=P2Vry6W7TuP7YS5AYj43Rb1SJCDaMTeitci3x06Bi0A=;
        h=Date:To:From:Subject:From;
        b=FJvcZQSpRHES8FBG9SuS7gv1rQAf+t1mHRtnBhwNPISYO0GD1qxK7ZuSDvsRDrdRs
         jBRM7fMl5ODWze9nwp6sarN6xPw/RzHcxCFo4d/LH4ihBbHajusg40xGHQ8IBK1s73
         AxjG2LamnrFTpbOqAZOaWN4bbBwkbAkW2p6gENvg=
Date:   Tue, 21 Mar 2023 12:37:30 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, opendmb@gmail.com, mhocko@kernel.org,
        mgorman@suse.de, david@redhat.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-vmalloc_init-declaration-to-mm-internalh.patch added to mm-unstable branch
Message-Id: <20230321193731.32288C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move vmalloc_init() declaration to mm/internal.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-vmalloc_init-declaration-to-mm-internalh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-vmalloc_init-declaration-to-mm-internalh.patch

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
Subject: mm: move vmalloc_init() declaration to mm/internal.h
Date: Tue, 21 Mar 2023 19:05:12 +0200

vmalloc_init() is called only from mm_core_init(), there is no need to
declare it in include/linux/vmalloc.h

Move vmalloc_init() declaration to mm/internal.h

Link: https://lkml.kernel.org/r/20230321170513.2401534-14-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    4 ----
 mm/internal.h           |    5 +++++
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/vmalloc.h~mm-move-vmalloc_init-declaration-to-mm-internalh
+++ a/include/linux/vmalloc.h
@@ -131,12 +131,8 @@ extern void *vm_map_ram(struct page **pa
 extern void vm_unmap_aliases(void);
 
 #ifdef CONFIG_MMU
-extern void __init vmalloc_init(void);
 extern unsigned long vmalloc_nr_pages(void);
 #else
-static inline void vmalloc_init(void)
-{
-}
 static inline unsigned long vmalloc_nr_pages(void) { return 0; }
 #endif
 
--- a/mm/internal.h~mm-move-vmalloc_init-declaration-to-mm-internalh
+++ a/mm/internal.h
@@ -900,9 +900,14 @@ size_t splice_folio_into_pipe(struct pip
  * mm/vmalloc.c
  */
 #ifdef CONFIG_MMU
+void __init vmalloc_init(void);
 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
                 pgprot_t prot, struct page **pages, unsigned int page_shift);
 #else
+static inline void vmalloc_init(void)
+{
+}
+
 static inline
 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
                 pgprot_t prot, struct page **pages, unsigned int page_shift)
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


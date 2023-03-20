Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4926C6FD1C
	for <mm-commits@archiver.kernel.org>; Mon, 20 Mar 2023 22:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjCTWMb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Mar 2023 18:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjCTWMY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Mar 2023 18:12:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD13CF979
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 15:11:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11835B810FE
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 22:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1817C433EF;
        Mon, 20 Mar 2023 22:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679350315;
        bh=CaWzUoJTeTbqjlonXRhaia/hxPua3eveziRgKwMgwsU=;
        h=Date:To:From:Subject:From;
        b=HwvkHUPDltT2xe7j2auWrLCDzLLQNubfb3h/sJRIh3ufblyEOnxzd8AN0aR90OwoL
         V0BIJ99NqpVCXa60mpSoEKhkjdxWyXSsQGYIb4WwfiF4SNmEMNNEgLX4/RDn2Pejt6
         jbpLNOavDaTSldWFM885wiyR6IJgSU233p6ljtrs=
Date:   Mon, 20 Mar 2023 15:11:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, mhocko@kernel.org, mgorman@suse.de,
        david@redhat.com, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-kmem_cache_init-declaration-to-mm-slabh.patch added to mm-unstable branch
Message-Id: <20230320221155.B1817C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move kmem_cache_init() declaration to mm/slab.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-kmem_cache_init-declaration-to-mm-slabh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-kmem_cache_init-declaration-to-mm-slabh.patch

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
Subject: mm: move kmem_cache_init() declaration to mm/slab.h
Date: Mon, 20 Mar 2023 00:00:06 +0200

kmem_cache_init() is called only from mm_core_init(), there is no need to
declare it in include/linux/slab.h

Move kmem_cache_init() declaration to mm/slab.h

Link: https://lkml.kernel.org/r/20230319220008.2138576-14-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/slab.h~mm-move-kmem_cache_init-declaration-to-mm-slabh
+++ a/include/linux/slab.h
@@ -167,7 +167,6 @@ struct mem_cgroup;
 /*
  * struct kmem_cache related prototypes
  */
-void __init kmem_cache_init(void);
 bool slab_is_available(void);
 
 struct kmem_cache *kmem_cache_create(const char *name, unsigned int size,
--- a/mm/mm_init.c~mm-move-kmem_cache_init-declaration-to-mm-slabh
+++ a/mm/mm_init.c
@@ -27,6 +27,7 @@
 #include <linux/swap.h>
 #include <linux/cma.h>
 #include "internal.h"
+#include "slab.h"
 #include "shuffle.h"
 
 #include <asm/setup.h>
--- a/mm/slab.h~mm-move-kmem_cache_init-declaration-to-mm-slabh
+++ a/mm/slab.h
@@ -4,6 +4,7 @@
 /*
  * Internal slab definitions
  */
+void __init kmem_cache_init(void);
 
 /* Reuses the bits in struct page */
 struct slab {
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


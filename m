Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD50C6FD1D
	for <mm-commits@archiver.kernel.org>; Mon, 20 Mar 2023 22:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjCTWM2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Mar 2023 18:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjCTWMX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Mar 2023 18:12:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FEB3646E
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 15:11:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A6B4B81100
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 22:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DE8C433D2;
        Mon, 20 Mar 2023 22:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679350310;
        bh=XySKT1UgJrtFpNj6dHeG2Sz9S5wkznJ8t07luk0nDb8=;
        h=Date:To:From:Subject:From;
        b=LYJQzPj9gCRWQIXMfhxTkYUj84WMUOTOL5inXpztLF+CLJPLBw4y7pKdaVgwgpRsB
         VcDz4Rms0TpeSRjXpXq35Gz4tjZ4RtUQwpVYoHveEtOQn5wbezJQ/YrE8MTHCB7Z9X
         SHt/3i3uiW8bpmNh5QkpH6Ux0qXh5DdAztaURz7A=
Date:   Mon, 20 Mar 2023 15:11:50 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, mhocko@kernel.org, mgorman@suse.de,
        david@redhat.com, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + initmm-fold-late-call-to-page_ext_init-to-page_alloc_init_late.patch added to mm-unstable branch
Message-Id: <20230320221150.B2DE8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init,mm: fold late call to page_ext_init() to page_alloc_init_late()
has been added to the -mm mm-unstable branch.  Its filename is
     initmm-fold-late-call-to-page_ext_init-to-page_alloc_init_late.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/initmm-fold-late-call-to-page_ext_init-to-page_alloc_init_late.patch

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
Subject: init,mm: fold late call to page_ext_init() to page_alloc_init_late()
Date: Mon, 20 Mar 2023 00:00:04 +0200

When deferred initialization of struct pages is enabled, page_ext_init()
must be called after all the deferred initialization is done, but there is
no point to keep it a separate call from kernel_init_freeable() right
after page_alloc_init_late().

Fold the call to page_ext_init() into page_alloc_init_late() and localize
deferred_struct_pages variable.

Link: https://lkml.kernel.org/r/20230319220008.2138576-12-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/page_ext.h~initmm-fold-late-call-to-page_ext_init-to-page_alloc_init_late
+++ a/include/linux/page_ext.h
@@ -29,8 +29,6 @@ struct page_ext_operations {
 	bool need_shared_flags;
 };
 
-extern bool deferred_struct_pages;
-
 #ifdef CONFIG_PAGE_EXTENSION
 
 /*
--- a/init/main.c~initmm-fold-late-call-to-page_ext_init-to-page_alloc_init_late
+++ a/init/main.c
@@ -62,7 +62,6 @@
 #include <linux/rmap.h>
 #include <linux/mempolicy.h>
 #include <linux/key.h>
-#include <linux/page_ext.h>
 #include <linux/debug_locks.h>
 #include <linux/debugobjects.h>
 #include <linux/lockdep.h>
@@ -1561,9 +1560,6 @@ static noinline void __init kernel_init_
 
 	padata_init();
 	page_alloc_init_late();
-	/* Initialize page ext after all struct pages are initialized. */
-	if (deferred_struct_pages)
-		page_ext_init();
 
 	do_basic_setup();
 
--- a/mm/mm_init.c~initmm-fold-late-call-to-page_ext_init-to-page_alloc_init_late
+++ a/mm/mm_init.c
@@ -225,7 +225,7 @@ static unsigned long nr_kernel_pages __i
 static unsigned long nr_all_pages __initdata;
 static unsigned long dma_reserve __initdata;
 
-bool deferred_struct_pages __meminitdata;
+static bool deferred_struct_pages __meminitdata;
 
 static DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
 
@@ -2338,6 +2338,10 @@ void __init page_alloc_init_late(void)
 
 	for_each_populated_zone(zone)
 		set_zone_contiguous(zone);
+
+	/* Initialize page ext after all struct pages are initialized. */
+	if (deferred_struct_pages)
+		page_ext_init();
 }
 
 #ifndef __HAVE_ARCH_RESERVED_KERNEL_PAGES
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


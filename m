Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77769C761A6
	for <mm-commits@archiver.kernel.org>; Mon, 20 Mar 2023 22:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjCTWMZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Mar 2023 18:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCTWMQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Mar 2023 18:12:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079E43608F
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 15:11:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 801FF61856
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 22:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EFEC433EF;
        Mon, 20 Mar 2023 22:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679350301;
        bh=Cc15lFKCHXtIOJYLzaVYZMBiWzbXisjE2gLSDNTPQfw=;
        h=Date:To:From:Subject:From;
        b=C0qbtH1XjU1NGgpFLTxn3VYrgpvkaqqnguH5dccF7+EboBtOSC9DvnRwWCurGxBsK
         Vs6oRupW6qSWqR3MsJrgr/K2srNulCdIQfQ6Mxs6Doqz+6xbo6ieY7C7OHdag5QBkQ
         CTxhSwzZVmIEmGp2pzBPqQV8oVgUUBlHgqnWmPr0=
Date:   Mon, 20 Mar 2023 15:11:41 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, mhocko@kernel.org, mgorman@suse.de,
        david@redhat.com, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + init-fold-build_all_zonelists-and-page_alloc_init_cpuhp-to-mm_init.patch added to mm-unstable branch
Message-Id: <20230320221141.D3EFEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init: fold build_all_zonelists() and page_alloc_init_cpuhp() to mm_init()
has been added to the -mm mm-unstable branch.  Its filename is
     init-fold-build_all_zonelists-and-page_alloc_init_cpuhp-to-mm_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-fold-build_all_zonelists-and-page_alloc_init_cpuhp-to-mm_init.patch

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
Subject: init: fold build_all_zonelists() and page_alloc_init_cpuhp() to mm_init()
Date: Mon, 20 Mar 2023 00:00:00 +0200

Both build_all_zonelists() and page_alloc_init_cpuhp() must be called
after SMP setup is complete but before the page allocator is set up.

Still, they both are a part of memory management initialization, so move
them to mm_init().

Link: https://lkml.kernel.org/r/20230319220008.2138576-8-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/init/main.c~init-fold-build_all_zonelists-and-page_alloc_init_cpuhp-to-mm_init
+++ a/init/main.c
@@ -833,6 +833,10 @@ static void __init report_meminit(void)
  */
 static void __init mm_init(void)
 {
+	/* Initializations relying on SMP setup */
+	build_all_zonelists(NULL);
+	page_alloc_init_cpuhp();
+
 	/*
 	 * page_ext requires contiguous pages,
 	 * bigger than MAX_ORDER unless SPARSEMEM.
@@ -968,9 +972,6 @@ asmlinkage __visible void __init __no_sa
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 	boot_cpu_hotplug_init();
 
-	build_all_zonelists(NULL);
-	page_alloc_init_cpuhp();
-
 	pr_notice("Kernel command line: %s\n", saved_command_line);
 	/* parameters may set static keys */
 	jump_label_init();
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


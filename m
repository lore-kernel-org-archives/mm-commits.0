Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C30C6FD1C
	for <mm-commits@archiver.kernel.org>; Mon, 20 Mar 2023 22:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjCTWMK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Mar 2023 18:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjCTWMJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Mar 2023 18:12:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66AA22E809
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 15:11:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E54AAB81103
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 22:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943C8C433D2;
        Mon, 20 Mar 2023 22:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679350297;
        bh=+Qu40IzZGr2Czc2Gp7CSXIeyETrbdE3nLz4kffubWfo=;
        h=Date:To:From:Subject:From;
        b=jezsHEBuoDMikUHUg7/sWb6vzt4oLJaYBb9oZFEJ+n6QYOQO9R7YDkTviqf6+Krw0
         mXDpoBOQWOchZ1A2Wk3kAXt/iafPFJ/Gh2HoW/TwC/Dqf0EdMZyoxedvMqdYhG8vGW
         Cz3mgoq3wPcNgW+fQh2B2mP0LqFGbWFBs+F70Op8=
Date:   Mon, 20 Mar 2023 15:11:36 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, mhocko@kernel.org, mgorman@suse.de,
        david@redhat.com, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handle-hashdist-initialization-in-mm-mm_initc.patch added to mm-unstable branch
Message-Id: <20230320221137.943C8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: handle hashdist initialization in mm/mm_init.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-handle-hashdist-initialization-in-mm-mm_initc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-handle-hashdist-initialization-in-mm-mm_initc.patch

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
Subject: mm: handle hashdist initialization in mm/mm_init.c
Date: Sun, 19 Mar 2023 23:59:58 +0200

The hashdist variable must be initialized before the first call to
alloc_large_system_hash() and free_area_init() looks like a better place
for it than page_alloc_init().

Move hashdist handling to mm/mm_init.c

Link: https://lkml.kernel.org/r/20230319220008.2138576-6-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mm_init.c~mm-handle-hashdist-initialization-in-mm-mm_initc
+++ a/mm/mm_init.c
@@ -607,6 +607,25 @@ int __meminit early_pfn_to_nid(unsigned
 
 	return nid;
 }
+
+int hashdist = HASHDIST_DEFAULT;
+
+static int __init set_hashdist(char *str)
+{
+	if (!str)
+		return 0;
+	hashdist = simple_strtoul(str, &str, 0);
+	return 1;
+}
+__setup("hashdist=", set_hashdist);
+
+static inline void fixup_hashdist(void)
+{
+	if (num_node_state(N_MEMORY) == 1)
+		hashdist = 0;
+}
+#else
+static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
@@ -1855,6 +1874,9 @@ void __init free_area_init(unsigned long
 	}
 
 	memmap_init();
+
+	/* disable hash distribution for systems with a single node */
+	fixup_hashdist();
 }
 
 /**
--- a/mm/page_alloc.c~mm-handle-hashdist-initialization-in-mm-mm_initc
+++ a/mm/page_alloc.c
@@ -6390,28 +6390,10 @@ static int page_alloc_cpu_online(unsigne
 	return 0;
 }
 
-#ifdef CONFIG_NUMA
-int hashdist = HASHDIST_DEFAULT;
-
-static int __init set_hashdist(char *str)
-{
-	if (!str)
-		return 0;
-	hashdist = simple_strtoul(str, &str, 0);
-	return 1;
-}
-__setup("hashdist=", set_hashdist);
-#endif
-
 void __init page_alloc_init(void)
 {
 	int ret;
 
-#ifdef CONFIG_NUMA
-	if (num_node_state(N_MEMORY) == 1)
-		hashdist = 0;
-#endif
-
 	ret = cpuhp_setup_state_nocalls(CPUHP_PAGE_ALLOC,
 					"mm/page_alloc:pcp",
 					page_alloc_cpu_online,
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


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21086C6FD20
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 19:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjCUTjb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 15:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjCUTjT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 15:39:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273FF1ACF1
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 12:38:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB173B81985
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 19:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626F3C433D2;
        Tue, 21 Mar 2023 19:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679427431;
        bh=+C6qmidJGVm3/AhnA3ra93yyPVLhvsZtTxPET8m1uFY=;
        h=Date:To:From:Subject:From;
        b=Inu+56UW/iTTivhK2FkGT+Ct4zXDjIX7jEv1jF8Ph045GkkQdYQDbXUb0J50UmU9i
         M3dkOE5tuHXvlnRlWOc13K7bn6FxgZ36yH0oURFsCC3+TF40VNWfQ4pjNhK3+ZLpkE
         mRuH5bWAxJmqDPmGt+7yqKF6FPLsSvExbMcOKChU=
Date:   Tue, 21 Mar 2023 12:37:10 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, opendmb@gmail.com, mhocko@kernel.org,
        mgorman@suse.de, david@redhat.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handle-hashdist-initialization-in-mm-mm_initc.patch added to mm-unstable branch
Message-Id: <20230321193711.626F3C433D2@smtp.kernel.org>
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
Date: Tue, 21 Mar 2023 19:05:03 +0200

The hashdist variable must be initialized before the first call to
alloc_large_system_hash() and free_area_init() looks like a better place
for it than page_alloc_init().

Move hashdist handling to mm/mm_init.c

Link: https://lkml.kernel.org/r/20230321170513.2401534-5-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c    |   22 ++++++++++++++++++++++
 mm/page_alloc.c |   18 ------------------
 2 files changed, 22 insertions(+), 18 deletions(-)

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
@@ -6383,28 +6383,10 @@ static int page_alloc_cpu_online(unsigne
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


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D9FFC6FD20
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 19:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjCUTjC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 15:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjCUTiv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 15:38:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7F2303F4
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 12:38:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF8A2B8198B
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 19:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AACC433D2;
        Tue, 21 Mar 2023 19:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679427433;
        bh=M2r9YxSgdxs9cp4eUTyPK5GNJCUeGTUtd4eq70fn2uk=;
        h=Date:To:From:Subject:From;
        b=EdcpOy0oS5BahwFhxebAJTWTk9ie3+sEYxytOaiQCa/GExf8DYxzYZwOG01uYCCZi
         JiB7VEQRNU7HkfINYtvL2tc1jCl7nxweLp9v247F3I2DePEd5FLFp2F1hfcN2KRmzM
         TuOqY6UHS5kLMyfPnHfuwXsFh7BwUyknjgQ7ZElU=
Date:   Tue, 21 Mar 2023 12:37:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, opendmb@gmail.com, mhocko@kernel.org,
        mgorman@suse.de, david@redhat.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-rename-page_alloc_init-to-page_alloc_init_cpuhp.patch added to mm-unstable branch
Message-Id: <20230321193713.75AACC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: rename page_alloc_init() to page_alloc_init_cpuhp()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-rename-page_alloc_init-to-page_alloc_init_cpuhp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-rename-page_alloc_init-to-page_alloc_init_cpuhp.patch

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
Subject: mm/page_alloc: rename page_alloc_init() to page_alloc_init_cpuhp()
Date: Tue, 21 Mar 2023 19:05:04 +0200

The page_alloc_init() name is really misleading because all this function
does is sets up CPU hotplug callbacks for the page allocator.

Rename it to page_alloc_init_cpuhp() so that name will reflect what the
function does.

Link: https://lkml.kernel.org/r/20230321170513.2401534-6-rppt@kernel.org
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

 include/linux/gfp.h |    2 +-
 init/main.c         |    2 +-
 mm/page_alloc.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/gfp.h~mm-page_alloc-rename-page_alloc_init-to-page_alloc_init_cpuhp
+++ a/include/linux/gfp.h
@@ -319,7 +319,7 @@ extern void page_frag_free(void *addr);
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)
 
-void page_alloc_init(void);
+void page_alloc_init_cpuhp(void);
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
 void drain_all_pages(struct zone *zone);
 void drain_local_pages(struct zone *zone);
--- a/init/main.c~mm-page_alloc-rename-page_alloc_init-to-page_alloc_init_cpuhp
+++ a/init/main.c
@@ -969,7 +969,7 @@ asmlinkage __visible void __init __no_sa
 	boot_cpu_hotplug_init();
 
 	build_all_zonelists(NULL);
-	page_alloc_init();
+	page_alloc_init_cpuhp();
 
 	pr_notice("Kernel command line: %s\n", saved_command_line);
 	/* parameters may set static keys */
--- a/mm/page_alloc.c~mm-page_alloc-rename-page_alloc_init-to-page_alloc_init_cpuhp
+++ a/mm/page_alloc.c
@@ -6383,7 +6383,7 @@ static int page_alloc_cpu_online(unsigne
 	return 0;
 }
 
-void __init page_alloc_init(void)
+void __init page_alloc_init_cpuhp(void)
 {
 	int ret;
 
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


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC252C761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbjDFCrS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbjDFCpT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:45:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5198C93C3
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2FF464217
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4330AC433D2;
        Thu,  6 Apr 2023 02:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749113;
        bh=sL8aeIpg6/8t2V3IVJbsYMeoE6uwcUAZ0oZKvZG/pN4=;
        h=Date:To:From:Subject:From;
        b=CwCsiE6OYQPz3vNbbnmTlT1z0AR4Aea6omf/xL25VKbLLJT+5r6gT7hfYji0tSyKL
         npaa5EwuGpiVog2s61qqktVgybhQnr9HSDFTh0uMJ7LyNa5WLktR7HbF7KQvxfge+q
         pu6qjcXIoIR82lP5B4l+fH3FPlVKlqF7H0dWWWco=
Date:   Wed, 05 Apr 2023 19:45:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, opendmb@gmail.com, mhocko@kernel.org,
        mgorman@suse.de, david@redhat.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-rename-page_alloc_init-to-page_alloc_init_cpuhp.patch removed from -mm tree
Message-Id: <20230406024513.4330AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: rename page_alloc_init() to page_alloc_init_cpuhp()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-rename-page_alloc_init-to-page_alloc_init_cpuhp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
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
@@ -973,7 +973,7 @@ asmlinkage __visible void __init __no_sa
 	boot_cpu_hotplug_init();
 
 	build_all_zonelists(NULL);
-	page_alloc_init();
+	page_alloc_init_cpuhp();
 
 	pr_notice("Kernel command line: %s\n", saved_command_line);
 	/* parameters may set static keys */
--- a/mm/page_alloc.c~mm-page_alloc-rename-page_alloc_init-to-page_alloc_init_cpuhp
+++ a/mm/page_alloc.c
@@ -6393,7 +6393,7 @@ static int page_alloc_cpu_online(unsigne
 	return 0;
 }
 
-void __init page_alloc_init(void)
+void __init page_alloc_init_cpuhp(void)
 {
 	int ret;
 
_

Patches currently in -mm which might be from rppt@kernel.org are

arm-reword-arch_force_max_order-prompt-and-help-text.patch
arm64-drop-ranges-in-definition-of-arch_force_max_order.patch
arm64-reword-arch_force_max_order-prompt-and-help-text.patch
arm64-reword-arch_force_max_order-prompt-and-help-text-v3.patch
csky-drop-arch_force_max_order.patch
ia64-dont-allow-users-to-override-arch_force_max_order.patch
m68k-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-drop-ranges-for-definition-of-arch_force_max_order.patch
powerpc-reword-arch_force_max_order-prompt-and-help-text.patch
powerpc-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-reword-arch_force_max_order-prompt-and-help-text.patch
sh-reword-arch_force_max_order-prompt-and-help-text-v3.patch
sh-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-drop-ranges-for-definition-of-arch_force_max_order-v3.patch
sparc-reword-arch_force_max_order-prompt-and-help-text.patch
xtensa-reword-arch_force_max_order-prompt-and-help-text.patch
mm-move-free_area_empty-to-mm-internalh.patch


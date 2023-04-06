Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E272C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbjDFCr2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbjDFCpg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:45:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BD4974F
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D35046417C
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356C6C433D2;
        Thu,  6 Apr 2023 02:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749117;
        bh=jP60eN4tGWAGx2am9u3FlyJnmDAMkGthUBvPrQPGopc=;
        h=Date:To:From:Subject:From;
        b=VEvfX/p/CHcn4aevkRoOu/RgP5O3XCVWZ8aOS/YCTnsEFLSdskmVB/bynDmJwKOr/
         TjtlPyxOKzkO0RF+Eq5SnwmDHDB7LiRTpbHfd6sTsxuAKDYs0FHV3YuWM+JQQcsmXB
         11iotCtO0cR9bC8WC4i/fqiISsZmRXZWybU4Rv1k=
Date:   Wed, 05 Apr 2023 19:45:16 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, sergei.shtylyov@gmail.com,
        opendmb@gmail.com, mhocko@kernel.org, mgorman@suse.de,
        david@redhat.com, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-call-ptlockpgtable_cache_init-directly-from-mm_core_init.patch removed from -mm tree
Message-Id: <20230406024517.356C6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: call {ptlock,pgtable}_cache_init() directly from mm_core_init()
has been removed from the -mm tree.  Its filename was
     mm-call-ptlockpgtable_cache_init-directly-from-mm_core_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mm: call {ptlock,pgtable}_cache_init() directly from mm_core_init()
Date: Tue, 21 Mar 2023 19:05:07 +0200

and drop pgtable_init() as it has no real value and its name is
misleading.

Link: https://lkml.kernel.org/r/20230321170513.2401534-9-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ------
 mm/mm_init.c       |    3 ++-
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-call-ptlockpgtable_cache_init-directly-from-mm_core_init
+++ a/include/linux/mm.h
@@ -2637,12 +2637,6 @@ static inline bool ptlock_init(struct pa
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


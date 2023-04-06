Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5EDEC7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbjDFCrp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234912AbjDFCqK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:46:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF7A9754
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 209A564217
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF4CC433EF;
        Thu,  6 Apr 2023 02:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749123;
        bh=li7CGVhsk9a7BegkEZ/E7QTqcVX07tSTPq42BXC0rS8=;
        h=Date:To:From:Subject:From;
        b=1w+rVd9pFKHNcNV3TMwuBMe5yCF33YjquVazqKZKhWKX96xON5mm6mUcBhGasVhDk
         FL8vBFdAuusvu6JljzWMhKJnCP/STbyYsheAvuusEbfLrmaaqCCxd6r5oKanqoKgVL
         +EHlKYgu0y68itbPjCKR83Lf4u54Pj6qJlO0TNVE=
Date:   Wed, 05 Apr 2023 19:45:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, opendmb@gmail.com, mhocko@kernel.org,
        mgorman@suse.de, david@redhat.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-vmalloc_init-declaration-to-mm-internalh.patch removed from -mm tree
Message-Id: <20230406024523.7AF4CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: move vmalloc_init() declaration to mm/internal.h
has been removed from the -mm tree.  Its filename was
     mm-move-vmalloc_init-declaration-to-mm-internalh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
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
@@ -879,9 +879,14 @@ size_t splice_folio_into_pipe(struct pip
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


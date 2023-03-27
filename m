Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B9FAC6FD1D
	for <mm-commits@archiver.kernel.org>; Mon, 27 Mar 2023 20:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjC0UaJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Mar 2023 16:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjC0UaI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Mar 2023 16:30:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F31926A2
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 13:30:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A75AB818FF
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 20:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC757C433EF;
        Mon, 27 Mar 2023 20:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679949005;
        bh=2YBaE4yBp4OPBlY8ecViOswik78UoED3alzBNZmPkzM=;
        h=Date:To:From:Subject:From;
        b=1gwNFO+0Vjij3DtCa1/myT7/0WmzNqyBnKBkcpAe338J3OrIBMDXiaoHPZ7M15ywK
         FB5ARrRJlSEuwnQlbmfA0ZtsMxyGYL4wkGvfDdzQKPz/DzHB8IaJKiUSzDapqLBiir
         O8Zov0Tpz66BGW4ulepBW8MAg5ofrHsSYH8NSkVM=
Date:   Mon, 27 Mar 2023 13:30:04 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-free_area_empty-to-mm-internalh.patch added to mm-unstable branch
Message-Id: <20230327203004.EC757C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move free_area_empty() to mm/internal.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-free_area_empty-to-mm-internalh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-free_area_empty-to-mm-internalh.patch

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
Subject: mm: move free_area_empty() to mm/internal.h
Date: Sun, 26 Mar 2023 19:02:15 +0300

The free_area_empty() helper is only used inside mm/ so move it there to
reduce noise in include/linux/mmzone.h

Link: https://lkml.kernel.org/r/20230326160215.2674531-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 -----
 mm/internal.h          |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/mmzone.h~mm-move-free_area_empty-to-mm-internalh
+++ a/include/linux/mmzone.h
@@ -110,11 +110,6 @@ struct free_area {
 	unsigned long		nr_free;
 };
 
-static inline bool free_area_empty(struct free_area *area, int migratetype)
-{
-	return list_empty(&area->free_list[migratetype]);
-}
-
 struct pglist_data;
 
 #ifdef CONFIG_NUMA
--- a/mm/internal.h~mm-move-free_area_empty-to-mm-internalh
+++ a/mm/internal.h
@@ -517,6 +517,11 @@ void init_cma_reserved_pageblock(struct
 int find_suitable_fallback(struct free_area *area, unsigned int order,
 			int migratetype, bool only_stealable, bool *can_steal);
 
+static inline bool free_area_empty(struct free_area *area, int migratetype)
+{
+	return list_empty(&area->free_list[migratetype]);
+}
+
 /*
  * These three helpers classifies VMAs for virtual memory accounting.
  */
_

Patches currently in -mm which might be from rppt@kernel.org are

loongarch-drop-ranges-for-definition-of-arch_force_max_order.patch
mips-drop-ranges-for-definition-of-arch_force_max_order.patch
mm-move-get_page_from_free_area-to-mm-page_allocc.patch
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


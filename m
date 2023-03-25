Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE0DC6FD1C
	for <mm-commits@archiver.kernel.org>; Sat, 25 Mar 2023 18:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjCYSqC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Mar 2023 14:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjCYSqB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 25 Mar 2023 14:46:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8414CEC69
        for <mm-commits@vger.kernel.org>; Sat, 25 Mar 2023 11:46:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22D8260AE7
        for <mm-commits@vger.kernel.org>; Sat, 25 Mar 2023 18:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B76C433D2;
        Sat, 25 Mar 2023 18:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679769959;
        bh=OBbLwTgr8FzG6fZdKLpQ853gPpeWOobtl/uEzi/EF6o=;
        h=Date:To:From:Subject:From;
        b=Zba00Pqey8b95mkW6so6M51w3IG3wsd6memVddiKvdqO2fyrvYjMbfH6Ntyd6+RUo
         hJomNJtFSKXHCZ+I2gkEyhPr9iNeMmV9UYnUIdxoXI9V/UbGzxVv3cgnWgjLnZnsuV
         h9WUj9hJNv5X6UYQm+hh8xi8N36LVilH4vEOTX4o=
Date:   Sat, 25 Mar 2023 11:45:58 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-reword-arch_force_max_order-prompt-and-help-text-v3.patch added to mm-unstable branch
Message-Id: <20230325184559.72B76C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sh-reword-arch_force_max_order-prompt-and-help-text-v3
has been added to the -mm mm-unstable branch.  Its filename is
     sh-reword-arch_force_max_order-prompt-and-help-text-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-reword-arch_force_max_order-prompt-and-help-text-v3.patch

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
Subject: sh-reword-arch_force_max_order-prompt-and-help-text-v3
Date: Sat, 25 Mar 2023 09:08:25 +0300

tweak ARCH_FORCE_MAX_ORDER's `range'

Link: https://lkml.kernel.org/r/20230325060828.2662773-12-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sh/mm/Kconfig~sh-reword-arch_force_max_order-prompt-and-help-text-v3
+++ a/arch/sh/mm/Kconfig
@@ -20,6 +20,7 @@ config PAGE_OFFSET
 
 config ARCH_FORCE_MAX_ORDER
 	int "Order of maximal physically contiguous allocations"
+	range 8 63 if PAGE_SIZE_16KB
 	default "8" if PAGE_SIZE_16KB
 	range 6 63 if PAGE_SIZE_64KB
 	default "6" if PAGE_SIZE_64KB
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


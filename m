Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D33D9C6FD1C
	for <mm-commits@archiver.kernel.org>; Wed, 22 Mar 2023 23:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjCVXJx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Mar 2023 19:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjCVXJw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Mar 2023 19:09:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5574EF967
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 16:09:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10717B81D84
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 23:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54B3C433D2;
        Wed, 22 Mar 2023 23:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679526588;
        bh=glvHfsFtxLR82yjlTf2C44f/EcJZixdyd1mtQYyrwa4=;
        h=Date:To:From:Subject:From;
        b=cKDwubvNU82dBSYsJdCL25NKN5ygJIdWd+io/YPnBoLZ+0YQhrBFnqtTxBCvSW522
         2se1OpN59ud+HSLiwKjeZl1qnG+ug7SlSeIQDTcGn4LLugxVo5//QRKs88J8aH9iPn
         l+jSxX7sd3hByZfCmCecGcFG7leMxoHO3dJ9izCA=
Date:   Wed, 22 Mar 2023 16:09:47 -0700
To:     mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com,
        kernel@xen0n.name, david@redhat.com, chenhuacai@kernel.org,
        rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + loongarch-drop-ranges-for-definition-of-arch_force_max_order.patch added to mm-unstable branch
Message-Id: <20230322230948.A54B3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: loongarch: drop ranges for definition of ARCH_FORCE_MAX_ORDER
has been added to the -mm mm-unstable branch.  Its filename is
     loongarch-drop-ranges-for-definition-of-arch_force_max_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/loongarch-drop-ranges-for-definition-of-arch_force_max_order.patch

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
Subject: loongarch: drop ranges for definition of ARCH_FORCE_MAX_ORDER
Date: Wed, 22 Mar 2023 10:17:27 +0200

LoongArch defines insane ranges for ARCH_FORCE_MAX_ORDER allowing
MAX_ORDER up to 63, which implies maximal contiguous allocation size of
2^63 pages.

Drop bogus definitions of ranges for ARCH_FORCE_MAX_ORDER and leave it a
simple integer with sensible defaults.

Users that *really* need to change the value of ARCH_FORCE_MAX_ORDER will
be able to do so but they won't be mislead by the bogus ranges.

Link: https://lkml.kernel.org/r/20230322081727.2516291-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/loongarch/Kconfig~loongarch-drop-ranges-for-definition-of-arch_force_max_order
+++ a/arch/loongarch/Kconfig
@@ -420,11 +420,8 @@ config NODES_SHIFT
 
 config ARCH_FORCE_MAX_ORDER
 	int "Maximum zone order"
-	range 13 63 if PAGE_SIZE_64KB
 	default "13" if PAGE_SIZE_64KB
-	range 11 63 if PAGE_SIZE_16KB
 	default "11" if PAGE_SIZE_16KB
-	range 10 63
 	default "10"
 	help
 	  The kernel memory allocator divides physically contiguous memory
_

Patches currently in -mm which might be from rppt@kernel.org are

loongarch-drop-ranges-for-definition-of-arch_force_max_order.patch
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


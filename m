Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A7E5C6FD1C
	for <mm-commits@archiver.kernel.org>; Fri, 24 Mar 2023 20:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbjCXUcm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Mar 2023 16:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbjCXUci (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Mar 2023 16:32:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F404D1BADE
        for <mm-commits@vger.kernel.org>; Fri, 24 Mar 2023 13:32:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9266D62CAD
        for <mm-commits@vger.kernel.org>; Fri, 24 Mar 2023 20:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EFCC433EF;
        Fri, 24 Mar 2023 20:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679689956;
        bh=sMmUTfdZDflSmh+lo7aeFgDMdpZ7Nzx7ila0yHzc3O4=;
        h=Date:To:From:Subject:From;
        b=pskfevX7wxW3VJpttUrNQPBQ/HsgVcT7RocIVuac7waOjrJShIUPAitLRHKnbqbZB
         Xue7NV96XzafAqPiBA6Ktgz+c67faz/pXLKDCA32onkr57oUNTgbI5APOUy4oQZVs9
         bvcfK7kKyanizFbdpZmweoC7GQyHhVc7dPmCZx/g=
Date:   Fri, 24 Mar 2023 13:32:35 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        ysato@users.sourceforge.jp, will@kernel.org, mpe@ellerman.id.au,
        linux@armlinux.org.uk, kirill.shutemov@linux.intel.com,
        jcmvbkbc@gmail.com, guoren@kernel.org,
        glaubitz@physik.fu-berlin.de, geert@linux-m68k.org,
        dinguyen@kernel.org, davem@davemloft.net, dalias@libc.org,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        arnd@arndb.de, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + m68k-reword-arch_force_max_order-prompt-and-help-text.patch added to mm-unstable branch
Message-Id: <20230324203235.E5EFCC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: reword ARCH_FORCE_MAX_ORDER prompt and help text
has been added to the -mm mm-unstable branch.  Its filename is
     m68k-reword-arch_force_max_order-prompt-and-help-text.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/m68k-reword-arch_force_max_order-prompt-and-help-text.patch

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
Subject: m68k: reword ARCH_FORCE_MAX_ORDER prompt and help text
Date: Fri, 24 Mar 2023 08:22:25 +0300

The prompt and help text of ARCH_FORCE_MAX_ORDER are not even close to
describe this configuration option.

Update both to actually describe what this option does.

Link: https://lkml.kernel.org/r/20230324052233.2654090-7-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Rich Felker <dalias@libc.org>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/Kconfig.cpu |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/arch/m68k/Kconfig.cpu~m68k-reword-arch_force_max_order-prompt-and-help-text
+++ a/arch/m68k/Kconfig.cpu
@@ -398,21 +398,23 @@ config SINGLE_MEMORY_CHUNK
 	  Say N if not sure.
 
 config ARCH_FORCE_MAX_ORDER
-	int "Maximum zone order" if ADVANCED
+	int "Order of maximal physically contiguous allocations" if ADVANCED
 	depends on !SINGLE_MEMORY_CHUNK
 	default "10"
 	help
-	  The kernel memory allocator divides physically contiguous memory
-	  blocks into "zones", where each zone is a power of two number of
-	  pages.  This option selects the largest power of two that the kernel
-	  keeps in the memory allocator.  If you need to allocate very large
-	  blocks of physically contiguous memory, then you may need to
-	  increase this value.
+	  The kernel page allocator limits the size of maximal physically
+	  contiguous allocations. The limit is called MAX_ORDER and it
+	  defines the maximal power of two of number of pages that can be
+	  allocated as a single contiguous block. This option allows
+	  overriding the default setting when ability to allocate very
+	  large blocks of physically contiguous memory is required.
 
 	  For systems that have holes in their physical address space this
 	  value also defines the minimal size of the hole that allows
 	  freeing unused memory map.
 
+	  Don't change if unsure.
+
 config 060_WRITETHROUGH
 	bool "Use write-through caching for 68060 supervisor accesses"
 	depends on ADVANCED && M68060
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
csky-drop-arch_force_max_order.patch
ia64-dont-allow-users-to-override-arch_force_max_order.patch
m68k-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-drop-ranges-for-definition-of-arch_force_max_order.patch
powerpc-reword-arch_force_max_order-prompt-and-help-text.patch
powerpc-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-reword-arch_force_max_order-prompt-and-help-text.patch
sh-drop-ranges-for-definition-of-arch_force_max_order.patch
sparc-reword-arch_force_max_order-prompt-and-help-text.patch
xtensa-reword-arch_force_max_order-prompt-and-help-text.patch


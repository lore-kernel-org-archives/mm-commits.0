Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35050C77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbjDRXdx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbjDRXdp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D657AA1
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F728639E9
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE24C433EF;
        Tue, 18 Apr 2023 23:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860822;
        bh=pMpAgdIcBMwlDDk4Gx/yheXq8jLToq0TxWIv5NNxffI=;
        h=Date:To:From:Subject:From;
        b=gYi0BG6nOpjpITqHNWgLSdWN+uf9/xxI97muDWhP63J+fEFdE8cBmvUm9nb5hAvbj
         xhhLcJCrDFGbHj1uiEuxWHFe0ZHS6gtTV/pTSAMEQ5hOJSLEyqzIJU9M6zfBdcm7TR
         Pbhui78jMZiv3qMRc70v90r5WkgTTjkmucTVYZg0=
Date:   Tue, 18 Apr 2023 16:33:42 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        ysato@users.sourceforge.jp, will@kernel.org, mpe@ellerman.id.au,
        linux@armlinux.org.uk, kirill.shutemov@linux.intel.com,
        jcmvbkbc@gmail.com, guoren@kernel.org,
        glaubitz@physik.fu-berlin.de, geert@linux-m68k.org,
        dinguyen@kernel.org, davem@davemloft.net, dalias@libc.org,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        arnd@arndb.de, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-drop-ranges-for-definition-of-arch_force_max_order.patch removed from -mm tree
Message-Id: <20230418233342.BFE24C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc: drop ranges for definition of ARCH_FORCE_MAX_ORDER
has been removed from the -mm tree.  Its filename was
     powerpc-drop-ranges-for-definition-of-arch_force_max_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: powerpc: drop ranges for definition of ARCH_FORCE_MAX_ORDER
Date: Fri, 24 Mar 2023 08:22:29 +0300

PowerPC defines ranges for ARCH_FORCE_MAX_ORDER some of which are insanely
allowing MAX_ORDER up to 63, which implies maximal contiguous allocation
size of 2^63 pages.

Drop bogus definitions of ranges for ARCH_FORCE_MAX_ORDER and leave it a
simple integer with sensible defaults.

Users that *really* need to change the value of ARCH_FORCE_MAX_ORDER will
be able to do so but they won't be mislead by the bogus ranges.

Link: https://lkml.kernel.org/r/20230324052233.2654090-11-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
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

 arch/powerpc/Kconfig |    6 ------
 1 file changed, 6 deletions(-)

--- a/arch/powerpc/Kconfig~powerpc-drop-ranges-for-definition-of-arch_force_max_order
+++ a/arch/powerpc/Kconfig
@@ -897,17 +897,11 @@ config DATA_SHIFT
 
 config ARCH_FORCE_MAX_ORDER
 	int "Order of maximal physically contiguous allocations"
-	range 7 8 if PPC64 && PPC_64K_PAGES
 	default "8" if PPC64 && PPC_64K_PAGES
-	range 12 12 if PPC64 && !PPC_64K_PAGES
 	default "12" if PPC64 && !PPC_64K_PAGES
-	range 8 63 if PPC32 && PPC_16K_PAGES
 	default "8" if PPC32 && PPC_16K_PAGES
-	range 6 63 if PPC32 && PPC_64K_PAGES
 	default "6" if PPC32 && PPC_64K_PAGES
-	range 4 63 if PPC32 && PPC_256K_PAGES
 	default "4" if PPC32 && PPC_256K_PAGES
-	range 10 63
 	default "10"
 	help
 	  The kernel page allocator limits the size of maximal physically
_

Patches currently in -mm which might be from rppt@kernel.org are

sh-reword-arch_force_max_order-prompt-and-help-text.patch
sh-drop-ranges-for-definition-of-arch_force_max_order.patch
sparc-reword-arch_force_max_order-prompt-and-help-text.patch
xtensa-reword-arch_force_max_order-prompt-and-help-text.patch
mm-move-free_area_empty-to-mm-internalh.patch


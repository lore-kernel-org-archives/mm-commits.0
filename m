Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C64D3C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjDRXdv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbjDRXdo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8255983C9
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21096615F4
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DD7C433D2;
        Tue, 18 Apr 2023 23:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860820;
        bh=+2228XJYgfDcKg/awuUWGiBhFz2O9l59b/4KJDIPot8=;
        h=Date:To:From:Subject:From;
        b=1dKFHS1lOdS5Z/bQuMIfMOtUJnm867NzEisQwYLjq5ZOM7L6ZbPt46nxJynUb6L/a
         LRVAwCj11lSA9MekoYDEy2b7jIjnwQhpxSRFhTPY3YNGYYtOPrY3fwPaLHkNUPD2NG
         piyfVx6jwWrg0Gp4Ytt5TiKsdNw5nq9n8JIVlgf8=
Date:   Tue, 18 Apr 2023 16:33:39 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        ysato@users.sourceforge.jp, will@kernel.org, mpe@ellerman.id.au,
        linux@armlinux.org.uk, kirill.shutemov@linux.intel.com,
        jcmvbkbc@gmail.com, guoren@kernel.org,
        glaubitz@physik.fu-berlin.de, geert@linux-m68k.org,
        dinguyen@kernel.org, davem@davemloft.net, dalias@libc.org,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        arnd@arndb.de, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nios2-drop-ranges-for-definition-of-arch_force_max_order.patch removed from -mm tree
Message-Id: <20230418233340.76DD7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nios2: drop ranges for definition of ARCH_FORCE_MAX_ORDER
has been removed from the -mm tree.  Its filename was
     nios2-drop-ranges-for-definition-of-arch_force_max_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: nios2: drop ranges for definition of ARCH_FORCE_MAX_ORDER
Date: Fri, 24 Mar 2023 08:22:27 +0300

nios2 defines range for ARCH_FORCE_MAX_ORDER allowing MAX_ORDER up to 19,
which implies maximal contiguous allocation size of 2^19 pages or 2GiB.

Drop bogus definition of ranges for ARCH_FORCE_MAX_ORDER and leave it a
simple integer with sensible default.

Users that *really* need to change the value of ARCH_FORCE_MAX_ORDER will
be able to do so but they won't be mislead by the bogus ranges.

Link: https://lkml.kernel.org/r/20230324052233.2654090-9-rppt@kernel.org
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

 arch/nios2/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/nios2/Kconfig~nios2-drop-ranges-for-definition-of-arch_force_max_order
+++ a/arch/nios2/Kconfig
@@ -46,7 +46,6 @@ source "kernel/Kconfig.hz"
 
 config ARCH_FORCE_MAX_ORDER
 	int "Order of maximal physically contiguous allocations"
-	range 8 19
 	default "10"
 	help
 	  The kernel page allocator limits the size of maximal physically
_

Patches currently in -mm which might be from rppt@kernel.org are

powerpc-reword-arch_force_max_order-prompt-and-help-text.patch
powerpc-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-reword-arch_force_max_order-prompt-and-help-text.patch
sh-drop-ranges-for-definition-of-arch_force_max_order.patch
sparc-reword-arch_force_max_order-prompt-and-help-text.patch
xtensa-reword-arch_force_max_order-prompt-and-help-text.patch
mm-move-free_area_empty-to-mm-internalh.patch


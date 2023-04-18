Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0F4C77B7C
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjDRXdy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbjDRXdt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42E07EEE
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C96B639E9
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652DBC4339B;
        Tue, 18 Apr 2023 23:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860825;
        bh=EUQ54AW+x750RgSMtXf5rGMrz9XyPZOdOZ6bFbjdnLU=;
        h=Date:To:From:Subject:From;
        b=AaqXk4dP+4mL9GTOit1Lpu//+XeSX/bnZAePcOP75CApvxqfusPezLvDyNpjiyWLW
         Dy4/Ow6u7ESZFAIM/cyW7A7jrYAGw5fQdWo59BFJvaxfL57d0DBYktOvwhnxfIR2sE
         P7n7LrA5qgozceeRTwD9PmjnPBZ+smEFe5IbB11A=
Date:   Tue, 18 Apr 2023 16:33:44 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        ysato@users.sourceforge.jp, will@kernel.org, mpe@ellerman.id.au,
        linux@armlinux.org.uk, kirill.shutemov@linux.intel.com,
        jcmvbkbc@gmail.com, guoren@kernel.org,
        glaubitz@physik.fu-berlin.de, geert@linux-m68k.org,
        dinguyen@kernel.org, davem@davemloft.net, dalias@libc.org,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        arnd@arndb.de, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-drop-ranges-for-definition-of-arch_force_max_order.patch removed from -mm tree
Message-Id: <20230418233345.652DBC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sh: drop ranges for definition of ARCH_FORCE_MAX_ORDER
has been removed from the -mm tree.  Its filename was
     sh-drop-ranges-for-definition-of-arch_force_max_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: sh: drop ranges for definition of ARCH_FORCE_MAX_ORDER
Date: Fri, 24 Mar 2023 08:22:31 +0300

sh defines insane ranges for ARCH_FORCE_MAX_ORDER allowing MAX_ORDER up to
63, which implies maximal contiguous allocation size of 2^63 pages.

Drop bogus definitions of ranges for ARCH_FORCE_MAX_ORDER and leave it a
simple integer with sensible defaults.

Users that *really* need to change the value of ARCH_FORCE_MAX_ORDER will
be able to do so but they won't be mislead by the bogus ranges.

[rppt@kernel.org: untweak ARCH_FORCE_MAX_ORDER's `range']
  Link: https://lkml.kernel.org/r/20230325060828.2662773-13-rppt@kernel.org
Link: https://lkml.kernel.org/r/20230324052233.2654090-13-rppt@kernel.org
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

 arch/sh/mm/Kconfig |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/sh/mm/Kconfig~sh-drop-ranges-for-definition-of-arch_force_max_order
+++ a/arch/sh/mm/Kconfig
@@ -20,11 +20,8 @@ config PAGE_OFFSET
 
 config ARCH_FORCE_MAX_ORDER
 	int "Order of maximal physically contiguous allocations"
-	range 8 63 if PAGE_SIZE_16KB
 	default "8" if PAGE_SIZE_16KB
-	range 6 63 if PAGE_SIZE_64KB
 	default "6" if PAGE_SIZE_64KB
-	range 10 63
 	default "13" if !MMU
 	default "10"
 	help
_

Patches currently in -mm which might be from rppt@kernel.org are

sparc-reword-arch_force_max_order-prompt-and-help-text.patch
xtensa-reword-arch_force_max_order-prompt-and-help-text.patch
mm-move-free_area_empty-to-mm-internalh.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87617C77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbjDRXdq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbjDRXdn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035E583F7
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EBCC61528
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91FCC433EF;
        Tue, 18 Apr 2023 23:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860816;
        bh=lGlXPLAVgDlj/oQpJwSSDwlFi6XX3o4iX7Dt0sIoG8o=;
        h=Date:To:From:Subject:From;
        b=0oP1twkdbHEMr6Xt8Hy35s9xkfBa91mwFBcTnGgb5PLyfKUhAeNWXpT01lE+oqdJL
         T3tFW1U/StEybRzjx3rEXi8fz+s/D323DzTVadpCQwHlvoyszyxsZrPq9FX78JtSqS
         QSw58awv31Exx8ErRqNxp70jWiXQ0APjtT3wz3rU=
Date:   Tue, 18 Apr 2023 16:33:35 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        ysato@users.sourceforge.jp, will@kernel.org, mpe@ellerman.id.au,
        linux@armlinux.org.uk, kirill.shutemov@linux.intel.com,
        jcmvbkbc@gmail.com, guoren@kernel.org,
        glaubitz@physik.fu-berlin.de, geert@linux-m68k.org,
        dinguyen@kernel.org, davem@davemloft.net, dalias@libc.org,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        arnd@arndb.de, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] csky-drop-arch_force_max_order.patch removed from -mm tree
Message-Id: <20230418233335.E91FCC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: csky: drop ARCH_FORCE_MAX_ORDER
has been removed from the -mm tree.  Its filename was
     csky-drop-arch_force_max_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: csky: drop ARCH_FORCE_MAX_ORDER
Date: Fri, 24 Mar 2023 08:22:23 +0300

The default value of ARCH_FORCE_MAX_ORDER matches the generic default
defined in the MM code, the architecture does not support huge pages, so
there is no need to keep ARCH_FORCE_MAX_ORDER option available.

Drop it.

Link: https://lkml.kernel.org/r/20230324052233.2654090-5-rppt@kernel.org
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

 arch/csky/Kconfig |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/csky/Kconfig~csky-drop-arch_force_max_order
+++ a/arch/csky/Kconfig
@@ -332,10 +332,6 @@ config HIGHMEM
 	select KMAP_LOCAL
 	default y
 
-config ARCH_FORCE_MAX_ORDER
-	int "Maximum zone order"
-	default "10"
-
 config DRAM_BASE
 	hex "DRAM start addr (the same with memory-section in dts)"
 	default 0x0
_

Patches currently in -mm which might be from rppt@kernel.org are

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
mm-move-free_area_empty-to-mm-internalh.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FFC3C77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjDRXdz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjDRXdv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1282F8A69
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D297639F5
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D3CC433D2;
        Tue, 18 Apr 2023 23:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860828;
        bh=ekHDhoFK6ro79IyuAKoXhUcbwhIO+a7/3UFZgsj6uHo=;
        h=Date:To:From:Subject:From;
        b=woK5/bC0LM5C77Ib4Tbg4kiYNn112ukWlQluY8sBn1mOZnP7nONK9dz8sTlntKVVQ
         jlZz5+1g33KS0XeFja8JVjbXw0AQxMejgEpr8h5hzgmwPyIuGa5CqjU4RYj+jQE47R
         Mcv6Vq6rl7IdWfyCm9bPsSr8KnSSA23BQbG1mrSQ=
Date:   Tue, 18 Apr 2023 16:33:47 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        ysato@users.sourceforge.jp, will@kernel.org, mpe@ellerman.id.au,
        linux@armlinux.org.uk, kirill.shutemov@linux.intel.com,
        jcmvbkbc@gmail.com, guoren@kernel.org,
        glaubitz@physik.fu-berlin.de, geert@linux-m68k.org,
        dinguyen@kernel.org, davem@davemloft.net, dalias@libc.org,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        arnd@arndb.de, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xtensa-reword-arch_force_max_order-prompt-and-help-text.patch removed from -mm tree
Message-Id: <20230418233348.02D3CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: xtensa: reword ARCH_FORCE_MAX_ORDER prompt and help text
has been removed from the -mm tree.  Its filename was
     xtensa-reword-arch_force_max_order-prompt-and-help-text.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: xtensa: reword ARCH_FORCE_MAX_ORDER prompt and help text
Date: Fri, 24 Mar 2023 08:22:33 +0300

The prompt and help text of ARCH_FORCE_MAX_ORDER are not even close to
describe this configuration option.

Update both to actually describe what this option does.

Link: https://lkml.kernel.org/r/20230324052233.2654090-15-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
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
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Rich Felker <dalias@libc.org>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/Kconfig |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/arch/xtensa/Kconfig~xtensa-reword-arch_force_max_order-prompt-and-help-text
+++ a/arch/xtensa/Kconfig
@@ -772,15 +772,17 @@ config HIGHMEM
 	  If unsure, say Y.
 
 config ARCH_FORCE_MAX_ORDER
-	int "Maximum zone order"
+	int "Order of maximal physically contiguous allocations"
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
+
+	  Don't change if unsure.
 
 endmenu
 
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-move-free_area_empty-to-mm-internalh.patch


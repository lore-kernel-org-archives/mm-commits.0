Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95489C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjDRXdp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbjDRXdh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2127EE3
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E86F4639ED
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BE9C433EF;
        Tue, 18 Apr 2023 23:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860813;
        bh=hk67T4kGQU4+f+Ns4gJG+0R5OisdfoZ8FnVz1Z1Dwlk=;
        h=Date:To:From:Subject:From;
        b=GLlIjKK9fGZZ1fprKvgGXKCCXfE4oR80pK49OYLeTSjkryviHgJahCayEskvh+N03
         abfY6BnMvdFSFKIyDLiRKM99H5pT5lQvkF74BBwMS7vFwljgeS1D2vDVjqdjYaNSy+
         61BCVLqU5gzfBwV7q2Ds9Vn48gIy6/K5qzKx+Upw=
Date:   Tue, 18 Apr 2023 16:33:32 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        ysato@users.sourceforge.jp, will@kernel.org,
        wangkefeng.wang@huawei.com, mpe@ellerman.id.au,
        linux@armlinux.org.uk, kirill.shutemov@linux.intel.com,
        jcmvbkbc@gmail.com, guoren@kernel.org,
        glaubitz@physik.fu-berlin.de, geert@linux-m68k.org,
        dinguyen@kernel.org, davem@davemloft.net, dalias@libc.org,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        arnd@arndb.de, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-drop-ranges-in-definition-of-arch_force_max_order.patch removed from -mm tree
Message-Id: <20230418233333.45BE9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64: drop ranges in definition of ARCH_FORCE_MAX_ORDER
has been removed from the -mm tree.  Its filename was
     arm64-drop-ranges-in-definition-of-arch_force_max_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: arm64: drop ranges in definition of ARCH_FORCE_MAX_ORDER
Date: Fri, 24 Mar 2023 08:22:21 +0300

It is not a good idea to change fundamental parameters of core memory
management.  Having predefined ranges suggests that the values within
those ranges are sensible, but one has to *really* understand implications
of changing MAX_ORDER before actually amending it and ranges don't help
here.

Drop ranges in definition of ARCH_FORCE_MAX_ORDER and make its prompt
visible only if EXPERT=y

Link: https://lkml.kernel.org/r/20230324052233.2654090-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Rich Felker <dalias@libc.org>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/arm64/Kconfig~arm64-drop-ranges-in-definition-of-arch_force_max_order
+++ a/arch/arm64/Kconfig
@@ -1487,11 +1487,9 @@ config XEN
 # 16K |       27          |      14      |       13        |         11         |
 # 64K |       29          |      16      |       13        |         13         |
 config ARCH_FORCE_MAX_ORDER
-	int "Maximum zone order" if ARM64_4K_PAGES || ARM64_16K_PAGES
+	int "Maximum zone order" if EXPERT && (ARM64_4K_PAGES || ARM64_16K_PAGES)
 	default "13" if ARM64_64K_PAGES
-	range 11 13 if ARM64_16K_PAGES
 	default "11" if ARM64_16K_PAGES
-	range 10 15 if ARM64_4K_PAGES
 	default "10"
 	help
 	  The kernel memory allocator divides physically contiguous memory
_

Patches currently in -mm which might be from rppt@kernel.org are

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
mm-move-free_area_empty-to-mm-internalh.patch


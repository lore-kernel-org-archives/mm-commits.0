Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A50D8C77B71
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbjDFCpQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbjDFCos (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0243793CF
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91A3C642B5
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7157C433D2;
        Thu,  6 Apr 2023 02:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749082;
        bh=Y9bTthNHvh81AdIJrv++3+AhZO0iqvK0LeVIuqtMf48=;
        h=Date:To:From:Subject:From;
        b=qYAFavP8Y6TdelB+jU8IkPUp31MixeODB+9HPk4XKtUVCtsmIBBQuJDF386Rn2v1E
         vjaDTYhojGPwExXSiomJOxdKDMaT8IV8+A4N5tNhiaMknFap4T8p/v0jriRqr9JEID
         X/6s+vnF/34jHfOVP9aY0P13+ilNEG99LLN1WXeM=
Date:   Wed, 05 Apr 2023 19:44:41 -0700
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        kirill.shutemov@linux.intel.com, kernel@xen0n.name,
        david@redhat.com, chenhuacai@kernel.org, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mips-drop-ranges-for-definition-of-arch_force_max_order.patch removed from -mm tree
Message-Id: <20230406024441.E7157C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mips: drop ranges for definition of ARCH_FORCE_MAX_ORDER
has been removed from the -mm tree.  Its filename was
     mips-drop-ranges-for-definition-of-arch_force_max_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mips: drop ranges for definition of ARCH_FORCE_MAX_ORDER
Date: Wed, 22 Mar 2023 10:15:20 +0200

MIPS defines insane ranges for ARCH_FORCE_MAX_ORDER allowing MAX_ORDER up
to 63, which implies maximal contiguous allocation size of 2^63 pages.

Drop bogus definitions of ranges for ARCH_FORCE_MAX_ORDER and leave it a
simple integer with sensible defaults.

Users that *really* need to change the value of ARCH_FORCE_MAX_ORDER will
be able to do so but they won't be mislead by the bogus ranges.

Link: https://lkml.kernel.org/r/20230322081520.2516226-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/mips/Kconfig~mips-drop-ranges-for-definition-of-arch_force_max_order
+++ a/arch/mips/Kconfig
@@ -2137,13 +2137,9 @@ endchoice
 
 config ARCH_FORCE_MAX_ORDER
 	int "Maximum zone order"
-	range 13 63 if MIPS_HUGE_TLB_SUPPORT && PAGE_SIZE_64KB
 	default "13" if MIPS_HUGE_TLB_SUPPORT && PAGE_SIZE_64KB
-	range 12 63 if MIPS_HUGE_TLB_SUPPORT && PAGE_SIZE_32KB
 	default "12" if MIPS_HUGE_TLB_SUPPORT && PAGE_SIZE_32KB
-	range 11 63 if MIPS_HUGE_TLB_SUPPORT && PAGE_SIZE_16KB
 	default "11" if MIPS_HUGE_TLB_SUPPORT && PAGE_SIZE_16KB
-	range 0 63
 	default "10"
 	help
 	  The kernel memory allocator divides physically contiguous memory
_

Patches currently in -mm which might be from rppt@kernel.org are

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


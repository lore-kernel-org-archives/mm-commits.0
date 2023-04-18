Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3678C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjDRXQ2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjDRXQ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:16:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA3D270E
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:16:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D4D0639E2
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8594DC433EF;
        Tue, 18 Apr 2023 23:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681859785;
        bh=6RkLA2+EHatT2ElQXuOmcwST44EZIZ610EM6DYRMtuQ=;
        h=Date:To:From:Subject:From;
        b=QGtuPfB3BjGY3fwITiz3437zbfsIduxF1XYfEXw4q5kVl6KrtxMgzjQfSOfBI4Ifo
         sFVZ/YF5y9g7VaCyff7FjGdWLDb3Z4aVKQVl2c/aH6nOH4840ckmwHWknGyrrk/69f
         l3TXIyUgN9sHvMqiCYCv8VAaaEfD698g3wlU8lAw=
Date:   Tue, 18 Apr 2023 16:16:24 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] sh-reword-arch_force_max_order-prompt-and-help-text-v3.patch removed from -mm tree
Message-Id: <20230418231625.8594DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sh-reword-arch_force_max_order-prompt-and-help-text-v3
has been removed from the -mm tree.  Its filename was
     sh-reword-arch_force_max_order-prompt-and-help-text-v3.patch

This patch was dropped because it was folded into sh-reword-arch_force_max_order-prompt-and-help-text.patch

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
sh-drop-ranges-for-definition-of-arch_force_max_order-v3.patch
sparc-reword-arch_force_max_order-prompt-and-help-text.patch
xtensa-reword-arch_force_max_order-prompt-and-help-text.patch
mm-move-free_area_empty-to-mm-internalh.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E29C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjDRXPx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjDRXPw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:15:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81016270E
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:15:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D0DA639E2
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4C3C433EF;
        Tue, 18 Apr 2023 23:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681859750;
        bh=UQA7YOcmeVe0Yrr5YLjlNIYpEPP92JyP972L9ty0zWk=;
        h=Date:To:From:Subject:From;
        b=ucxbDrhzGuZqx7yI4dM/i2ThC0lDjSCazwHW+IQTumKDt67MJIdmfXEsSa6/9bX90
         y3uVYqG6uHKV7WVVd6/2oeAdmyLou4ljh/BvOKOtcYOGByKJISb7nG17Vz5QrczI66
         p1wpk/Dk6cc8Id/ZEfPpy/ZxqGhHmtCAFUzgyb04=
Date:   Tue, 18 Apr 2023 16:15:49 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] arm64-reword-arch_force_max_order-prompt-and-help-text-v3.patch removed from -mm tree
Message-Id: <20230418231550.6A4C3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64-reword-arch_force_max_order-prompt-and-help-text-v3
has been removed from the -mm tree.  Its filename was
     arm64-reword-arch_force_max_order-prompt-and-help-text-v3.patch

This patch was dropped because it was folded into arm64-reword-arch_force_max_order-prompt-and-help-text.patch

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: arm64-reword-arch_force_max_order-prompt-and-help-text-v3
Date: Sat, 25 Mar 2023 09:08:17 +0300

change ARCH_FORCE_MAX_ORDER dependencies

Link: https://lkml.kernel.org/r/20230325060828.2662773-4-rppt@kernel.org
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/Kconfig~arm64-reword-arch_force_max_order-prompt-and-help-text-v3
+++ a/arch/arm64/Kconfig
@@ -1487,7 +1487,7 @@ config XEN
 # 16K |       27          |      14      |       13        |         11         |
 # 64K |       29          |      16      |       13        |         13         |
 config ARCH_FORCE_MAX_ORDER
-	int "Order of maximal physically contiguous allocations" if ARM64_4K_PAGES || ARM64_16K_PAGES
+	int "Order of maximal physically contiguous allocations" if EXPERT && (ARM64_4K_PAGES || ARM64_16K_PAGES)
 	default "13" if ARM64_64K_PAGES
 	default "11" if ARM64_16K_PAGES
 	default "10"
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
sh-reword-arch_force_max_order-prompt-and-help-text-v3.patch
sh-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-drop-ranges-for-definition-of-arch_force_max_order-v3.patch
sparc-reword-arch_force_max_order-prompt-and-help-text.patch
xtensa-reword-arch_force_max_order-prompt-and-help-text.patch
mm-move-free_area_empty-to-mm-internalh.patch


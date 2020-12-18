Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA6F6C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 20:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78C5723B08
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 20:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbgLRUI5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 15:08:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:44516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728215AbgLRUI4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 15:08:56 -0500
Date:   Fri, 18 Dec 2020 12:08:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608322096;
        bh=k8Fglps2nN1jTzqMJ2MIcFwaTo2qHCb/KbX4se1a0UM=;
        h=From:To:Subject:From;
        b=h+jJGg3XpueIu8Kzwzsacfx40AG0Uy8DRYE6w6Gy3bHs/lJliJYhb4eTawOH5lm5e
         D92afy7hB74mINcmLy6M/EN3MPlUti+ulCqVxedDfp5AM4+UAvjAbNQnLMjL8puS36
         jxGGmEY0bZZEGBDNmnv9E5tyoxq/H7pZJDeePPw0=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        glider@google.com, aryabinin@virtuozzo.com, andreyknvl@google.com,
        catalin.marinas@arm.com
Subject:  [folded-merged]
 arm64-mte-add-in-kernel-tag-fault-handler-fix.patch removed from -mm tree
Message-ID: <20201218200815.lgw1x%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: mte: ensure CONFIG_ARM64_PAN is enabled with MTE
has been removed from the -mm tree.  Its filename was
     arm64-mte-add-in-kernel-tag-fault-handler-fix.patch

This patch was dropped because it was folded into arm64-mte-add-in-kernel-tag-fault-handler.patch

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: arm64: mte: ensure CONFIG_ARM64_PAN is enabled with MTE

The uaccess routines like get/put_user() rely on the user TCF0 mode
setting for tag checking.  However, if CONFIG_ARM64_PAN is disabled, these
routines would use the standard LDR/STR instructions and therefore the
kernel TCF mode.  In 5.10, the kernel TCF==0, so no tag checking, but this
will change with the in-kernel MTE support.

Make ARM64_MTE depend on ARM64_PAN.

Link: https://lkml.kernel.org/r/20201203102628.GB2224@gaia
Fixes: 89b94df9dfb1 ("arm64: mte: Kconfig entry")
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/Kconfig~arm64-mte-add-in-kernel-tag-fault-handler-fix
+++ a/arch/arm64/Kconfig
@@ -1650,6 +1650,8 @@ config ARM64_MTE
 	default y
 	depends on ARM64_AS_HAS_MTE && ARM64_TAGGED_ADDR_ABI
 	depends on AS_HAS_ARMV8_5
+	# Required for tag checking in the uaccess routines
+	depends on ARM64_PAN
 	select ARCH_USES_HIGH_VMA_FLAGS
 	help
 	  Memory Tagging (part of the ARMv8.5 Extensions) provides
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

arm64-mte-add-in-kernel-tag-fault-handler.patch


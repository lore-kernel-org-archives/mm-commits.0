Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A96C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 20:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95671221F2
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 20:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbgLCUXo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:23:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLCUXo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Dec 2020 15:23:44 -0500
Date:   Thu, 03 Dec 2020 12:22:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607026977;
        bh=Gfo9GTN0s76EECfSPEOhVJrc1xspxYr2T9tFRxsz8DU=;
        h=From:To:Subject:From;
        b=ygvF/X6NoRRH+kVXrl+bYa3PEqTpfYqacAB/HQkvPXX7cu1RO7y17x/IyvEqH3AwB
         QH7qWaOfkyz5SjWCpZS9ne7PSmxolCM2sbnhn9fZsmqK4jLCGoZ2/6f+bqhjB1udPU
         QGky9YRZ1kUhIwA/NGm8JCiv+ZWlJ0iViSB9doAA=
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        catalin.marinas@arm.com, glider@google.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com
Subject:  + arm64-mte-add-in-kernel-tag-fault-handler-fix.patch
 added to -mm tree
Message-ID: <20201203202256.jOdlGRMB4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: mte: ensure CONFIG_ARM64_PAN is enabled with MTE
has been added to the -mm tree.  Its filename is
     arm64-mte-add-in-kernel-tag-fault-handler-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-mte-add-in-kernel-tag-fault-handler-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-mte-add-in-kernel-tag-fault-handler-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arm64-mte-add-in-kernel-tag-fault-handler-fix.patch


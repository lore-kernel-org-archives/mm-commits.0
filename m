Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1DCEC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 22:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 849A56108F
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 22:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbhJEW00 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 18:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229831AbhJEW00 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 18:26:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED9F4610E5;
        Tue,  5 Oct 2021 22:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633472675;
        bh=sLDiBL/QSJ9oNPZ6mdny6aE9LhgUFBu0T/CpzV12B0g=;
        h=Date:From:To:Subject:From;
        b=rLlyFu5gISgTzEi5bL1Mh9hAK+7JoGbJIhEohKjMLWfyW9VG7eIVXKcrW8jwwEu9U
         1Uyd6LlIG7A9ON8fyeAw98CIyM+NMKjOiF33OQYf0GTxsiWVF770FT5YyRhy41eB3U
         C3f1MIjzDrfhg7XREmNpfy07QaH6UKHUWWTc5a0o=
Date:   Tue, 05 Oct 2021 15:24:34 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, aryabinin@virtuozzo.com,
        branislav.rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, lorenzo.pieralisi@arm.com,
        mm-commits@vger.kernel.org, suzuki.poulose@arm.com,
        vincenzo.frascino@arm.com, will@kernel.org
Subject:  + arm64-mte-bitfield-definitions-for-asymm-mte.patch
 added to -mm tree
Message-ID: <20211005222434.IyMZ6E79i%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: mte: bitfield definitions for Asymm MTE
has been added to the -mm tree.  Its filename is
     arm64-mte-bitfield-definitions-for-asymm-mte.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-mte-bitfield-definitions-for-asymm-mte.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-mte-bitfield-definitions-for-asymm-mte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: arm64: mte: bitfield definitions for Asymm MTE

Add Asymmetric Memory Tagging Extension bitfield definitions.

Link: https://lkml.kernel.org/r/20211004202253.27857-3-vincenzo.frascino@arm.com
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <branislav.rankov@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/sysreg.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/include/asm/sysreg.h~arm64-mte-bitfield-definitions-for-asymm-mte
+++ a/arch/arm64/include/asm/sysreg.h
@@ -621,6 +621,7 @@
 #define SCTLR_ELx_TCF_NONE	(UL(0x0) << SCTLR_ELx_TCF_SHIFT)
 #define SCTLR_ELx_TCF_SYNC	(UL(0x1) << SCTLR_ELx_TCF_SHIFT)
 #define SCTLR_ELx_TCF_ASYNC	(UL(0x2) << SCTLR_ELx_TCF_SHIFT)
+#define SCTLR_ELx_TCF_ASYMM	(UL(0x3) << SCTLR_ELx_TCF_SHIFT)
 #define SCTLR_ELx_TCF_MASK	(UL(0x3) << SCTLR_ELx_TCF_SHIFT)
 
 #define SCTLR_ELx_ENIA_SHIFT	31
@@ -666,6 +667,7 @@
 #define SCTLR_EL1_TCF0_NONE	(UL(0x0) << SCTLR_EL1_TCF0_SHIFT)
 #define SCTLR_EL1_TCF0_SYNC	(UL(0x1) << SCTLR_EL1_TCF0_SHIFT)
 #define SCTLR_EL1_TCF0_ASYNC	(UL(0x2) << SCTLR_EL1_TCF0_SHIFT)
+#define SCTLR_EL1_TCF0_ASYMM	(UL(0x3) << SCTLR_EL1_TCF0_SHIFT)
 #define SCTLR_EL1_TCF0_MASK	(UL(0x3) << SCTLR_EL1_TCF0_SHIFT)
 
 #define SCTLR_EL1_BT1		(BIT(36))
@@ -807,6 +809,7 @@
 #define ID_AA64PFR1_MTE_NI		0x0
 #define ID_AA64PFR1_MTE_EL0		0x1
 #define ID_AA64PFR1_MTE			0x2
+#define ID_AA64PFR1_MTE_ASYMM		0x3
 
 /* id_aa64zfr0 */
 #define ID_AA64ZFR0_F64MM_SHIFT		56
_

Patches currently in -mm which might be from vincenzo.frascino@arm.com are

kasan-remove-duplicate-of-kasan_flag_async.patch
arm64-mte-bitfield-definitions-for-asymm-mte.patch
arm64-mte-cpu-feature-detection-for-asymm-mte.patch
arm64-mte-add-asymmetric-mode-support.patch
kasan-extend-kasan-mode-kernel-parameter.patch


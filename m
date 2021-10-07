Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F77FC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 01:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C44261090
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 01:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhJGBQJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Oct 2021 21:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230252AbhJGBQI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Oct 2021 21:16:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A395761175;
        Thu,  7 Oct 2021 01:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633569256;
        bh=NH7a54Llc6w1w/nMycOSy273W4sIhT14uxeOyljnUjU=;
        h=Date:From:To:Subject:From;
        b=ZsKruhOUfaW0kc04Y2yPSMWOSvjkknKv5zyCea0qHtmwVNWvdSEsJk5z9reRpcBWU
         FDFZFf0rlgk8TR8qAdR0TvGU8fKqVW6vC8zFAQJcQGny6M6cmqQ5ZqeEUFSQwfbX5T
         ba0xVEZ4Q86CckfyZJxjTJITCst1DlT6zlWPuOLk=
Date:   Wed, 06 Oct 2021 18:14:15 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, aryabinin@virtuozzo.com,
        branislav.rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, lorenzo.pieralisi@arm.com,
        mm-commits@vger.kernel.org, suzuki.poulose@arm.com,
        vincenzo.frascino@arm.com, will@kernel.org
Subject:  [alternative-merged]
 arm64-mte-bitfield-definitions-for-asymm-mte.patch removed from -mm tree
Message-ID: <20211007011415.-f8S5jUtY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: mte: bitfield definitions for Asymm MTE
has been removed from the -mm tree.  Its filename was
     arm64-mte-bitfield-definitions-for-asymm-mte.patch

This patch was dropped because an alternative patch was merged

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

arm64-mte-cpu-feature-detection-for-asymm-mte.patch
arm64-mte-add-asymmetric-mode-support.patch
kasan-extend-kasan-mode-kernel-parameter.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7CDEC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 22:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9832B6108F
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 22:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhJEW03 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 18:26:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229831AbhJEW03 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 18:26:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F00B5610CA;
        Tue,  5 Oct 2021 22:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633472678;
        bh=IFPMlvAeGaHwFG1v9Q3W16xUAoXKoCr8VtgUVD5IDWw=;
        h=Date:From:To:Subject:From;
        b=wOb2c88HI0PUY5RXtN6RSjd0563q/PQ3oO4evgE1/f/kjaHv2BR3kk4Qw/tMRu3AU
         UtKNYgr8xf0X5A1Kp5AshXC2vbCleJg8tQ8piUxAK8xYXsfzS+MDBRrXKo5slyc55Z
         XbQIrbOMyo8JIUUTqbiMY1UAS/iEoIrvFGbmQQz0=
Date:   Tue, 05 Oct 2021 15:24:37 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, aryabinin@virtuozzo.com,
        branislav.rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, lorenzo.pieralisi@arm.com,
        mm-commits@vger.kernel.org, suzuki.poulose@arm.com,
        vincenzo.frascino@arm.com, will@kernel.org
Subject:  + arm64-mte-cpu-feature-detection-for-asymm-mte.patch
 added to -mm tree
Message-ID: <20211005222437.V7YjznuGP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: mte: CPU feature detection for Asymm MTE
has been added to the -mm tree.  Its filename is
     arm64-mte-cpu-feature-detection-for-asymm-mte.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-mte-cpu-feature-detection-for-asymm-mte.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-mte-cpu-feature-detection-for-asymm-mte.patch

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
Subject: arm64: mte: CPU feature detection for Asymm MTE

Add the cpufeature entries to detect the presence of Asymmetric MTE.

Note: The tag checking mode is initialized via cpu_enable_mte() ->
kasan_init_hw_tags() hence to enable it we require asymmetric mode to be
at least on the boot CPU.  If the boot CPU does not have it, it is fine
for late CPUs to have it as long as the feature is not enabled
(ARM64_CPUCAP_BOOT_CPU_FEATURE).

Link: https://lkml.kernel.org/r/20211004202253.27857-4-vincenzo.frascino@arm.com
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <branislav.rankov@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/cpufeature.c |   10 ++++++++++
 arch/arm64/tools/cpucaps       |    1 +
 2 files changed, 11 insertions(+)

--- a/arch/arm64/kernel/cpufeature.c~arm64-mte-cpu-feature-detection-for-asymm-mte
+++ a/arch/arm64/kernel/cpufeature.c
@@ -2321,6 +2321,16 @@ static const struct arm64_cpu_capabiliti
 		.sign = FTR_UNSIGNED,
 		.cpu_enable = cpu_enable_mte,
 	},
+	{
+		.desc = "Asymmetric MTE Tag Check Fault",
+		.capability = ARM64_MTE_ASYMM,
+		.type = ARM64_CPUCAP_BOOT_CPU_FEATURE,
+		.matches = has_cpuid_feature,
+		.sys_reg = SYS_ID_AA64PFR1_EL1,
+		.field_pos = ID_AA64PFR1_MTE_SHIFT,
+		.min_field_value = ID_AA64PFR1_MTE_ASYMM,
+		.sign = FTR_UNSIGNED,
+	},
 #endif /* CONFIG_ARM64_MTE */
 	{
 		.desc = "RCpc load-acquire (LDAPR)",
--- a/arch/arm64/tools/cpucaps~arm64-mte-cpu-feature-detection-for-asymm-mte
+++ a/arch/arm64/tools/cpucaps
@@ -39,6 +39,7 @@ HW_DBM
 KVM_PROTECTED_MODE
 MISMATCHED_CACHE_TYPE
 MTE
+MTE_ASYMM
 SPECTRE_V2
 SPECTRE_V3A
 SPECTRE_V4
_

Patches currently in -mm which might be from vincenzo.frascino@arm.com are

kasan-remove-duplicate-of-kasan_flag_async.patch
arm64-mte-bitfield-definitions-for-asymm-mte.patch
arm64-mte-cpu-feature-detection-for-asymm-mte.patch
arm64-mte-add-asymmetric-mode-support.patch
kasan-extend-kasan-mode-kernel-parameter.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF635C4361B
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADF1E23B8C
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgLRWDk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:03:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:36046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgLRWDj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:03:39 -0500
Date:   Fri, 18 Dec 2020 14:03:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608329004;
        bh=o4LWwQlSOpED0V2os9lzQIgkMFv6BxZ2jMv9cz3gbxo=;
        h=From:To:Subject:In-Reply-To:From;
        b=ONAP4qDQ4KV0R61G4/3hd8m557uK7oHCno3obmvtsO69EaVdKu19tz0H1KWsrgeKu
         8lzEHMrIDv84Ex7RTiSeU944uDTGfL7d02LvmA5yV7YmWQ/q3+TsaEYpbXigdxa+jo
         n8c1z1hOrIgRL88edBrZu0OPgdxcshMlXOipD0Cs=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, gor@linux.ibm.com,
        kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [patch 36/78] arm64: enable armv8.5-a asm-arch option
Message-ID: <20201218220323.FBOTcmeWO%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: arm64: enable armv8.5-a asm-arch option

Hardware tag-based KASAN relies on Memory Tagging Extension (MTE) which is
an armv8.5-a architecture extension.

Enable the correct asm option when the compiler supports it in order to
allow the usage of ALTERNATIVE()s with MTE instructions.

Link: https://lkml.kernel.org/r/d03d1157124ea3532eaeb77507988733f5734986.1606161801.git.andreyknvl@google.com
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig  |    4 ++++
 arch/arm64/Makefile |    5 +++++
 2 files changed, 9 insertions(+)

--- a/arch/arm64/Kconfig~arm64-enable-armv85-a-asm-arch-option
+++ a/arch/arm64/Kconfig
@@ -1571,6 +1571,9 @@ endmenu
 
 menu "ARMv8.5 architectural features"
 
+config AS_HAS_ARMV8_5
+	def_bool $(cc-option,-Wa$(comma)-march=armv8.5-a)
+
 config ARM64_BTI
 	bool "Branch Target Identification support"
 	default y
@@ -1645,6 +1648,7 @@ config ARM64_MTE
 	bool "Memory Tagging Extension support"
 	default y
 	depends on ARM64_AS_HAS_MTE && ARM64_TAGGED_ADDR_ABI
+	depends on AS_HAS_ARMV8_5
 	select ARCH_USES_HIGH_VMA_FLAGS
 	help
 	  Memory Tagging (part of the ARMv8.5 Extensions) provides
--- a/arch/arm64/Makefile~arm64-enable-armv85-a-asm-arch-option
+++ a/arch/arm64/Makefile
@@ -96,6 +96,11 @@ ifeq ($(CONFIG_AS_HAS_ARMV8_4), y)
 asm-arch := armv8.4-a
 endif
 
+ifeq ($(CONFIG_AS_HAS_ARMV8_5), y)
+# make sure to pass the newest target architecture to -march.
+asm-arch := armv8.5-a
+endif
+
 ifdef asm-arch
 KBUILD_CFLAGS	+= -Wa,-march=$(asm-arch) \
 		   -DARM64_ASM_ARCH='"$(asm-arch)"'
_

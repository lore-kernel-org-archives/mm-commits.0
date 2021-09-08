Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24EBC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A21C56115B
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbhIHDAR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:00:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347231AbhIHDAP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:00:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C405F61100;
        Wed,  8 Sep 2021 02:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069948;
        bh=fwYIxVmaCXuh2bjSxeZ7JQlFFF+RYWbr0BWaQVIf9iA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2l+QYUp1CgQExeGKz+kr0Exx36Z2ua41G7wi/bqst9VjUG21EzMQQXHcaVVxylyAR
         qDVJ75B1z/MUEEgTaXe78EEfiCta8adtRyxJYf5C7DaHGwcz4iQvegUhn2wqLsFXzd
         iwsCLCfftgsW3abPrLR3Pv5wxUoM9++l+JudjtXM=
Date:   Tue, 07 Sep 2021 19:59:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aklimov@redhat.com, akpm@linux-foundation.org, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, ulf.hansson@linaro.org,
        will@kernel.org, wsa+renesas@sang-engineering.com,
        yury.norov@gmail.com
Subject:  [patch 110/147] arch: remove GENERIC_FIND_FIRST_BIT
 entirely
Message-ID: <20210908025907.YK9ww9N-v%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>
Subject: arch: remove GENERIC_FIND_FIRST_BIT entirely

In 5.12 cycle we enabled GENERIC_FIND_FIRST_BIT config option for ARM64
and MIPS.  It increased performance and shrunk .text size; and so far I
didn't receive any negative feedback on the change.

https://lore.kernel.org/linux-arch/20210225135700.1381396-1-yury.norov@gmail.com/

Now I think it's a good time to switch all architectures to use
find_{first,last}_bit() unconditionally, and so remove corresponding
config option.

The patch does't introduce functioal changes for arc, arm, arm64, mips,
m68k, s390 and x86, for other architectures I expect improvement both in
performance and .text size.

Link: https://lkml.kernel.org/r/20210814211713.180533-5-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Tested-by: Alexander Lobakin <alobakin@pm.me> (mips)
Reviewed-by: Alexander Lobakin <alobakin@pm.me> (mips)
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Will Deacon <will@kernel.org>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/Kconfig     |    1 -
 arch/arm64/Kconfig   |    1 -
 arch/mips/Kconfig    |    1 -
 arch/s390/Kconfig    |    1 -
 arch/x86/Kconfig     |    1 -
 arch/x86/um/Kconfig  |    1 -
 include/linux/find.h |   13 -------------
 lib/Kconfig          |    3 ---
 8 files changed, 22 deletions(-)

--- a/arch/arc/Kconfig~arch-remove-generic_find_first_bit-entirely
+++ a/arch/arc/Kconfig
@@ -20,7 +20,6 @@ config ARC
 	select COMMON_CLK
 	select DMA_DIRECT_REMAP
 	select GENERIC_ATOMIC64 if !ISA_ARCV2 || !(ARC_HAS_LL64 && ARC_HAS_LLSC)
-	select GENERIC_FIND_FIRST_BIT
 	# for now, we don't need GENERIC_IRQ_PROBE, CONFIG_GENERIC_IRQ_CHIP
 	select GENERIC_IRQ_SHOW
 	select GENERIC_PCI_IOMAP
--- a/arch/arm64/Kconfig~arch-remove-generic_find_first_bit-entirely
+++ a/arch/arm64/Kconfig
@@ -119,7 +119,6 @@ config ARM64
 	select GENERIC_CPU_AUTOPROBE
 	select GENERIC_CPU_VULNERABILITIES
 	select GENERIC_EARLY_IOREMAP
-	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_IDLE_POLL_SETUP
 	select GENERIC_IRQ_IPI
 	select GENERIC_IRQ_PROBE
--- a/arch/mips/Kconfig~arch-remove-generic_find_first_bit-entirely
+++ a/arch/mips/Kconfig
@@ -30,7 +30,6 @@ config MIPS
 	select GENERIC_ATOMIC64 if !64BIT
 	select GENERIC_CMOS_UPDATE
 	select GENERIC_CPU_AUTOPROBE
-	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_GETTIMEOFDAY
 	select GENERIC_IOMAP
 	select GENERIC_IRQ_PROBE
--- a/arch/s390/Kconfig~arch-remove-generic_find_first_bit-entirely
+++ a/arch/s390/Kconfig
@@ -126,7 +126,6 @@ config S390
 	select GENERIC_CPU_AUTOPROBE
 	select GENERIC_CPU_VULNERABILITIES
 	select GENERIC_ENTRY
-	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_GETTIMEOFDAY
 	select GENERIC_PTDUMP
 	select GENERIC_SMP_IDLE_THREAD
--- a/arch/x86/Kconfig~arch-remove-generic_find_first_bit-entirely
+++ a/arch/x86/Kconfig
@@ -133,7 +133,6 @@ config X86
 	select GENERIC_CPU_VULNERABILITIES
 	select GENERIC_EARLY_IOREMAP
 	select GENERIC_ENTRY
-	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_IOMAP
 	select GENERIC_IRQ_EFFECTIVE_AFF_MASK	if SMP
 	select GENERIC_IRQ_MATRIX_ALLOCATOR	if X86_LOCAL_APIC
--- a/arch/x86/um/Kconfig~arch-remove-generic_find_first_bit-entirely
+++ a/arch/x86/um/Kconfig
@@ -8,7 +8,6 @@ endmenu
 
 config UML_X86
 	def_bool y
-	select GENERIC_FIND_FIRST_BIT
 
 config 64BIT
 	bool "64-bit kernel" if "$(SUBARCH)" = "x86"
--- a/include/linux/find.h~arch-remove-generic_find_first_bit-entirely
+++ a/include/linux/find.h
@@ -101,8 +101,6 @@ unsigned long find_next_zero_bit(const u
 }
 #endif
 
-#ifdef CONFIG_GENERIC_FIND_FIRST_BIT
-
 #ifndef find_first_bit
 /**
  * find_first_bit - find the first set bit in a memory region
@@ -147,17 +145,6 @@ unsigned long find_first_zero_bit(const
 }
 #endif
 
-#else /* CONFIG_GENERIC_FIND_FIRST_BIT */
-
-#ifndef find_first_bit
-#define find_first_bit(addr, size) find_next_bit((addr), (size), 0)
-#endif
-#ifndef find_first_zero_bit
-#define find_first_zero_bit(addr, size) find_next_zero_bit((addr), (size), 0)
-#endif
-
-#endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
-
 #ifndef find_last_bit
 /**
  * find_last_bit - find the last set bit in a memory region
--- a/lib/Kconfig~arch-remove-generic_find_first_bit-entirely
+++ a/lib/Kconfig
@@ -59,9 +59,6 @@ config GENERIC_STRNLEN_USER
 config GENERIC_NET_UTILS
 	bool
 
-config GENERIC_FIND_FIRST_BIT
-	bool
-
 source "lib/math/Kconfig"
 
 config NO_GENERIC_PCI_IOPORT_MAP
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B13CC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiATCKg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:10:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44208 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233455AbiATCKd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:10:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77DF461522
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 519DDC340E3;
        Thu, 20 Jan 2022 02:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644632;
        bh=gcAL4Sy8K9r9PVP/bh1o6gyHungznqqXueqpWlVu6jU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JS9uvzHHkT4RjMDkAZjWA9WGLdbNeGsLKGYp8t4gQrTcucgajvRIJLwQsr71iB0Ic
         E6iV1pz6j2KCExDNGXHyar7m5KHmfXSg9fkLld4FCu3EHrpq/DLLH+qJ17Xmcdj2Lx
         ctFSl3+Po4f77XQK9usD2UFLLiEhxzBYbm8Pbm88=
Date:   Wed, 19 Jan 2022 18:10:31 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com, bp@alien8.de,
        catalin.marinas@arm.com, dave.hansen@linux.intel.com,
        dvyukov@google.com, elver@google.com, hpa@zytor.com,
        linux-mm@kvack.org, mark.rutland@arm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, peterz@infradead.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, will@kernel.org
Subject:  [patch 53/55] kcov: fix generic Kconfig dependencies if
 ARCH_WANTS_NO_INSTR
Message-ID: <20220120021031.l7CtetKve%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: kcov: fix generic Kconfig dependencies if ARCH_WANTS_NO_INSTR

Until recent versions of GCC and Clang, it was not possible to disable
KCOV instrumentation via a function attribute. The relevant function
attribute was introduced in 540540d06e9d9 ("kcov: add
__no_sanitize_coverage to fix noinstr for all architectures").

x86 was the first architecture to want a working noinstr, and at the
time no compiler support for the attribute existed yet. Therefore,
0f1441b44e823 ("objtool: Fix noinstr vs KCOV") introduced the ability to
NOP __sanitizer_cov_*() calls in .noinstr.text.

However, this doesn't work for other architectures like arm64 and s390
that want a working noinstr per ARCH_WANTS_NO_INSTR.

At the time of 0f1441b44e823, we didn't yet have ARCH_WANTS_NO_INSTR,
but now we can move the Kconfig dependency checks to the generic KCOV
option. KCOV will be available if:

	- architecture does not care about noinstr, OR
	- we have objtool support (like on x86), OR
	- GCC is 12.0 or newer, OR
	- Clang is 13.0 or newer.

Link: https://lkml.kernel.org/r/20211201152604.3984495-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig  |    2 +-
 lib/Kconfig.debug |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/Kconfig~kcov-fix-generic-kconfig-dependencies-if-arch_wants_no_instr
+++ a/arch/x86/Kconfig
@@ -78,7 +78,7 @@ config X86
 	select ARCH_HAS_FILTER_PGPROT
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
-	select ARCH_HAS_KCOV			if X86_64 && STACK_VALIDATION
+	select ARCH_HAS_KCOV			if X86_64
 	select ARCH_HAS_MEM_ENCRYPT
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
--- a/lib/Kconfig.debug~kcov-fix-generic-kconfig-dependencies-if-arch_wants_no_instr
+++ a/lib/Kconfig.debug
@@ -1979,6 +1979,8 @@ config KCOV
 	bool "Code coverage for fuzzing"
 	depends on ARCH_HAS_KCOV
 	depends on CC_HAS_SANCOV_TRACE_PC || GCC_PLUGINS
+	depends on !ARCH_WANTS_NO_INSTR || STACK_VALIDATION || \
+		   GCC_VERSION >= 120000 || CLANG_VERSION >= 130000
 	select DEBUG_FS
 	select GCC_PLUGIN_SANCOV if !CC_HAS_SANCOV_TRACE_PC
 	help
_

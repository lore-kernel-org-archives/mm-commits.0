Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79FEC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 16:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243615AbhLJQit (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 11:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243603AbhLJQir (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 11:38:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386A7C061746
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 08:35:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 81B30CE2C1B
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 16:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2676FC00446;
        Fri, 10 Dec 2021 16:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639154108;
        bh=5IqD+deZwFm/hyzla3Qhhi9IMEpKbfJm0O5syTEfNxg=;
        h=Date:From:To:Subject:From;
        b=qWwyDqw5xLEEoh+hlQ1Yb0eY1PoizRb8vvDXrAwFVqNlV3hbq7kPcfMQG0AegbDqa
         w+LJ8T9XdC/3vKJDb7BtYI2Z4ZTA4s2vvSFi2Kik7/Ed98sK7ObKFuidXdHlFNEeP3
         lmjcwcwm8ujzfCNutw0iHwjhRjXTDvAlONWGRPPA=
Date:   Fri, 10 Dec 2021 08:35:07 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bp@alien8.de, catalin.marinas@arm.com,
        dave.hansen@linux.intel.com, dvyukov@google.com, elver@google.com,
        hpa@zytor.com, mark.rutland@arm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, peterz@infradead.org, tglx@linutronix.de,
        will@kernel.org
Subject:  +
 kcov-fix-generic-kconfig-dependencies-if-arch_wants_no_instr.patch added to
 -mm tree
Message-ID: <20211210163507.Wu6bT8kGg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: fix generic Kconfig dependencies if ARCH_WANTS_NO_INSTR
has been added to the -mm tree.  Its filename is
     kcov-fix-generic-kconfig-dependencies-if-arch_wants_no_instr.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kcov-fix-generic-kconfig-dependencies-if-arch_wants_no_instr.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kcov-fix-generic-kconfig-dependencies-if-arch_wants_no_instr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1985,6 +1985,8 @@ config KCOV
 	bool "Code coverage for fuzzing"
 	depends on ARCH_HAS_KCOV
 	depends on CC_HAS_SANCOV_TRACE_PC || GCC_PLUGINS
+	depends on !ARCH_WANTS_NO_INSTR || STACK_VALIDATION || \
+		   GCC_VERSION >= 120000 || CLANG_VERSION >= 130000
 	select DEBUG_FS
 	select GCC_PLUGIN_SANCOV if !CC_HAS_SANCOV_TRACE_PC
 	help
_

Patches currently in -mm which might be from elver@google.com are

mm-slab_common-use-warn-if-cache-still-has-objects-on-destroy.patch
kasan-test-add-globals-left-out-of-bounds-test.patch
kasan-add-ability-to-detect-double-kmem_cache_destroy.patch
kasan-test-add-test-case-for-double-kmem_cache_destroy.patch
panic-use-error_report_end-tracepoint-on-warnings.patch
kcov-fix-generic-kconfig-dependencies-if-arch_wants_no_instr.patch
lib-stackdepot-always-do-filter_irq_stacks-in-stack_depot_save.patch


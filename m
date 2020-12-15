Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69DF9C2BBCF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B50D22DCC
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgLPAAl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726206AbgLOX3j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:29:39 -0500
Date:   Tue, 15 Dec 2020 15:19:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074351;
        bh=ZSFPlAedE1qpeJfwQY2KoYiz8TQ1bpzCO/Fdi1WCal4=;
        h=From:To:Subject:From;
        b=eRiNw3Bv4mO/r811pqGsFNqgBiQJsxqC3v3IQ+QKgb3ECqY5mYrKJIBlaOFa84PNo
         XJ0R2HdyQObwLMyMGVUdFTo2QR2b8pSr0Uh+M+rREzPIaFHN5DaMOfYj79ToMoNjEt
         49w++n2PHd1imelgSdqxotSPDxv+wWfxKB9jM/o0=
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, arnd@arndb.de, bgeffon@google.com,
        bp@alien8.de, catalin.marinas@arm.com,
        christian.brauner@ubuntu.com, dave.hansen@intel.com,
        frederic@kernel.org, gshan@redhat.com, hnaveed@wavecomp.com,
        hpa@zytor.com, jhubbard@nvidia.com, justin.he@arm.com,
        kaleshsingh@google.com, keescook@chromium.org,
        kirill.shutemov@linux.intel.com, krzk@kernel.org,
        linuxram@us.ibm.com, lokeshgidra@google.com, mark.rutland@arm.com,
        masahiroy@kernel.org, mhiramat@kernel.org, minchan@google.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org,
        rcampbell@nvidia.com, rppt@kernel.org, samitolvanen@google.com,
        sandipan@linux.ibm.com, shuah@kernel.org, sjpark@amazon.de,
        steven.price@arm.com, surenb@google.com, tglx@linutronix.de,
        will@kernel.org, ziy@nvidia.com
Subject:  [merged] x86-mremap-speedup-enable-have_move_pud.patch
 removed from -mm tree
Message-ID: <20201215231909.P19IFqXlf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: mremap speedup - Enable HAVE_MOVE_PUD
has been removed from the -mm tree.  Its filename was
     x86-mremap-speedup-enable-have_move_pud.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kalesh Singh <kaleshsingh@google.com>
Subject: x86: mremap speedup - Enable HAVE_MOVE_PUD

HAVE_MOVE_PUD enables remapping pages at the PUD level if both the
source and destination addresses are PUD-aligned.

With HAVE_MOVE_PUD enabled it can be inferred that there is approximately
a 13x improvement in performance on x86. (See data below).

------- Test Results ---------

The following results were obtained using a 5.4 kernel, by remapping
a PUD-aligned, 1GB sized region to a PUD-aligned destination.
The results from 10 iterations of the test are given below:

Total mremap times for 1GB data on x86. All times are in nanoseconds.

Control        HAVE_MOVE_PUD

180394         15089
235728         14056
238931         25741
187330         13838
241742         14187
177925         14778
182758         14728
160872         14418
205813         15107
245722         13998

205721.5       15594    <-- Mean time in nanoseconds

A 1GB mremap completion time drops from ~205 microseconds
to ~15 microseconds on x86. (~13x speed up).

Link: https://lkml.kernel.org/r/20201014005320.2233162-6-kaleshsingh@google.com
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Hassan Naveed <hnaveed@wavecomp.com>
Cc: Jia He <justin.he@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/Kconfig~x86-mremap-speedup-enable-have_move_pud
+++ a/arch/x86/Kconfig
@@ -199,6 +199,7 @@ config X86
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_MOVE_PMD
+	select HAVE_MOVE_PUD
 	select HAVE_NMI
 	select HAVE_OPROFILE
 	select HAVE_OPTPROBES
_

Patches currently in -mm which might be from kaleshsingh@google.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBDF9C2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD49122D08
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgLPAAl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbgLOX3j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:29:39 -0500
Date:   Tue, 15 Dec 2020 15:19:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074347;
        bh=wc6ny73Ah4EcnD8SC2ZCbtUk2n7KctOZWH5/fEaee3U=;
        h=From:To:Subject:From;
        b=vCEchddNx4JPbE2K4Ku2EdkV7ZA85vXfY6OK5glP8x09FLetZzvE/4IEhSrZmVZyF
         UTRdX26tbqHXz/7AFoYPEPvO59r6E2IRafy7O/5doOPQEnAzVmvocnv0nNb9q8dwlf
         SkF5EU/tJSz1CADP2wNWS6k3o+TMJBzCMxPrTuWg=
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
Subject:  [merged] arm64-mremap-speedup-enable-have_move_pud.patch
 removed from -mm tree
Message-ID: <20201215231905.2r8VLHNfV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: mremap speedup - enable HAVE_MOVE_PUD
has been removed from the -mm tree.  Its filename was
     arm64-mremap-speedup-enable-have_move_pud.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kalesh Singh <kaleshsingh@google.com>
Subject: arm64: mremap speedup - enable HAVE_MOVE_PUD

HAVE_MOVE_PUD enables remapping pages at the PUD level if both the source
and destination addresses are PUD-aligned.

With HAVE_MOVE_PUD enabled it can be inferred that there is approximately
a 19x improvement in performance on arm64.  (See data below).

------- Test Results ---------

The following results were obtained using a 5.4 kernel, by remapping a
PUD-aligned, 1GB sized region to a PUD-aligned destination.  The results
from 10 iterations of the test are given below:

Total mremap times for 1GB data on arm64. All times are in nanoseconds.

Control          HAVE_MOVE_PUD

1247761          74271
1219896          46771
1094792          59687
1227760          48385
1043698          76666
1101771          50365
1159896          52500
1143594          75261
1025833          61354
1078125          48697

1134312.6        59395.7    <-- Mean time in nanoseconds

A 1GB mremap completion time drops from ~1.1 milliseconds to ~59
microseconds on arm64.  (~19x speed up).

Link: https://lkml.kernel.org/r/20201014005320.2233162-5-kaleshsingh@google.com
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Hassan Naveed <hnaveed@wavecomp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
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
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig               |    1 +
 arch/arm64/include/asm/pgtable.h |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mremap-speedup-enable-have_move_pud
+++ a/arch/arm64/include/asm/pgtable.h
@@ -462,6 +462,7 @@ static inline pmd_t pmd_mkdevmap(pmd_t p
 #define pfn_pud(pfn,prot)	__pud(__phys_to_pud_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
 #define set_pmd_at(mm, addr, pmdp, pmd)	set_pte_at(mm, addr, (pte_t *)pmdp, pmd_pte(pmd))
+#define set_pud_at(mm, addr, pudp, pud)	set_pte_at(mm, addr, (pte_t *)pudp, pud_pte(pud))
 
 #define __p4d_to_phys(p4d)	__pte_to_phys(p4d_pte(p4d))
 #define __phys_to_p4d_val(phys)	__phys_to_pte_val(phys)
--- a/arch/arm64/Kconfig~arm64-mremap-speedup-enable-have_move_pud
+++ a/arch/arm64/Kconfig
@@ -125,6 +125,7 @@ config ARM64
 	select HANDLE_DOMAIN_IRQ
 	select HARDIRQS_SW_RESEND
 	select HAVE_MOVE_PMD
+	select HAVE_MOVE_PUD
 	select HAVE_PCI
 	select HAVE_ACPI_APEI if (ACPI && EFI)
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
_

Patches currently in -mm which might be from kaleshsingh@google.com are



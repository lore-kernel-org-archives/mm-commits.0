Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E71EC433ED
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 22:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D553616EA
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 22:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhEKWSP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 18:18:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhEKWSP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 May 2021 18:18:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F1636191D;
        Tue, 11 May 2021 22:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620771428;
        bh=HbJwFYCKxbRBevEeuxCtgkMRxitr+L+Jpt/Y7W5vu58=;
        h=Date:From:To:Subject:From;
        b=wNmlQmO4ieE+ijUbW4Tnpeq8h1RkqD+ef5iXf6+U71IS4YoeqEOKo2SGsuPbGCyvV
         NLAB5MG7oJVsFtDWD6UZDl5VhIeFUTvbVNBKET+6Kc0ScFdhEw9x2BHL/0Yaz7oHFk
         WzCFtOf5EUj1IrUQiBGfijGxd6lC81gEHXobh4Sc=
Date:   Tue, 11 May 2021 15:17:07 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        joel@joelfernandes.org, kaleshsingh@google.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com
Subject:  + mm-mremap-allow-arch-runtime-override.patch added to
 -mm tree
Message-ID: <20210511221707.Mikop-Pt3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: allow arch runtime override
has been added to the -mm tree.  Its filename is
     mm-mremap-allow-arch-runtime-override.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-allow-arch-runtime-override.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-allow-arch-runtime-override.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/mremap: allow arch runtime override

Architectures like ppc64 support faster mremap only with radix
translation.  Hence allow a runtime check w.r.t support for fast mremap.

Link: https://lkml.kernel.org/r/20210422054323.150993-9-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/tlb.h |    6 ++++++
 mm/mremap.c                    |   15 ++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/tlb.h~mm-mremap-allow-arch-runtime-override
+++ a/arch/powerpc/include/asm/tlb.h
@@ -83,5 +83,11 @@ static inline int mm_is_thread_local(str
 }
 #endif
 
+#define arch_supports_page_table_move arch_supports_page_table_move
+static inline bool arch_supports_page_table_move(void)
+{
+	return radix_enabled();
+}
+
 #endif /* __KERNEL__ */
 #endif /* __ASM_POWERPC_TLB_H */
--- a/mm/mremap.c~mm-mremap-allow-arch-runtime-override
+++ a/mm/mremap.c
@@ -25,7 +25,7 @@
 #include <linux/userfaultfd_k.h>
 
 #include <asm/cacheflush.h>
-#include <asm/tlbflush.h>
+#include <asm/tlb.h>
 #include <asm/pgalloc.h>
 
 #include "internal.h"
@@ -220,6 +220,15 @@ static inline void flush_pte_tlb_pwc_ran
 }
 #endif
 
+#ifndef arch_supports_page_table_move
+#define arch_supports_page_table_move arch_supports_page_table_move
+static inline bool arch_supports_page_table_move(void)
+{
+	return IS_ENABLED(CONFIG_HAVE_MOVE_PMD) ||
+		IS_ENABLED(CONFIG_HAVE_MOVE_PUD);
+}
+#endif
+
 #ifdef CONFIG_HAVE_MOVE_PMD
 static bool move_normal_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 		  unsigned long new_addr, pmd_t *old_pmd, pmd_t *new_pmd)
@@ -228,6 +237,8 @@ static bool move_normal_pmd(struct vm_ar
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t pmd;
 
+	if (!arch_supports_page_table_move())
+		return false;
 	/*
 	 * The destination pmd shouldn't be established, free_pgtables()
 	 * should have released it.
@@ -294,6 +305,8 @@ static bool move_normal_pud(struct vm_ar
 	struct mm_struct *mm = vma->vm_mm;
 	pud_t pud;
 
+	if (!arch_supports_page_table_move())
+		return false;
 	/*
 	 * The destination pud shouldn't be established, free_pgtables()
 	 * should have released it.
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

selftest-mremap_test-update-the-test-to-handle-pagesize-other-than-4k.patch
selftest-mremap_test-avoid-crash-with-static-build.patch
mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch
powerpc-mm-book3s64-fix-possible-build-error.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush.patch
mm-mremap-move-tlb-flush-outside-page-table-lock.patch
mm-mremap-allow-arch-runtime-override.patch
powerpc-mm-enable-move-pmd-pud.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEDE4C433ED
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 22:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B55F06191D
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 22:16:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhEKWSB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 18:18:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229964AbhEKWSA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 May 2021 18:18:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1827B6191E;
        Tue, 11 May 2021 22:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620771413;
        bh=mSuODW5hR4r1fu4sVRt0rTYH1VGPIRvFcDq7dQlMcRU=;
        h=Date:From:To:Subject:From;
        b=ADQSWUgshknaUj2QK+bNQjIaAubyH6QQD7PoiHm61pH+FBDLCWEPjCGJ1i//iJmAt
         PWqYmVFMBfGLE36x92QSgT1ofCKCb51TQt5oXOyxbP+rcHK2ScoJMgXh4wGii/+wBS
         qz65jd3UqcmxodzPFEd7gfZZY+786KwHo936C0OQ=
Date:   Tue, 11 May 2021 15:16:52 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        joel@joelfernandes.org, kaleshsingh@google.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com
Subject:  +
 mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch added to
 -mm tree
Message-ID: <20210511221652.ZvIWfajeB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: use pmd/pud_poplulate to update page table entries
has been added to the -mm tree.  Its filename is
     mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch

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
Subject: mm/mremap: use pmd/pud_poplulate to update page table entries

pmd/pud_populate is the right interface to be used to set the respective
page table entries.  Some architectures like ppc64 do assume that
set_pmd/= pud_at can only be used to set a hugepage PTE.  Since we are not
setting up a hug= epage PTE here, use the pmd/pud_populate interface.

Link: https://lkml.kernel.org/r/20210422054323.150993-4-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/mremap.c~mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries
+++ a/mm/mremap.c
@@ -26,6 +26,7 @@
 
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
+#include <asm/pgalloc.h>
 
 #include "internal.h"
 
@@ -257,9 +258,8 @@ static bool move_normal_pmd(struct vm_ar
 	pmd_clear(old_pmd);
 
 	VM_BUG_ON(!pmd_none(*new_pmd));
+	pmd_populate(mm, new_pmd, (pgtable_t)pmd_page_vaddr(pmd));
 
-	/* Set the new pmd */
-	set_pmd_at(mm, new_addr, new_pmd, pmd);
 	flush_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
 	if (new_ptl != old_ptl)
 		spin_unlock(new_ptl);
@@ -306,8 +306,7 @@ static bool move_normal_pud(struct vm_ar
 
 	VM_BUG_ON(!pud_none(*new_pud));
 
-	/* Set the new pud */
-	set_pud_at(mm, new_addr, new_pud, pud);
+	pud_populate(mm, new_pud, (pmd_t *)pud_page_vaddr(pud));
 	flush_tlb_range(vma, old_addr, old_addr + PUD_SIZE);
 	if (new_ptl != old_ptl)
 		spin_unlock(new_ptl);
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


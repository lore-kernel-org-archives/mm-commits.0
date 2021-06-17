Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D44A8C2B9F4
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 04:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC265613E7
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 04:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbhFQEGi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Jun 2021 00:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229447AbhFQEGh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 17 Jun 2021 00:06:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9F10611CE;
        Thu, 17 Jun 2021 04:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623902670;
        bh=06ziY8cOTEhmTb3quZKVfQdAf4KxwAv4XN0xd8R7yUM=;
        h=Date:From:To:Subject:From;
        b=kMZyDk9M1wk8noUGje+7Vve0ENR0vIpDEKne92Xa6ACdqUHOYJELpfphfhKUNZlzj
         6ExBBZS3kRXJPrU5Bo+hkeu0YLCTPKC8a/vVPCytyNYPJ42885qmfRE3zNZ9W5h/P2
         lmvq5WRAuGrCgtoe5aB5YwtMUjCOWX6r1zDS+gp0=
Date:   Wed, 16 Jun 2021 21:04:29 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        hughd@google.com, joel@joelfernandes.org, kaleshsingh@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, npiggin@gmail.com, sfr@canb.auug.org.au
Subject:  +
 mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch added to
 -mm tree
Message-ID: <20210617040429.jlbQPWCzn%akpm@linux-foundation.org>
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
set_pmd/pud_at can only be used to set a hugepage PTE.  Since we are not
setting up a hugepage PTE here, use the pmd/pud_populate interface.

Link: https://lkml.kernel.org/r/20210616045239.370802-6-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
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
 
@@ -258,8 +259,7 @@ static bool move_normal_pmd(struct vm_ar
 
 	VM_BUG_ON(!pmd_none(*new_pmd));
 
-	/* Set the new pmd */
-	set_pmd_at(mm, new_addr, new_pmd, pmd);
+	pmd_populate(mm, new_pmd, pmd_pgtable(pmd));
 	flush_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
 	if (new_ptl != old_ptl)
 		spin_unlock(new_ptl);
@@ -306,8 +306,7 @@ static bool move_normal_pud(struct vm_ar
 
 	VM_BUG_ON(!pud_none(*new_pud));
 
-	/* Set the new pud */
-	set_pud_at(mm, new_addr, new_pud, pud);
+	pud_populate(mm, new_pud, pud_pgtable(pud));
 	flush_tlb_range(vma, old_addr, old_addr + PUD_SIZE);
 	if (new_ptl != old_ptl)
 		spin_unlock(new_ptl);
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t.patch
mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2.patch
mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t.patch
mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch
selftest-mremap_test-update-the-test-to-handle-pagesize-other-than-4k.patch
selftest-mremap_test-avoid-crash-with-static-build.patch
mm-mremap-convert-huge-pud-move-to-separate-helper.patch
mm-mremap-dont-enable-optimized-pud-move-if-page-table-levels-is-2.patch
mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch
mm-mremap-hold-the-rmap-lock-in-write-mode-when-moving-page-table-entries.patch
mm-mremap-allow-arch-runtime-override.patch
powerpc-book3s64-mm-update-flush_tlb_range-to-flush-page-walk-cache.patch
powerpc-mm-enable-have_move_pmd-support.patch


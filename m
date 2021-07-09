Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77192C07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DF87613D6
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhGIVgt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:36:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230519AbhGIVgs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:36:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7760D613D1;
        Fri,  9 Jul 2021 21:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866444;
        bh=lS5Jemr+QEiWkmkTFIstwtSPFzCD1KZOub7gwjhuAb4=;
        h=Date:From:To:Subject:From;
        b=vi5yBnvVAU7HXj75cfw1lUY3jNJkTwZXw4z57Tof0Jv/WLOBYPVIh5a3QDFu9gIVZ
         PJs1ANlGCehUkd2GcCsoSX3xQSpr3H4HsU2OUegpyU06FMauDFQVzYGQlJISnfhQlK
         U0UYfnp3QZ2xqM41vMRWBPhEhs7e7WGP+iN0OXzY=
Date:   Fri, 09 Jul 2021 14:34:04 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        hughd@google.com, joel@joelfernandes.org, kaleshsingh@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, npiggin@gmail.com, sfr@canb.auug.org.au
Subject:  [merged]
 mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch removed
 from -mm tree
Message-ID: <20210709213404._GpMHzX1A%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: use pmd/pud_poplulate to update page table entries
has been removed from the -mm tree.  Its filename was
     mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



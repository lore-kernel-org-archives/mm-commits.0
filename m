Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8472FC07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F99D61CD1
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhGHBMy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:12:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230233AbhGHBMy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:12:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3EF261CC4;
        Thu,  8 Jul 2021 01:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706613;
        bh=RDlcb7tw7At65K1VOucmo00LNaaG8kBWtnjA1abacQA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qCHaQYw5foM78GbHtAse1mxy+LsQVFMXspf1RB+5kPX+iH9lYRC6gzusghc7uQpA+
         r+F70GEXIsPx6Dv/XmeCFud1ZO/RuHfANY88KshQl/tN4Fpjk0iz1eeIfuvOpHBusR
         1UYD/MmHgCnc71+NoEuXX1Np9S+GvIAf8/V3IUG0=
Date:   Wed, 07 Jul 2021 18:10:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        christophe.leroy@csgroup.eu, hughd@google.com,
        joel@joelfernandes.org, kaleshsingh@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
        sfr@canb.auug.org.au, torvalds@linux-foundation.org
Subject:  [patch 50/54] mm/mremap: use pmd/pud_poplulate to update
 page table entries
Message-ID: <20210708011012.wfp_rfgph%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

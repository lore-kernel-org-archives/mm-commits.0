Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6613CC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1238F21655
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881271;
	bh=PmWuwfj6Hz8fM2NSJJ8Q1klFjhppKDCd76Qph59gN50=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Ak0AiM5isUN4xUZDYTyxezNt449P4Jkss1+xolli2eDccn8Ow4KWHtwyvIDISGRFZ
	 UWD+iaW63ShoqNFmOIwiaN8SYoRWLsskfN0nmiTHO4wpKBbPKTxYvhdgOdQ4aRGHkj
	 VUIFJK8hTk15EziC9Ket+ktwqSOdYT2guYvYEu4o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392647AbgJPUru (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:47:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391117AbgJPUru (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:47:50 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C56BE20878;
        Fri, 16 Oct 2020 20:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881270;
        bh=PmWuwfj6Hz8fM2NSJJ8Q1klFjhppKDCd76Qph59gN50=;
        h=Date:From:To:Subject:From;
        b=LDY2vrzRm9QusldrKPZhLYQ53eXVDM/bO8o7wxjqdI+nJHLRvq4kCLB4xkz+r4KWk
         BSx7+eubsMXVZiPYvoBRHZiioUbf65QqvFSNp6Ut2YkISIb52wq61lzvWjEP3+lFkN
         L8NYH6s0CwCor94poq7D2mFle0jYFtLImaVAqhY8=
Date:   Fri, 16 Oct 2020 13:47:49 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        christophe.leroy@csgroup.eu, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au
Subject:  [merged]
 mm-debug_vm_pgtable-pmd_clear-dont-use-pmd-pud_clear-on-pte-entries.patch
 removed from -mm tree
Message-ID: <20201016204749.EbyInp7CO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable/pmd_clear: don't use pmd/pud_clear on pte entries
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-pmd_clear-dont-use-pmd-pud_clear-on-pte-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/debug_vm_pgtable/pmd_clear: don't use pmd/pud_clear on pte entries

pmd_clear() should not be used to clear pmd level pte entries.

Link: https://lkml.kernel.org/r/20200902114222.181353-12-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-pmd_clear-dont-use-pmd-pud_clear-on-pte-entries
+++ a/mm/debug_vm_pgtable.c
@@ -196,6 +196,8 @@ static void __init pmd_advanced_tests(st
 	pmd = READ_ONCE(*pmdp);
 	WARN_ON(pmd_young(pmd));
 
+	/*  Clear the pte entries  */
+	pmdp_huge_get_and_clear(mm, vaddr, pmdp);
 	pgtable = pgtable_trans_huge_withdraw(mm, pmdp);
 }
 
@@ -319,6 +321,8 @@ static void __init pud_advanced_tests(st
 	pudp_test_and_clear_young(vma, vaddr, pudp);
 	pud = READ_ONCE(*pudp);
 	WARN_ON(pud_young(pud));
+
+	pudp_huge_get_and_clear(mm, vaddr, pudp);
 }
 
 static void __init pud_leaf_tests(unsigned long pfn, pgprot_t prot)
@@ -442,8 +446,6 @@ static void __init pud_populate_tests(st
 	 * This entry points to next level page table page.
 	 * Hence this must not qualify as pud_bad().
 	 */
-	pmd_clear(pmdp);
-	pud_clear(pudp);
 	pud_populate(mm, pudp, pmdp);
 	pud = READ_ONCE(*pudp);
 	WARN_ON(pud_bad(pud));
@@ -575,7 +577,6 @@ static void __init pmd_populate_tests(st
 	 * This entry points to next level page table page.
 	 * Hence this must not qualify as pmd_bad().
 	 */
-	pmd_clear(pmdp);
 	pmd_populate(mm, pmdp, pgtable);
 	pmd = READ_ONCE(*pmdp);
 	WARN_ON(pmd_bad(pmd));
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are



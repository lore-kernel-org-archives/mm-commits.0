Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D2CFC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BC9220897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817509;
	bh=EDZeoik6ip2wmYr+ORIrFSiuIfWG+o83Omgn/oxpoKo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=YdUiQu4vbGGf3UpbMQgml92inFO2wgsyfapzQvEbOXQ6pdCC1EVolyhV5H7EHCdPV
	 4CSEsK4QDx1mDKbaEO2iFhjIVi7HWKzCafB8J4qqd3zavSDKtt7T66kUjrJc1CpWD4
	 5IFfytLHZ5gFZ4vCOSgKS1XtJWAGvw/4ur1/3zuI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392207AbgJPDFI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:05:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDFI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:05:08 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D5DD20878;
        Fri, 16 Oct 2020 03:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817507;
        bh=EDZeoik6ip2wmYr+ORIrFSiuIfWG+o83Omgn/oxpoKo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BMJ2naMngzeH5B1pRd2oRZJ/A/5zSt4BhpdLuQxE4eIHIx0ViV0N47jD2m+9Kellb
         zmfgTBHQ8Dl12sUe2TaYfcQitm/Q/xfaJ7X5f7XFIXgtKZl8i1awZbGnNXkIko8IFR
         6q/yZOo3VRlCcnN1M37MkF5O80Y4t6sgpwd9u14Y=
Date:   Thu, 15 Oct 2020 20:05:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, aou@eecs.berkeley.edu,
        christophe.leroy@csgroup.eu, linux@roeck-us.net,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        natechancellor@gmail.com, palmer@dabbelt.com,
        paul.walmsley@sifive.com, torvalds@linux-foundation.org
Subject:  [patch 014/156] mm/debug_vm_pgtable: avoid none pte in
 pte_clear_test
Message-ID: <20201016030506.lGMcDjbrJ%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/debug_vm_pgtable: avoid none pte in pte_clear_test

pte_clear_tests operate on an existing pte entry.  Make sure that is not a
none pte entry.

[aneesh.kumar@linux.ibm.com: avoid kernel crash with riscv]
  Link: https://lkml.kernel.org/r/20201015033206.140550-1-aneesh.kumar@linux.ibm.com
Link: https://lkml.kernel.org/r/20200902114222.181353-14-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-avoid-none-pte-in-pte_clear_test
+++ a/mm/debug_vm_pgtable.c
@@ -542,12 +542,15 @@ static void __init pgd_populate_tests(st
 #endif /* PAGETABLE_P4D_FOLDED */
 
 static void __init pte_clear_tests(struct mm_struct *mm, pte_t *ptep,
-				   unsigned long vaddr)
+				   unsigned long pfn, unsigned long vaddr,
+				   pgprot_t prot)
 {
-	pte_t pte = ptep_get(ptep);
+	pte_t pte = pfn_pte(pfn, prot);
 
 	pr_debug("Validating PTE clear\n");
+#ifndef CONFIG_RISCV
 	pte = __pte(pte_val(pte) | RANDOM_ORVALUE);
+#endif
 	set_pte_at(mm, vaddr, ptep, pte);
 	barrier();
 	pte_clear(mm, vaddr, ptep);
@@ -998,7 +1001,7 @@ static int __init debug_vm_pgtable(void)
 
 	ptl = pte_lockptr(mm, pmdp);
 	spin_lock(ptl);
-	pte_clear_tests(mm, ptep, vaddr);
+	pte_clear_tests(mm, ptep, pte_aligned, vaddr, prot);
 	pte_advanced_tests(mm, vma, ptep, pte_aligned, vaddr, prot);
 	pte_unmap_unlock(ptep, ptl);
 
_

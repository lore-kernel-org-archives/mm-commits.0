Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01554C432BE
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 18:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D93E1610EA
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 18:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235193AbhHISAW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Aug 2021 14:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235980AbhHIR7K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Aug 2021 13:59:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B136115B;
        Mon,  9 Aug 2021 17:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628531870;
        bh=focxFIqC7wv2wdMDVzKRbE68EOW/3iH28pzzrX4gE+0=;
        h=Date:From:To:Subject:From;
        b=2TBg+N072VyM7dGyl2tKzYbFHgHZ7ZGMyMdGXiZ3vRkMoxIkWnYrQ8ehYz1YmchFa
         05D+SOwovc0u1Y2ojdf1baSDu/Gi/DF1C5uY80l/I9Tj8Nvegqhl7FrRNM5peVl6c1
         9YHHFr5joYDXCuh4kHNmWjaVp5dJEfN/0MFcw3p0=
Date:   Mon, 09 Aug 2021 10:57:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, vgupta@synopsys.com,
        gerald.schaefer@linux.ibm.com, chuhu@redhat.com,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com, cai@lca.pw,
        anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com,
        gshan@redhat.com
Subject:  [to-be-updated]
 mm-debug_vm_pgtable-remove-unused-code.patch removed from -mm tree
Message-ID: <20210809175749.-mE5S%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: remove unused code
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-remove-unused-code.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/debug_vm_pgtable: remove unused code

The variables used by old implementation isn't needed as we switched to
"struct pgtable_debug_args".  Lets remove them and related code in
debug_vm_pgtable().

Link: https://lkml.kernel.org/r/20210802060419.1360913-12-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Chunyu Hu <chuhu@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   54 ----------------------------------------
 1 file changed, 54 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-remove-unused-code
+++ a/mm/debug_vm_pgtable.c
@@ -1188,15 +1188,7 @@ error:
 static int __init debug_vm_pgtable(void)
 {
 	struct pgtable_debug_args args;
-	struct vm_area_struct *vma;
-	struct mm_struct *mm;
-	pgd_t *pgdp;
-	p4d_t *p4dp;
-	pud_t *pudp;
-	pmd_t *pmdp, *saved_pmdp, pmd;
 	pte_t *ptep;
-	pgtable_t saved_ptep;
-	unsigned long vaddr;
 	spinlock_t *ptl = NULL;
 	int idx, ret;
 
@@ -1205,41 +1197,6 @@ static int __init debug_vm_pgtable(void)
 	if (ret)
 		return ret;
 
-	vaddr = get_random_vaddr();
-	mm = mm_alloc();
-	if (!mm) {
-		pr_err("mm_struct allocation failed\n");
-		return 1;
-	}
-
-	vma = vm_area_alloc(mm);
-	if (!vma) {
-		pr_err("vma allocation failed\n");
-		return 1;
-	}
-
-	pgdp = pgd_offset(mm, vaddr);
-	p4dp = p4d_alloc(mm, pgdp, vaddr);
-	pudp = pud_alloc(mm, p4dp, vaddr);
-	pmdp = pmd_alloc(mm, pudp, vaddr);
-	/*
-	 * Allocate pgtable_t
-	 */
-	if (pte_alloc(mm, pmdp)) {
-		pr_err("pgtable allocation failed\n");
-		return 1;
-	}
-
-	/*
-	 * Save all the page table page addresses as the page table
-	 * entries will be used for testing with random or garbage
-	 * values. These saved addresses will be used for freeing
-	 * page table pages.
-	 */
-	pmd = READ_ONCE(*pmdp);
-	saved_pmdp = pmd_offset(pudp, 0UL);
-	saved_ptep = pmd_pgtable(pmd);
-
 	/*
 	 * Iterate over the protection_map[] to make sure that all
 	 * the basic page table transformation validations just hold
@@ -1322,17 +1279,6 @@ static int __init debug_vm_pgtable(void)
 	pgd_populate_tests(&args);
 	spin_unlock(&(args.mm->page_table_lock));
 
-	p4d_free(mm, p4d_offset(pgdp, 0UL));
-	pud_free(mm, pud_offset(p4dp, 0UL));
-	pmd_free(mm, saved_pmdp);
-	pte_free(mm, saved_ptep);
-
-	vm_area_free(vma);
-	mm_dec_nr_puds(mm);
-	mm_dec_nr_pmds(mm);
-	mm_dec_nr_ptes(mm);
-	mmdrop(mm);
-
 	destroy_args(&args);
 	return 0;
 }
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-debug_vm_pgtable-fix-corrupted-page-flag.patch


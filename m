Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7964FC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63BC7610D2
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238770AbhICU4s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349849AbhICU4r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:56:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A89E4610E5;
        Fri,  3 Sep 2021 20:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702547;
        bh=bkbSg5n5IN0fCwcnz0jD9jm1BQkOzKBZoJWHC6CvwiM=;
        h=Date:From:To:Subject:From;
        b=EDV1aGO9wFXN3dzIyzByjL8tE9CJe9fGpSX2RKIcycdta4Qfl1qNavtWJvYb8GHxK
         AnrWJdeB/LUBbUTohe0cMWPfTDKLq/VpUF04AiTYm8LYDrrLvYV/bn08QqSQbfVKsM
         R/CyGdSg+BjQPdBrnIQJbJa5CNuTk/hm9kB6+yag=
Date:   Fri, 03 Sep 2021 13:55:46 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, cai@lca.pw,
        catalin.marinas@arm.com, christophe.leroy@csgroup.eu,
        chuhu@redhat.com, gerald.schaefer@linux.ibm.com, gshan@redhat.com,
        mm-commits@vger.kernel.org, vgupta@synopsys.com, will@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-debug=5Fvm=5Fpgtable-use-struct-pgtable=5Fdebug=5Fargs-?=
 =?US-ASCII?Q?in-pgd-and-p4d-modifying-tests.patch?= removed from -mm tree
Message-ID: <20210903205546.4sKXOitAG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in PGD and P4D modifying tests
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pgd-and-p4d-modifying-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in PGD and P4D modifying tests

This uses struct pgtable_debug_args in PGD/P4D modifying tests.  No
allocated huge page is used in these tests.  Besides, the unused variable
@saved_p4dp and @saved_pudp are dropped.

Link: https://lkml.kernel.org/r/20210809092631.1888748-11-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>	[powerpc 8xx]
Tested-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>	[s390]
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chunyu Hu <chuhu@redhat.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   86 +++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 48 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pgd-and-p4d-modifying-tests
+++ a/mm/debug_vm_pgtable.c
@@ -518,27 +518,26 @@ static void __init pud_populate_tests(st
 #endif /* PAGETABLE_PUD_FOLDED */
 
 #ifndef __PAGETABLE_P4D_FOLDED
-static void __init p4d_clear_tests(struct mm_struct *mm, p4d_t *p4dp)
+static void __init p4d_clear_tests(struct pgtable_debug_args *args)
 {
-	p4d_t p4d = READ_ONCE(*p4dp);
+	p4d_t p4d = READ_ONCE(*args->p4dp);
 
-	if (mm_pud_folded(mm))
+	if (mm_pud_folded(args->mm))
 		return;
 
 	pr_debug("Validating P4D clear\n");
 	p4d = __p4d(p4d_val(p4d) | RANDOM_ORVALUE);
-	WRITE_ONCE(*p4dp, p4d);
-	p4d_clear(p4dp);
-	p4d = READ_ONCE(*p4dp);
+	WRITE_ONCE(*args->p4dp, p4d);
+	p4d_clear(args->p4dp);
+	p4d = READ_ONCE(*args->p4dp);
 	WARN_ON(!p4d_none(p4d));
 }
 
-static void __init p4d_populate_tests(struct mm_struct *mm, p4d_t *p4dp,
-				      pud_t *pudp)
+static void __init p4d_populate_tests(struct pgtable_debug_args *args)
 {
 	p4d_t p4d;
 
-	if (mm_pud_folded(mm))
+	if (mm_pud_folded(args->mm))
 		return;
 
 	pr_debug("Validating P4D populate\n");
@@ -546,34 +545,33 @@ static void __init p4d_populate_tests(st
 	 * This entry points to next level page table page.
 	 * Hence this must not qualify as p4d_bad().
 	 */
-	pud_clear(pudp);
-	p4d_clear(p4dp);
-	p4d_populate(mm, p4dp, pudp);
-	p4d = READ_ONCE(*p4dp);
+	pud_clear(args->pudp);
+	p4d_clear(args->p4dp);
+	p4d_populate(args->mm, args->p4dp, args->start_pudp);
+	p4d = READ_ONCE(*args->p4dp);
 	WARN_ON(p4d_bad(p4d));
 }
 
-static void __init pgd_clear_tests(struct mm_struct *mm, pgd_t *pgdp)
+static void __init pgd_clear_tests(struct pgtable_debug_args *args)
 {
-	pgd_t pgd = READ_ONCE(*pgdp);
+	pgd_t pgd = READ_ONCE(*(args->pgdp));
 
-	if (mm_p4d_folded(mm))
+	if (mm_p4d_folded(args->mm))
 		return;
 
 	pr_debug("Validating PGD clear\n");
 	pgd = __pgd(pgd_val(pgd) | RANDOM_ORVALUE);
-	WRITE_ONCE(*pgdp, pgd);
-	pgd_clear(pgdp);
-	pgd = READ_ONCE(*pgdp);
+	WRITE_ONCE(*args->pgdp, pgd);
+	pgd_clear(args->pgdp);
+	pgd = READ_ONCE(*args->pgdp);
 	WARN_ON(!pgd_none(pgd));
 }
 
-static void __init pgd_populate_tests(struct mm_struct *mm, pgd_t *pgdp,
-				      p4d_t *p4dp)
+static void __init pgd_populate_tests(struct pgtable_debug_args *args)
 {
 	pgd_t pgd;
 
-	if (mm_p4d_folded(mm))
+	if (mm_p4d_folded(args->mm))
 		return;
 
 	pr_debug("Validating PGD populate\n");
@@ -581,23 +579,17 @@ static void __init pgd_populate_tests(st
 	 * This entry points to next level page table page.
 	 * Hence this must not qualify as pgd_bad().
 	 */
-	p4d_clear(p4dp);
-	pgd_clear(pgdp);
-	pgd_populate(mm, pgdp, p4dp);
-	pgd = READ_ONCE(*pgdp);
+	p4d_clear(args->p4dp);
+	pgd_clear(args->pgdp);
+	pgd_populate(args->mm, args->pgdp, args->start_p4dp);
+	pgd = READ_ONCE(*args->pgdp);
 	WARN_ON(pgd_bad(pgd));
 }
 #else  /* !__PAGETABLE_P4D_FOLDED */
-static void __init p4d_clear_tests(struct mm_struct *mm, p4d_t *p4dp) { }
-static void __init pgd_clear_tests(struct mm_struct *mm, pgd_t *pgdp) { }
-static void __init p4d_populate_tests(struct mm_struct *mm, p4d_t *p4dp,
-				      pud_t *pudp)
-{
-}
-static void __init pgd_populate_tests(struct mm_struct *mm, pgd_t *pgdp,
-				      p4d_t *p4dp)
-{
-}
+static void __init p4d_clear_tests(struct pgtable_debug_args *args) { }
+static void __init pgd_clear_tests(struct pgtable_debug_args *args) { }
+static void __init p4d_populate_tests(struct pgtable_debug_args *args) { }
+static void __init pgd_populate_tests(struct pgtable_debug_args *args) { }
 #endif /* PAGETABLE_P4D_FOLDED */
 
 static void __init pte_clear_tests(struct pgtable_debug_args *args)
@@ -1200,8 +1192,8 @@ static int __init debug_vm_pgtable(void)
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 	pgd_t *pgdp;
-	p4d_t *p4dp, *saved_p4dp;
-	pud_t *pudp, *saved_pudp;
+	p4d_t *p4dp;
+	pud_t *pudp;
 	pmd_t *pmdp, *saved_pmdp, pmd;
 	pgtable_t saved_ptep;
 	unsigned long vaddr;
@@ -1245,8 +1237,6 @@ static int __init debug_vm_pgtable(void)
 	 * page table pages.
 	 */
 	pmd = READ_ONCE(*pmdp);
-	saved_p4dp = p4d_offset(pgdp, 0UL);
-	saved_pudp = pud_offset(p4dp, 0UL);
 	saved_pmdp = pmd_offset(pudp, 0UL);
 	saved_ptep = pmd_pgtable(pmd);
 
@@ -1325,15 +1315,15 @@ static int __init debug_vm_pgtable(void)
 	pud_populate_tests(&args);
 	spin_unlock(ptl);
 
-	spin_lock(&mm->page_table_lock);
-	p4d_clear_tests(mm, p4dp);
-	pgd_clear_tests(mm, pgdp);
-	p4d_populate_tests(mm, p4dp, saved_pudp);
-	pgd_populate_tests(mm, pgdp, saved_p4dp);
-	spin_unlock(&mm->page_table_lock);
+	spin_lock(&(args.mm->page_table_lock));
+	p4d_clear_tests(&args);
+	pgd_clear_tests(&args);
+	p4d_populate_tests(&args);
+	pgd_populate_tests(&args);
+	spin_unlock(&(args.mm->page_table_lock));
 
-	p4d_free(mm, saved_p4dp);
-	pud_free(mm, saved_pudp);
+	p4d_free(mm, p4d_offset(pgdp, 0UL));
+	pud_free(mm, pud_offset(p4dp, 0UL));
 	pmd_free(mm, saved_pmdp);
 	pte_free(mm, saved_ptep);
 
_

Patches currently in -mm which might be from gshan@redhat.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6CAEC4338F
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF06F60F6B
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbhG0UxA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:53:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231961AbhG0UxA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 16:53:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9386260F9D;
        Tue, 27 Jul 2021 20:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627419179;
        bh=0M9mwEW0f7QUj5h+3S2s9/XkIQyivatyYTCqdvY8jaU=;
        h=Date:From:To:Subject:From;
        b=rluwtMDwLmsS3h4cl355PcJubQ678JlzPu4lsdJhweqKNY1R1KjLGPJLW8pqpoJO4
         6iQ0BHwiXj2sP/tL+9n/zWsIWjQGLItK8kf1+Pv77oV9QKQFUetUPppXyBh5hMtoGq
         8jW9Z0GoitZidaKUJi248HdOz5Xj/HCatkjTjE6w=
Date:   Tue, 27 Jul 2021 13:52:59 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        gerald.schaefer@linux.ibm.com, chuhu@redhat.com,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com, cai@lca.pw,
        anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com,
        gshan@redhat.com
Subject:  +
 =?us-ascii?Q?mm-debug=5Fvm=5Fpgtable-use-struct-pgtable=5Fdebug=5Fargs-?=
 =?us-ascii?Q?in-pgd-and-p4d-modifying-tests.patch?= added to -mm tree
Message-ID: <20210727205259.hRL6Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in PGD and P4D modifying tests
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pgd-and-p4d-modifying-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pgd-and-p4d-modifying-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pgd-and-p4d-modifying-tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in PGD and P4D modifying tests

This uses struct pgtable_debug_args in PGD/P4D modifying tests.  No
allocated huge page is used in these tests.  Besides, the unused variable
@saved_p4dp and @saved_pudp are dropped.

Link: https://lkml.kernel.org/r/20210727061401.592616-11-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Chunyu Hu <chuhu@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Qian Cai <cai@lca.pw>
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
@@ -1212,8 +1204,8 @@ static int __init debug_vm_pgtable(void)
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 	pgd_t *pgdp;
-	p4d_t *p4dp, *saved_p4dp;
-	pud_t *pudp, *saved_pudp;
+	p4d_t *p4dp;
+	pud_t *pudp;
 	pmd_t *pmdp, *saved_pmdp, pmd;
 	pte_t *ptep;
 	pgtable_t saved_ptep;
@@ -1258,8 +1250,6 @@ static int __init debug_vm_pgtable(void)
 	 * page table pages.
 	 */
 	pmd = READ_ONCE(*pmdp);
-	saved_p4dp = p4d_offset(pgdp, 0UL);
-	saved_pudp = pud_offset(p4dp, 0UL);
 	saved_pmdp = pmd_offset(pudp, 0UL);
 	saved_ptep = pmd_pgtable(pmd);
 
@@ -1338,15 +1328,15 @@ static int __init debug_vm_pgtable(void)
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

mm-debug_vm_pgtable-introduce-struct-pgtable_debug_args.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-basic-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-leaf-and-savewrite-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-protnone-and-devmap-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-soft_dirty-and-swap-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-migration-and-thp-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pte-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pmd-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pud-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pgd-and-p4d-modifying-tests.patch
mm-debug_vm_pgtable-remove-unused-code.patch
mm-debug_vm_pgtable-fix-corrupted-page-flag.patch


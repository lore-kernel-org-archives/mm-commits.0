Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C29C07E95
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 22:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DFBC61004
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 22:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhGTV3W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 17:29:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231974AbhGTV3D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 17:29:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E83736120C;
        Tue, 20 Jul 2021 22:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626818976;
        bh=ia8i+ii0dtrUu++yNoVrSH/juwuM138GLGEmSgsYYHs=;
        h=Date:From:To:Subject:From;
        b=lD9Z1cTfxQLOiq9j60FRypLyU9wk70a883NH0k7dschT6eXfUb4BIyeCYg7MXPx8k
         Be5nsuEi5ai6X4jvoseKNeR4ezXLSFLnh+IQWSAm7/gn9o114IhVHfO+2jvm1yWbbW
         ROmWYtOeUPoNbhgzl58a9J/cfBYMaBoPMI1aQ99s=
Date:   Tue, 20 Jul 2021 15:09:35 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, chuhu@redhat.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        gshan@redhat.com
Subject:  [to-be-updated]
 =?us-ascii?Q?mm-debug=5Fvm=5Fpgtable-use-struct-vm=5Fpgtable=5Fdebug-in-p?=
 =?us-ascii?Q?gd-and-p4d-modifying-tests.patch?= removed from -mm tree
Message-ID: <20210720220935.fWQ9n%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: use struct vm_pgtable_debug in PGD and P4D modifying tests
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-pgd-and-p4d-modifying-tests.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/debug_vm_pgtable: use struct vm_pgtable_debug in PGD and P4D modifying tests

This uses struct vm_pgtable_debug in PGD/P4D modifying tests.  No
allocated huge page is used in these tests.

Link: https://lkml.kernel.org/r/20210706061748.161258-11-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chunyu Hu <chuhu@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   76 +++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 42 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-pgd-and-p4d-modifying-tests
+++ a/mm/debug_vm_pgtable.c
@@ -520,27 +520,26 @@ static void __init pud_populate_tests(st
 #endif /* PAGETABLE_PUD_FOLDED */
 
 #ifndef __PAGETABLE_P4D_FOLDED
-static void __init p4d_clear_tests(struct mm_struct *mm, p4d_t *p4dp)
+static void __init p4d_clear_tests(struct vm_pgtable_debug *debug)
 {
-	p4d_t p4d = READ_ONCE(*p4dp);
+	p4d_t p4d = READ_ONCE(*(debug->p4dp));
 
-	if (mm_pud_folded(mm))
+	if (mm_pud_folded(debug->mm))
 		return;
 
 	pr_debug("Validating P4D clear\n");
 	p4d = __p4d(p4d_val(p4d) | RANDOM_ORVALUE);
-	WRITE_ONCE(*p4dp, p4d);
-	p4d_clear(p4dp);
-	p4d = READ_ONCE(*p4dp);
+	WRITE_ONCE(*(debug->p4dp), p4d);
+	p4d_clear(debug->p4dp);
+	p4d = READ_ONCE(*(debug->p4dp));
 	WARN_ON(!p4d_none(p4d));
 }
 
-static void __init p4d_populate_tests(struct mm_struct *mm, p4d_t *p4dp,
-				      pud_t *pudp)
+static void __init p4d_populate_tests(struct vm_pgtable_debug *debug)
 {
 	p4d_t p4d;
 
-	if (mm_pud_folded(mm))
+	if (mm_pud_folded(debug->mm))
 		return;
 
 	pr_debug("Validating P4D populate\n");
@@ -548,34 +547,33 @@ static void __init p4d_populate_tests(st
 	 * This entry points to next level page table page.
 	 * Hence this must not qualify as p4d_bad().
 	 */
-	pud_clear(pudp);
-	p4d_clear(p4dp);
-	p4d_populate(mm, p4dp, pudp);
-	p4d = READ_ONCE(*p4dp);
+	pud_clear(debug->pudp);
+	p4d_clear(debug->p4dp);
+	p4d_populate(debug->mm, debug->p4dp, debug->start_pudp);
+	p4d = READ_ONCE(*(debug->p4dp));
 	WARN_ON(p4d_bad(p4d));
 }
 
-static void __init pgd_clear_tests(struct mm_struct *mm, pgd_t *pgdp)
+static void __init pgd_clear_tests(struct vm_pgtable_debug *debug)
 {
-	pgd_t pgd = READ_ONCE(*pgdp);
+	pgd_t pgd = READ_ONCE(*(debug->pgdp));
 
-	if (mm_p4d_folded(mm))
+	if (mm_p4d_folded(debug->mm))
 		return;
 
 	pr_debug("Validating PGD clear\n");
 	pgd = __pgd(pgd_val(pgd) | RANDOM_ORVALUE);
-	WRITE_ONCE(*pgdp, pgd);
-	pgd_clear(pgdp);
-	pgd = READ_ONCE(*pgdp);
+	WRITE_ONCE(*(debug->pgdp), pgd);
+	pgd_clear(debug->pgdp);
+	pgd = READ_ONCE(*(debug->pgdp));
 	WARN_ON(!pgd_none(pgd));
 }
 
-static void __init pgd_populate_tests(struct mm_struct *mm, pgd_t *pgdp,
-				      p4d_t *p4dp)
+static void __init pgd_populate_tests(struct vm_pgtable_debug *debug)
 {
 	pgd_t pgd;
 
-	if (mm_p4d_folded(mm))
+	if (mm_p4d_folded(debug->mm))
 		return;
 
 	pr_debug("Validating PGD populate\n");
@@ -583,23 +581,17 @@ static void __init pgd_populate_tests(st
 	 * This entry points to next level page table page.
 	 * Hence this must not qualify as pgd_bad().
 	 */
-	p4d_clear(p4dp);
-	pgd_clear(pgdp);
-	pgd_populate(mm, pgdp, p4dp);
-	pgd = READ_ONCE(*pgdp);
+	p4d_clear(debug->p4dp);
+	pgd_clear(debug->pgdp);
+	pgd_populate(debug->mm, debug->pgdp, debug->start_p4dp);
+	pgd = READ_ONCE(*(debug->pgdp));
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
+static void __init p4d_clear_tests(struct vm_pgtable_debug *debug) { }
+static void __init pgd_clear_tests(struct vm_pgtable_debug *debug) { }
+static void __init p4d_populate_tests(struct vm_pgtable_debug *debug) { }
+static void __init pgd_populate_tests(struct vm_pgtable_debug *debug) { }
 #endif /* PAGETABLE_P4D_FOLDED */
 
 static void __init pte_clear_tests(struct vm_pgtable_debug *debug)
@@ -1300,12 +1292,12 @@ static int __init debug_vm_pgtable(void)
 	pud_populate_tests(&debug);
 	spin_unlock(ptl);
 
-	spin_lock(&mm->page_table_lock);
-	p4d_clear_tests(mm, p4dp);
-	pgd_clear_tests(mm, pgdp);
-	p4d_populate_tests(mm, p4dp, saved_pudp);
-	pgd_populate_tests(mm, pgdp, saved_p4dp);
-	spin_unlock(&mm->page_table_lock);
+	spin_lock(&(debug.mm->page_table_lock));
+	p4d_clear_tests(&debug);
+	pgd_clear_tests(&debug);
+	p4d_populate_tests(&debug);
+	pgd_populate_tests(&debug);
+	spin_unlock(&(debug.mm->page_table_lock));
 
 	p4d_free(mm, saved_p4dp);
 	pud_free(mm, saved_pudp);
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-debug_vm_pgtable-remove-unused-code.patch
mm-debug_vm_pgtable-fix-corrupted-page-flag.patch


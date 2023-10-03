Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE4F0E7AD74
	for <mm-commits@archiver.kernel.org>; Tue,  3 Oct 2023 16:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240030AbjJCQCS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Oct 2023 12:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbjJCQCS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2023 12:02:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1CF1B4
        for <mm-commits@vger.kernel.org>; Tue,  3 Oct 2023 09:02:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE43C433C7;
        Tue,  3 Oct 2023 16:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696348922;
        bh=XJj0AH+dELcTG+Oqzg/AdC61JCXEHV9BWxK/ZIRSLik=;
        h=Date:To:From:Subject:From;
        b=ocWznvuIn+p1MwXnKz0LvTQuxaGwiSmqiUZauoxvRyf+17PV6prQDesaoRr7SF2cG
         3HeNIU5VxHyJblWP25niGZtaRf4PH7vMR0sCS45a1QkI40WkOc1mBxJHFJUhUgoDbm
         M68D00O4oqdkYBJzcSd3DQ+BVnzUUWbWHCIZu+Eo=
Date:   Tue, 03 Oct 2023 09:02:01 -0700
To:     mm-commits@vger.kernel.org, ryan.roberts@arm.com,
        paul.walmsley@sifive.com, panqinglin2020@iscas.ac.cn,
        palmer@dabbelt.com, conor@kernel.org, aou@eecs.berkeley.edu,
        ajones@ventanamicro.com, alexghiti@rivosinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-fix-set_huge_pte_at-for-napot-mappings-when-a-swap-entry-is-set.patch added to mm-hotfixes-unstable branch
Message-Id: <20231003160202.4AE43C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv: fix set_huge_pte_at() for NAPOT mappings when a swap entry is set
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     riscv-fix-set_huge_pte_at-for-napot-mappings-when-a-swap-entry-is-set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-fix-set_huge_pte_at-for-napot-mappings-when-a-swap-entry-is-set.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: riscv: fix set_huge_pte_at() for NAPOT mappings when a swap entry is set
Date: Thu, 28 Sep 2023 17:18:46 +0200

We used to determine the number of page table entries to set for a NAPOT
hugepage by using the pte value which actually fails when the pte to set
is a swap entry.

So take advantage of a recent fix for arm64 reported in [1] which
introduces the size of the mapping as an argument of set_huge_pte_at(): we
can then use this size to compute the number of page table entries to set
for a NAPOT region.

Link: https://lkml.kernel.org/r/20230928151846.8229-3-alexghiti@rivosinc.com
Fixes: 82a1a1f3bfb6 ("riscv: mm: support Svnapot in hugetlb page")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Closes: https://lore.kernel.org/linux-arm-kernel/20230922115804.2043771-1-ryan.roberts@arm.com/ [1]
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Qinglin Pan <panqinglin2020@iscas.ac.cn>
Cc: Conor Dooley <conor@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/mm/hugetlbpage.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/arch/riscv/mm/hugetlbpage.c~riscv-fix-set_huge_pte_at-for-napot-mappings-when-a-swap-entry-is-set
+++ a/arch/riscv/mm/hugetlbpage.c
@@ -183,15 +183,22 @@ void set_huge_pte_at(struct mm_struct *m
 		     pte_t pte,
 		     unsigned long sz)
 {
+	unsigned long hugepage_shift;
 	int i, pte_num;
 
-	if (!pte_napot(pte)) {
-		set_pte_at(mm, addr, ptep, pte);
-		return;
-	}
+	if (sz >= PGDIR_SIZE)
+		hugepage_shift = PGDIR_SHIFT;
+	else if (sz >= P4D_SIZE)
+		hugepage_shift = P4D_SHIFT;
+	else if (sz >= PUD_SIZE)
+		hugepage_shift = PUD_SHIFT;
+	else if (sz >= PMD_SIZE)
+		hugepage_shift = PMD_SHIFT;
+	else
+		hugepage_shift = PAGE_SHIFT;
 
-	pte_num = napot_pte_num(napot_cont_order(pte));
-	for (i = 0; i < pte_num; i++, ptep++, addr += PAGE_SIZE)
+	pte_num = sz >> hugepage_shift;
+	for (i = 0; i < pte_num; i++, ptep++, addr += (1 << hugepage_shift))
 		set_pte_at(mm, addr, ptep, pte);
 }
 
_

Patches currently in -mm which might be from alexghiti@rivosinc.com are

riscv-handle-vm_fault_-faults-instead-of-panicking.patch
riscv-fix-set_huge_pte_at-for-napot-mappings-when-a-swap-entry-is-set.patch


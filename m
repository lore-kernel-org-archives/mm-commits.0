Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1073E94125
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbjJFVrL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbjJFVrD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:47:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D136BE
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:47:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709DEC433C7;
        Fri,  6 Oct 2023 21:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628820;
        bh=B0gGtcHHHZNczqwafebNS3TC2bATZGbuMgxRHwIYqEI=;
        h=Date:To:From:Subject:From;
        b=Yokin+tbOVRLXjnpLk1F0u2fvQlvnDcYl02WA7SpumvZSO4kveowltsiCkc2StKqW
         1evJr58uwqkEmHqqQYPUIAwQdxkih0gF1fRq3aMOaR/Rz8Ah35zRvNU9WxvwTA5JIt
         4yJNa39PMgiCQGGaZQ1gdLw3YfsfwlsNPzxwoaHg=
Date:   Fri, 06 Oct 2023 14:46:58 -0700
To:     mm-commits@vger.kernel.org, ryan.roberts@arm.com,
        paul.walmsley@sifive.com, panqinglin2020@iscas.ac.cn,
        palmer@dabbelt.com, conor@kernel.org, aou@eecs.berkeley.edu,
        ajones@ventanamicro.com, alexghiti@rivosinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] riscv-fix-set_huge_pte_at-for-napot-mappings-when-a-swap-entry-is-set.patch removed from -mm tree
Message-Id: <20231006214700.709DEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: riscv: fix set_huge_pte_at() for NAPOT mappings when a swap entry is set
has been removed from the -mm tree.  Its filename was
     riscv-fix-set_huge_pte_at-for-napot-mappings-when-a-swap-entry-is-set.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



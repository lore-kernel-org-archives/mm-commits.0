Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE293D1A8F;
	Tue, 30 Jun 2026 04:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782792323; cv=none; b=VkqB0NWbtncPK/+DnVe7o+jBW+vitCfgxuanCGfwPR4VlfGPYNKHfMWlgAjf3dUhM6cJMODg6o0EO46FgasCa/K8YIHUW86+1HFDxyaTgx+lFllMAErhs+5SEqoT6Ik8gjtwErmbc2KfAH7s10KX03v2C/I/HVriut5Tpe478pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782792323; c=relaxed/simple;
	bh=95O7Wao62v3RiGOdIRMuJmVIvKSvaa/7CnOUjaXPybw=;
	h=Date:To:From:Subject:Message-Id; b=hREoiHX2/2bjqEZLxv2PnLmtUCdyUEdZYZjeF1Iwv4yjPMh+eJiHqIIuFF+UcbGBRh4+Wty8KOOsbsz0fFRKJucvOe+/C/vdHLP3LNZ+MufMEHYARMykNq+3/aHt6f6wHdVSdBucBfXlN9tV1RfWQCwa4vc+khRuFLCwQwiNs2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1ERTBICu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1ERTBICu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA0E1F000E9;
	Tue, 30 Jun 2026 04:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782792318;
	bh=UNFHlV6QbWQkxz0nq9746r9Y7bJ09t24YmRa4DK4Z7Y=;
	h=Date:To:From:Subject;
	b=1ERTBICunzJeD5Le8iT9iLK5r7Vlx/VeIH5cuwNi8W/wdG7YAonBx3eqiruyqCYKt
	 Dm755jNK+3kCDOL9TUjOihD8G2+BSI4eXKb6eTKdy0q5I3WdUFxL7npqZJdjnn8eVr
	 2Dyn+6ioWSloCqp1q/n2/sPt8btlPYrsGpcz29gA=
Date: Mon, 29 Jun 2026 21:05:17 -0700
To: mm-commits@vger.kernel.org,tongtiangen@huawei.com,stable@vger.kernel.org,paul.walmsley@sifive.com,pasha.tatashin@soleen.com,palmer@dabbelt.com,aou@eecs.berkeley.edu,cuiyunhui@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-mm-exclude-invalid-thp-pmds-from-page-table-check.patch added to mm-nonmm-unstable branch
Message-Id: <20260630040518.3BA0E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: mm: exclude invalid THP PMDs from page table check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     riscv-mm-exclude-invalid-thp-pmds-from-page-table-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-mm-exclude-invalid-thp-pmds-from-page-table-check.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Yunhui Cui <cuiyunhui@bytedance.com>
Subject: riscv: mm: exclude invalid THP PMDs from page table check
Date: Sat, 23 May 2026 12:20:52 +0800

RISC-V THP splitting uses a temporary invalid PMD state where
pmd_mkinvalid() clears _PAGE_PRESENT and _PAGE_PROT_NONE but leaves
_PAGE_LEAF set so the MM code can still recognize the PMD as a THP split
in-progress entry.

That temporary state no longer describes a user-accessible mapping, but
page_table_check currently treats it as one because the RISC-V PMD
user-accessibility test only checks whether the PMD is a leaf and has user
permissions.

As a result, when a PMD-sized anonymous THP is split during a COW fault,
page_table_check can account the invalid intermediate PMD as a live PMD
mapping, and then account the replacement PTE mappings again when the
split installs the PTE table.  This leaves stale PMD accounting behind and
later triggers page_table_check failures such as a non-zero anon_map_count
when the folio is freed.

Fix this by tightening pmd_user_accessible_page() so PMD page-table-check
accounting only considers leaf PMDs that still carry either _PAGE_PRESENT
or _PAGE_PROT_NONE.  This preserves the THP split semantics required by
the MM code while preventing page_table_check from treating invalid split
PMDs as live user mappings.

With CONFIG_PAGE_TABLE_CHECK=y and CONFIG_PAGE_TABLE_CHECK_ENFORCED=y,
tools/testing/selftests/mm/cow completes successfully on RISC-V after this
change.

Link: https://lore.kernel.org/20260523042052.35476-1-cuiyunhui@bytedance.com
Fixes: 3fee229a8eb9 ("riscv/mm: enable ARCH_SUPPORTS_PAGE_TABLE_CHECK")
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: tongtiangen <tongtiangen@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/pgtable.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/riscv/include/asm/pgtable.h~riscv-mm-exclude-invalid-thp-pmds-from-page-table-check
+++ a/arch/riscv/include/asm/pgtable.h
@@ -986,7 +986,14 @@ static inline bool pte_user_accessible_p
 
 static inline bool pmd_user_accessible_page(struct mm_struct *mm, unsigned long addr, pmd_t pmd)
 {
-	return pmd_leaf(pmd) && pmd_user(pmd);
+	/*
+	 * page_table_check() must ignore THP split invalidation entries created by
+	 * pmd_mkinvalid(). These retain _PAGE_LEAF so pmd_present()/pmd_leaf() stay
+	 * true during the split, but they no longer describe a user-accessible
+	 * mapping once both _PAGE_PRESENT and _PAGE_PROT_NONE are cleared.
+	 */
+	return (pmd_val(pmd) & (_PAGE_PRESENT | _PAGE_PROT_NONE)) &&
+		(pmd_val(pmd) & _PAGE_LEAF) && pmd_user(pmd);
 }
 
 static inline bool pud_user_accessible_page(struct mm_struct *mm, unsigned long addr, pud_t pud)
_

Patches currently in -mm which might be from cuiyunhui@bytedance.com are

mm-gup_test-fix-race-with-pin_longterm_test-ioctls.patch
riscv-mm-exclude-invalid-thp-pmds-from-page-table-check.patch


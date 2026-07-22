Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C85154425;
	Wed, 22 Jul 2026 23:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784761788; cv=none; b=XUZs1KCYYrQD2Hmrg79CPwhn+/XzG8QahTlwt48exCVtGYaYv10JumgWOhR5NddaarPb8zlaBEwRurxJRQXss7CizAOybqT+LCey9axiqAiQluA7NdnX8IipUGNMvodyjySDkh3g1hmWqOEFdHXGHb4kuiVq0CYtgtYtljDSdPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784761788; c=relaxed/simple;
	bh=ndPFJ7/7heiyeAON/rY0WqsU91YJyM+Ho5ZQJSJfTGw=;
	h=Date:To:From:Subject:Message-Id; b=WYvuuJUOxaaJRBfQ5TIIha1ERlXp5OGBDljedyIX3NOIQmqaROIn9euHpR7qCCHD+/d/SXSnS4g7aI+HuG1FM2Dgbo/iwRyWg7+rtiG09bBl9BsE6UcU0wF9fDZQ8V+5OzsUTa2f6CLxJrM1L0DwKT9fzJpuQsCE+TwCkIRNq7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gWIsQl59; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gWIsQl59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F751F000E9;
	Wed, 22 Jul 2026 23:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784761787;
	bh=9biYUlbQNrpqH5KAKkO4VmjdcWIP6SPcxWZtdZyTIeM=;
	h=Date:To:From:Subject;
	b=gWIsQl59PtYGrbw6k1g6EA9OxRg4cOL5rekP3X8yXAma3zkQFK4HsewCu8iCCa/jG
	 Y4J34UGobbJ2yvEWVl7HolaBSzdJmzGhKx5bv3vqclmsiCWcl4xcRm5cKr/kK761Ci
	 LS1/MlO89twlnnfsYhGMsaJqaWCd8j5eHx6nBmrs=
Date: Wed, 22 Jul 2026 16:09:46 -0700
To: mm-commits@vger.kernel.org,vega@nebusec.ai,stable@vger.kernel.org,pasha.tatashin@soleen.com,enjou1224z@gmail.com,zhilinz@nebusec.ai,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-skip-special-zero-mappings.patch added to mm-hotfixes-unstable branch
Message-Id: <20260722230946.F3F751F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_table_check: skip special zero mappings
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_table_check-skip-special-zero-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-skip-special-zero-mappings.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Zhiling Zou <zhilinz@nebusec.ai>
Subject: mm/page_table_check: skip special zero mappings
Date: Thu, 23 Jul 2026 00:48:13 +0800

page_table_check_set() and page_table_check_clear() account mappings based
on PageAnon().  Shared zero-page PTEs and huge zero PMDs are special
mappings, but page_table_check can still account them as file-backed
pages.

An unprivileged process can populate enough zero mappings to overflow
file_map_count and hit the existing BUG_ON().  The PTE path can do this
with the shared zero page, and the PMD path can do the same with huge zero
mappings.

Skip special zero mappings in the user page-table accounting paths.  Keep
the PTE-side pte_special() check, and identify huge zero PMDs from the
mapped folio instead of pmd_special().  That covers architectures where
pmd_special() is a no-op without adding huge_zero_pfn checks to the
generic counter helpers.

Link: https://lore.kernel.org/cover.1784717203.git.zhilinz@nebusec.ai
Link: https://lore.kernel.org/e94478e4fb7912fb7e8ebebed5ce85d00dc9a69d.1784717203.git.zhilinz@nebusec.ai
Fixes: df4e817b7108 ("mm: page table check")
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Reported-by: Vega <vega@nebusec.ai>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Assisted-by: Codex:gpt-5.4
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/mm/page_table_check.c~mm-page_table_check-skip-special-zero-mappings
+++ a/mm/page_table_check.c
@@ -151,18 +151,29 @@ void __page_table_check_pte_clear(struct
 	if (&init_mm == mm)
 		return;
 
-	if (pte_user_accessible_page(mm, addr, pte))
+	if (pte_user_accessible_page(mm, addr, pte) && !pte_special(pte))
 		page_table_check_clear(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT);
 }
 EXPORT_SYMBOL(__page_table_check_pte_clear);
 
+static inline bool page_table_check_huge_zero_pmd(pmd_t pmd)
+{
+	unsigned long pfn = pmd_pfn(pmd);
+
+	if (!pfn_valid(pfn))
+		return false;
+
+	return is_huge_zero_folio(page_folio(pfn_to_page(pfn)));
+}
+
 void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
 				  pmd_t pmd)
 {
 	if (&init_mm == mm)
 		return;
 
-	if (pmd_user_accessible_page(mm, addr, pmd))
+	if (pmd_user_accessible_page(mm, addr, pmd) &&
+	    !page_table_check_huge_zero_pmd(pmd))
 		page_table_check_clear(pmd_pfn(pmd), PMD_SIZE >> PAGE_SHIFT);
 }
 EXPORT_SYMBOL(__page_table_check_pmd_clear);
@@ -208,7 +219,7 @@ void __page_table_check_ptes_set(struct
 
 	for (i = 0; i < nr; i++)
 		__page_table_check_pte_clear(mm, addr + PAGE_SIZE * i, ptep_get(ptep + i));
-	if (pte_user_accessible_page(mm, addr, pte))
+	if (pte_user_accessible_page(mm, addr, pte) && !pte_special(pte))
 		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
 }
 EXPORT_SYMBOL(__page_table_check_ptes_set);
@@ -238,7 +249,8 @@ void __page_table_check_pmds_set(struct
 
 	for (i = 0; i < nr; i++)
 		__page_table_check_pmd_clear(mm, addr + PMD_SIZE * i, *(pmdp + i));
-	if (pmd_user_accessible_page(mm, addr, pmd))
+	if (pmd_user_accessible_page(mm, addr, pmd) &&
+	    !page_table_check_huge_zero_pmd(pmd))
 		page_table_check_set(pmd_pfn(pmd), stride * nr, pmd_write(pmd));
 }
 EXPORT_SYMBOL(__page_table_check_pmds_set);
_

Patches currently in -mm which might be from zhilinz@nebusec.ai are

mm-page_table_check-skip-special-zero-mappings.patch


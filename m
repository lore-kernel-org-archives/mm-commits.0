Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C503BB10C;
	Wed,  5 Aug 2026 03:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785898988; cv=none; b=cb4AXP4yJAKbuHnpvO14rCIlSmQ5G+NaSOP1ZsV4HqZezAalL9ErhryFyBrIga5/CXl8rqMYTsfTNLPd1gyu0x9NKvQ0HSpg02xhkJ+7/w7Jlv3LjcjT5Y5Vj2BUfrNpNLdnRJY3UOUaxNClm+mM58uKifQemUQQOoEb05AKInA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785898988; c=relaxed/simple;
	bh=PfnG2/z22aJLzlaOEdMi7z7aV0T7RLd/KFyKXkh8xfw=;
	h=Date:To:From:Subject:Message-Id; b=ljyQ4EE9BRSJFtWk+J1E/dr1Z1WnXMU3bTl1c7PjTU2S2RoG+itNh3KkReaOb2VV7+m4Bi+38zxEHgtmhDdbTTZtsL+XiSqF2NxwcHIShxeujcoJzeAghJ0v1He5qy9Vi7hZGGd/NJEEttCgL8IZSrnpuK/vYpcjYR76uSgs/+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SIurrjaC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SIurrjaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC111F00A3A;
	Wed,  5 Aug 2026 03:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785898986;
	bh=THuG4vH4dgz61zwIANzV9ttd1EqCOrffpATk4uDWwxs=;
	h=Date:To:From:Subject;
	b=SIurrjaCxtvDVcE8Hrkcd+8kVjIFwG+/EEy0qp/U8Vxkl17JE5QlQ9VYPMf+rMK19
	 KCTfWbAuwSPtNSvKX6elOUs4IFq7ovUVCWPke/kzRTWwwcvkSTCWq2hIxPj5yFFNih
	 9uOeXfa1u+e/HmlJVfN1uTd0SWitx3VxUL/0JDYo=
Date: Tue, 04 Aug 2026 20:03:05 -0700
To: mm-commits@vger.kernel.org,vega@nebusec.ai,stable@vger.kernel.org,pasha.tatashin@soleen.com,enjou1224z@gmail.com,zhilinz@nebusec.ai,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_table_check-skip-special-zero-mappings.patch removed from -mm tree
Message-Id: <20260805030306.4CC111F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_table_check: skip special zero mappings
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-skip-special-zero-mappings.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-shmem-reject-page-aligned-fallocate-end-overflow.patch


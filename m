Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1576536D516
	for <mm-commits@vger.kernel.org>; Fri, 21 Nov 2025 19:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763754805; cv=none; b=qRvkKk0nwRBqoVJELYbotO9bmLcwfEr/ln/gwnjumeSHWmAmW+NIG6SPr++VGNLE9pQIgFcFVyljex3kox25bewmVaEyNME6jLcQ/0l26mKvqKUVGFMLqSKnOgpoi7vf8ZZQYQa0aZYcmwQrAhLAydu6HyxcARs2P68Ids9H0B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763754805; c=relaxed/simple;
	bh=AH3bdIe88pfVXFmJ4HCAq4wbQr5fvlVlvEq9wXsqRWE=;
	h=Date:To:From:Subject:Message-Id; b=qvGBQKPDYNzqysfw3fK8Als98l39EThBLtK+116D3kWwDOxvLy8kaKwf0qGA+7B4I7f7GRyj8fABii9VJkqNjEcQj9EeGoAnNWhfgiY7KbEipo8yMsFXg26vJIGZYx6mfR8hDVXEmdIVqYUZaDN2tUHrPXtefVYJe0EqKNdTK+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c/NiD79z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c/NiD79z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780CBC4CEF1;
	Fri, 21 Nov 2025 19:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763754804;
	bh=AH3bdIe88pfVXFmJ4HCAq4wbQr5fvlVlvEq9wXsqRWE=;
	h=Date:To:From:Subject:From;
	b=c/NiD79z8G9RderDbtJHzwxgIHHT4TdtvMRmxkU+usr4Kw/ko/EraSxCeboo9yxNZ
	 48YsNZ15JZejQR8vJ8LHIObr3eP92WNi6+QmC5Kk6Ep9ieRCXrUt12hcDT8McglcUI
	 qvjF8siP1uSWJZ2AyqxOFiCUsUQcVneN26cKWZqw=
Date: Fri, 21 Nov 2025 11:53:23 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd-fix.patch added to mm-unstable branch
Message-Id: <20251121195324.780CBC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_table_check: fix device private check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/page_table_check: fix device private check
Date: Fri, 21 Nov 2025 19:20:57 +0000

check writable, not readable/writable, per Vlastimil

Link: https://lkml.kernel.org/r/cd97b6ec-00f9-45a4-9ae0-8f009c212a94@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_table_check.c~mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd-fix
+++ a/mm/page_table_check.c
@@ -181,7 +181,7 @@ EXPORT_SYMBOL(__page_table_check_pud_cle
 /* Whether the swap entry cached writable information */
 static inline bool softleaf_cached_writable(softleaf_t entry)
 {
-	return softleaf_is_device_private(entry) ||
+	return softleaf_is_device_private_write(entry) ||
 		softleaf_is_migration_write(entry);
 }
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-introduce-vma-flags-bitmap-type.patch
mm-correctly-handle-uffd-pte-markers.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic.patch
mm-avoid-unnecessary-uses-of-is_swap_pte.patch
mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices.patch
mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch
fs-proc-task_mmu-refactor-pagemap_pmd_range.patch
mm-avoid-unnecessary-use-of-is_swap_pmd.patch
mm-huge_memory-refactor-copy_huge_pmd-non-present-logic.patch
mm-huge_memory-refactor-change_huge_pmd-non-present-logic.patch
mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd.patch
mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd-fix.patch
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-softleaf-helpers-instead.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-softleaf_from_pte.patch
mm-softdirty-add-pgtable_supports_soft_dirty-fix.patch
tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA2CA944
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 22:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764024705; cv=none; b=Nj2yOdX/Oo5RPvW6Pp0vZbnPOQi1TXTzyQdF05m8yr68rVg8zwM8GfbLvBWDBOPKsKGyrP7g6WBLR7513McYmxjtmV+vQsreBpHyEAaS9eafhYsgiBwxC7EE2P1qh8W5chI5vFt3ASkG0kIVMWPLkKbTWZrD45ob0qw+T+qMmiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764024705; c=relaxed/simple;
	bh=UTuVpYup8XmqBT1FwT6QIEM61+FuhpMZ+sEsfzPEwnc=;
	h=Date:To:From:Subject:Message-Id; b=iU/3oErq1ltinx7OTX6tKRJfke+KQfpCusDabvEL118kZ5xaU8jc99nwSipgQKagpWZJiLwIcZ9nrjF6tANl9oMQVpsSxwTXglnm9NH6/pcmk68E1vnhAmRs7xkWGdnglJcT+wJn6nj/Bcs5zCS0M309yiCH/7TQahjysIU/Axo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GlEfXp1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GlEfXp1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0923AC4CEF1;
	Mon, 24 Nov 2025 22:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764024705;
	bh=UTuVpYup8XmqBT1FwT6QIEM61+FuhpMZ+sEsfzPEwnc=;
	h=Date:To:From:Subject:From;
	b=GlEfXp1qPp+RutCquJ0r/wSxiBF+v4qm6JbxQFloaiPB14KFi1PRfZhHiMjynpYmL
	 4X1twg4iin5ZDUvx3NYGM0ObHWMZMASp2PJA0cR90KbrZ2NF3yALKp+RJuaT2o7kUl
	 OJIjWWs2/4XIg1JGBI9vQTEoaw1QCOF7uBZEeVnw=
Date: Mon, 24 Nov 2025 14:51:44 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd-fix.patch removed from -mm tree
Message-Id: <20251124225145.0923AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_table_check: fix device private check
has been removed from the -mm tree.  Its filename was
     mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd-fix.patch

This patch was dropped because it was folded into mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd.patch

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
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-softleaf-helpers-instead.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-softleaf_from_pte.patch
mm-softdirty-add-pgtable_supports_soft_dirty-fix.patch
tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch


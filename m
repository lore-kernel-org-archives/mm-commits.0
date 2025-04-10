Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F00F20E711;
	Thu, 10 Apr 2025 22:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744325247; cv=none; b=bj5OVjOfo6HtPdtV6TsCtzV9mrrqn/OqpIecscu+XqIxBMU0wj3/s47yE+4eu5V4KyhZJ8ANYUO1+0y1v0Sv8FfzhwGpBlWF5r4oIIsqJKF/18ztLJAOA6kQuOo62RIFdpdDfM2X+6cZtUkSFVZ8bUFCSutO1jnHrdiGa6NjXmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744325247; c=relaxed/simple;
	bh=DTRkNNiO9oFOFGncd0BEsw9Kdo0L0H8hQ+EkS/cMfZw=;
	h=Date:To:From:Subject:Message-Id; b=D+mNDe/HzrNKQLH/y8FcpNNpY0u34jR/T3ay4JvAzEbfvET0bh4HCSINkcKQHpSfbkJ4q3AUt/oGfypnMcL7ccOE4LIZYu4GChj3xUiwco1qJ7bZgLt9fOGwl6s2U1oDTeYfnLOYiJHXJ0/dWpJw58MCI4PqwXWs8s3ZseoABM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V6M9fPYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V6M9fPYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB51AC4CEE9;
	Thu, 10 Apr 2025 22:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744325246;
	bh=DTRkNNiO9oFOFGncd0BEsw9Kdo0L0H8hQ+EkS/cMfZw=;
	h=Date:To:From:Subject:From;
	b=V6M9fPYI5kGFJZnzDHvCLmZd1MdXhoJ0X8PlR+dL8GrnU27X5rqxcaajIwie9d2d3
	 5DxZ2p9QLz4VjHubh8BZMgZerSW+jQ8jLHBbM7Byr2fkyzvRqPYX5Jvl4zWTTzfANJ
	 F1gC/qzS/iBoWUKEzgV41yYGeVs4DNiXHDyViyUo=
Date: Thu, 10 Apr 2025 15:47:26 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ryabinin.a.a@gmail.com,npiggin@gmail.com,linux@roeck-us.net,jgross@suse.com,jeremy@goop.org,hughd@google.com,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-protect-kernel-pgtables-in-apply_to_pte_range.patch removed from -mm tree
Message-Id: <20250410224726.BB51AC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: protect kernel pgtables in apply_to_pte_range()
has been removed from the -mm tree.  Its filename was
     mm-protect-kernel-pgtables-in-apply_to_pte_range.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: mm: protect kernel pgtables in apply_to_pte_range()
Date: Tue, 8 Apr 2025 18:07:32 +0200

The lazy MMU mode can only be entered and left under the protection of the
page table locks for all page tables which may be modified.  Yet, when it
comes to kernel mappings apply_to_pte_range() does not take any locks. 
That does not conform arch_enter|leave_lazy_mmu_mode() semantics and could
potentially lead to re-schedulling a process while in lazy MMU mode or
racing on a kernel page table updates.

Link: https://lkml.kernel.org/r/ef8f6538b83b7fc3372602f90375348f9b4f3596.1744128123.git.agordeev@linux.ibm.com
Fixes: 38e0edb15bd0 ("mm/apply_to_range: call pte function with lazy updates")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Juegren Gross <jgross@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |    7 ++-----
 mm/memory.c       |    5 ++++-
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/kasan/shadow.c~mm-protect-kernel-pgtables-in-apply_to_pte_range
+++ a/mm/kasan/shadow.c
@@ -308,14 +308,14 @@ static int kasan_populate_vmalloc_pte(pt
 	__memset((void *)page, KASAN_VMALLOC_INVALID, PAGE_SIZE);
 	pte = pfn_pte(PFN_DOWN(__pa(page)), PAGE_KERNEL);
 
-	spin_lock(&init_mm.page_table_lock);
 	if (likely(pte_none(ptep_get(ptep)))) {
 		set_pte_at(&init_mm, addr, ptep, pte);
 		page = 0;
 	}
-	spin_unlock(&init_mm.page_table_lock);
+
 	if (page)
 		free_page(page);
+
 	return 0;
 }
 
@@ -401,13 +401,10 @@ static int kasan_depopulate_vmalloc_pte(
 
 	page = (unsigned long)__va(pte_pfn(ptep_get(ptep)) << PAGE_SHIFT);
 
-	spin_lock(&init_mm.page_table_lock);
-
 	if (likely(!pte_none(ptep_get(ptep)))) {
 		pte_clear(&init_mm, addr, ptep);
 		free_page(page);
 	}
-	spin_unlock(&init_mm.page_table_lock);
 
 	return 0;
 }
--- a/mm/memory.c~mm-protect-kernel-pgtables-in-apply_to_pte_range
+++ a/mm/memory.c
@@ -2926,6 +2926,7 @@ static int apply_to_pte_range(struct mm_
 			pte = pte_offset_kernel(pmd, addr);
 		if (!pte)
 			return err;
+		spin_lock(&init_mm.page_table_lock);
 	} else {
 		if (create)
 			pte = pte_alloc_map_lock(mm, pmd, addr, &ptl);
@@ -2951,7 +2952,9 @@ static int apply_to_pte_range(struct mm_
 
 	arch_leave_lazy_mmu_mode();
 
-	if (mm != &init_mm)
+	if (mm == &init_mm)
+		spin_unlock(&init_mm.page_table_lock);
+	else
 		pte_unmap_unlock(mapped_pte, ptl);
 
 	*mask |= PGTBL_PTE_MODIFIED;
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are



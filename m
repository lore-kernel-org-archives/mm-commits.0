Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469712701AC;
	Thu, 24 Apr 2025 21:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745530271; cv=none; b=MoBdcGh5rh7JCwVIy77cPPiemkuhG2IVrHh+H6R3tpE+9QhySG8K5IP5fCc7f8lb3d+csKa8abpJQsDRfVYx8uu7IaW2S87s8asAgptysSl7+hXLZ5b8hWoDW2dASC4ZVAHc3wAkZNLRxpFzQCmprXxPuQ0lq+OdPeaRj25GDNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745530271; c=relaxed/simple;
	bh=Nyl8up2tOsjVm+IjdQA9JUKV7IhTKARROQ82LGEckIE=;
	h=Date:To:From:Subject:Message-Id; b=q1IKWGx2mmhNU57X/QfnVSve4arfep5j5eADvZ4GuzLL6YylMF0sdmTy/m/yC0tz4miBtABpXWs/v0S+KYLQz2W3PLV1FId6oiHReym4lc2RjtoXi8uCsHOxIqGPd7RH8M0xe/cP1KOUrcb/FOgFfMK8AhP+HhE0GHhjydtBDqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=evglQcw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="evglQcw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D62AC4CEE3;
	Thu, 24 Apr 2025 21:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745530270;
	bh=Nyl8up2tOsjVm+IjdQA9JUKV7IhTKARROQ82LGEckIE=;
	h=Date:To:From:Subject:From;
	b=evglQcw1G95nhgHGgJ1FfPG256fHKPL5zx0ZdqULUhPbeUIwGUR1HMHTZgYqNlB3w
	 MGHVWNGsCIZ3kbt/6boJVhgqcGBpJE0rUda9oGTNm4ALwL32Rd/djXeh9viZlsygC1
	 zvBkXRi9aYaBB1G6o58FFJ1DeE3YUoYyarnD/sVs=
Date: Thu, 24 Apr 2025 14:31:09 -0700
To: mm-commits@vger.kernel.org,zhanghongchen@loongson.cn,willy@infradead.org,stable@vger.kernel.org,ryan.roberts@arm.com,rientjes@google.com,osalvador@suse.de,nao.horiguchi@gmail.com,mhocko@suse.cz,joern@logfs.org,hughd@google.com,david@redhat.com,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,andrii@kernel.org,wangming01@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] smaps-fix-crash-in-smaps_hugetlb_range-for-non-present-hugetlb-entries.patch removed from -mm tree
Message-Id: <20250424213110.8D62AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: smaps: fix crash in smaps_hugetlb_range for non-present hugetlb entries
has been removed from the -mm tree.  Its filename was
     smaps-fix-crash-in-smaps_hugetlb_range-for-non-present-hugetlb-entries.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Ming Wang <wangming01@loongson.cn>
Subject: smaps: fix crash in smaps_hugetlb_range for non-present hugetlb entries
Date: Wed, 23 Apr 2025 09:03:59 +0800

When reading /proc/pid/smaps for a process that has mapped a hugetlbfs
file with MAP_PRIVATE, the kernel might crash inside
pfn_swap_entry_to_page.  This occurs on LoongArch under specific
conditions.

The root cause involves several steps:

1. When the hugetlbfs file is mapped (MAP_PRIVATE), the initial PMD
   (or relevant level) entry is often populated by the kernel during
   mmap() with a non-present entry pointing to the architecture's
   invalid_pte_table On the affected LoongArch system, this address was
   observed to be 0x90000000031e4000.

2. The smaps walker (walk_hugetlb_range -> smaps_hugetlb_range) reads
   this entry.

3. The generic is_swap_pte() macro checks `!pte_present() &&
   !pte_none()`.  The entry (invalid_pte_table address) is not present. 
   Crucially, the generic pte_none() check (`!(pte_val(pte) &
   ~_PAGE_GLOBAL)`) returns false because the invalid_pte_table address is
   non-zero.  Therefore, is_swap_pte() incorrectly returns true.

4. The code enters the `else if (is_swap_pte(...))` block.

5. Inside this block, it checks `is_pfn_swap_entry()`.  Due to a bit
   pattern coincidence in the invalid_pte_table address on LoongArch, the
   embedded generic `is_migration_entry()` check happens to return true
   (misinterpreting parts of the address as a migration type).

6. This leads to a call to pfn_swap_entry_to_page() with the bogus
   swap entry derived from the invalid table address.

7. pfn_swap_entry_to_page() extracts a meaningless PFN, finds an
   unrelated struct page, checks its lock status (unlocked), and hits the
   `BUG_ON(is_migration_entry(entry) && !PageLocked(p))` assertion.

The original code's intent in the `else if` block seems aimed at handling
potential migration entries, as indicated by the inner
`is_pfn_swap_entry()` check.  The issue arises because the outer
`is_swap_pte()` check incorrectly includes the invalid table pointer case
on LoongArch.

This patch fixes the issue by changing the condition in
smaps_hugetlb_range() from the broad `is_swap_pte()` to the specific
`is_hugetlb_entry_migration()`.

The `is_hugetlb_entry_migration()` helper function correctly handles this
by first checking `huge_pte_none()`.  Architectures like LoongArch can
provide an override for `huge_pte_none()` that specifically recognizes the
`invalid_pte_table` address as a "none" state for HugeTLB entries.  This
ensures `is_hugetlb_entry_migration()` returns false for the invalid
entry, preventing the code from entering the faulty block.

This change makes the code reflect the likely original intent (handling
migration) more accurately and leverages architecture-specific helpers
(`huge_pte_none`) to correctly interpret special PTE/PMD values in the
HugeTLB context, fixing the crash on LoongArch without altering the
generic is_swap_pte() behavior.

Link: https://lkml.kernel.org/r/20250423010359.2030576-1-wangming01@loongson.cn
Fixes: 25ee01a2fca0 ("mm: hugetlb: proc: add hugetlb-related fields to /proc/PID/smaps")
Co-developed-by: Hongchen Zhang <zhanghongchen@loongson.cn>
Signed-off-by: Hongchen Zhang <zhanghongchen@loongson.cn>
Signed-off-by: Ming Wang <wangming01@loongson.cn>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joern Engel <joern@logfs.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~smaps-fix-crash-in-smaps_hugetlb_range-for-non-present-hugetlb-entries
+++ a/fs/proc/task_mmu.c
@@ -1027,7 +1027,7 @@ static int smaps_hugetlb_range(pte_t *pt
 	if (pte_present(ptent)) {
 		folio = page_folio(pte_page(ptent));
 		present = true;
-	} else if (is_swap_pte(ptent)) {
+	} else if (is_hugetlb_entry_migration(ptent)) {
 		swp_entry_t swpent = pte_to_swp_entry(ptent);
 
 		if (is_pfn_swap_entry(swpent))
_

Patches currently in -mm which might be from wangming01@loongson.cn are



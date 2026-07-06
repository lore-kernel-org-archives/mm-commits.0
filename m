Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7807A31CA4E
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 17:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360122; cv=none; b=A++usoslBEeFqxFgCGJCEHkWoA4cRzJftSaqPkUbf6NxsU/xRqPR/qxwlpoLp3RNKTBj+s7JIf5TOG3WaPcE0H5t0EBJzLtN40xSDzMwb1CrtjfQz+azgMipCLX0H47DDifXHgutAZD9L8DJfaGFSp6Yjd8KbkdAornW7mzSrzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360122; c=relaxed/simple;
	bh=8kC0+OOsWiu+UDPLqQTouQEMIaQVFYNZ8Iee6q2VeIQ=;
	h=Date:To:From:Subject:Message-Id; b=pOneWr1CY6kDbOV5LjxaN8zEBE6URGXFLjAy1X22c6jApGVXZVJCacx0bDO6ImSd2+DpXkVijijxXcTboRt6dfLll+WKEVWNp7ISH1qbNwlPy1awwgCbbtxjA79EgUnuVHMD5gIGLe8xvS8GYbLgO7bKUNcVj19m2CC7tBp5ELk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bG8Y80LN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bG8Y80LN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB171F00A3D;
	Mon,  6 Jul 2026 17:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783360121;
	bh=8a8EoaDYAyEjI1eor8bZOLFjGWZezTO/KJZ+frEBlPs=;
	h=Date:To:From:Subject;
	b=bG8Y80LNQj8PqUBiz4Z4KlNfxRO2CaLyFoiiS/zO4zlRpRFrYP95ACEugetov+Z23
	 PVG9E0TDYQ1eFcFK9ofvuXPgBCrvOB70xJJdwOryMKcOi+VgXiN0BWx8s7ExigX+7+
	 TGmvkwWQ93macwLP41vvu4T8Pc7P3pzbMbyk9KZA=
Date: Mon, 06 Jul 2026 10:48:40 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-extract-mm_prepare_for_swap_entries-helper.patch removed from -mm tree
Message-Id: <20260706174841.4CB171F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: extract mm_prepare_for_swap_entries() helper
has been removed from the -mm tree.  Its filename was
     mm-extract-mm_prepare_for_swap_entries-helper.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm: extract mm_prepare_for_swap_entries() helper
Date: Tue, 30 Jun 2026 09:34:39 -0700

When a swap entry is installed in a page table, the mm must be added to
init_mm.mmlist so that swapoff can find and unuse its swap entries.  This
double-checked locking pattern is currently open-coded in
try_to_unmap_one() and copy_nonpresent_pte().

Move it into mm_prepare_for_swap_entries() in mm/internal.h and convert
both callers so it can be reused by upcoming PMD-level swap entry code
paths that also need to register the mm with swapoff.

copy_nonpresent_pte() previously inserted into &src_mm->mmlist rather than
&init_mm.mmlist, but the insertion point is irrelevant, mmlist is a
circular list and swapoff walks it entirely from init_mm.mmlist, so only
membership matters, not position.

Link: https://lore.kernel.org/20260630164143.1595669-3-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   13 +++++++++++++
 mm/memory.c   |    9 +--------
 mm/rmap.c     |    7 +------
 3 files changed, 15 insertions(+), 14 deletions(-)

--- a/mm/internal.h~mm-extract-mm_prepare_for_swap_entries-helper
+++ a/mm/internal.h
@@ -1955,4 +1955,17 @@ static inline int get_sysctl_max_map_cou
 bool may_expand_vm(struct mm_struct *mm, const vma_flags_t *vma_flags,
 		   unsigned long npages);
 
+/*
+ * Ensure @mm is on the init_mm.mmlist so swapoff can find it.
+ */
+static inline void mm_prepare_for_swap_entries(struct mm_struct *mm)
+{
+	if (list_empty(&mm->mmlist)) {
+		spin_lock(&mmlist_lock);
+		if (list_empty(&mm->mmlist))
+			list_add(&mm->mmlist, &init_mm.mmlist);
+		spin_unlock(&mmlist_lock);
+	}
+}
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/memory.c~mm-extract-mm_prepare_for_swap_entries-helper
+++ a/mm/memory.c
@@ -953,14 +953,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 		if (swap_dup_entry_direct(entry) < 0)
 			return -EIO;
 
-		/* make sure dst_mm is on swapoff's mmlist. */
-		if (unlikely(list_empty(&dst_mm->mmlist))) {
-			spin_lock(&mmlist_lock);
-			if (list_empty(&dst_mm->mmlist))
-				list_add(&dst_mm->mmlist,
-						&src_mm->mmlist);
-			spin_unlock(&mmlist_lock);
-		}
+		mm_prepare_for_swap_entries(dst_mm);
 		/* Mark the swap entry as shared. */
 		if (pte_swp_exclusive(orig_pte)) {
 			pte = pte_swp_clear_exclusive(orig_pte);
--- a/mm/rmap.c~mm-extract-mm_prepare_for_swap_entries-helper
+++ a/mm/rmap.c
@@ -2304,12 +2304,7 @@ static bool try_to_unmap_one(struct foli
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
-			if (list_empty(&mm->mmlist)) {
-				spin_lock(&mmlist_lock);
-				if (list_empty(&mm->mmlist))
-					list_add(&mm->mmlist, &init_mm.mmlist);
-				spin_unlock(&mmlist_lock);
-			}
+			mm_prepare_for_swap_entries(mm);
 			dec_mm_counter(mm, MM_ANONPAGES);
 			inc_mm_counter(mm, MM_SWAPENTS);
 			swp_pte = swp_entry_to_pte(entry);
_

Patches currently in -mm which might be from usama.arif@linux.dev are

userfaultfd-wait-on-source-pmd-during-uffdio_move.patch
mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch
fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch
mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch
mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch
mm-rename-arch_enable_thp_migration-to-arch_supports_pmd_softleaf.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch
mm-vmpressure-move-v1-userspace-eventfd-code-into-memcontrol-v1c.patch
mm-migrate_device-pin-large-folios-before-splitting.patch
mm-migrate_device-pin-large-folios-before-splitting-fix.patch


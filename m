Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15D83BA244
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360612; cv=none; b=aVv53y1x/Z5fpS+70cwvjecb6mckPXRG3V4LlgMeuCxgX53MzJYnPFEbvEtCC4CdqPTmWIcZLYf0DSyIH08yC0zD7esNMqLVRXzv+WJPRsaTwcL45BY0i4H45nYwzCkxShrKJu19FqWrixayx0d0YKCweVXJ2lTtVNQsngCNWpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360612; c=relaxed/simple;
	bh=8nMgtsPm8QpewQCdybHPia60qJreUaLykDZLTf6BWgs=;
	h=Date:To:From:Subject:Message-Id; b=ggUYkNPB24yTZgutxfjNWQDN00MzfDEED1VgXOFXTdnePSFY9lQ2j3YHYygQUoBoNVzPrp7Tm/92rOstEPxHbSn05sGQQasfnDEtNX3tk8cVMmNXxbWzm2/IbBBNsLbtUmVfDCnbu10kYmJwKH+J1WE9A7gXyoIR0NaP/5A9JGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IYAjMPc1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IYAjMPc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A15E1F000E9;
	Mon,  6 Jul 2026 17:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783360610;
	bh=MW4WUXgH8942fZ3gckw8f3SdLms/itkorZs4FREsFtE=;
	h=Date:To:From:Subject;
	b=IYAjMPc1pB4uMzfScX+I4wNZLPlmu3syHy/4UNxggiFCh/DbaAEVNEODQ+3A71DNn
	 Qjo4GL5Gux0LIAZqQFvdzdWKvki/KafwS0rf0l+IRouFPps14ES0r7ZpEjqeHvVOur
	 5IrDhW2tHeJ4DozYmb2ArokLwlrgSG6KIK6kDA38=
Date: Mon, 06 Jul 2026 10:56:49 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-extract-mm_prepare_for_swap_entries-helper.patch added to mm-unstable branch
Message-Id: <20260706175650.5A15E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: extract mm_prepare_for_swap_entries() helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-extract-mm_prepare_for_swap_entries-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-extract-mm_prepare_for_swap_entries-helper.patch

This patch will later appear in the mm-unstable branch at
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
From: Usama Arif <usama.arif@linux.dev>
Subject: mm: extract mm_prepare_for_swap_entries() helper
Date: Mon, 6 Jul 2026 04:42:04 -0700

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

Link: https://lore.kernel.org/20260706114320.1643046-3-usama.arif@linux.dev
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

 mm/internal.h |   10 ++++++++++
 mm/memory.c   |    9 +--------
 mm/rmap.c     |    7 +------
 3 files changed, 12 insertions(+), 14 deletions(-)

--- a/mm/internal.h~mm-extract-mm_prepare_for_swap_entries-helper
+++ a/mm/internal.h
@@ -1955,4 +1955,14 @@ static inline int get_sysctl_max_map_cou
 bool may_expand_vm(struct mm_struct *mm, const vma_flags_t *vma_flags,
 		   unsigned long npages);
 
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
mm-add-softleaf_to_pmd-and-convert-existing-callers.patch
mm-extract-mm_prepare_for_swap_entries-helper.patch
fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch
mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch
mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch
mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch
mm-vmpressure-move-v1-userspace-eventfd-code-into-memcontrol-v1c.patch
mm-migrate_device-pin-large-folios-before-splitting.patch
mm-migrate_device-pin-large-folios-before-splitting-fix.patch


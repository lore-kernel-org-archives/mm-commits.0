Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCAC157466
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 22:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722377848; cv=none; b=YKh4Q07QODbZ3tMMtxtJNx6owOa+xHqRMuJtt8qwyLZx9mzNPft+pREOjq8XJCq9Z5mRh8RnCjy3No35GQY94GEHnb2OFEv3msAS20Ej50m5aWF4bqosUy7UKy5bRe+vQ5qS28jOQZ/VtIjLpMx6iiP8G/cwE6D+xqR8qkbkspk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722377848; c=relaxed/simple;
	bh=KoJPwkkv91+XGtI3x9XzN3rm1YF/sDU32VMZrRzXLjs=;
	h=Date:To:From:Subject:Message-Id; b=q38nFEC+NKPkoHzAGaCQ17JoaV9bR30J77sCq9rUqFi/KCr7x3pBN4CWvi3fDlFtTFJ07tD6MTj+4R7XbdRv7/JicBjkBIKmpa5kVwI7OqJTg4t6KWAMv6pd9wGTZX0T1TbH6HQSV0Xow2+0aVShQkm0W1otXM2zAF4+U+Nn1CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lyc7i4dn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lyc7i4dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DADC32782;
	Tue, 30 Jul 2024 22:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722377848;
	bh=KoJPwkkv91+XGtI3x9XzN3rm1YF/sDU32VMZrRzXLjs=;
	h=Date:To:From:Subject:From;
	b=lyc7i4dnyH7L5/WQYnwzanhBfV8xAYKkb+HENY+W+dldnCkEuwTIzJWr5N1FS6z5E
	 i6/PLbpo/ahCrJ4ZOu3y7HMHThUT6pqQivZ8TiKrOjz2xD9zdl4kbC4PPS9EIGJRmJ
	 Owom/Mrpot4ujYiuxoEPuKon8U5nuPxDcVuq2WqM=
Date: Tue, 30 Jul 2024 15:17:27 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking.patch removed from -mm tree
Message-Id: <20240730221727.F3DADC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix hugetlb vs. core-mm PT locking
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/hugetlb: fix hugetlb vs. core-mm PT locking
Date: Thu, 25 Jul 2024 20:39:55 +0200

We recently made GUP's common page table walking code to also walk hugetlb
VMAs without most hugetlb special-casing, preparing for the future of
having less hugetlb-specific page table walking code in the codebase. 
Turns out that we missed one page table locking detail: page table locking
for hugetlb folios that are not mapped using a single PMD/PUD.

Assume we have hugetlb folio that spans multiple PTEs (e.g., 64 KiB
hugetlb folios on arm64 with 4 KiB base page size).  GUP, as it walks the
page tables, will perform a pte_offset_map_lock() to grab the PTE table
lock.

However, hugetlb that concurrently modifies these page tables would
actually grab the mm->page_table_lock: with USE_SPLIT_PTE_PTLOCKS, the
locks would differ.  Something similar can happen right now with hugetlb
folios that span multiple PMDs when USE_SPLIT_PMD_PTLOCKS.

Let's make huge_pte_lockptr() effectively uses the same PT locks as any
core-mm page table walker would.

There is one ugly case: powerpc 8xx, whereby we have an 8 MiB hugetlb
folio being mapped using two PTE page tables.  While hugetlb wants to take
the PMD table lock, core-mm would grab the PTE table lock of one of both
PTE page tables.  In such corner cases, we have to make sure that both
locks match, which is (fortunately!) currently guaranteed for 8xx as it
does not support SMP.

Link: https://lkml.kernel.org/r/20240725183955.2268884-3-david@redhat.com
Fixes: 9cb28da54643 ("mm/gup: handle hugetlb in the generic follow_page_mask code")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking
+++ a/include/linux/hugetlb.h
@@ -944,10 +944,29 @@ static inline bool htlb_allow_alloc_fall
 static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 					   struct mm_struct *mm, pte_t *pte)
 {
-	if (huge_page_size(h) == PMD_SIZE)
+	VM_WARN_ON(huge_page_size(h) == PAGE_SIZE);
+	VM_WARN_ON(huge_page_size(h) >= P4D_SIZE);
+
+	/*
+	 * hugetlb must use the exact same PT locks as core-mm page table
+	 * walkers would. When modifying a PTE table, hugetlb must take the
+	 * PTE PT lock, when modifying a PMD table, hugetlb must take the PMD
+	 * PT lock etc.
+	 *
+	 * The expectation is that any hugetlb folio smaller than a PMD is
+	 * always mapped into a single PTE table and that any hugetlb folio
+	 * smaller than a PUD (but at least as big as a PMD) is always mapped
+	 * into a single PMD table.
+	 *
+	 * If that does not hold for an architecture, then that architecture
+	 * must disable split PT locks such that all *_lockptr() functions
+	 * will give us the same result: the per-MM PT lock.
+	 */
+	if (huge_page_size(h) < PMD_SIZE)
+		return pte_lockptr(mm, pte);
+	else if (huge_page_size(h) < PUD_SIZE)
 		return pmd_lockptr(mm, (pmd_t *) pte);
-	VM_BUG_ON(huge_page_size(h) == PAGE_SIZE);
-	return &mm->page_table_lock;
+	return pud_lockptr(mm, (pud_t *) pte);
 }
 
 #ifndef hugepages_supported
_

Patches currently in -mm which might be from david@redhat.com are

mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch


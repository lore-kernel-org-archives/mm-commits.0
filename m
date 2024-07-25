Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2712139D00
	for <mm-commits@vger.kernel.org>; Thu, 25 Jul 2024 20:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721940102; cv=none; b=PVsgciigYnaYPJybOCF39979ssmk2x7cfs9SfnLbpGQ8wiBXJjd8NkyKwqxZ5TIa2Ipnq2O59WaWCWV5oAmebAykGOowJiIO6luTHVFmJNgQ3HZz1qBxHqj+8WsMCttituPWnj481Ko+KLcA8L6sRYc52rfJgF930KAJmfzRo6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721940102; c=relaxed/simple;
	bh=YaPVj/7tEmSiXoulC/Olf/KS1U82SyLaDB/U8+QRVpE=;
	h=Date:To:From:Subject:Message-Id; b=Humq6LQ9/9XPKGpbDKNSO+kVpU8HMq1KQHEbW5r74IKHsS1TjSy8j+Z8iYFM4vzOTsqTKQGK4inMXpZn5u/7msEYzeT8o7mSPfcszTv8fXNPvRgK8brEf/wds1nw37J/TzJ3jxM/POWKIL3p9KvJano3FdGDe1thlQUP1dnT/lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BjlketK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BjlketK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662A1C116B1;
	Thu, 25 Jul 2024 20:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721940101;
	bh=YaPVj/7tEmSiXoulC/Olf/KS1U82SyLaDB/U8+QRVpE=;
	h=Date:To:From:Subject:From;
	b=BjlketK0tU2ikWdyD8adJgVKGIFng5w7Jh1YjVH5oSBtAL9fg41TQ1krmNs7aL2jP
	 U0I/gTnWli/gt/GwV5dL/lDo82g3jjPgmd1Lsv5XTwYoYS0xlaRezuOQUvSoSJe3gf
	 hsVD1uD4vvOk1t12mRPHgC5Sx0c/K9Hqt0J1MbxQ=
Date: Thu, 25 Jul 2024 13:41:40 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking.patch added to mm-hotfixes-unstable branch
Message-Id: <20240725204141.662A1C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix hugetlb vs. core-mm PT locking
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
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

mm-let-pte_lockptr-consume-a-pte_t-pointer.patch
mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E366758118
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 20:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KbgaQIs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BC7C43399;
	Thu, 11 Jan 2024 20:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705005153;
	bh=CfLlCwfuon+yuDF5OG4LFM2i/JYyN6H7wJu9wl3yOHc=;
	h=Date:To:From:Subject:From;
	b=KbgaQIs4ffVecd2EmYw0RF6cxJgfG+emk9qzRu4WKt8TUbhgnxqsHi9Gq22m82yYw
	 PPp+wXH8ShMpMhP7ywaCj7YvbQV85ViTD4rVd6nK0VmoI3T7zyok8oLQ2Ffk9SREc4
	 GoS+qoO24OvppVtsPPO9qE4fBJIeMcYYgRoACIVc=
Date: Thu, 11 Jan 2024 12:32:32 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-pfn_swap_entry_folio.patch added to mm-unstable branch
Message-Id: <20240111203233.38BC7C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add pfn_swap_entry_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-pfn_swap_entry_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-pfn_swap_entry_folio.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add pfn_swap_entry_folio()
Date: Thu, 11 Jan 2024 15:24:20 +0000

Patch series "mm: convert mm counter to take a folio", v3.

Make sure all mm_counter() and mm_counter_file() callers have a folio,
then convert mm counter functions to take a folio, which saves some
compound_head() calls.


This patch (of 10):  

Thanks to the compound_head() hidden inside PageLocked(), this saves a
call to compound_head() over calling page_folio(pfn_swap_entry_to_page())

Link: https://lkml.kernel.org/r/20240111152429.3374566-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240111152429.3374566-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |   13 +++++++++++++
 mm/filemap.c            |    2 +-
 mm/huge_memory.c        |    2 +-
 3 files changed, 15 insertions(+), 2 deletions(-)

--- a/include/linux/swapops.h~mm-add-pfn_swap_entry_folio
+++ a/include/linux/swapops.h
@@ -468,6 +468,19 @@ static inline struct page *pfn_swap_entr
 	return p;
 }
 
+static inline struct folio *pfn_swap_entry_folio(swp_entry_t entry)
+{
+	struct folio *folio = pfn_folio(swp_offset_pfn(entry));
+
+	/*
+	 * Any use of migration entries may only occur while the
+	 * corresponding folio is locked
+	 */
+	BUG_ON(is_migration_entry(entry) && !folio_test_locked(folio));
+
+	return folio;
+}
+
 /*
  * A pfn swap entry is a special type of swap entry that always has a pfn stored
  * in the swap offset. They are used to represent unaddressable device memory
--- a/mm/filemap.c~mm-add-pfn_swap_entry_folio
+++ a/mm/filemap.c
@@ -1354,7 +1354,7 @@ void migration_entry_wait_on_locked(swp_
 	unsigned long pflags;
 	bool in_thrashing;
 	wait_queue_head_t *q;
-	struct folio *folio = page_folio(pfn_swap_entry_to_page(entry));
+	struct folio *folio = pfn_swap_entry_folio(entry);
 
 	q = folio_waitqueue(folio);
 	if (!folio_test_uptodate(folio) && folio_test_workingset(folio)) {
--- a/mm/huge_memory.c~mm-add-pfn_swap_entry_folio
+++ a/mm/huge_memory.c
@@ -2035,7 +2035,7 @@ int change_huge_pmd(struct mmu_gather *t
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 	if (is_swap_pmd(*pmd)) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
-		struct folio *folio = page_folio(pfn_swap_entry_to_page(entry));
+		struct folio *folio = pfn_swap_entry_folio(entry);
 		pmd_t newpmd;
 
 		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
_

Patches currently in -mm which might be from willy@infradead.org are

memcg-convert-mem_cgroup_move_charge_pte_range-to-use-a-folio.patch
memcg-return-the-folio-in-union-mc_target.patch
memcg-use-a-folio-in-get_mctgt_type.patch
memcg-use-a-folio-in-get_mctgt_type_thp.patch
mm-add-pfn_swap_entry_folio.patch
proc-use-pfn_swap_entry_folio-where-obvious.patch
mprotect-use-pfn_swap_entry_folio.patch
bounds-support-non-power-of-two-config_nr_cpus.patch


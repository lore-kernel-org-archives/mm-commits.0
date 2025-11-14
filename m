Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF7818EFD1
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 23:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763163758; cv=none; b=kkDyLGC95tmUYmifQiBZO+ldRZXVGQwpMtF/YVIrZ2DFEk45pKxO94RIQ6JTz/7LHtP/KpFBOpXgORpwyrUKll6a2+vStIn5kVEVJvVbhL8c3mVetKi8E5LCm+WPmQiF1OMSG3fbhUCbI6CDrH4kBuQyrp/LTmH7WiyW4xwhBJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763163758; c=relaxed/simple;
	bh=RZ+q5H95ZCrMQ68tKBZAa81Tj6Cu2JI69Hc8UNyR4ps=;
	h=Date:To:From:Subject:Message-Id; b=CAbSCdLqsY1ZUyUQ9+0NgcTSgkg1BmcKDL3zuvyNZs4a/JPuwdWD9+Rv45Dg3eDe3O1o21FQKF5jYAzTHqPH0rrzQX1TjKq57owj0OTXTC6CjiIVnCpNeY8nf9tj05ZQrfoHogDGgutu4VzP3G9UQlsL7/GMxJQub5HjOCcDQEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RaiP2neI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RaiP2neI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE84C4CEF5;
	Fri, 14 Nov 2025 23:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763163758;
	bh=RZ+q5H95ZCrMQ68tKBZAa81Tj6Cu2JI69Hc8UNyR4ps=;
	h=Date:To:From:Subject:From;
	b=RaiP2neIjDPRSkj5O9uN60roP1oP/6KsULuDOjZEb8j4rYvdvku6ZFglzknflS4jZ
	 hDS/gb8hfUaFPu/O8msnaVSql+fby82NwGRRmnWDe0cB3IOy2Pv0EHA1OBybBJw6UO
	 hBaHOy3UkZ3OYhaVH1eyk9i1yAbGtrhzXF8VZS6U=
Date: Fri, 14 Nov 2025 15:42:37 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,rostedt@goodmis.org,npache@redhat.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-unify-scan_pmd_none-and-scan_pmd_null-into-scan_no_pte_table.patch added to mm-new branch
Message-Id: <20251114234237.EBE84C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: unify SCAN_PMD_NONE and SCAN_PMD_NULL into SCAN_NO_PTE_TABLE
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-unify-scan_pmd_none-and-scan_pmd_null-into-scan_no_pte_table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-unify-scan_pmd_none-and-scan_pmd_null-into-scan_no_pte_table.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/khugepaged: unify SCAN_PMD_NONE and SCAN_PMD_NULL into SCAN_NO_PTE_TABLE
Date: Fri, 14 Nov 2025 03:00:28 +0000

The current hugepage collapse scan results include two separate values,
SCAN_PMD_NONE and SCAN_PMD_NULL, which are handled identically by the
consuming code.

To reduce confusion and improve long-term maintenance, this commit merges
these two functionally equivalent states into a single, clearer
identifier: SCAN_NO_PTE_TABLE

Link: https://lkml.kernel.org/r/20251114030028.7035-4-richard.weiyang@gmail.com
Suggested-by: "David Hildenbrand (Red Hat)" <david@kernel.org>
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    3 +--
 mm/khugepaged.c                    |   23 ++++++++++-------------
 2 files changed, 11 insertions(+), 15 deletions(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-unify-scan_pmd_none-and-scan_pmd_null-into-scan_no_pte_table
+++ a/include/trace/events/huge_memory.h
@@ -10,8 +10,7 @@
 #define SCAN_STATUS							\
 	EM( SCAN_FAIL,			"failed")			\
 	EM( SCAN_SUCCEED,		"succeeded")			\
-	EM( SCAN_PMD_NULL,		"pmd_null")			\
-	EM( SCAN_PMD_NONE,		"pmd_none")			\
+	EM( SCAN_NO_PTE_TABLE,		"no_pte_table")			\
 	EM( SCAN_PMD_MAPPED,		"page_pmd_mapped")		\
 	EM( SCAN_EXCEED_NONE_PTE,	"exceed_none_pte")		\
 	EM( SCAN_EXCEED_SWAP_PTE,	"exceed_swap_pte")		\
--- a/mm/khugepaged.c~mm-khugepaged-unify-scan_pmd_none-and-scan_pmd_null-into-scan_no_pte_table
+++ a/mm/khugepaged.c
@@ -30,8 +30,7 @@
 enum scan_result {
 	SCAN_FAIL,
 	SCAN_SUCCEED,
-	SCAN_PMD_NULL,
-	SCAN_PMD_NONE,
+	SCAN_NO_PTE_TABLE,
 	SCAN_PMD_MAPPED,
 	SCAN_EXCEED_NONE_PTE,
 	SCAN_EXCEED_SWAP_PTE,
@@ -934,7 +933,7 @@ static inline int check_pmd_state(pmd_t
 	pmd_t pmde = pmdp_get_lockless(pmd);
 
 	if (pmd_none(pmde))
-		return SCAN_PMD_NONE;
+		return SCAN_NO_PTE_TABLE;
 
 	/*
 	 * The folio may be under migration when khugepaged is trying to
@@ -944,11 +943,11 @@ static inline int check_pmd_state(pmd_t
 	if (pmd_is_migration_entry(pmde))
 		return SCAN_PMD_MAPPED;
 	if (!pmd_present(pmde))
-		return SCAN_PMD_NULL;
+		return SCAN_NO_PTE_TABLE;
 	if (pmd_trans_huge(pmde))
 		return SCAN_PMD_MAPPED;
 	if (pmd_bad(pmde))
-		return SCAN_PMD_NULL;
+		return SCAN_NO_PTE_TABLE;
 	return SCAN_SUCCEED;
 }
 
@@ -958,7 +957,7 @@ static int find_pmd_or_thp_or_none(struc
 {
 	*pmd = mm_find_pmd(mm, address);
 	if (!*pmd)
-		return SCAN_PMD_NULL;
+		return SCAN_NO_PTE_TABLE;
 
 	return check_pmd_state(*pmd);
 }
@@ -1013,7 +1012,7 @@ static int __collapse_huge_page_swapin(s
 			pte = pte_offset_map_ro_nolock(mm, pmd, addr, &ptl);
 			if (!pte) {
 				mmap_read_unlock(mm);
-				result = SCAN_PMD_NULL;
+				result = SCAN_NO_PTE_TABLE;
 				goto out;
 			}
 		}
@@ -1187,7 +1186,7 @@ static int collapse_huge_page(struct mm_
 						      &compound_pagelist);
 		spin_unlock(pte_ptl);
 	} else {
-		result = SCAN_PMD_NULL;
+		result = SCAN_NO_PTE_TABLE;
 	}
 
 	if (unlikely(result != SCAN_SUCCEED)) {
@@ -1270,7 +1269,7 @@ static int hpage_collapse_scan_pmd(struc
 	nodes_clear(cc->alloc_nmask);
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
-		result = SCAN_PMD_NULL;
+		result = SCAN_NO_PTE_TABLE;
 		goto out;
 	}
 
@@ -1544,8 +1543,7 @@ int collapse_pte_mapped_thp(struct mm_st
 	switch (result) {
 	case SCAN_SUCCEED:
 		break;
-	case SCAN_PMD_NULL:
-	case SCAN_PMD_NONE:
+	case SCAN_NO_PTE_TABLE:
 		/*
 		 * All pte entries have been removed and pmd cleared.
 		 * Skip all the pte checks and just update the pmd mapping.
@@ -2832,8 +2830,7 @@ handle_result:
 			mmap_read_unlock(mm);
 			goto handle_result;
 		/* Whitelisted set of results where continuing OK */
-		case SCAN_PMD_NULL:
-		case SCAN_PMD_NONE:
+		case SCAN_NO_PTE_TABLE:
 		case SCAN_PTE_NON_PRESENT:
 		case SCAN_PTE_UFFD_WP:
 		case SCAN_LACK_REFERENCED_PAGE:
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-huge_memory-avoid-reinvoking-folio_test_anon.patch
mm-huge_memory-update-folio-stat-after-successful-split.patch
mm-huge_memory-optimize-and-simplify-folio-stat-update-after-split.patch
mm-huge_memory-optimize-old_order-derivation-during-folio-splitting.patch
mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch
mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch
mm-huge_memory-introduce-enum-split_type-for-clarity.patch
mm-huge_memory-merge-uniform_split_supported-and-non_uniform_split_supported.patch
mm-khugepaged-remove-redundant-clearing-of-struct-collapse_control.patch
mm-khugepaged-continue-to-collapse-on-scan_pmd_none.patch
mm-khugepaged-unify-scan_pmd_none-and-scan_pmd_null-into-scan_no_pte_table.patch


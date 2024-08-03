Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F4613E02C
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 05:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722663226; cv=none; b=UQ5Dg2Kq3T8335l5CS4rR/hgvazJc6S4SuGQHnQGKY9sPJkvX/bjSMId7Qq65LE9H/PMU3gruy9yq038VsogcK3axMylx/WFSXOu0L5lFmLQy/xT4G9kk8cTw6Er9q8Y8BTHWGU44DyudMoOmIc3om/dI4KmL6wQY5u7w5V3xp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722663226; c=relaxed/simple;
	bh=6ssCaRIpGatcRAawtDpioESClqRwIIREGvM5vb4VNtU=;
	h=Date:To:From:Subject:Message-Id; b=nEZRxkOtSh1OI1tTDqa9JUlZim/j1W9cibLlWlVzL6+57v9unh1rYbqrXb8eBbdJn+eBzjIxCvxlWp1LXr+6rMM7Yhy6Oh9oTPMAomRTC1yuuCxQhQaHkGv3+g/+ipHZ4NNIOTgcBxu4NQG3e4VtURsKiqThFzTxO4I0hXxMICs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E9raXwXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E9raXwXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3950AC116B1;
	Sat,  3 Aug 2024 05:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722663226;
	bh=6ssCaRIpGatcRAawtDpioESClqRwIIREGvM5vb4VNtU=;
	h=Date:To:From:Subject:From;
	b=E9raXwXzzVhXCDc+1jkIaJ2RhWJ3WiTmTAePrCFCArlUeq3aYV0BGpLUtymq3P0PO
	 oOKFwSNo+7wbx7dAZLykOIU3Y9yDRdJUrzFTQFeBkuADp4zGXTefYKjiVa6Z0xLTVg
	 JlLm+7tJlonF1EYmRPF7t24J04XlbJc6Qm4IpiVU=
Date: Fri, 02 Aug 2024 22:33:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,svens@linux.ibm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk.patch added to mm-unstable branch
Message-Id: <20240803053346.3950AC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: convert split_huge_pages_pid() from follow_page() to folio_walk
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: convert split_huge_pages_pid() from follow_page() to folio_walk
Date: Fri, 2 Aug 2024 17:55:20 +0200

Let's remove yet another follow_page() user.  Note that we have to do the
split without holding the PTL, after folio_walk_end().  We don't care
about losing the secretmem check in follow_page().

Link: https://lkml.kernel.org/r/20240802155524.517137-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk
+++ a/mm/huge_memory.c
@@ -40,6 +40,7 @@
 #include <linux/memory-tiers.h>
 #include <linux/compat.h>
 #include <linux/pgalloc_tag.h>
+#include <linux/pagewalk.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -3507,7 +3508,7 @@ static int split_huge_pages_pid(int pid,
 	 */
 	for (addr = vaddr_start; addr < vaddr_end; addr += PAGE_SIZE) {
 		struct vm_area_struct *vma = vma_lookup(mm, addr);
-		struct page *page;
+		struct folio_walk fw;
 		struct folio *folio;
 
 		if (!vma)
@@ -3519,13 +3520,10 @@ static int split_huge_pages_pid(int pid,
 			continue;
 		}
 
-		/* FOLL_DUMP to ignore special (like zero) pages */
-		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
-
-		if (IS_ERR_OR_NULL(page))
+		folio = folio_walk_start(&fw, vma, addr, 0);
+		if (!folio)
 			continue;
 
-		folio = page_folio(page);
 		if (!is_transparent_hugepage(folio))
 			goto next;
 
@@ -3544,13 +3542,19 @@ static int split_huge_pages_pid(int pid,
 
 		if (!folio_trylock(folio))
 			goto next;
+		folio_get(folio);
+		folio_walk_end(&fw, vma);
 
 		if (!split_folio_to_order(folio, new_order))
 			split++;
 
 		folio_unlock(folio);
-next:
 		folio_put(folio);
+
+		cond_resched();
+		continue;
+next:
+		folio_walk_end(&fw, vma);
 		cond_resched();
 	}
 	mmap_read_unlock(mm);
_

Patches currently in -mm which might be from david@redhat.com are

mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch
mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch
mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap.patch
mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios.patch
mm-provide-vm_normal_pagefolio_pmd-with-config_pgtable_has_huge_leaves.patch
mm-pagewalk-introduce-folio_walk_start-folio_walk_end.patch
mm-migrate-convert-do_pages_stat_array-from-follow_page-to-folio_walk.patch
mm-migrate-convert-add_page_for_migration-from-follow_page-to-folio_walk.patch
mm-ksm-convert-get_mergeable_page-from-follow_page-to-folio_walk.patch
mm-ksm-convert-scan_get_next_rmap_item-from-follow_page-to-folio_walk.patch
mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk.patch
s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk.patch
s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk.patch
mm-remove-follow_page.patch
mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch


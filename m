Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0356599A21;
	Fri, 11 Sep 2026 20:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789157749; cv=none; b=jVp7q/HkAAPuzKZjuyHBfiFIhb1nh+HK6PMIHUam3H/2ZV+KgXAfoBvxysE/B9ZYiaG0xEYm0hssk8Ncs9Dj7scfMzR6Jlwp/oCQEA7TO1d66gsI5b4uHJjXUfKvTCJmcFttXNlfOI20TXN8gEC0uVU/N81qEOub7JdwDppEfWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789157749; c=relaxed/simple;
	bh=DzCNHFbm3NnbE3D0IQJ3Et/VTrk5FoIxKvrEK9xnWJo=;
	h=Date:To:From:Subject:Message-Id; b=g8SKscRpbGe+dPFWWCyF+3XKRNhSzriD+paN/MCrQDg1nvS/0lphAZt8dwJMX7O/Prpqayhl/NL0yC5cnC6+ZE9V8YjyIeI0zhoy14dpofO5Z9rYOL1SnmOnco/Rg4BSTK5ysx6wrqK7j9zP+Vyc+hiCSJbmYqLFhZiVz0ABLLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TTHMx2Ac; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TTHMx2Ac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E9C1F000FF;
	Fri, 11 Sep 2026 20:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789157747;
	bh=Jong8Bs7yyTV+4fs5tCcx+DWqgmDleALDYVZg5SsDl0=;
	h=Date:To:From:Subject;
	b=TTHMx2AcgWkmBnar/4MuMAbOv/GoZXynrdJ+yncbrBuTnnHds45ogmS7JVjo/UYnP
	 J+/K8vwYOIqXYBr2CAIsX6+sOGRgymlaR3GQ4YKk1BKan5Gs4eCnYURh4HRryjJ+m5
	 28Rq7zG7fO4lMlLSZOnf/RqYA7mzQ6zneP+aFbMc=
Date: Fri, 11 Sep 2026 13:15:47 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,johan@kernel.org,david@kernel.org,jaewook376@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-preserve-mremap-address-delta-when-skipping-page-tables.patch added to mm-new branch
Message-Id: <20260911201547.73E9C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: preserve mremap address delta when skipping page tables
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-preserve-mremap-address-delta-when-skipping-page-tables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-preserve-mremap-address-delta-when-skipping-page-tables.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Jaewook You <jaewook376@gmail.com>
Subject: mm/hugetlb: preserve mremap address delta when skipping page tables
Date: Sat, 12 Sep 2026 03:24:08 +0900

In move_hugetlb_page_tables(), optimize mremap() by advancing to the end
of the page table when the source page table does not exist, either
initially or after unsharing a PMD table.

However, the code advances both the source and destination addresses to
the end of their respective page tables, which is wrong.  The destination
address must be advanced only by the same amount as the source address.

If the source and destination offsets within their page tables differ, the
destination address can be advanced too far, causing follow-up issues. 
Fix this by advancing the destination address by the source advance
distance.

With a reproducer, we were able to trigger a kernel panic on x86-64.  With
this fix in place, we can no longer reproduce the issue.

Link: https://lore.kernel.org/20260911182408.75821-1-jaewook376@gmail.com
Fixes: e95a9851787b ("hugetlb: skip to end of PT page mapping when pte not present")
Fixes: 4ddb4d91b82f ("hugetlb: do not update address in huge_pmd_unshare")
Signed-off-by: Jaewook You <jaewook376@gmail.com>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Johan Hovold <johan@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-preserve-mremap-address-delta-when-skipping-page-tables
+++ a/mm/hugetlb.c
@@ -5226,18 +5226,21 @@ int move_hugetlb_page_tables(struct vm_a
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(mapping);
 	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
+		const unsigned long remaining_size =
+			(old_addr | last_addr_mask) - old_addr;
+
 		src_pte = hugetlb_walk(vma, old_addr, sz);
 		if (!src_pte) {
-			old_addr |= last_addr_mask;
-			new_addr |= last_addr_mask;
+			old_addr += remaining_size;
+			new_addr += remaining_size;
 			continue;
 		}
 		if (huge_pte_none(huge_ptep_get(mm, old_addr, src_pte)))
 			continue;
 
 		if (huge_pmd_unshare(&tlb, vma, old_addr, src_pte)) {
-			old_addr |= last_addr_mask;
-			new_addr |= last_addr_mask;
+			old_addr += remaining_size;
+			new_addr += remaining_size;
 			continue;
 		}
 
_

Patches currently in -mm which might be from jaewook376@gmail.com are

mm-hugetlb-preserve-mremap-address-delta-when-skipping-page-tables.patch


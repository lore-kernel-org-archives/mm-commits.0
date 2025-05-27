Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C351F9A8B
	for <mm-commits@vger.kernel.org>; Tue, 27 May 2025 22:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748383883; cv=none; b=bGdYfJDcV8h0GTGYA+ehVz5naDuHdCUoEdlBRdoAPCCUuypUUWfTN6HxY1xgDsK2p0FMLHOixRCXsk+2V1j3N1iIsTWOXebZYxvOv5D1tWeTUV+LRf4hpo+hFJ3lYdSLzetlyZVSLznihNLoEGM9uquJU3FRdOL4gHDKRgDTahY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748383883; c=relaxed/simple;
	bh=iu3yeKHLavvT8U7+h/lL9VVCo187ncW/m9r5+RmOZZA=;
	h=Date:To:From:Subject:Message-Id; b=YVgY8jb7JT75F0O2QSFw6iT46sLut7+Xtf6+7GZoqlHVySbxwKcJHiBEu+SZHr6YLDywgTsmnTotCAGA1n4I+TJuaddbyBiqmsRlms0Wdh8xHNCoBuGYsbPEa2GtRE/bktA6eLQGANRg1ZQZ5+V3emaIjRh+3oqvQWzALJfUJt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y3iY66Rh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y3iY66Rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB6AC4CEE9;
	Tue, 27 May 2025 22:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748383882;
	bh=iu3yeKHLavvT8U7+h/lL9VVCo187ncW/m9r5+RmOZZA=;
	h=Date:To:From:Subject:From;
	b=Y3iY66Rh3xEY9u03tVWFLOZy7T1bVjI0dWgylY1CVjfBZvxsR+6vigsbu6bBOClFe
	 hO/RaMkc67oZaP2ho5UfHJ3F4QTz/yf5Z7nBRTChjLYXpU7mOy3FKN3eCC1yJe0wNP
	 tgR0HqX9WIp7KzODPy3NWU638zLMx0SpH9LBw4EA=
Date: Tue, 27 May 2025 15:11:22 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@kernel.org,osalvador@suse.de,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-huge_pmd_unshare-vs-gup-fast-race.patch added to mm-hotfixes-unstable branch
Message-Id: <20250527221122.9CB6AC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-huge_pmd_unshare-vs-gup-fast-race.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-huge_pmd_unshare-vs-gup-fast-race.patch

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
From: Jann Horn <jannh@google.com>
Subject: mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race
Date: Tue, 27 May 2025 23:23:54 +0200

huge_pmd_unshare() drops a reference on a page table that may have
previously been shared across processes, potentially turning it into a
normal page table used in another process in which unrelated VMAs can
afterwards be installed.

If this happens in the middle of a concurrent gup_fast(), gup_fast() could
end up walking the page tables of another process.  While I don't see any
way in which that immediately leads to kernel memory corruption, it is
really weird and unexpected.

Fix it with an explicit broadcast IPI through tlb_remove_table_sync_one(),
just like we do in khugepaged when removing page tables for a THP
collapse.

Link: https://lkml.kernel.org/r/20250527-hugetlb-fixes-splitrace-v1-2-f4136f5ec58a@google.com
Fixes: 39dde65c9940 ("[PATCH] shared page table for hugetlb page")
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-fix-huge_pmd_unshare-vs-gup-fast-race
+++ a/mm/hugetlb.c
@@ -7627,6 +7627,13 @@ int huge_pmd_unshare(struct mm_struct *m
 		return 0;
 
 	pud_clear(pud);
+	/*
+	 * Once our caller drops the rmap lock, some other process might be
+	 * using this page table as a normal, non-hugetlb page table.
+	 * Wait for pending gup_fast() in other threads to finish before letting
+	 * that happen.
+	 */
+	tlb_remove_table_sync_one();
 	ptdesc_pmd_pts_dec(virt_to_ptdesc(ptep));
 	mm_dec_nr_pmds(mm);
 	return 1;
_

Patches currently in -mm which might be from jannh@google.com are

mm-hugetlb-unshare-page-tables-during-vma-split-not-before.patch
mm-hugetlb-fix-huge_pmd_unshare-vs-gup-fast-race.patch


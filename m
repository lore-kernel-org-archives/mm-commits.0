Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182781F4E4F
	for <mm-commits@vger.kernel.org>; Wed, 28 May 2025 21:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748466711; cv=none; b=rAA/nPJVBhpoPVwsJ/onW1kGvC9NJMyrSnTDy33arATBIt1dPKxeO0wDtHJ0BwcT4FN/g+0uy+56XChfXo1+VbE5X3OC//wVPRK5sll9nSkdLaTzbxe3kqYOPGGR9p/+4Csct1m6F4bRL28kMnYXcAqCz6v1UF3Sb08HAV98PGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748466711; c=relaxed/simple;
	bh=CpTaNoa7slFZ2w7XiPAp9ESQQjxtYaN9evOimh/arb0=;
	h=Date:To:From:Subject:Message-Id; b=s7PsB1MyfAQGYaXEC7phpAdtCbGSOCjXAMwFcStZO+dgeidneLOInv7d1erFfjjiF0CYnwrzltl6ghODZOfhFEi8Wtpkd8CxB1GMaXj4R155SlD627LtDl7tIe5stT+cTaaSm0UzRm/GCv0Kzhl9dcqA7wSKVk5prtrWqesx71k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rE/S2HpG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rE/S2HpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FEFC4CEE3;
	Wed, 28 May 2025 21:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748466710;
	bh=CpTaNoa7slFZ2w7XiPAp9ESQQjxtYaN9evOimh/arb0=;
	h=Date:To:From:Subject:From;
	b=rE/S2HpGSB4TDIv5EvVN0R8ewCxXKh3DN0/QyzJMytYooLHBbMVsGTBEJxlXQ2jD1
	 W4waSpCY3zj10ZPtAkwU+efJopJiV397pVlcDNOoWhFkkWkEy/pg+ql/EAdCPjXwI1
	 TPIgXjCQm3pXNJ0olicH+swOrhihENkT8rds/mwo=
Date: Wed, 28 May 2025 14:11:49 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-unshare-page-tables-during-vma-split-not-before-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20250528211150.64FEFC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-hugetlb-unshare-page-tables-during-vma-split-not-before-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-unshare-page-tables-during-vma-split-not-before-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-unshare-page-tables-during-vma-split-not-before-v2.patch

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
Subject: mm-hugetlb-unshare-page-tables-during-vma-split-not-before-v2
Date: Wed, 28 May 2025 19:08:55 +0200

- more verbose locking context explanation (Lorenzo)
- assert file rmap lock held (Lorenzo)
- label bool function argument (Lorenzo)
- more verbose locking context comment (Lorenzo)

Link: https://lkml.kernel.org/r/20250528-hugetlb-fixes-splitrace-v2-1-1329349bad1a@google.com
Fixes: 39dde65c9940 ("[PATCH] shared page table for hugetlb page")
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-unshare-page-tables-during-vma-split-not-before-v2
+++ a/mm/hugetlb.c
@@ -5440,6 +5440,7 @@ void hugetlb_split(struct vm_area_struct
 	 * walks (except hardware and gup_fast()).
 	 */
 	vma_assert_write_locked(vma);
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
 
 	if (addr & ~PUD_MASK) {
 		unsigned long floor = addr & PUD_MASK;
@@ -5456,7 +5457,7 @@ void hugetlb_split(struct vm_area_struct
 			 * table walks, which are not possible thanks to the
 			 * locks held by our caller.
 			 */
-			hugetlb_unshare_pmds(vma, floor, ceil, false);
+			hugetlb_unshare_pmds(vma, floor, ceil, /* take_locks = */ false);
 		}
 	}
 }
@@ -7900,6 +7901,8 @@ void move_hugetlb_state(struct folio *ol
 /*
  * If @take_locks is false, the caller must ensure that no concurrent page table
  * access can happen (except for gup_fast() and hardware page walks).
+ * If @take_locks is true, we take the hugetlb VMA lock (to lock out things like
+ * concurrent page fault handling) and the file rmap lock.
  */
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 				   unsigned long start,
@@ -7961,7 +7964,8 @@ static void hugetlb_unshare_pmds(struct
 void hugetlb_unshare_all_pmds(struct vm_area_struct *vma)
 {
 	hugetlb_unshare_pmds(vma, ALIGN(vma->vm_start, PUD_SIZE),
-			ALIGN_DOWN(vma->vm_end, PUD_SIZE), true);
+			ALIGN_DOWN(vma->vm_end, PUD_SIZE),
+			/* take_locks = */ true);
 }
 
 /*
_

Patches currently in -mm which might be from jannh@google.com are

mm-hugetlb-unshare-page-tables-during-vma-split-not-before.patch
mm-hugetlb-unshare-page-tables-during-vma-split-not-before-v2.patch
mm-hugetlb-fix-huge_pmd_unshare-vs-gup-fast-race.patch
mmu_notifiers-remove-leftover-stub-macros.patch


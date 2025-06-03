Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B2F4C92
	for <mm-commits@vger.kernel.org>; Tue,  3 Jun 2025 03:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748920864; cv=none; b=lcW7gS4kC7y6zqW6QTympjlbLuQi15UMUQoA0rLxXVbaz6p/ZI6iAnqifSLoWF8ONJOhRsAHgmUOtiT53ojNkfb7Fvj2+57NQzmLfsC3Ih7mhQLVJGjWkC3nRW4yVIBlt5nI0JyqNV3k/hPDkyxLxO4Blr5o+2KKYMVMndZ72To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748920864; c=relaxed/simple;
	bh=TMVvcPyAMj7jtgGXCiNM2aAJoSlI8QHBfqWvzzSXR9M=;
	h=Date:To:From:Subject:Message-Id; b=jl807B3oBQ+zuDS8cLZoEWqSzFVb9hwLI7rm4sFT2yqyos3o9RhcCvZMsa+vB2MY6sx1uVovra0ylkRPOC9QF0rea/BAj5lgzeItp5yBTcjACTwnpwdSrLxL5rIzQ00VBCcY+f651ywHneD0MAFW4K8LroGUPBNMMJoUFTJKgD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2AUqqqOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2AUqqqOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA4BC4CEEB;
	Tue,  3 Jun 2025 03:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748920863;
	bh=TMVvcPyAMj7jtgGXCiNM2aAJoSlI8QHBfqWvzzSXR9M=;
	h=Date:To:From:Subject:From;
	b=2AUqqqOzg/O5ItzpIHCw3amefWPTGK49SaKibxf5gLfukFP8bRKa2bKjK07tT1p6Y
	 UN5ROdomd0smDJ+L/DioK2/cgd0caZUKF7vd1TPX4XgBe5WzamWFUTOzSjNm9eb96j
	 8YVgpQKHKIgpWwRB2jlMMDEpvFIJ3wjI5KGHvHFI=
Date: Mon, 02 Jun 2025 20:21:02 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-unshare-page-tables-during-vma-split-not-before-v2.patch removed from -mm tree
Message-Id: <20250603032103.7CA4BC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-hugetlb-unshare-page-tables-during-vma-split-not-before-v2
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-unshare-page-tables-during-vma-split-not-before-v2.patch

This patch was dropped because it was folded into mm-hugetlb-unshare-page-tables-during-vma-split-not-before.patch

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
mm-hugetlb-fix-huge_pmd_unshare-vs-gup-fast-race.patch


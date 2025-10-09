Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB9B173
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 00:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759970344; cv=none; b=VNcaa/DDh104PC4vNuscg3hBeQR9tIy9GRbSEHMQ+0b+r/WWPnXU+vrltHK2XJoUzu3LjxhoISBVVWA8df7GY9FxFwbe3/112wLi+vbL8i2BBsfv2STFNQP+hp+SOIk7S/cIB5ULHp1zlAD/cTr9owl54nAaHoPrZfog+U5lCvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759970344; c=relaxed/simple;
	bh=C6x/Q6PoUG7XaoVebIxXz3LoDRdZrXMd7mH8Kx4Xed4=;
	h=Date:To:From:Subject:Message-Id; b=SazOTOxnyA0GEx3AU7DG2HBPhcwy63wJ4ZkR5BNGQpXZKsu7KcqI1jwqREwA/ir5aaWkNzeajM9dz6MMB1e1eGV3E7Trat5pffDj+OrXf/OtSJolz0Wydpm+mCxBVhiYBXMGRcM7cObxPoeBTZIF/Ma8t/T3nyQ3uUvwzqtChHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LbeX7pw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LbeX7pw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E51C4CEE7;
	Thu,  9 Oct 2025 00:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759970342;
	bh=C6x/Q6PoUG7XaoVebIxXz3LoDRdZrXMd7mH8Kx4Xed4=;
	h=Date:To:From:Subject:From;
	b=LbeX7pw0QWMnFOE9JianRp9SAI3qtknH7UZn2I8hgJF0du2LxzNu8eX89tEIpOwg5
	 N+RGD55jLwSN4omEtgoBLh4Nf/TL5vFXWGIR+V7jt5qykfkhOhk2pm/l3vk1n0hSC6
	 3kW5DVPAn7X/EiC3dK/4i/Ikx6kH6EBzDVZeMTPs=
Date: Wed, 08 Oct 2025 17:39:02 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,broonie@kernel.org,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-check-for-shareable-lock-before-calling-huge_pmd_unshare.patch added to mm-hotfixes-unstable branch
Message-Id: <20251009003902.C4E51C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlbfs: check for shareable lock before calling huge_pmd_unshare()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     hugetlbfs-check-for-shareable-lock-before-calling-huge_pmd_unshare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-check-for-shareable-lock-before-calling-huge_pmd_unshare.patch

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
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: hugetlbfs: check for shareable lock before calling huge_pmd_unshare()
Date: Wed, 8 Oct 2025 10:57:59 +0530

When hugetlb_vmdelete_list() processes VMAs during truncate operations, it
may encounter VMAs where huge_pmd_unshare() is called without the required
shareable lock.  This triggers an assertion failure in
hugetlb_vma_assert_locked().

The previous fix in commit dd83609b8898 ("hugetlbfs: skip VMAs without
shareable locks in hugetlb_vmdelete_list") skipped entire VMAs without
shareable locks to avoid the assertion.  However, this prevented pages
from being unmapped and freed, causing a regression in
fallocate(PUNCH_HOLE) operations where pages were not freed immediately,
as reported by Mark Brown.

Instead of skipping VMAs or adding new flags, check __vma_shareable_lock()
directly in __unmap_hugepage_range() right before calling
huge_pmd_unshare().  This ensures PMD unsharing only happens when the VMA
has a shareable lock structure, while still allowing page unmapping and
freeing to proceed for all VMAs.

Link: https://lkml.kernel.org/r/20251008052759.469714-1-kartikey406@gmail.com
Fixes: dd83609b8898 ("hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list")
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Tested-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Reported-by: Mark Brown <broonie@kernel.org>
Suggested-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   10 +---------
 mm/hugetlb.c         |    2 +-
 2 files changed, 2 insertions(+), 10 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-check-for-shareable-lock-before-calling-huge_pmd_unshare
+++ a/fs/hugetlbfs/inode.c
@@ -478,14 +478,6 @@ hugetlb_vmdelete_list(struct rb_root_cac
 		if (!hugetlb_vma_trylock_write(vma))
 			continue;
 
-		/*
-		 * Skip VMAs without shareable locks. Per the design in commit
-		 * 40549ba8f8e0, these will be handled by remove_inode_hugepages()
-		 * called after this function with proper locking.
-		 */
-		if (!__vma_shareable_lock(vma))
-			goto skip;
-
 		v_start = vma_offset_start(vma, start);
 		v_end = vma_offset_end(vma, end);
 
@@ -496,7 +488,7 @@ hugetlb_vmdelete_list(struct rb_root_cac
 		 * vmas.  Therefore, lock is not held when calling
 		 * unmap_hugepage_range for private vmas.
 		 */
-skip:
+
 		hugetlb_vma_unlock_write(vma);
 	}
 }
--- a/mm/hugetlb.c~hugetlbfs-check-for-shareable-lock-before-calling-huge_pmd_unshare
+++ a/mm/hugetlb.c
@@ -5885,7 +5885,7 @@ void __unmap_hugepage_range(struct mmu_g
 		}
 
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, vma, address, ptep)) {
+		if (__vma_shareable_lock(vma) && huge_pmd_unshare(mm, vma, address, ptep)) {
 			spin_unlock(ptl);
 			tlb_flush_pmd_range(tlb, address & PUD_MASK, PUD_SIZE);
 			force_flush = true;
_

Patches currently in -mm which might be from kartikey406@gmail.com are

hugetlbfs-check-for-shareable-lock-before-calling-huge_pmd_unshare.patch


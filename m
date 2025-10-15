Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C785158DA3
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 01:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760492321; cv=none; b=nNNgGG+u0iIJEyKGNfJNK5GZOSftMajFwpWVrRKaGmz7bO1OYKLF1IA4Jf/pjRWV/u6AxatVNdIK+MN09P2ISKNh9VNddmfigEDYz8ZKh23CG4dmVbkB4yJiPsmTElI2aNns+ZkIeNtuf8EmMKTo1CtQM6kgVw8pVk/4L3ezUU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760492321; c=relaxed/simple;
	bh=XEI/2lxYDZy+FGstA71+rxvsiauBMmlT7nYDGb+7nww=;
	h=Date:To:From:Subject:Message-Id; b=U8RXreqfcQpFV3ocSLEEFGZm+GrlTYsMTUHnNVZSLcOiPPw0z1ATEVjiUHhOyqywOfODbllFkZ6lrD117T+C3sIRm+DAGFNSAVlgJunm7nXW/l87x+TeZaBH6RaAqBP+b3v211RRDaKYhCCqtRh+6WzdUZYHLm4DBE6dMNG/EAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xweah4dn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xweah4dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AE3C4CEE7;
	Wed, 15 Oct 2025 01:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760492320;
	bh=XEI/2lxYDZy+FGstA71+rxvsiauBMmlT7nYDGb+7nww=;
	h=Date:To:From:Subject:From;
	b=xweah4dnFaHbVTb/VjXrf53CfNfN5nhmgB2Qyd3xBDUdJXVElwiPvd3JiPbUAnp6i
	 YK21+MuBUR59ZTzVO3prMnOvlpeZS4drfUYs7Bpr9KtXfWBRKdXCfaS27edWMj/lE/
	 GVFOkEAf8BFTSnUanrPzVCA3ji4R+pJLxLhAe1Sc=
Date: Tue, 14 Oct 2025 18:38:40 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,broonie@kernel.org,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] hugetlbfs-check-for-shareable-lock-before-calling-huge_pmd_unshare.patch removed from -mm tree
Message-Id: <20251015013840.D9AE3C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlbfs: check for shareable lock before calling huge_pmd_unshare()
has been removed from the -mm tree.  Its filename was
     hugetlbfs-check-for-shareable-lock-before-calling-huge_pmd_unshare.patch

This patch was dropped because an updated version will be issued

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
Acked-by: Oscar Salvador <osalvador@suse.de>
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

ocfs2-clear-extent-cache-after-moving-defragmenting-extents.patch
hugetlbfs-move-lock-assertions-after-early-returns-in-huge_pmd_unshare.patch


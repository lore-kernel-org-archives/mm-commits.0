Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6802BE636
	for <mm-commits@vger.kernel.org>; Tue, 21 Oct 2025 22:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761086819; cv=none; b=pHUwR5rKggxVdmc/iKIFtv2B7WwhkgVnjyZk9OeXBZZUGg3u/yK+d17S++ON9ZTRHyWP2tNm1Dx/0RC1ncvcHdaYmce6TyXhHMunoa2zUbLeaJORHIBUmwR9SUrs7RupqYgiaxCG6DNaoyvaAhpluQ03AJDlhKIibPVc5Txij4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761086819; c=relaxed/simple;
	bh=s45RZkPWG649/IMUZZ6molqcC8aTarI6kyc5FPMDokE=;
	h=Date:To:From:Subject:Message-Id; b=AZQYxN7xBCpsSlG3mhJS7WNlc6c8qXtLkYKlpUkldRE88I92H8cItWR2+pKh0cKZRGoVnEBBKZSscx7Us5r71Uod+Dn8TcrrYdGUiN/lMDi8kf15BoXOmZ3LfDJhNvYIZKKzCnPAF9R+J6L5EqppzA29t2ITbmRF8WvXOXLDOPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NjsBWprf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NjsBWprf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB7EC4CEF1;
	Tue, 21 Oct 2025 22:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761086818;
	bh=s45RZkPWG649/IMUZZ6molqcC8aTarI6kyc5FPMDokE=;
	h=Date:To:From:Subject:From;
	b=NjsBWprfsu7yIbzI6ZAJpNhwDFE6h7uocsRxc8Kthgd2pg9rdIpnoHxAesPXmdveU
	 6mjrI/EExqoaMtJsAe47z20iGMOhnWL77t846IiTK0bGAymM5n+NmIp6TXPikM2AAV
	 bnY5sPB4T2+Yj/V2Tf9MwenZoemKvDgVyQ7J7Rkk=
Date: Tue, 21 Oct 2025 15:46:57 -0700
To: mm-commits@vger.kernel.org,syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com,osalvador@suse.de,david@redhat.com,broonie@kernel.org,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] hugetlbfs-move-lock-assertions-after-early-returns-in-huge_pmd_unshare.patch removed from -mm tree
Message-Id: <20251021224658.8DB7EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlbfs: move lock assertions after early returns in huge_pmd_unshare()
has been removed from the -mm tree.  Its filename was
     hugetlbfs-move-lock-assertions-after-early-returns-in-huge_pmd_unshare.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: hugetlbfs: move lock assertions after early returns in huge_pmd_unshare()
Date: Tue, 14 Oct 2025 17:03:44 +0530

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

Instead of checking locks in the caller or skipping VMAs, move the lock
assertions in huge_pmd_unshare() to after the early return checks.  The
assertions are only needed when actual PMD unsharing work will be
performed.  If the function returns early because sz != PMD_SIZE or the
PMD is not shared, no locks are required and assertions should not fire.

This approach reverts the VMA skipping logic from commit dd83609b8898
("hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list")
while moving the assertions to avoid the assertion failure, keeping all
the logic within huge_pmd_unshare() itself and allowing page unmapping and
freeing to proceed for all VMAs.

Link: https://lkml.kernel.org/r/20251014113344.21194-1-kartikey406@gmail.com
Fixes: dd83609b8898 ("hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list")
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: <syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com>
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://syzkaller.appspot.com/bug?extid=f26d7c75c26ec19790e7
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Oscar Salvador <osalvador@suse.de>
Tested-by: <syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    9 ---------
 mm/hugetlb.c         |    5 ++---
 2 files changed, 2 insertions(+), 12 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-move-lock-assertions-after-early-returns-in-huge_pmd_unshare
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
 
@@ -496,7 +488,6 @@ hugetlb_vmdelete_list(struct rb_root_cac
 		 * vmas.  Therefore, lock is not held when calling
 		 * unmap_hugepage_range for private vmas.
 		 */
-skip:
 		hugetlb_vma_unlock_write(vma);
 	}
 }
--- a/mm/hugetlb.c~hugetlbfs-move-lock-assertions-after-early-returns-in-huge_pmd_unshare
+++ a/mm/hugetlb.c
@@ -7614,13 +7614,12 @@ int huge_pmd_unshare(struct mm_struct *m
 	p4d_t *p4d = p4d_offset(pgd, addr);
 	pud_t *pud = pud_offset(p4d, addr);
 
-	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
-	hugetlb_vma_assert_locked(vma);
 	if (sz != PMD_SIZE)
 		return 0;
 	if (!ptdesc_pmd_is_shared(virt_to_ptdesc(ptep)))
 		return 0;
-
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
+	hugetlb_vma_assert_locked(vma);
 	pud_clear(pud);
 	/*
 	 * Once our caller drops the rmap lock, some other process might be
_

Patches currently in -mm which might be from kartikey406@gmail.com are



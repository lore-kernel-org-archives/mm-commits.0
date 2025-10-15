Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BC32F9DAF
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 01:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760492366; cv=none; b=hDBDxUhTlx9wE2zSbwLn5kJ/HroXw4iuvcTygSEg+KFBWg8ub+E7y7nlACsCdGo0wepr02AuVGzex1dfqo7LPVgpdw16AUWNSMWrgH70KJckLJSUpED2/gBGTcOm3LmiGDjfJw4KEIu1yOg5fcDaZuGtvFnjWG+nnMsWyWk5GzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760492366; c=relaxed/simple;
	bh=FKy5z6sPm+KccV3WH5bVtsR7xQdYQpSUE6EFe2tUOBA=;
	h=Date:To:From:Subject:Message-Id; b=BPQmvX1jNpY1//IyT8rvKISN8qczzQD9EHPF6PPlEEqKlNJYPzquOOvahEr8KsPuHnVpimzmHlLnDinKbUV2yPwCE5euBZ9iZsG7ERRFgZroXLvCGy+1h3dOqHJWsjzhmrXP3gVQf96PUzGPNwIII0jUeEbZKbZAXgWyLGcpT1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aFDxzrXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aFDxzrXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81ACC4CEE7;
	Wed, 15 Oct 2025 01:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760492364;
	bh=FKy5z6sPm+KccV3WH5bVtsR7xQdYQpSUE6EFe2tUOBA=;
	h=Date:To:From:Subject:From;
	b=aFDxzrXOjepGZorTj9oFYGc8zN11SdpyYIoieBKECKpMe3EjWvOoxQpnYxCKhhWZC
	 TRd30aenm9cIaedgnSaRF8ymK4rkL7PBFH+LnBT9Zkc+iT8mFt46vSmjOaisqodBQm
	 YLz5fjOyRKaVU7lpfwFR/2KM36ndv72IgtYi7oQA=
Date: Tue, 14 Oct 2025 18:39:24 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,david@redhat.com,broonie@kernel.org,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-move-lock-assertions-after-early-returns-in-huge_pmd_unshare.patch added to mm-hotfixes-unstable branch
Message-Id: <20251015013924.C81ACC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlbfs: move lock assertions after early returns in huge_pmd_unshare()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     hugetlbfs-move-lock-assertions-after-early-returns-in-huge_pmd_unshare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-move-lock-assertions-after-early-returns-in-huge_pmd_unshare.patch

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
Reported-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://syzkaller.appspot.com/bug?extid=f26d7c75c26ec19790e7
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Oscar Salvador <osalvador@suse.de>
Tested-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
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

ocfs2-clear-extent-cache-after-moving-defragmenting-extents.patch
hugetlbfs-move-lock-assertions-after-early-returns-in-huge_pmd_unshare.patch


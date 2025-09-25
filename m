Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE9235940;
	Thu, 25 Sep 2025 20:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758832505; cv=none; b=lj70FoLTf+NXFt7ocVJVtFNoGJTxsokp5yr6Nm2P4z7dbBzlfjjXy5pjRck0XcXXWryKnq8M6W/EErm65o9z/zayw/YR2DLMbe1RhnAHAcyZI6SLDdrPO1FRl1y9AMRd2EdtCaJoSDy2v0aLMA9P9xhMGuqwH1riZgcOYnbbc3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758832505; c=relaxed/simple;
	bh=UXqrSeyJfQ5VVk+A27k67uRWkFpFX7EluQAj7zgGa4c=;
	h=Date:To:From:Subject:Message-Id; b=FvN1xg7/4+/xIsBPayRHODquIWByfNLjj7aUpV7FqpcVLHtfYSwYqMDCeA2NQOFtZR6jOBoEJpGUtngqp90AOvePlIyPM6nVzxqZzoAhn8I980m+r2Cnn14hRXKsUtwMUytqqBiUKa81yNbH8vuNFfotXZDXcjWS3Zqbvhj6HHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=17RYXXM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="17RYXXM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE02C4CEF7;
	Thu, 25 Sep 2025 20:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758832504;
	bh=UXqrSeyJfQ5VVk+A27k67uRWkFpFX7EluQAj7zgGa4c=;
	h=Date:To:From:Subject:From;
	b=17RYXXM3Pew41qykdf0bS8QoHdfN7Bjm8zKnHN2wp4D0evEjc7VTUqZouUrc/3Kid
	 pTQskJVdJCOVDCIXQt9VicxDHqbGdZ/yK4J1M3AgS0b6dYG6MAlJWwZ7AYNpYipHMT
	 vEm2egIMeNKiHCq58B9gZUy9jwOTefYhlx6DIEjE=
Date: Thu, 25 Sep 2025 13:35:03 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-skip-vmas-without-shareable-locks-in-hugetlb_vmdelete_list.patch added to mm-new branch
Message-Id: <20250925203504.7BE02C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
has been added to the -mm mm-new branch.  Its filename is
     hugetlbfs-skip-vmas-without-shareable-locks-in-hugetlb_vmdelete_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-skip-vmas-without-shareable-locks-in-hugetlb_vmdelete_list.patch

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
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
Date: Thu, 25 Sep 2025 20:19:32 +0530

hugetlb_vmdelete_list() uses trylock to acquire VMA locks during truncate
operations.  As per the original design in commit 40549ba8f8e0 ("hugetlb:
use new vma_lock for pmd sharing synchronization"), if the trylock fails
or the VMA has no lock, it should skip that VMA.  Any remaining mapped
pages are handled by remove_inode_hugepages() which is called after
hugetlb_vmdelete_list() and uses proper lock ordering to guarantee
unmapping success.

Currently, when hugetlb_vma_trylock_write() returns success (1) for VMAs
without shareable locks, the code proceeds to call unmap_hugepage_range().
This causes assertion failures in huge_pmd_unshare() →
hugetlb_vma_assert_locked() because no lock is actually held:

  WARNING: CPU: 1 PID: 6594 Comm: syz.0.28 Not tainted
  Call Trace:
   hugetlb_vma_assert_locked+0x1dd/0x250
   huge_pmd_unshare+0x2c8/0x540
   __unmap_hugepage_range+0x6e3/0x1aa0
   unmap_hugepage_range+0x32e/0x410
   hugetlb_vmdelete_list+0x189/0x1f0

Fix by explicitly skipping VMAs without shareable locks after trylock
succeeds, consistent with the original design where such VMAs are deferred
to remove_inode_hugepages() for proper handling.

Link: https://lkml.kernel.org/r/20250925144934.150299-1-kartikey406@gmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=f26d7c75c26ec19790e7
Fixes: 40549ba8f8e0 ("hugetlb: use new vma_lock for pmd sharing synchronization")
Tested-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-skip-vmas-without-shareable-locks-in-hugetlb_vmdelete_list
+++ a/fs/hugetlbfs/inode.c
@@ -487,7 +487,8 @@ hugetlb_vmdelete_list(struct rb_root_cac
 
 		if (!hugetlb_vma_trylock_write(vma))
 			continue;
-
+		if (!__vma_shareable_lock(vma))
+			continue;
 		v_start = vma_offset_start(vma, start);
 		v_end = vma_offset_end(vma, end);
 
_

Patches currently in -mm which might be from kartikey406@gmail.com are

hugetlbfs-skip-vmas-without-shareable-locks-in-hugetlb_vmdelete_list.patch


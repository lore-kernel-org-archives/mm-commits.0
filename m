Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621AF258EF6
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085553; cv=none; b=qOAl0WybaGD/UQX6Ruv6/UuOtuL9oBuMxe5lRzzOnFBWS6XhBGKUad4XGwykvm5FQTK4nF0Uw0pyd9t5iOZ9ng+x/rilk2A6CQWqVyfn1eNHgLJwOnsKUpceZkJbTETQjC+pcGzo309zeK37KfJlbkqxoTYZrl9NhxAhoeRu7hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085553; c=relaxed/simple;
	bh=PX4uqLnzXSnjK4l+65Ob8qEPh/PjSjZom1Hm+/XZK/M=;
	h=Date:To:From:Subject:Message-Id; b=htfFjtz7e/lZpgL2bv6ojej6isySmtSWs1uDXOC7odMj5pKRuFMhs/5y1wGUoZ/Oly5Zhnhq3UyAVdW1Zh5A8OplL79DFyu3wVjRP0//kOfNNxIYCQw2aYwbsUOW5LQ8hKu8IUd70H6wZsimTWvaLonfb5QZCZATbzu3Jdz963M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vMbwjfmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vMbwjfmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDB6C4CEF0;
	Sun, 28 Sep 2025 18:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085552;
	bh=PX4uqLnzXSnjK4l+65Ob8qEPh/PjSjZom1Hm+/XZK/M=;
	h=Date:To:From:Subject:From;
	b=vMbwjfmJcHZZtZQ0PHIHQQKsywQT6KuWJqMKXHO2icNEm9a7b0YrPwf2NO6uX0vqJ
	 kOaWcrWF5SU20Jdid67r3kXJ/7BnBRE9yD+dq+7DSueNOBzhAlqYyzTQB0KGT4NwlO
	 jQ6jU4LLEKF7NMgx6/Y4nKjoMl9zHu7acYlkh4/0=
Date: Sun, 28 Sep 2025 11:52:32 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlbfs-skip-vmas-without-shareable-locks-in-hugetlb_vmdelete_list.patch removed from -mm tree
Message-Id: <20250928185232.BEDB6C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
has been removed from the -mm tree.  Its filename was
     hugetlbfs-skip-vmas-without-shareable-locks-in-hugetlb_vmdelete_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
Date: Fri, 26 Sep 2025 09:02:54 +0530

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

Fix by using goto to ensure locks acquired by trylock are always released,
even when skipping VMAs without shareable locks.

Link: https://lkml.kernel.org/r/20250926033255.10930-1-kartikey406@gmail.com
Fixes: 40549ba8f8e0 ("hugetlb: use new vma_lock for pmd sharing synchronization")
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f26d7c75c26ec19790e7
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-skip-vmas-without-shareable-locks-in-hugetlb_vmdelete_list
+++ a/fs/hugetlbfs/inode.c
@@ -478,6 +478,14 @@ hugetlb_vmdelete_list(struct rb_root_cac
 		if (!hugetlb_vma_trylock_write(vma))
 			continue;
 
+		/*
+		 * Skip VMAs without shareable locks. Per the design in commit
+		 * 40549ba8f8e0, these will be handled by remove_inode_hugepages()
+		 * called after this function with proper locking.
+		 */
+		if (!__vma_shareable_lock(vma))
+			goto skip;
+
 		v_start = vma_offset_start(vma, start);
 		v_end = vma_offset_end(vma, end);
 
@@ -488,6 +496,7 @@ hugetlb_vmdelete_list(struct rb_root_cac
 		 * vmas.  Therefore, lock is not held when calling
 		 * unmap_hugepage_range for private vmas.
 		 */
+skip:
 		hugetlb_vma_unlock_write(vma);
 	}
 }
_

Patches currently in -mm which might be from kartikey406@gmail.com are



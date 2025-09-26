Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234AE27FB1E
	for <mm-commits@vger.kernel.org>; Fri, 26 Sep 2025 20:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758918541; cv=none; b=ZFBPoYugFvrfxh2uXREF02fAqWxmuM6PtzX34R/mQMg2e6nxd0hazfOHlxrp3l5YdweXAX9hF6ipPFldDMUSxLCsnknQE0bKDp/ad8lBEvoBYrBl6F1uECZ6NH6mGN2Hq2Ism+WExf+rWICL8j7a1UTdM5E13m5Va/z0PViKYxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758918541; c=relaxed/simple;
	bh=nqL/08zDDv2XeribPyEo8utpbU46a3gZKkqVkUUDfRw=;
	h=Date:To:From:Subject:Message-Id; b=vFniq8uMJAuOlplGwEsWs88kbX3QrGICE9/PD1TwiVP9Yr5ysiDNM937EvsgZQg2a1rgDymI26e1Z2LTlTy7PVhJZE8Nr3AuA7TdYe07AHiht/SmpY0YiBHIO14B+MYMy+Kg268XZOsaWMQlJZuEr6FjtmjFyDcdzGhhPFO4d0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Iar7vXg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Iar7vXg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B24C4CEF4;
	Fri, 26 Sep 2025 20:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758918540;
	bh=nqL/08zDDv2XeribPyEo8utpbU46a3gZKkqVkUUDfRw=;
	h=Date:To:From:Subject:From;
	b=Iar7vXg3AavoY0DH7vy9o62At3IxXPWwEw2lr5oeuaY4rf5RV5kiW8foOSgjLgfLE
	 7Q0qvN7/dLsrDBP3UFY6lv0VzxhBwbewcc/70Y0xaOor8mcF1n09/X/oGmEFTQhcGe
	 Vwzc/sjkGE2D2ERK0HLlDUVeyjS6fQ3vPkFVOB5E=
Date: Fri, 26 Sep 2025 13:28:59 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-skip-vmas-without-shareable-locks-in-hugetlb_vmdelete_list.patch added to mm-unstable branch
Message-Id: <20250926202900.62B24C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlbfs-skip-vmas-without-shareable-locks-in-hugetlb_vmdelete_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-skip-vmas-without-shareable-locks-in-hugetlb_vmdelete_list.patch

This patch will later appear in the mm-unstable branch at
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

hugetlbfs-skip-vmas-without-shareable-locks-in-hugetlb_vmdelete_list.patch


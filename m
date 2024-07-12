Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B4839AC3
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 20:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720816179; cv=none; b=fmgMP5woZY8UAPhkCfDq3t6ShbPRbU1CCap67aS7gBuFc13h12E/90uOmsXnSEtLP9w6cf483SRXOU98Y3WOTk5PHL8dA2KIZs5yhmej8p8KJAW3+RMWVXRAWxwOu0wIsaCvpo5Z/HD36k7ffaRsSLkxyiZzR1Erz4jOOcLUSI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720816179; c=relaxed/simple;
	bh=ZakExdmulJ3LnJCf98GOABFIzjQ6PV33jlWOnXFVF90=;
	h=Date:To:From:Subject:Message-Id; b=cGffKc8X6u0AbWFNAWJQS1/svpI7tP8+V1f/OX/jp22Tag5opDnsDDnaYRer6zylZy8W4c/YOn/BMaokxb38fQmfodR20N17NJlooCthU7uuPEVtIkR1c7QfCKvsOCiUx/ZCtcaaiChgiRpgK4IPfJjnbP2odVRWQbk+Z2u8Cak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sxm0QMZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sxm0QMZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB83C32782;
	Fri, 12 Jul 2024 20:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720816178;
	bh=ZakExdmulJ3LnJCf98GOABFIzjQ6PV33jlWOnXFVF90=;
	h=Date:To:From:Subject:From;
	b=sxm0QMZxAuXg6yr6w9JPbw25hN+8gyI2L0xA6CMIHW+wTLpGIx1y35pZaqGIy8/tp
	 ftZSiR3fU85tXyqR4a8mTg+mZOLcOxU5GxcQUyh/e61mXPjJ6A0EzufD2F59uT2nx/
	 AXHgzQpRmf608BLitBnG3bToqwmNdk9/8waA5aQc=
Date: Fri, 12 Jul 2024 13:29:37 -0700
To: mm-commits@vger.kernel.org,syzbot+35a4414f6e247f515443@syzkaller.appspotmail.com,skhan@linuxfoundation.org,david@redhat.com,peili.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-fix-mmap_assert_locked-in-follow_pte.patch removed from -mm tree
Message-Id: <20240712202938.8BB83C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix mmap_assert_locked() in follow_pte()
has been removed from the -mm tree.  Its filename was
     mm-fix-mmap_assert_locked-in-follow_pte.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Pei Li <peili.dev@gmail.com>
Subject: mm: fix mmap_assert_locked() in follow_pte()
Date: Wed, 10 Jul 2024 22:13:17 -0700

Syzbot reported the following warning in follow_pte():

WARNING: CPU: 3 PID: 5192 at include/linux/rwsem.h:195 rwsem_assert_held include/linux/rwsem.h:195 [inline]
WARNING: CPU: 3 PID: 5192 at include/linux/rwsem.h:195 mmap_assert_locked include/linux/mmap_lock.h:65 [inline]
WARNING: CPU: 3 PID: 5192 at include/linux/rwsem.h:195 follow_pte+0x414/0x4c0 mm/memory.c:5980

This is because we are assuming that mm->mmap_lock should be held when
entering follow_pte().  This is added in commit c5541ba378e3 (mm:
follow_pte() improvements).

However, in the following call stack, we are not acquring the lock:
 follow_phys arch/x86/mm/pat/memtype.c:957 [inline]
 get_pat_info+0xf2/0x510 arch/x86/mm/pat/memtype.c:991
 untrack_pfn+0xf7/0x4d0 arch/x86/mm/pat/memtype.c:1104
 unmap_single_vma+0x1bd/0x2b0 mm/memory.c:1819
 zap_page_range_single+0x326/0x560 mm/memory.c:1920

In zap_page_range_single(), we passed mm_wr_locked as false, as we do not
expect write lock to be held.  In the special case where vma->vm_flags is
set as VM_PFNMAP, we are hitting untrack_pfn() which eventually calls into
follow_phys.

This patch fixes this warning by acquiring read lock before entering
untrack_pfn() while write lock is not held.

syzbot has tested the proposed patch and the reproducer did not
trigger any issue.

Link: https://lkml.kernel.org/r/20240710-bug12-v1-1-0e5440f9b8d3@gmail.com
Fixes: c5541ba378e3 ("mm: follow_pte() improvements")
Signed-off-by: Pei Li <peili.dev@gmail.com>
Reported-by: <syzbot+35a4414f6e247f515443@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=35a4414f6e247f515443
Tested-by: <syzbot+35a4414f6e247f515443@syzkaller.appspotmail.com>
Cc: Pei Li <peili.dev@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-fix-mmap_assert_locked-in-follow_pte
+++ a/mm/memory.c
@@ -1815,9 +1815,16 @@ static void unmap_single_vma(struct mmu_
 	if (vma->vm_file)
 		uprobe_munmap(vma, start, end);
 
-	if (unlikely(vma->vm_flags & VM_PFNMAP))
+	if (unlikely(vma->vm_flags & VM_PFNMAP)) {
+		if (!mm_wr_locked)
+			mmap_read_lock(vma->vm_mm);
+
 		untrack_pfn(vma, 0, 0, mm_wr_locked);
 
+		if (!mm_wr_locked)
+			mmap_read_unlock(vma->vm_mm);
+	}
+
 	if (start != end) {
 		if (unlikely(is_vm_hugetlb_page(vma))) {
 			/*
_

Patches currently in -mm which might be from peili.dev@gmail.com are

mm-ignore-data-race-in-__swap_writepage.patch


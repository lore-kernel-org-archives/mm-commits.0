Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCC8231C9F;
	Fri,  4 Oct 2024 22:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728081244; cv=none; b=r7QOBy0J8+oOGPedv7wchG+6FsjJcxwE3Mege6KYcfn0VRViba15DYiHFk8FcOQwB0c7eAmqhqhRZ/pYMhr66tWrVMYkHG2ZK+LY3Wi7qggsbld1StR05wGCb9xEhRd6IGPJBH6U4gPNlpWliy+HNRagPmbiO7s5rQv1XQBHGLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728081244; c=relaxed/simple;
	bh=shRFwDgr1XuSXcpBS34QoR+L4Fh7clAuQDuYW9cADbs=;
	h=Date:To:From:Subject:Message-Id; b=nqqYN84Du/J2wrMhOQfdomvFdImnNIIxk/HyBCd8O+bvO21/KSyvavv7XtZ1nVT+OMRLxV1oCxKh86pWHab7T3IJVrIHOatr57lviDZFdvm8tt8xaIP51QIX1Nc94OkrARYKzs+E2fYZ+bYNgN/dHC9bkJN5cUZJPM1X200Y0nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kHxzOiaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kHxzOiaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD03C4CEC6;
	Fri,  4 Oct 2024 22:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728081244;
	bh=shRFwDgr1XuSXcpBS34QoR+L4Fh7clAuQDuYW9cADbs=;
	h=Date:To:From:Subject:From;
	b=kHxzOiaQdZBkGZZXjQeR9BTs2NoWMjSD+nEfogZuvyps24g8bHnf4pWOXvvUz42zq
	 9HVrw6ct4lCliQ2ExRlPIg/7qeMmMatM3EhAYO8CrDLa5CH4pEyFWQwKXRCNBY2lhO
	 AWPBIdnynGUgxSHWUW9nkh3mT4YEMt2xoOpd96HA=
Date: Fri, 04 Oct 2024 15:34:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,skhan@linuxfoundation.org,anupnewsmail@gmail.com,manas18244@iiitd.ac.in,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fixes-null-pointer-dereference-in-pfnmap_lockdep_assert.patch added to mm-hotfixes-unstable branch
Message-Id: <20241004223404.1CD03C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix null pointer dereference in pfnmap_lockdep_assert
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fixes-null-pointer-dereference-in-pfnmap_lockdep_assert.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fixes-null-pointer-dereference-in-pfnmap_lockdep_assert.patch

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
From: Manas <manas18244@iiitd.ac.in>
Subject: mm: fix null pointer dereference in pfnmap_lockdep_assert
Date: Fri, 04 Oct 2024 23:12:16 +0530

syzbot has pointed to a possible null pointer dereference in
pfnmap_lockdep_assert.  vm_file member of vm_area_struct is being
dereferenced without any checks.

This fix assigns mapping only if vm_file is not NULL.

Peter said (https://lkml.kernel.org/r/Zv8HRA5mnhVevBN_@x1n):

: If I read the stack right, the crash was before mmap() of the new vma
: happens, instead it's during unmap() of one existing vma which existed and
: overlapped with the new vma's mapping range:
: 
:  follow_phys arch/x86/mm/pat/memtype.c:956 [inline]
:  get_pat_info+0x182/0x3f0 arch/x86/mm/pat/memtype.c:988
:  untrack_pfn+0x327/0x640 arch/x86/mm/pat/memtype.c:1101
:  unmap_single_vma+0x1f6/0x2b0 mm/memory.c:1834
:  unmap_vmas+0x3cc/0x5f0 mm/memory.c:1900
:  unmap_region+0x214/0x380 mm/vma.c:354     <--------------- here
:  mmap_region+0x22f9/0x2990 mm/mmap.c:1573
:  do_mmap+0x8f0/0x1000 mm/mmap.c:496
:  vm_mmap_pgoff+0x1dd/0x3d0 mm/util.c:588
:  ksys_mmap_pgoff+0x4eb/0x720 mm/mmap.c:542
:  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
:  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
:  entry_SYSCALL_64_after_hwframe+0x77/0x7f
: 
: It looks like the vma that was overwritten by the new file vma mapping
: could be a VM_PFNMAP vma (I'm guessing vvar or something similar..),
: that's where untrack_pfn() got kicked off.  In this case, the vma being
: overwritten and to be unmapped can have ->vm_file==NULL (while ->vm_ops
: non-NULL; /me looking at __install_special_mapping()).


Link: https://lkml.kernel.org/r/20241004-fix-null-deref-v4-1-d0a8ec01ac85@iiitd.ac.in
Reported-by: syzbot+093d096417e7038a689b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=093d096417e7038a689b
Cc: Anup Sharma <anupnewsmail@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/memory.c~fixes-null-pointer-dereference-in-pfnmap_lockdep_assert
+++ a/mm/memory.c
@@ -6355,10 +6355,13 @@ static inline void pfnmap_args_setup(str
 static inline void pfnmap_lockdep_assert(struct vm_area_struct *vma)
 {
 #ifdef CONFIG_LOCKDEP
-	struct address_space *mapping = vma->vm_file->f_mapping;
+	struct address_space *mapping = NULL;
+
+	if (vma->vm_file)
+		mapping = vma->vm_file->f_mapping;
 
 	if (mapping)
-		lockdep_assert(lockdep_is_held(&vma->vm_file->f_mapping->i_mmap_rwsem) ||
+		lockdep_assert(lockdep_is_held(&mapping->i_mmap_rwsem) ||
 			       lockdep_is_held(&vma->vm_mm->mmap_lock));
 	else
 		lockdep_assert(lockdep_is_held(&vma->vm_mm->mmap_lock));
_

Patches currently in -mm which might be from manas18244@iiitd.ac.in are

fixes-null-pointer-dereference-in-pfnmap_lockdep_assert.patch


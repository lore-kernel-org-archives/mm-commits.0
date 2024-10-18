Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D793818DF7C
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 21:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729286314; cv=none; b=GRUMrzq+erzUndVbGg65akTe8cPuTgnKo87FRyKBUgZQ6eSnJN4QtbhiMdn+P4kch3Ds/rUhzrNqjOPufb1yfB7te8t3+cR5/caTwZGs0Vth2Nr2WvZoIKvbdMibLPXKNQcoKVvs3Cxg/9lbF1/IWeENKC+FW+0cst435Jl8WXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729286314; c=relaxed/simple;
	bh=yG2tOSF3s2KKkn3gVBaodud9CbURBqBXq7I54MshyjM=;
	h=Date:To:From:Subject:Message-Id; b=a5bPZ42+Fcnl+MJ5sJywj/rv+Q0FJI1XGE1t+fg7713nmxE9dgGx1s9vY9eRrSO3/UqAruTew7wpDw1yptkUepinXH27W+OVDzu9sIitlcrkWvzWFHodKkfJk/uBLGhvU99PDIGjgLoP4OnpkczjXoDGjOzvcH1G2GkYmUvymeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cc1RVxLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cc1RVxLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C708C4CEC3;
	Fri, 18 Oct 2024 21:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729286314;
	bh=yG2tOSF3s2KKkn3gVBaodud9CbURBqBXq7I54MshyjM=;
	h=Date:To:From:Subject:From;
	b=Cc1RVxLobR0nHEeWBAhjquIoIXNS5mxQ8HHwwlha6LD3c2UduWZD1WP2wgY2smiTB
	 NPAlstKdMWrhK/lQZiAFveeZxm0ZONJQNspBJ71k7Uut+kH+3Dex5ZXQgnfowslIG3
	 Q+f+Vze6iuVwyh9bH0tHcZ5hQlNMoR6EAltt0zUI=
Date: Fri, 18 Oct 2024 14:18:33 -0700
To: mm-commits@vger.kernel.org,zohar@linux.ibm.com,vbabka@suse.cz,serge@hallyn.com,roberto.sassu@huawei.com,paul@paul-moore.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jmorris@namei.org,jarkko@kernel.org,jannh@google.com,eric.snowberg@oracle.com,ebpqwerty472123@gmail.com,dmitry.kasatkin@gmail.com,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-split-critical-region-in-remap_file_pages-and-invoke-lsms-in-between.patch added to mm-hotfixes-unstable branch
Message-Id: <20241018211834.4C708C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: split critical region in remap_file_pages() and invoke LSMs in between
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-split-critical-region-in-remap_file_pages-and-invoke-lsms-in-between.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-split-critical-region-in-remap_file_pages-and-invoke-lsms-in-between.patch

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
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: split critical region in remap_file_pages() and invoke LSMs in between
Date: Fri, 18 Oct 2024 18:14:15 +0200

Commit ea7e2d5e49c0 ("mm: call the security_mmap_file() LSM hook in
remap_file_pages()") fixed a security issue, it added an LSM check when
trying to remap file pages, so that LSMs have the opportunity to evaluate
such action like for other memory operations such as mmap() and
mprotect().

However, that commit called security_mmap_file() inside the mmap_lock
lock, while the other calls do it before taking the lock, after commit
8b3ec6814c83 ("take security_mmap_file() outside of ->mmap_sem").

This caused lock inversion issue with IMA which was taking the mmap_lock
and i_mutex lock in the opposite way when the remap_file_pages() system
call was called.

Solve the issue by splitting the critical region in remap_file_pages() in
two regions: the first takes a read lock of mmap_lock, retrieves the VMA
and the file descriptor associated, and calculates the 'prot' and 'flags'
variables; the second takes a write lock on mmap_lock, checks that the VMA
flags and the VMA file descriptor are the same as the ones obtained in the
first critical region (otherwise the system call fails), and calls
do_mmap().

In between, after releasing the read lock and before taking the write
lock, call security_mmap_file(), and solve the lock inversion issue.

Link: https://lkml.kernel.org/r/20241018161415.3845146-1-roberto.sassu@huaweicloud.com
Fixes: ea7e2d5e49c0 ("mm: call the security_mmap_file() LSM hook in remap_file_pages()")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reported-by: syzbot+1cd571a672400ef3a930@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-security-module/66f7b10e.050a0220.46d20.0036.GAE@google.com/
Tested-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Tested-by: syzbot+1cd571a672400ef3a930@syzkaller.appspotmail.com
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Eric Snowberg <eric.snowberg@oracle.com>
Cc: James Morris <jmorris@namei.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Shu Han <ebpqwerty472123@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   69 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 52 insertions(+), 17 deletions(-)

--- a/mm/mmap.c~mm-split-critical-region-in-remap_file_pages-and-invoke-lsms-in-between
+++ a/mm/mmap.c
@@ -1642,6 +1642,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	unsigned long populate = 0;
 	unsigned long ret = -EINVAL;
 	struct file *file;
+	vm_flags_t vm_flags;
 
 	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. See Documentation/mm/remap_file_pages.rst.\n",
 		     current->comm, current->pid);
@@ -1658,12 +1659,60 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	if (pgoff + (size >> PAGE_SHIFT) < pgoff)
 		return ret;
 
-	if (mmap_write_lock_killable(mm))
+	if (mmap_read_lock_killable(mm))
 		return -EINTR;
 
+	/*
+	 * Look up VMA under read lock first so we can perform the security
+	 * without holding locks (which can be problematic). We reacquire a
+	 * write lock later and check nothing changed underneath us.
+	 */
 	vma = vma_lookup(mm, start);
 
-	if (!vma || !(vma->vm_flags & VM_SHARED))
+	if (!vma || !(vma->vm_flags & VM_SHARED)) {
+		mmap_read_unlock(mm);
+		return -EINVAL;
+	}
+
+	prot |= vma->vm_flags & VM_READ ? PROT_READ : 0;
+	prot |= vma->vm_flags & VM_WRITE ? PROT_WRITE : 0;
+	prot |= vma->vm_flags & VM_EXEC ? PROT_EXEC : 0;
+
+	flags &= MAP_NONBLOCK;
+	flags |= MAP_SHARED | MAP_FIXED | MAP_POPULATE;
+	if (vma->vm_flags & VM_LOCKED)
+		flags |= MAP_LOCKED;
+
+	/* Save vm_flags used to calculate prot and flags, and recheck later. */
+	vm_flags = vma->vm_flags;
+	file = get_file(vma->vm_file);
+
+	mmap_read_unlock(mm);
+
+	/* Call outside mmap_lock to be consistent with other callers. */
+	ret = security_mmap_file(file, prot, flags);
+	if (ret) {
+		fput(file);
+		return ret;
+	}
+
+	ret = -EINVAL;
+
+	/* OK security check passed, take write lock + let it rip. */
+	if (mmap_write_lock_killable(mm)) {
+		fput(file);
+		return -EINTR;
+	}
+
+	vma = vma_lookup(mm, start);
+
+	if (!vma)
+		goto out;
+
+	/* Make sure things didn't change under us. */
+	if (vma->vm_flags != vm_flags)
+		goto out;
+	if (vma->vm_file != file)
 		goto out;
 
 	if (start + size > vma->vm_end) {
@@ -1691,25 +1740,11 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 			goto out;
 	}
 
-	prot |= vma->vm_flags & VM_READ ? PROT_READ : 0;
-	prot |= vma->vm_flags & VM_WRITE ? PROT_WRITE : 0;
-	prot |= vma->vm_flags & VM_EXEC ? PROT_EXEC : 0;
-
-	flags &= MAP_NONBLOCK;
-	flags |= MAP_SHARED | MAP_FIXED | MAP_POPULATE;
-	if (vma->vm_flags & VM_LOCKED)
-		flags |= MAP_LOCKED;
-
-	file = get_file(vma->vm_file);
-	ret = security_mmap_file(vma->vm_file, prot, flags);
-	if (ret)
-		goto out_fput;
 	ret = do_mmap(vma->vm_file, start, size,
 			prot, flags, 0, pgoff, &populate, NULL);
-out_fput:
-	fput(file);
 out:
 	mmap_write_unlock(mm);
+	fput(file);
 	if (populate)
 		mm_populate(ret, populate);
 	if (!IS_ERR_VALUE(ret))
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-split-critical-region-in-remap_file_pages-and-invoke-lsms-in-between.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB79C2F22
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 00:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733272837; cv=none; b=CCyKFWPYPpm1OdpKRXPE0RS11Cop+XT4MbRq4KmtVVpqLi75nJd2hGaLiEvexmcWcc7Ac44DAdcRdy3WCyOIclIo64Dom3oWIWwIaHcjKzSepY09VCooDjecRHe3gfovMFxxUfQgEiJLRYItnYuR+4Ny3QS2GPYTFESyGx1UD+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733272837; c=relaxed/simple;
	bh=kB6noxKeWymN8ZtQUcIQNzmMzGwB0icHxYG0nJ0qCIE=;
	h=Date:To:From:Subject:Message-Id; b=moED4/s6BebEhyYxIW4lciOIgXI85sf4/Z9CmBgGWPGLWGQbt5PuvHJnZF7o2O+dbimUH7qXNza8Dqqdez3xjbx2zYU1QPklmJKnE/+QC5KpoE659TrCZJTyAhecS6Ds/Xnw6nSAZwVs7kWi+qL0jKNizz3B9QNqi6bpQl0uU7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SZO8VQ5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SZO8VQ5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A410C4CEDE;
	Wed,  4 Dec 2024 00:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733272837;
	bh=kB6noxKeWymN8ZtQUcIQNzmMzGwB0icHxYG0nJ0qCIE=;
	h=Date:To:From:Subject:From;
	b=SZO8VQ5njFZkaPRz3mSgWpndkOCzcb3LTxpR/IGYpSot1cXLw++0kQBe87UcpX2n/
	 YSo/wTnB6J25etvHmVuNBHhF9RMpuHsxd1ISNj5EaWAceOqE76RtPzgt6RK6/azSx1
	 xgEq8LZZE7J6Qzjpip1GdiK2QIiHM/kYHHMJFh2A=
Date: Tue, 03 Dec 2024 16:40:36 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,Liam.Howlett@Oracle.com,kees@kernel.org,jannh@google.com,jack@suse.cz,ebiederm@xmission.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-move-__vm_munmap-to-mm-vmac.patch added to mm-unstable branch
Message-Id: <20241204004037.3A410C4CEDE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: move __vm_munmap() to mm/vma.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-move-__vm_munmap-to-mm-vmac.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-move-__vm_munmap-to-mm-vmac.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: move __vm_munmap() to mm/vma.c
Date: Tue, 3 Dec 2024 18:05:12 +0000

This was arbitrarily left in mmap.c it makes no sense being there, move it
to vma.c to render it testable.

Link: https://lkml.kernel.org/r/5e5e81807c54dfbe363edb2d431eb3d7a37fcdba.1733248985.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c                        |   18 ------------------
 mm/vma.c                         |   18 ++++++++++++++++++
 mm/vma.h                         |    2 ++
 tools/testing/vma/vma_internal.h |    9 +++++++++
 4 files changed, 29 insertions(+), 18 deletions(-)

--- a/mm/mmap.c~mm-vma-move-__vm_munmap-to-mm-vmac
+++ a/mm/mmap.c
@@ -1044,24 +1044,6 @@ unsigned long mmap_region(struct file *f
 	return ret;
 }
 
-static int __vm_munmap(unsigned long start, size_t len, bool unlock)
-{
-	int ret;
-	struct mm_struct *mm = current->mm;
-	LIST_HEAD(uf);
-	VMA_ITERATOR(vmi, mm, start);
-
-	if (mmap_write_lock_killable(mm))
-		return -EINTR;
-
-	ret = do_vmi_munmap(&vmi, mm, start, len, &uf, unlock);
-	if (ret || !unlock)
-		mmap_write_unlock(mm);
-
-	userfaultfd_unmap_complete(mm, &uf);
-	return ret;
-}
-
 int vm_munmap(unsigned long start, size_t len)
 {
 	return __vm_munmap(start, len, false);
--- a/mm/vma.c~mm-vma-move-__vm_munmap-to-mm-vmac
+++ a/mm/vma.c
@@ -2874,3 +2874,21 @@ int expand_downwards(struct vm_area_stru
 	validate_mm(mm);
 	return error;
 }
+
+int __vm_munmap(unsigned long start, size_t len, bool unlock)
+{
+	int ret;
+	struct mm_struct *mm = current->mm;
+	LIST_HEAD(uf);
+	VMA_ITERATOR(vmi, mm, start);
+
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
+
+	ret = do_vmi_munmap(&vmi, mm, start, len, &uf, unlock);
+	if (ret || !unlock)
+		mmap_write_unlock(mm);
+
+	userfaultfd_unmap_complete(mm, &uf);
+	return ret;
+}
--- a/mm/vma.h~mm-vma-move-__vm_munmap-to-mm-vmac
+++ a/mm/vma.h
@@ -478,4 +478,6 @@ int expand_upwards(struct vm_area_struct
 
 int expand_downwards(struct vm_area_struct *vma, unsigned long address);
 
+int __vm_munmap(unsigned long start, size_t len, bool unlock);
+
 #endif	/* __MM_VMA_H */
--- a/tools/testing/vma/vma_internal.h~mm-vma-move-__vm_munmap-to-mm-vmac
+++ a/tools/testing/vma/vma_internal.h
@@ -906,6 +906,11 @@ static inline void mmap_write_unlock(str
 {
 }
 
+static inline int mmap_write_lock_killable(struct mm_struct *)
+{
+	return 0;
+}
+
 static inline bool can_modify_mm(struct mm_struct *mm,
 				 unsigned long start,
 				 unsigned long end)
@@ -1175,5 +1180,9 @@ static inline int anon_vma_prepare(struc
 	return __anon_vma_prepare(vma);
 }
 
+static inline void userfaultfd_unmap_complete(struct mm_struct *mm,
+					      struct list_head *uf)
+{
+}
 
 #endif	/* __MM_VMA_INTERNAL_H */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
mm-correct-typo-in-mmap_state-macro.patch
docs-mm-add-vma-locks-documentation.patch
mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch


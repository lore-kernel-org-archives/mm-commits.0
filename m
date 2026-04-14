Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73C3282F3D
	for <mm-commits@vger.kernel.org>; Tue, 14 Apr 2026 05:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776143715; cv=none; b=N3OnBw/WU3E4GoqCYARWMXONiDoj9vM5JivxvdrqWimNqO++XLsKsbVTI6bXJb6V1rznWk7EBvO0bHrKzsBSzXmgpz8CFI4tqWOWVjfPcsFPL9nDRoI01xSzqUzIbkXMSKmmKrTnM6S9gDUNE7PJMv3IX4l17FBR+Yml3/3Y21w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776143715; c=relaxed/simple;
	bh=73Kx7iutSC+PxVhCPTQvEtd8i6QnMMeB6AM4Ccr/9Xc=;
	h=Date:To:From:Subject:Message-Id; b=hSVjDAPS/60BBpP6gVEPUxCHJw3g1wbpoU6J2HreuqfEnSOlBIa5Z2ORDE5qs85DZsgupKfuqTLmfLt3dY+kmEgFl/1GV9vZhdezlBFozHSLKa3VNi5TlhRw0YN9im9mOA+4WWs9MFJluOWKOUgZU7yVuYEe2sqzd6VSNLC2brg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RRAvBj++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RRAvBj++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D66C2BCB3;
	Tue, 14 Apr 2026 05:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776143714;
	bh=73Kx7iutSC+PxVhCPTQvEtd8i6QnMMeB6AM4Ccr/9Xc=;
	h=Date:To:From:Subject:From;
	b=RRAvBj++R9KUJpE1T8sfGuhkic4VqUjlvAvNVswOoMyfcY/cYQgFhJAW/yT9HwW3N
	 Autmv7nx2l8wN6gh/kJKuZa//8KzvtaOD/1gJWxxU8mgR/vgaR9D/0+mtCKI0H3wz/
	 Bzk9ILJVV5UQrtn0rK8mXxXJJ6Nm+NU5b/RYpVJM=
Date: Mon, 13 Apr 2026 22:15:10 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,shinichiro.kawasaki@wdc.com,rppt@kernel.org,mhocko@suse.com,liam.howlett@oracle.com,jack@suse.cz,david@kernel.org,brauner@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-remove-__vma_check_mmap_hook.patch added to mm-unstable branch
Message-Id: <20260414051513.C4D66C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: remove __vma_check_mmap_hook()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-remove-__vma_check_mmap_hook.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-remove-__vma_check_mmap_hook.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/vma: remove __vma_check_mmap_hook()
Date: Mon, 13 Apr 2026 11:57:13 +0100

Commit c50ca15dd496 ("mm: add vm_ops->mapped hook") introduced
__vma_check_mmap_hook() in order to assert that a driver doesn't
incorrectly implement both an f_op->mmap() and a vm_ops->mapped hook, the
latter of which would not ultimately get invoked.

However, this did not correctly account for stacked drivers (or drivers
that otherwise use the compatibility layer) which might recursively call
an mmap_prepare hook via the compatibility layer.

Thus the nested mmap_prepare() invocation might result in a VMA which has
vm_ops->mapped set with an overlaying mmap() hook, causing the
__vma_check_mmap_hook() to fail in vfs_mmap(), wrongly failing the
operation.

This patch resolves this by simply removing the check, as we can't be
certain that an mmap() hook doesn't at some point invoke the compatibility
layer, and it's not worth trying to track it.

Link: https://lkml.kernel.org/r/20260413105713.92625-1-ljs@kernel.org
Fixes: c50ca15dd496 ("mm: add vm_ops->mapped hook")
Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Closes: https://lore.kernel.org/all/adx2ws5z0NMIe5Yj@shinmob/
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Tested-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    9 +--------
 mm/util.c          |   10 ----------
 2 files changed, 1 insertion(+), 18 deletions(-)

--- a/include/linux/fs.h~mm-vma-remove-__vma_check_mmap_hook
+++ a/include/linux/fs.h
@@ -2062,20 +2062,13 @@ void compat_set_desc_from_vma(struct vm_
 			      const struct vm_area_struct *vma);
 int __compat_vma_mmap(struct vm_area_desc *desc, struct vm_area_struct *vma);
 int compat_vma_mmap(struct file *file, struct vm_area_struct *vma);
-int __vma_check_mmap_hook(struct vm_area_struct *vma);
 
 static inline int vfs_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	int err;
-
 	if (file->f_op->mmap_prepare)
 		return compat_vma_mmap(file, vma);
 
-	err = file->f_op->mmap(file, vma);
-	if (err)
-		return err;
-
-	return __vma_check_mmap_hook(vma);
+	return file->f_op->mmap(file, vma);
 }
 
 static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
--- a/mm/util.c~mm-vma-remove-__vma_check_mmap_hook
+++ a/mm/util.c
@@ -1281,16 +1281,6 @@ int compat_vma_mmap(struct file *file, s
 }
 EXPORT_SYMBOL(compat_vma_mmap);
 
-int __vma_check_mmap_hook(struct vm_area_struct *vma)
-{
-	/* vm_ops->mapped is not valid if mmap() is specified. */
-	if (vma->vm_ops && WARN_ON_ONCE(vma->vm_ops->mapped))
-		return -EINVAL;
-
-	return 0;
-}
-EXPORT_SYMBOL(__vma_check_mmap_hook);
-
 static void set_ps_flags(struct page_snapshot *ps, const struct folio *folio,
 			 const struct page *page)
 {
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-remove-__vma_check_mmap_hook.patch
maintainers-update-mglru-entry-to-reflect-current-status.patch
tools-testing-selftests-add-merge-test-for-partial-msealed-range.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437FB16BE03
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725055874; cv=none; b=gXalaW3p62bysj2dg7Jxl8qq+WFUsuIdViplzyTCYncrMEE6lotPFggzDL3EF/o88Xaovhm+vA/X4Dsb7BETDBcAeDQOakS9FVeFoVgzm5AUfb1ALthSAvklmRP84VaiRmttjIzUNLLRvu3h6mmNOeDG1g5l7gUOo/kptTLMLbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725055874; c=relaxed/simple;
	bh=2MOkuEirGtRO4PyKrQrOTa7PXIh++w5X8WmuXBdjVzw=;
	h=Date:To:From:Subject:Message-Id; b=oYDdOpRbK3QqefI6qApS8wE0fpOlQA1H+Syzdaiu+RcpFSg0CjmXer7SMGLQGVTOHOQbXFU8qjAcSKY+2AzGOe+1VW5knxC8vw/ik4YVF+ryHIF9RAfaMoARsDA6a6U+CEVD/i+PjMu8kOvpaA0sdHDy1ZvANQCY7k6gK37GlQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NsT+ZWNK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NsT+ZWNK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1969C4CEC2;
	Fri, 30 Aug 2024 22:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725055873;
	bh=2MOkuEirGtRO4PyKrQrOTa7PXIh++w5X8WmuXBdjVzw=;
	h=Date:To:From:Subject:From;
	b=NsT+ZWNKkC7NpX9rkKUoRqDtrPggbE9kj0XUL108TQmkBl85qfD5ZshKpBa0J4UhD
	 wrHESRtyLGDFJ2q3r6Y4ZodiKe3/7s5rWVmtrfJcY5kIhOGJWChK9QU15p0/pdH5P7
	 7ioc0+/v8OxjlQgJvNas2B2ftjBIyrfFPzFOnltw=
Date: Fri, 30 Aug 2024 15:11:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-support-vma-==-null-in-init_vma_munmap.patch added to mm-unstable branch
Message-Id: <20240830221113.C1969C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: support vma == NULL in init_vma_munmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-support-vma-==-null-in-init_vma_munmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-support-vma-==-null-in-init_vma_munmap.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/vma: support vma == NULL in init_vma_munmap()
Date: Fri, 30 Aug 2024 00:00:50 -0400

Adding support for a NULL vma means the init_vma_munmap() can be
initialized for a less error-prone process when calling
vms_complete_munmap_vmas() later on.

Link: https://lkml.kernel.org/r/20240830040101.822209-11-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 mm/vma.h  |   11 ++++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/mm/mmap.c~mm-vma-support-vma-==-null-in-init_vma_munmap
+++ a/mm/mmap.c
@@ -1393,11 +1393,11 @@ unsigned long mmap_region(struct file *f
 
 	/* Find the first overlapping VMA */
 	vma = vma_find(&vmi, end);
+	init_vma_munmap(&vms, &vmi, vma, addr, end, uf, /* unlock = */ false);
 	if (vma) {
 		mt_init_flags(&mt_detach, vmi.mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
 		mt_on_stack(mt_detach);
 		mas_init(&mas_detach, &mt_detach, /* addr = */ 0);
-		init_vma_munmap(&vms, &vmi, vma, addr, end, uf, /* unlock = */ false);
 		/* Prepare to unmap any existing mapping in the area */
 		error = vms_gather_munmap_vmas(&vms, &mas_detach);
 		if (error)
--- a/mm/vma.h~mm-vma-support-vma-==-null-in-init_vma_munmap
+++ a/mm/vma.h
@@ -95,9 +95,14 @@ static inline void init_vma_munmap(struc
 {
 	vms->vmi = vmi;
 	vms->vma = vma;
-	vms->mm = vma->vm_mm;
-	vms->start = start;
-	vms->end = end;
+	if (vma) {
+		vms->mm = vma->vm_mm;
+		vms->start = start;
+		vms->end = end;
+	} else {
+		vms->mm = NULL;
+		vms->start = vms->end = 0;
+	}
 	vms->unlock = unlock;
 	vms->uf = uf;
 	vms->vma_count = 0;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-remove-rcu_read_lock-from-mt_validate.patch
mm-vma-correctly-position-vma_iterator-in-__split_vma.patch
mm-vma-introduce-abort_munmap_vmas.patch
mm-vma-introduce-vmi_complete_munmap_vmas.patch
mm-vma-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch
mm-vma-introduce-vma_munmap_struct-for-use-in-munmap-operations.patch
mm-vma-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas.patch
mm-vma-extract-validate_mm-from-vma_complete.patch
mm-vma-inline-munmap-operation-in-mmap_region.patch
mm-vma-expand-mmap_region-munmap-call.patch
mm-vma-support-vma-==-null-in-init_vma_munmap.patch
mm-mmap-reposition-vma-iterator-in-mmap_region.patch
mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct.patch
mm-clean-up-unmap_region-argument-list.patch
mm-mmap-avoid-zeroing-vma-tree-in-mmap_region.patch
mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure.patch
mm-mmap-use-phys_pfn-in-mmap_region.patch
mm-mmap-use-vms-accounted-pages-in-mmap_region.patch
ipc-shm-mm-drop-do_vma_munmap.patch
mm-move-may_expand_vm-check-in-mmap_region.patch
mm-vma-drop-incorrect-comment-from-vms_gather_munmap_vmas.patch
mm-vmah-optimise-vma_munmap_struct.patch


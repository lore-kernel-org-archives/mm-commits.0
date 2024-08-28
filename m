Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF004962E
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 09:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724837225; cv=none; b=sTN7VdI1D2uq1G4EOLxC0h5G+dRVlvGToA6pAVEekwflGczy9mcQkh7uJ2a/pbOGGr3Y0wFxtS8XDUzz1kj579s4LsffB8dTbC+9XF9KTmmelLHSbXWBPaGj6ICBpcaTmBY9LQlVW7DfZNL6jdevPnCkF14+giEuU+TX8OuIS5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724837225; c=relaxed/simple;
	bh=sREG4MXDsPMfyqIakRnkDBFKaINDsQpE5kK4UTa9xGc=;
	h=Date:To:From:Subject:Message-Id; b=R0ALLFL2BvvIqD5IMFmAo5IXhPYXAqPKQX9BeJ+UbGm4saV1PSsbZ0QrJ8r8wJ6XFKx55OsIE83x0h5gMDJqBfQQRWD0ar8ysYDWlwgekrBsPw7s5tbdwG6jD/n9iKQwEcH+upgibBjZV1r+DL1GpcvnLRpy33My9g3J0w6J0Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R4w5oMQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R4w5oMQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FF0C90DFB;
	Wed, 28 Aug 2024 09:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724837225;
	bh=sREG4MXDsPMfyqIakRnkDBFKaINDsQpE5kK4UTa9xGc=;
	h=Date:To:From:Subject:From;
	b=R4w5oMQxtYB1qbxunkfc+iVtliS+NEi9vdtOGQH30MQodNw41WfRzG5bGbK6+zUjM
	 6aFL9cN0MZpgFERZsUVoYOodOTfVdJCqzP2O3dSuprZPTBdk6EDeTnR+4gLX8qaAD6
	 I4zfS8W99Inq028wsvzB/dyEESW4YUT4Yz+/yU4M=
Date: Wed, 28 Aug 2024 02:27:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,Liam.Howlett@Oracle.com,kees@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-expand-mmap_region-munmap-call-fix.patch added to mm-unstable branch
Message-Id: <20240828092705.44FF0C90DFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fixup vma.h for nommu
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-expand-mmap_region-munmap-call-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-expand-mmap_region-munmap-call-fix.patch

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
Subject: mm: fixup vma.h for nommu
Date: Sun, 25 Aug 2024 12:29:47 +0100

Some series of includes result in vma.h being imported by nommu under
certain circumstances, which references FIRST_USER_ADDRESS and
USER_PGTABLES_CEILING, neither of which are necessarily defined in a nommu
scenario.

Work around this by wrapping the inline function which references these
(init_vma_munmap()) in an #ifdef CONFIG_MMU.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vma.h~mm-vma-expand-mmap_region-munmap-call-fix
+++ a/mm/vma.h
@@ -78,6 +78,7 @@ int vma_expand(struct vma_iterator *vmi,
 int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	       unsigned long start, unsigned long end, pgoff_t pgoff);
 
+#ifdef CONFIG_MMU
 /*
  * init_vma_munmap() - Initializer wrapper for vma_munmap_struct
  * @vms: The vma munmap struct
@@ -104,6 +105,7 @@ static inline void init_vma_munmap(struc
 	vms->nr_pages = vms->locked_vm = vms->nr_accounted = 0;
 	vms->exec_vm = vms->stack_vm = vms->data_vm = 0;
 }
+#endif
 
 int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 		struct ma_state *mas_detach);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch
userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc-fix.patch
mm-move-vma_modify-and-helpers-to-internal-header.patch
mm-move-vma_shrink-vma_expand-to-internal-header.patch
mm-move-internal-core-vma-manipulation-functions-to-own-file.patch
maintainers-add-entry-for-new-vma-files.patch
tools-separate-out-shared-radix-tree-components.patch
tools-add-skeleton-code-for-userland-testing-of-vma-logic.patch
mm-vma-expand-mmap_region-munmap-call-fix.patch
mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct-fix.patch
tools-improve-vma-test-makefile.patch
tools-add-vma-merge-tests.patch
mm-introduce-vma_merge_struct-and-abstract-vma_mergevma_modify.patch
mm-remove-duplicated-open-coded-vma-policy-check.patch
mm-abstract-vma_expand-to-use-vma_merge_struct.patch
mm-avoid-using-vma_merge-for-new-vmas.patch
mm-avoid-using-vma_merge-for-new-vmas-fix.patch
mm-make-vma_prepare-and-friends-static-and-internal-to-vmac.patch
mm-introduce-commit_merge-abstracting-final-commit-of-merge.patch
mm-refactor-vma_merge-into-modify-only-vma_merge_existing_range.patch
mm-rework-vm_ops-close-handling-on-vma-merge.patch


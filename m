Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E3A257D
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 06:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724480574; cv=none; b=cWTU9UuC0QjXPMoZ0hhy8t7vXsr+336123l/4yRIvqDtjvZnAhg4ZBWeMsJZ5mlz3a6t2GCq/smwh01KzqGYC84UUVWInc20fDNRYSFoP+9bNfR+UWwPnf2P9CsqpHaGG/17xb2PSuLt1vQyXnPK0VXHkCMuRAZYVgDuzH1dJYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724480574; c=relaxed/simple;
	bh=cHKwwEjwGd+u9QhQ1ebpM7f7p5hTDQGSw8BOm7kRMuM=;
	h=Date:To:From:Subject:Message-Id; b=IZd7DedL9rrZ8juKzHT6Oz4UHQDjA9JXBmn+3PH8j3iInaJ7uuDYy7IzzSzQ92JfbIdlC3I158eODBI6JxNoiMWlkzEWmfzD1P+LSjBH17h6psCVAZRFpex7r1QXO4wdfitV08F8ca4fN19m8z6u6hwzjJ+EreBRr3lRdnyBeEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ywkyoXlf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ywkyoXlf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA5CC32781;
	Sat, 24 Aug 2024 06:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724480573;
	bh=cHKwwEjwGd+u9QhQ1ebpM7f7p5hTDQGSw8BOm7kRMuM=;
	h=Date:To:From:Subject:From;
	b=ywkyoXlfbRywPNUEIksKCKK6c8v5a9I6mWNPxe6IfUC5ad5k1ZshXU8s4YUf+CHQe
	 Mk62cbYwqnbUgs1MqWNt8oSndtr5npY/FwqcJBBIEi35De2vecc/2wYWAqHoD0Fott
	 EC4ZBD8NjTW+DKEWwPDRLpxwQQxJP4gYTed4RVC0=
Date: Fri, 23 Aug 2024 23:22:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,kees@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-commit_merge-abstracting-final-commit-of-merge.patch added to mm-unstable branch
Message-Id: <20240824062253.BDA5CC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce commit_merge(), abstracting final commit of merge
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-commit_merge-abstracting-final-commit-of-merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-commit_merge-abstracting-final-commit-of-merge.patch

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
Subject: mm: introduce commit_merge(), abstracting final commit of merge
Date: Fri, 23 Aug 2024 21:07:03 +0100

Pull the part of vma_expand() which actually commits the merge operation,
that is inserts it into the maple tree and sets the VMA's vma->vm_start and
vma->vm_end parameters, into its own function.

We implement only the parts needed for vma_expand() which now as a result
of previous work is also the means by which new VMA ranges are merged.

The next commit in the series will implement merging of existing ranges
which will extend commit_merge() to accommodate this case and result in all
merges using this common code.

Link: https://lkml.kernel.org/r/1574f1e878da4dc2f23be611f318c4f5eb82ef01.1724441678.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

--- a/mm/vma.c~mm-introduce-commit_merge-abstracting-final-commit-of-merge
+++ a/mm/vma.c
@@ -540,6 +540,31 @@ void validate_mm(struct mm_struct *mm)
 }
 #endif /* CONFIG_DEBUG_VM_MAPLE_TREE */
 
+/* Actually perform the VMA merge operation. */
+static int commit_merge(struct vma_merge_struct *vmg,
+			struct vm_area_struct *remove)
+{
+	struct vma_prepare vp;
+
+	init_multi_vma_prep(&vp, vmg->vma, NULL, remove, NULL);
+
+	/* Note: vma iterator must be pointing to 'start'. */
+	vma_iter_config(vmg->vmi, vmg->start, vmg->end);
+
+	if (vma_iter_prealloc(vmg->vmi, vmg->vma))
+		return -ENOMEM;
+
+	vma_prepare(&vp);
+	vma_adjust_trans_huge(vmg->vma, vmg->start, vmg->end, 0);
+	vma_set_range(vmg->vma, vmg->start, vmg->end, vmg->pgoff);
+
+	vma_iter_store(vmg->vmi, vmg->vma);
+
+	vma_complete(&vp, vmg->vmi, vmg->vma->vm_mm);
+
+	return 0;
+}
+
 /*
  * vma_merge_new_range - Attempt to merge a new VMA into address space
  *
@@ -672,7 +697,6 @@ int vma_expand(struct vma_merge_struct *
 	bool remove_next = false;
 	struct vm_area_struct *vma = vmg->vma;
 	struct vm_area_struct *next = vmg->next;
-	struct vma_prepare vp;
 
 	mmap_assert_write_locked(vmg->mm);
 
@@ -687,24 +711,15 @@ int vma_expand(struct vma_merge_struct *
 			return ret;
 	}
 
-	init_multi_vma_prep(&vp, vma, NULL, remove_next ? next : NULL, NULL);
 	/* Not merging but overwriting any part of next is not handled. */
-	VM_WARN_ON(next && !vp.remove &&
+	VM_WARN_ON(next && !remove_next &&
 		  next != vma && vmg->end > next->vm_start);
 	/* Only handles expanding */
 	VM_WARN_ON(vma->vm_start < vmg->start || vma->vm_end > vmg->end);
 
-	/* Note: vma iterator must be pointing to 'start' */
-	vma_iter_config(vmg->vmi, vmg->start, vmg->end);
-	if (vma_iter_prealloc(vmg->vmi, vma))
+	if (commit_merge(vmg, remove_next ? next : NULL))
 		goto nomem;
 
-	vma_prepare(&vp);
-	vma_adjust_trans_huge(vma, vmg->start, vmg->end, 0);
-	vma_set_range(vma, vmg->start, vmg->end, vmg->pgoff);
-	vma_iter_store(vmg->vmi, vma);
-
-	vma_complete(&vp, vmg->vmi, vma->vm_mm);
 	return 0;
 
 nomem:
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
tools-improve-vma-test-makefile.patch
tools-add-vma-merge-tests.patch
mm-introduce-vma_merge_struct-and-abstract-vma_mergevma_modify.patch
mm-remove-duplicated-open-coded-vma-policy-check.patch
mm-abstract-vma_expand-to-use-vma_merge_struct.patch
mm-avoid-using-vma_merge-for-new-vmas.patch
mm-make-vma_prepare-and-friends-static-and-internal-to-vmac.patch
mm-introduce-commit_merge-abstracting-final-commit-of-merge.patch
mm-refactor-vma_merge-into-modify-only-vma_merge_existing_range.patch
mm-rework-vm_ops-close-handling-on-vma-merge.patch


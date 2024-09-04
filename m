Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692377DA8B
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423591; cv=none; b=mLKnqFeO0DD9DEGr/zNT94ywrRwFIvFJIrVBCnL1tS/UHu7WJF15jsZ1xLfywSKKCGptCTGLFbSbVm4xoIqGMYvq49/f+uce2tUt15kmdRuS7RcAfuls30i/DZ3YT+NEysjX6pacyMazLhQpUfBQFZA7mKwLtMmfixKcuVOOJr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423591; c=relaxed/simple;
	bh=8dpOmnWm52PsVfygn+sDUdOQZA3fMeysGEGcKnF+sXE=;
	h=Date:To:From:Subject:Message-Id; b=H6Pj22NtLWnXMq3RQPZ488l/BGNPCJFMwWURkMPAP9PnHS+my209iHS9penC7lDMFF7WJ7RykMpht8/+6AfBerhEK7KLep0ykdE41R71JHpJXYae6fOgKbTWv/kDXmVU0ByrE4mUYSL8rLXL+3ZyGykzq08/AqOXDr/BTa3C4NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1p3Avv3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1p3Avv3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3BFC4CEC2;
	Wed,  4 Sep 2024 04:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423589;
	bh=8dpOmnWm52PsVfygn+sDUdOQZA3fMeysGEGcKnF+sXE=;
	h=Date:To:From:Subject:From;
	b=1p3Avv3OVGELodtcnEQjqhqhC4s4Pyyv4+xc+Goxg3GRdS3aaPHb64JRgj3kBp84d
	 ENUYnoSXOIe6Sana2cNwWdziuL6My0iQPZo9j9VtwqrnVtjD9FPJHVaANTdmoCDWyH
	 TTWpgSaRgq+0ULyH2uByeQUJvoT7wry48DrsEkrw=
Date: Tue, 03 Sep 2024 21:19:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-commit_merge-abstracting-final-commit-of-merge.patch removed from -mm tree
Message-Id: <20240904041949.CF3BFC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce commit_merge(), abstracting final commit of merge
has been removed from the -mm tree.  Its filename was
     mm-introduce-commit_merge-abstracting-final-commit-of-merge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: introduce commit_merge(), abstracting final commit of merge
Date: Fri, 30 Aug 2024 19:10:20 +0100

Pull the part of vma_expand() which actually commits the merge operation,
that is inserts it into the maple tree and sets the VMA's vma->vm_start
and vma->vm_end parameters, into its own function.

We implement only the parts needed for vma_expand() which now as a result
of previous work is also the means by which new VMA ranges are merged.

The next commit in the series will implement merging of existing ranges
which will extend commit_merge() to accommodate this case and result in
all merges using this common code.

Link: https://lkml.kernel.org/r/7b985a20dfa549e3c370cd274d732b64c44f6dbd.1725040657.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

--- a/mm/vma.c~mm-introduce-commit_merge-abstracting-final-commit-of-merge
+++ a/mm/vma.c
@@ -585,6 +585,31 @@ void validate_mm(struct mm_struct *mm)
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
@@ -712,7 +737,6 @@ int vma_expand(struct vma_merge_struct *
 	bool remove_next = false;
 	struct vm_area_struct *vma = vmg->vma;
 	struct vm_area_struct *next = vmg->next;
-	struct vma_prepare vp;
 
 	mmap_assert_write_locked(vmg->mm);
 
@@ -727,24 +751,15 @@ int vma_expand(struct vma_merge_struct *
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB1F23D3E3
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837138; cv=none; b=HsqXCkl/jisaZ1kY43U67DxXoHTFpKKgdHvBRxFfEbEJkLJr+M2ZEpeDsnj0u4BADcTBQRvkm8Bzh27CgqGZMyVoMUvuLc2gr2Him63mLLWNWcZCeJumrRfCdgqPk8+tQL/kmJzfzuohxLzf2/fqbuzf9O/m2WjJ0bXHnkcPedo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837138; c=relaxed/simple;
	bh=7UutLicLKM+Lw20gqwruYZt6VmjonvIwVlHMxFShVvw=;
	h=Date:To:From:Subject:Message-Id; b=aukosC3Lcgf2MV7axCZSBAIgFF5xU5tY+O1E1eReTVOETyZD5eYv7hcbVg/IsqpgmO1JrwMuDl5huoOyXQ8wF/P80z0mapXeTKAlc4nAkvncWvAXb2btDSMA0IMBUUm2VabZk4noTnczTqPHGMqOKgiRYIMx9WaMcT2inshcDDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zogkjjfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zogkjjfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0201C4CEDD;
	Tue, 14 Jan 2025 06:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837137;
	bh=7UutLicLKM+Lw20gqwruYZt6VmjonvIwVlHMxFShVvw=;
	h=Date:To:From:Subject:From;
	b=zogkjjfGte7/WIYzvld7maypuFF/3Rg2Sc5yO1XfGRtew3TphjYovT7rKF6ZyFllD
	 PDkR7NF661B2Hw5NQYq97gMwecJX/LKCi1izFmklyhIWAtIkM3NWsVDFSp4lwBxkKT
	 ocNI7KZ8L+8IDgwRaoiLplUKLK8KtyiZPbKVJkFc=
Date: Mon, 13 Jan 2025 22:45:37 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug-prefer-vm_warn_on_vmg-to-report-vmg-debug-warnings.patch removed from -mm tree
Message-Id: <20250114064537.C0201C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/debug: prefer VM_WARN_ON_VMG() to report VMG debug warnings
has been removed from the -mm tree.  Its filename was
     mm-debug-prefer-vm_warn_on_vmg-to-report-vmg-debug-warnings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/debug: prefer VM_WARN_ON_VMG() to report VMG debug warnings
Date: Fri, 3 Jan 2025 19:35:36 +0000

Now we have VM_WARN_ON_VMG() to provide us with considerably more debug
output when a debug assert fails, utilise it everywhere we can.

This allows us to have considerably more information to go on when things
go wrong, especially when a non-repro issue occurs as reported by
syzkaller or the like.

Link: https://lkml.kernel.org/r/986e45e9549e71284ac7a7fa878688568a94d58b.1735932169.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/mm/vma.c~mm-debug-prefer-vm_warn_on_vmg-to-report-vmg-debug-warnings
+++ a/mm/vma.c
@@ -729,19 +729,20 @@ static __must_check struct vm_area_struc
 	bool expanded;
 
 	mmap_assert_write_locked(vmg->mm);
-	VM_WARN_ON(!vma); /* We are modifying a VMA, so caller must specify. */
-	VM_WARN_ON(vmg->next); /* We set this. */
-	VM_WARN_ON(prev && start <= prev->vm_start);
-	VM_WARN_ON(start >= end);
+	VM_WARN_ON_VMG(!vma, vmg); /* We are modifying a VMA, so caller must specify. */
+	VM_WARN_ON_VMG(vmg->next, vmg); /* We set this. */
+	VM_WARN_ON_VMG(prev && start <= prev->vm_start, vmg);
+	VM_WARN_ON_VMG(start >= end, vmg);
+
 	/*
 	 * If vma == prev, then we are offset into a VMA. Otherwise, if we are
 	 * not, we must span a portion of the VMA.
 	 */
-	VM_WARN_ON(vma && ((vma != prev && vmg->start != vma->vm_start) ||
-			   vmg->end > vma->vm_end));
+	VM_WARN_ON_VMG(vma && ((vma != prev && vmg->start != vma->vm_start) ||
+			       vmg->end > vma->vm_end), vmg);
 	/* The vmi must be positioned within vmg->vma. */
-	VM_WARN_ON(vma && !(vma_iter_addr(vmg->vmi) >= vma->vm_start &&
-			    vma_iter_addr(vmg->vmi) < vma->vm_end));
+	VM_WARN_ON_VMG(vma && !(vma_iter_addr(vmg->vmi) >= vma->vm_start &&
+				vma_iter_addr(vmg->vmi) < vma->vm_end), vmg);
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
@@ -858,9 +859,9 @@ static __must_check struct vm_area_struc
 
 		pgoff_t pglen = PHYS_PFN(vmg->end - vmg->start);
 
-		VM_WARN_ON(!merge_right);
+		VM_WARN_ON_VMG(!merge_right, vmg);
 		/* If we are offset into a VMA, then prev must be vma. */
-		VM_WARN_ON(vmg->start > vma->vm_start && prev && vma != prev);
+		VM_WARN_ON_VMG(vmg->start > vma->vm_start && prev && vma != prev, vmg);
 
 		if (merge_will_delete_vma) {
 			vmg->vma = next;
@@ -972,9 +973,9 @@ struct vm_area_struct *vma_merge_new_ran
 	bool just_expand = vmg->merge_flags & VMG_FLAG_JUST_EXPAND;
 
 	mmap_assert_write_locked(vmg->mm);
-	VM_WARN_ON(vmg->vma);
+	VM_WARN_ON_VMG(vmg->vma, vmg);
 	/* vmi must point at or before the gap. */
-	VM_WARN_ON(vma_iter_addr(vmg->vmi) > end);
+	VM_WARN_ON_VMG(vma_iter_addr(vmg->vmi) > end, vmg);
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
@@ -1056,7 +1057,7 @@ int vma_expand(struct vma_merge_struct *
 
 		remove_next = true;
 		/* This should already have been checked by this point. */
-		VM_WARN_ON(!can_merge_remove_vma(next));
+		VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
 		vma_start_write(next);
 		ret = dup_anon_vma(vma, next, &anon_dup);
 		if (ret)
@@ -1064,10 +1065,10 @@ int vma_expand(struct vma_merge_struct *
 	}
 
 	/* Not merging but overwriting any part of next is not handled. */
-	VM_WARN_ON(next && !remove_next &&
-		  next != vma && vmg->end > next->vm_start);
+	VM_WARN_ON_VMG(next && !remove_next &&
+		       next != vma && vmg->end > next->vm_start, vmg);
 	/* Only handles expanding */
-	VM_WARN_ON(vma->vm_start < vmg->start || vma->vm_end > vmg->end);
+	VM_WARN_ON_VMG(vma->vm_start < vmg->start || vma->vm_end > vmg->end, vmg);
 
 	if (commit_merge(vmg, NULL, remove_next ? next : NULL, NULL, 0, true))
 		goto nomem;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mips-vdso-prefer-do_mmap-to-mmap_region.patch
mm-make-mmap_region-internal.patch


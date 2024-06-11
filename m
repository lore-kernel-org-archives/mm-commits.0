Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA646F2F0
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 18:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718130431; cv=none; b=TEW3Wa38mHGwcYrdgK3YByi8dp2FmiBw+rhakpmYe1lUozqzVObetAlndIB9j/wLVm90eDEI1ns9SYVRor5bJfC4gkmyqTpnDxV2//Rwk14RbJuo/lsmfE28+1QHd7kDePipz88tRNCfIXg6IJk+CU7kiO5fnT+hiDLDaPRhfnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718130431; c=relaxed/simple;
	bh=vqeK722A0Aoh6LPOnd/fpmlDIR409n2gQ1Y1hJgrN/g=;
	h=Date:To:From:Subject:Message-Id; b=FiciKwP/o/njvWDkOxKjJLhI/95h1U29JWR2/1JDO/Xb8ZWMXOFSOZ9LSqvPc1jRcauuIaYhhe3cX1f/vFnUjp0ARRx4rq2AhWTGHC9oHDSic6SAdNtQNK/ahdzKujc5fanw5gQWR7vypQp8FE5CyoJmyW5obAmFVZ5qXteXBzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=InzcvlhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="InzcvlhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A14FC2BD10;
	Tue, 11 Jun 2024 18:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718130430;
	bh=vqeK722A0Aoh6LPOnd/fpmlDIR409n2gQ1Y1hJgrN/g=;
	h=Date:To:From:Subject:From;
	b=InzcvlhG+2RLGxgUkruTeWq0sT2TSN1I1hK/eN2zI0bNhnf4sAWrY/TGINm+1lNGs
	 AT6gw9/3PUroew2bcXp2jaJljgiJHD5CFqkaTu8xn19IyaP9+vlfOgSFgTZN+ktwMW
	 s5TELBQ0mEnTfpvsPpagOw6O3oJcqfAA01WVKZVY=
Date: Tue, 11 Jun 2024 11:27:09 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-extract-validate_mm-from-vma_complete.patch added to mm-unstable branch
Message-Id: <20240611182710.7A14FC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmap: extract validate_mm() from vma_complete()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-extract-validate_mm-from-vma_complete.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-extract-validate_mm-from-vma_complete.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mmap: extract validate_mm() from vma_complete()
Date: Tue, 11 Jun 2024 14:01:59 -0400

vma_complete() will need to be called during an unsafe time to call
validate_mm().  Extract the call in all places now so that only one
location can be modified in the next change.

Link: https://lkml.kernel.org/r/20240611180200.711239-8-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-extract-validate_mm-from-vma_complete
+++ a/mm/mmap.c
@@ -646,7 +646,6 @@ again:
 	}
 	if (vp->insert && vp->file)
 		uprobe_mmap(vp->insert);
-	validate_mm(mm);
 }
 
 /*
@@ -734,6 +733,7 @@ int vma_expand(struct vma_iterator *vmi,
 	vma_iter_store(vmi, vma);
 
 	vma_complete(&vp, vmi, vma->vm_mm);
+	validate_mm(vma->vm_mm);
 	return 0;
 
 nomem:
@@ -775,6 +775,7 @@ int vma_shrink(struct vma_iterator *vmi,
 	vma_iter_clear(vmi);
 	vma_set_range(vma, start, end, pgoff);
 	vma_complete(&vp, vmi, vma->vm_mm);
+	validate_mm(vma->vm_mm);
 	return 0;
 }
 
@@ -1103,6 +1104,7 @@ static struct vm_area_struct
 	}
 
 	vma_complete(&vp, vmi, mm);
+	validate_mm(mm);
 	khugepaged_enter_vma(res, vm_flags);
 	return res;
 
@@ -2481,6 +2483,7 @@ static int __split_vma(struct vma_iterat
 
 	/* vma_complete stores the new vma */
 	vma_complete(&vp, vmi, vma->vm_mm);
+	validate_mm(vma->vm_mm);
 
 	/* Success. */
 	if (new_below)
@@ -3349,6 +3352,7 @@ static int do_brk_flags(struct vma_itera
 		vma_iter_store(vmi, vma);
 
 		vma_complete(&vp, vmi, mm);
+		validate_mm(mm);
 		khugepaged_enter_vma(vma, flags);
 		goto out;
 	}
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mmap-correctly-position-vma_iterator-in-__split_vma.patch
mm-mmap-introduce-abort_munmap_vmas.patch
mm-mmap-introduce-vmi_complete_munmap_vmas.patch
mm-mmap-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch
mm-mmap-introduce-vma_munmap_struct-for-use-in-munmap-operations.patch
mm-mmap-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas.patch
mm-mmap-extract-validate_mm-from-vma_complete.patch
mm-mmap-use-split-munmap-calls-for-map_fixed.patch


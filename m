Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C564436A
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 23:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729900009; cv=none; b=NOiYtBJpxqYbAjAXn4di871eKIkmaeeboNd+4PpMUq+sgWiOnImV+nRDa5rSAG//Ddo2lTgVzKucQJweR4Je2CiHRPtIgznG7xkDtlE9z6erHBXk9bIW3EhxmHRlFYWbNr8m3Jc966K1QP61GME84uMgxx4RlRHfRl6dmWpN5MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729900009; c=relaxed/simple;
	bh=f65D9XAMGmq5JkJhSZkcI2zXHeJmipgAEGIEs80gJu0=;
	h=Date:To:From:Subject:Message-Id; b=fNT0p4VV4vWDnWdRfQuGyooqzfEyB/1H1UvvJ9T1AH8X6wq8FrnFyalKLyPj4xUMymuvAtjNSQ7+wMCGu7fEaz7hzivO0CFOU2v0e2PZ/l+8A+iuluBazbCu1DNd0L/xM0Wa7j/vLrfSE+Uraf0g9qeFfORZQTy4vqsChwjizmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rqH8seg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rqH8seg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBC9C4CEC3;
	Fri, 25 Oct 2024 23:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729900009;
	bh=f65D9XAMGmq5JkJhSZkcI2zXHeJmipgAEGIEs80gJu0=;
	h=Date:To:From:Subject:From;
	b=rqH8seg+SFjw8atTKtf3OGh4c1+gN2WUR3MmKjJyKFCveqp3oJMQkvhRNsqjBegi4
	 buX6boeGmE+ysKDCG1OYjeIBc/Dx9/LD7PHGe7QHr6oCgNKeoyl1jsrExIhS01hYB+
	 20luJYy944Az15IvaxGSK34tu/MZ8+rbxh606KRg=
Date: Fri, 25 Oct 2024 16:46:48 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-the-pgoff-is-correct-if-can_merge_right.patch added to mm-unstable branch
Message-Id: <20241025234649.0FBC9C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: the pgoff is correct if can_merge_right
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-the-pgoff-is-correct-if-can_merge_right.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-the-pgoff-is-correct-if-can_merge_right.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/vma: the pgoff is correct if can_merge_right
Date: Thu, 24 Oct 2024 09:33:47 +0000

By this point can_vma_merge_right() must have returned true, which implies
can_vma_merge_before() also returned true, which already asserts that the
pgoff is as expected for a merge with the following VMA, thus this
assignment is redundant.

Below is a more detail explanation.

Current definition of can_vma_merge_right() is:

	static bool can_vma_merge_right(struct vma_merge_struct *vmg,
					bool can_merge_left)
	{
		if (!vmg->next || vmg->end != vmg->next->vm_start ||
		    !can_vma_merge_before(vmg))
			return false;
		...
	}

And:

	static bool can_vma_merge_before(struct vma_merge_struct *vmg)
	{
		pgoff_t pglen = PHYS_PFN(vmg->end - vmg->start);
	...
			if (vmg->next->vm_pgoff == vmg->pgoff + pglen)
				return true;
	...
	}

Which implies vmg->pgoff == vmg->next->vm_pgoff - pglen.

None of these values are changed between the check and prior assignment,
so this was an entirely redundant assignment.

[lorenzo: rephrase the change log]

Link: https://lkml.kernel.org/r/20241024093347.18057-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/vma.c~mm-vma-the-pgoff-is-correct-if-can_merge_right
+++ a/mm/vma.c
@@ -964,7 +964,6 @@ struct vm_area_struct *vma_merge_new_ran
 	struct vm_area_struct *next = vmg->next;
 	unsigned long start = vmg->start;
 	unsigned long end = vmg->end;
-	pgoff_t pglen = PHYS_PFN(end - start);
 	bool can_merge_left, can_merge_right;
 	bool just_expand = vmg->merge_flags & VMG_FLAG_JUST_EXPAND;
 
@@ -986,7 +985,6 @@ struct vm_area_struct *vma_merge_new_ran
 	if (can_merge_right) {
 		vmg->end = next->vm_end;
 		vmg->vma = next;
-		vmg->pgoff = next->vm_pgoff - pglen;
 	}
 
 	/* If we can merge with the previous VMA, adjust vmg accordingly. */
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch
maple_tree-goto-complete-directly-on-a-pivot-of-0.patch
maple_tree-remove-maple_big_nodeparent.patch
maple_tree-memset-maple_big_node-as-a-whole.patch
maple_tree-root-node-could-be-handled-by-p_slot-too.patch
maple_tree-clear-request_count-for-new-allocated-one.patch
maple_tree-total-is-not-changed-for-nomem_one-case.patch
maple_tree-simplify-mas_push_node.patch
maple_tree-calculate-new_end-when-needed.patch
maple_tree-remove-sanity-check-from-mas_wr_slot_store.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right.patch


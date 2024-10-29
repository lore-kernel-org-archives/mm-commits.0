Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D68FC0B;
	Tue, 29 Oct 2024 04:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730175126; cv=none; b=H2ZDvChLw5kOJSlCj80qsFJfKqK9AahiWUWLLlt1VLcuvlEQckKcjQp+9gBp14Xo2rEb2tnkLeSUBiyNEaM+J7XBAMHau/MaOufHPc+hiEs4HBeuiK3HZP3i/95s+ruFtbXfDRboCCsZGQFIfWIT4bv744a2inDqdfQ0qcV2pSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730175126; c=relaxed/simple;
	bh=s+mXBe946lxmwtMv0OvtjqL32cTOo0ziylvevAJ+oyw=;
	h=Date:To:From:Subject:Message-Id; b=o6gZnM4tVkurbYEpi8lFfqiduke3d4JB1v3MJ9QSGsBOU6eAQuSVkxJ1XUj5JmvgVMfnNumA9XeSs5ZckhgdNQs2a29vs0xNRV+fwWnm4/W4HRek4dMrB4Q8n6Qx41bDYVpHXXMyPXa5FPUcRjTf4ZI0y9FHx4mUUjSS0jk/E8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YVGFYkNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YVGFYkNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DEAC4CECD;
	Tue, 29 Oct 2024 04:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730175125;
	bh=s+mXBe946lxmwtMv0OvtjqL32cTOo0ziylvevAJ+oyw=;
	h=Date:To:From:Subject:From;
	b=YVGFYkNCpNZLsEJ3abdwhRw3ReKPgB8JToMTo1jggey2nz057wP/9XgL7WTma+UEB
	 DWHasp7ubMJZzDq4s1i5rcZnuWi15f2wRAP1+nxjqHw6F5QoqCfSsWq9Ymx5gw8a8f
	 +CX0g8ii+3HZ//pevSdzIYzF9J+b+muS+0Duf5WU=
Date: Mon, 28 Oct 2024 21:12:05 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mlock-set-the-correct-prev-on-failure.patch added to mm-unstable branch
Message-Id: <20241029041205.A0DEAC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mlock: set the correct prev on failure
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mlock-set-the-correct-prev-on-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mlock-set-the-correct-prev-on-failure.patch

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
Subject: mm/mlock: set the correct prev on failure
Date: Sun, 27 Oct 2024 12:33:21 +0000

After commit 94d7d9233951 ("mm: abstract the vma_merge()/split_vma()
pattern for mprotect() et al."), if vma_modify_flags() return error, the
vma is set to an error code.  This will lead to an invalid prev be
returned.

Generally this shouldn't matter as the caller should treat an error as
indicating state is now invalidated, however unfortunately
apply_mlockall_flags() does not check for errors and assumes that
mlock_fixup() correctly maintains prev even if an error were to occur.

This patch fixes that assumption.

[lorenzo.stoakes@oracle.com: provide a better fix and rephrase the log]
Link: https://lkml.kernel.org/r/20241027123321.19511-1-richard.weiyang@gmail.com
Fixes: 94d7d9233951 ("mm: abstract the vma_merge()/split_vma() pattern for mprotect() et al.")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/mlock.c~mm-mlock-set-the-correct-prev-on-failure
+++ a/mm/mlock.c
@@ -725,14 +725,17 @@ static int apply_mlockall_flags(int flag
 	}
 
 	for_each_vma(vmi, vma) {
+		int error;
 		vm_flags_t newflags;
 
 		newflags = vma->vm_flags & ~VM_LOCKED_MASK;
 		newflags |= to_add;
 
-		/* Ignore errors */
-		mlock_fixup(&vmi, vma, &prev, vma->vm_start, vma->vm_end,
-			    newflags);
+		error = mlock_fixup(&vmi, vma, &prev, vma->vm_start, vma->vm_end,
+				    newflags);
+		/* Ignore errors, but prev needs fixing up. */
+		if (error)
+			prev = vma;
 		cond_resched();
 	}
 out:
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
mm-mlock-set-the-correct-prev-on-failure.patch


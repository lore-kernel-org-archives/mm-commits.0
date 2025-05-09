Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2DCD53C;
	Fri,  9 May 2025 00:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746752291; cv=none; b=pxItYxLKkCLovZeHhXhZbCtVI4jGgG4vcQQTlhey8nZd4/jqS+8LUZAge9orey7j7f4Rcc+W1zhy2G714IbI9s+M7ynnHl6fu+ELsrSXnU+qzZ6jD2mvOKFp7quyPXN9/2kVkRMUt7EiTQdEeY+9xh3mZtfD+oR8Hq/PS+mF4Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746752291; c=relaxed/simple;
	bh=6UHx54DMjMlf3Ohp8TL2ArLx6Txr0ynHe1wIwHx9GPs=;
	h=Date:To:From:Subject:Message-Id; b=D/4BpEnhKyYtQ6+cgcFgxbDCOWNP2AmacQ8KJmqIdA/CDt7w10M7p7TUGR3GEvVTLyxVy6IjnFgZ3+2QCIgr4TcoiBg9DVu+WvxbIXhCMqA/sWKhbc5R5sqAbsNt3nuYXbjMP7OhGL6nfBXMnLK6Rkd4QOKtapFiijDPfXy+nhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sv72gbes; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sv72gbes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359E1C4CEE7;
	Fri,  9 May 2025 00:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746752290;
	bh=6UHx54DMjMlf3Ohp8TL2ArLx6Txr0ynHe1wIwHx9GPs=;
	h=Date:To:From:Subject:From;
	b=sv72gbesztEMWIwaR/Bey0CXPGlEKh/azwyMtyjBowaJTt/t63p802LKyb6efZI0o
	 Eb7eHHGlciFFMdeoPRBsooJPfbI6RI7Y1gQh0a1MNjwxeFYpU23DT2Rvcq48vCcLT6
	 SC1offd6mBx9IP73uqYtBCOLTpT17cz9mX5169Z4=
Date: Thu, 08 May 2025 17:58:09 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,peterx@redhat.com,lokeshgidra@google.com,david@redhat.com,aarcange@redhat.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-correct-dirty-flags-set-for-both-present-and-swap-pte.patch added to mm-hotfixes-unstable branch
Message-Id: <20250509005810.359E1C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: userfaultfd: correct dirty flags set for both present and swap pte
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-userfaultfd-correct-dirty-flags-set-for-both-present-and-swap-pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-correct-dirty-flags-set-for-both-present-and-swap-pte.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: userfaultfd: correct dirty flags set for both present and swap pte
Date: Fri, 9 May 2025 10:09:12 +1200

As David pointed out, what truly matters for mremap and userfaultfd move
operations is the soft dirty bit.  The current comment and
implementation—which always sets the dirty bit for present PTEs and
fails to set the soft dirty bit for swap PTEs—are incorrect.  This could
break features like Checkpoint-Restore in Userspace (CRIU).

This patch updates the behavior to correctly set the soft dirty bit for
both present and swap PTEs in accordance with mremap.

Link: https://lkml.kernel.org/r/20250508220912.7275-1-21cnbao@gmail.com
Fixes: adef440691bab ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reported-by: David Hildenbrand <david@redhat.com>
Closes: https://lore.kernel.org/linux-mm/02f14ee1-923f-47e3-a994-4950afb9afcc@redhat.com/
Acked-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-correct-dirty-flags-set-for-both-present-and-swap-pte
+++ a/mm/userfaultfd.c
@@ -1064,8 +1064,13 @@ static int move_present_pte(struct mm_st
 	src_folio->index = linear_page_index(dst_vma, dst_addr);
 
 	orig_dst_pte = mk_pte(&src_folio->page, dst_vma->vm_page_prot);
-	/* Follow mremap() behavior and treat the entry dirty after the move */
-	orig_dst_pte = pte_mkwrite(pte_mkdirty(orig_dst_pte), dst_vma);
+	/* Set soft dirty bit so userspace can notice the pte was moved */
+#ifdef CONFIG_MEM_SOFT_DIRTY
+	orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
+#endif
+	if (pte_dirty(orig_src_pte))
+		orig_dst_pte = pte_mkdirty(orig_dst_pte);
+	orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
 
 	set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
 out:
@@ -1100,6 +1105,9 @@ static int move_swap_pte(struct mm_struc
 	}
 
 	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
+#ifdef CONFIG_MEM_SOFT_DIRTY
+	orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
+#endif
 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
 
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-userfaultfd-correct-dirty-flags-set-for-both-present-and-swap-pte.patch


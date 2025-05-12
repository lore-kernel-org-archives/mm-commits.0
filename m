Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C7417741;
	Mon, 12 May 2025 00:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747009815; cv=none; b=ZqGV5+RLBIVgnrh+KfCTax3yQhSaRNtY4sg82KrGeRwTKqW8oHtnAtLUV71cWObL9gtR7sArqTiyEmo+pUwku9IMjyk4nOq/D/3F/drkLkjFB5Y+jg85jlYKHDrej8J3FQX1egJn4dcTwZK6i5YFobdPX/eXc3K+0/ZC9i7iUpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747009815; c=relaxed/simple;
	bh=JHjdxSqWl/qn8ijPKEzvBVBy3M+QALcVxHezti25ZoY=;
	h=Date:To:From:Subject:Message-Id; b=dBjb428SmWuwWSmxdffzuZeG0F3rKvIRE1AH+RAMGBBnzR+iYFZ3vQZ/Qm1VtAuhz7q9ZhiQs5dHeBo6i8quSorOkWRRKNg8J31Cnhth4F3Ik7uBswr7uqjGFlyMvSxP06h5zsQsvzHKLqhvM3UtNLZhhxhRpLrXqX3sEHZhVZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vJ4Jmc2d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vJ4Jmc2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B480BC4CEE4;
	Mon, 12 May 2025 00:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747009813;
	bh=JHjdxSqWl/qn8ijPKEzvBVBy3M+QALcVxHezti25ZoY=;
	h=Date:To:From:Subject:From;
	b=vJ4Jmc2dc11ENm6njBcSkkdYJu/qM3fBMLsT2NG5/e4mVt+6K7EgqHroYdfCNvJFs
	 R23D6RIuGtTTJoVWGDgTql4eRaPh3K+EnW8L4NCOnsIn+c1KaUMKztiyd1009Ytv6Y
	 kzmpw2kv/7RpAOqF2oShIF3uLtnccd/dC4L3U2Sw=
Date: Sun, 11 May 2025 17:30:13 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,peterx@redhat.com,lokeshgidra@google.com,david@redhat.com,aarcange@redhat.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-userfaultfd-correct-dirty-flags-set-for-both-present-and-swap-pte.patch removed from -mm tree
Message-Id: <20250512003013.B480BC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: userfaultfd: correct dirty flags set for both present and swap pte
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-correct-dirty-flags-set-for-both-present-and-swap-pte.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814053C00
	for <mm-commits@vger.kernel.org>; Wed, 12 Feb 2025 00:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739319235; cv=none; b=ex4yd2gluofr5G3fPOgKts6J+HGrzStgrq+cugoAzEAcQrXDdycJoOVRPKxJsS9D8Mtb+4KQi78br1mVM6M59KrO9g83m9acDgyLlt7gK00kYbxr0PFQRqMfI54oCCHL+PuKHXsciS3do0ww9MHyoyBtb5MQyvojBRqP2Fjp6YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739319235; c=relaxed/simple;
	bh=5GeOR8EW26w2wjbUP46Je+aO+qcgbnv4O4ujwZFeJY0=;
	h=Date:To:From:Subject:Message-Id; b=j+u0t99qRwOLSfcRnsQozzSqnzZ3fXcsK+86Coq6hdM3oVaNotZ3Qx1ppIJLk109N4jB4CJBvU7kIOGV/BADZmjTb3r7YfpFA36+WzVxQidea8SaWZAEZWbnnScmaWMnXXarpeKCIgTvC20/xRsh0VdtJtOoPBr77NbhbHQf9ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fqsX6W27; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fqsX6W27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AF0C4CEDD;
	Wed, 12 Feb 2025 00:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739319234;
	bh=5GeOR8EW26w2wjbUP46Je+aO+qcgbnv4O4ujwZFeJY0=;
	h=Date:To:From:Subject:From;
	b=fqsX6W27yUINrFmeS0JUyt4eqcrco3g3CgpIj0KBVXBVn75q0isvB9xS2M/foWcEC
	 l4Vk8Qy2siGUbvb1fjWb270qR9rf/pXt/4gHCc5yEx8r+d6rVSaFhfXejjTxw7JEV4
	 93I962hr4j0MSgGGZcHoTpivhOEe1a+ctVHAQGfo=
Date: Tue, 11 Feb 2025 16:13:53 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,will@kernel.org,peterz@infradead.org,npiggin@gmail.com,aneesh.kumar@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmu_gather-remove-unused-__tlb_remove_page.patch added to mm-unstable branch
Message-Id: <20250212001354.D6AF0C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmu_gather: remove unused __tlb_remove_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmu_gather-remove-unused-__tlb_remove_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmu_gather-remove-unused-__tlb_remove_page.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/mmu_gather: remove unused __tlb_remove_page()
Date: Tue, 11 Feb 2025 18:13:39 +0800

Nobody is using __tlb_remove_page() now, clean it up.

And also remove the code comment above tlb_remove_page() because it's not
meaningful any more.

Link: https://lkml.kernel.org/r/Z6si0/A/zzEF/bFJ@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |   10 ----------
 1 file changed, 10 deletions(-)

--- a/include/asm-generic/tlb.h~mm-mmu_gather-remove-unused-__tlb_remove_page
+++ a/include/asm-generic/tlb.h
@@ -502,16 +502,6 @@ static inline void tlb_remove_page_size(
 		tlb_flush_mmu(tlb);
 }
 
-static __always_inline bool __tlb_remove_page(struct mmu_gather *tlb,
-		struct page *page, bool delay_rmap)
-{
-	return __tlb_remove_page_size(tlb, page, delay_rmap, PAGE_SIZE);
-}
-
-/* tlb_remove_page
- *	Similar to __tlb_remove_page but will call tlb_flush_mmu() itself when
- *	required.
- */
 static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
 	return tlb_remove_page_size(tlb, page, PAGE_SIZE);
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-swap_statec-fix-the-obsolete-code-comment.patch
mm-swap_statec-optimize-the-code-in-clear_shadow_from_swap_cache.patch
mm-swap-remove-swap_flag_prio_shift.patch
mm-swap-skip-scanning-cluster-range-if-its-empty-cluster.patch
mm-swap-rename-swap_is_has_cache-to-swap_only_has_cache.patch
mm-swapfilec-update-the-code-comment-above-swap_count_continued.patch
mm-swapfilec-update-the-code-comment-above-swap_count_continued-v2.patch
mm-swapfilec-optimize-code-in-setup_clusters.patch
mm-swap_statec-remove-the-meaningless-code-comment.patch
mm-swapfilec-remove-the-unneeded-checking.patch
mm-swap-rename-swap_swapcount-to-swap_entry_swapped.patch
mm-swapfilec-remove-the-incorrect-code-comment.patch
mm-swapfilec-open-code-cluster_alloc_swap.patch
mm-mmu_gather-remove-unused-__tlb_remove_page.patch
mm-mmu_gather-clean-up-the-stale-code-comment.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B573BCD29
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896602; cv=none; b=F+3CYbcK6ua8umrK1RGe05dl4OrK9DAdeKiVJFpUa58bunicgycjzm49lYGBqEMwXDprdXjA0y5aLGDODabX8jc2P2Ajtix8ScgJJhw/2YpBdZM8e6vUMYRhv0x8dlCiVhuMMSERc4WrZqBAlXmNF6+g2ynJSGSrtmfyFj9BmHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896602; c=relaxed/simple;
	bh=DzPtMnLrpD5jlaVyYQcWGXF3GOl07NkMQ+yOPYjawWg=;
	h=Date:To:From:Subject:Message-Id; b=kfztbj5jUM8k8Nqu1aRcbhADzntgUtErdUr3oZxtRzrmGgx1FLZmNnxVoml/xYsX617G4dPMVqzaVcZC4pNzeejoXdOEXyC5ehlJnpR0Zh1BdmOpIU5wszYNbYSaDXtQv3++xeXqz/JzqHuou07SlWojCHOcPavZou+P6lFB7fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ILmz/nGU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ILmz/nGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05691F000E9;
	Wed,  5 Aug 2026 02:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896601;
	bh=YekCzmHSg3w4qj0gshhXQ5pgWPZ39XM/YMg4SDtEwF4=;
	h=Date:To:From:Subject;
	b=ILmz/nGUowqoovxw1WsRPRZrHP50cq9W1/rt03QXeNj8RqqLdtKchnccVjXP9svXf
	 KNjzxkShIpiKYMSi06ydPDC5q7UlIsK9Hf3nNj9ytscxAtn+DJ9oDpSdqHBgXamWr6
	 h54z9HHvpt0Gr59C1bonSxTahU9Cvq8U3A+gJ0aU=
Date: Tue, 04 Aug 2026 19:23:20 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rppt@kernel.org,nphamcs@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic.patch removed from -mm tree
Message-Id: <20260805022320.D05691F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: drop stale folio_ref_count()==1 check in do_swap_page reuse logic
has been removed from the -mm tree.  Its filename was
     mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm: drop stale folio_ref_count()==1 check in do_swap_page reuse logic
Date: Thu, 2 Jul 2026 07:59:53 +0800

The "we just allocated them without exposing them to the swapcache" case
no longer exists, as Kairui has routed synchronous I/O through the
swapcache as well in his series "unify swapin use swap cache and cleanup
flags"[1].  As a result, folio_ref_count() should never be 1 in this path,
since at least two references are held (base ref plus swapcache).  Remove
the folio_ref_count()==1 check and update the comment accordingly.

The ksm_might_need_to_copy() check may allocate a fresh folio with
folio_ref_count() == 1.  Along that path, exclusive has already been
set to true, so the folio can still be reused correctly.

[akpm@linux-foundation.org: update comment, per David]
  Link: https://lore.kernel.org/3a185a5d-2f2c-4e9d-9cd9-8bdb236dfc5c@kernel.org
Link: https://lore.kernel.org/20260701235955.36126-3-baohua@kernel.org
Link: https://lore.kernel.org/all/20251220-swap-table-p2-v5-0-8862a265a033@tencent.com/ [1]
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic
+++ a/mm/memory.c
@@ -5039,13 +5039,10 @@ check_folio:
 		pte = pte_mkuffd_wp(pte);
 
 	/*
-	 * Same logic as in do_wp_page(); however, optimize for pages that are
-	 * certainly not shared either because we just allocated them without
-	 * exposing them to the swapcache or because the swap entry indicates
-	 * exclusivity.
+	 * Similar logic as in do_wp_page(); however, optimize for pages that
+	 * are certainly exclusive.
 	 */
-	if (!folio_test_ksm(folio) &&
-	    (exclusive || folio_ref_count(folio) == 1)) {
+	if (exclusive) {
 		if ((vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
 		    !pte_needs_soft_dirty_wp(vma, pte)) {
 			pte = pte_mkwrite(pte, vma);
_

Patches currently in -mm which might be from baohua@kernel.org are

arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch
arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch


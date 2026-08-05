Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A65326AC5
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 01:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785892295; cv=none; b=bc0ui1o6JxsAcKVHURk4OydHth+sIkSJI8iY15YJ3pbTPb/WE9r6vkZNiQOd9+VPDERIx2Iy/YKR00xJI1X6flmQXDR14UEh/Mr2VehtevYJxVG0bRyjLv895UVfYn6bwWdpSRwT/hjuAgGJ05L1ntokO6hI65gJUwATmFEOp2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785892295; c=relaxed/simple;
	bh=zY4ugKyYhcMo0hHWARj3uRVqxdd2ztzmVkJI+2PTA3c=;
	h=Date:To:From:Subject:Message-Id; b=RRSiMuMj/R0xc2cEdekCNDEvgqxxjFTfRsRHSeez5LV3GQNtsYTuP+snnKHqmgQtSBEq5zVTRSwq7meMv8r/mdMbsINBZ8l/imoi0VXGCJ4084UCSTGXiFNBwHLBOjk72EXux13mp1pRA/wlAUSNTyjYjmHNbth2I6H512efNrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ciOoRD53; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ciOoRD53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36451F000E9;
	Wed,  5 Aug 2026 01:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785892293;
	bh=EdkSPtYtXtPCtY8wm4zlamDxnOmL3l1KwJOdWIZosgs=;
	h=Date:To:From:Subject;
	b=ciOoRD53Z8q5irJmutPEc8LMJwlAUAXHFjxBPAZf5yjeHlQqxQ6uuaKcECkz4Qr+V
	 8V0wmAe44c4VynTsQziDEGo4LwE5k6+oe6ZUlmvIVofm0xDHBHk+PNwue13Cx3miIM
	 ZY5mD0+b+WI8ZNKRbG6O4eKU9SykudpBOIz2CRvQ=
Date: Tue, 04 Aug 2026 18:11:33 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rppt@kernel.org,nphamcs@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch removed from -mm tree
Message-Id: <20260805011133.C36451F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix
has been removed from the -mm tree.  Its filename was
     mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch

This patch was dropped because it was folded into mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix
Date: Mon Jul  6 04:13:37 PM PDT 2026

update comment, per David

Link: https://lore.kernel.org/3a185a5d-2f2c-4e9d-9cd9-8bdb236dfc5c@kernel.org
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
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

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix
+++ a/mm/memory.c
@@ -5039,8 +5039,8 @@ check_folio:
 		pte = pte_mkuffd_wp(pte);
 
 	/*
-	 * Similar logic as in do_wp_page(); however, optimize for pages that are
-	 * certainly not because the swap entry indicates exclusivity.
+	 * Similar logic as in do_wp_page(); however, optimize for pages that
+	 * are certainly exclusive.
 	 */
 	if (exclusive) {
 		if ((vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic.patch
mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier.patch
mm-vma-add-and-use-vma__pgoff-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


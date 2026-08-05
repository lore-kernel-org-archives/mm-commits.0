Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B02B3BBFCE
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896607; cv=none; b=UEPuhB1CXtdivr/S7GOqTwE8UI9FywlF7NyV1XyL+OjOJldMb8TLBlillYVMML+C+/Gq4fchUUZInaQXysKXIsQC6ypsifBR6P9KYirWwAHF7Xcsl6lfIu+8Oy+biPsPlJcNpImT5VuLMjc7F6R1ZxFc4o3Kuh7L65FBVx156Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896607; c=relaxed/simple;
	bh=YeQpzGUjcDYSil7MUK7L9eoEQhBvECQpiaUZZFPMf3k=;
	h=Date:To:From:Subject:Message-Id; b=UvIXcpBamGsjNZyYM/y4GLdUjRjoWG2PDasOzRbSiT896ckSZDdkilFVfbSDe0VCj1lDL39z8Vyu+vlVMqQEOOtb738BcgCmIAa2PUV+oZ800KtD+BLoeWUB4QwrONSnS3ZrmFnkXAsUvRfQz0mPSXgELxnNf9b5+mfTtBG1OPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BIIU2RPx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BIIU2RPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E4D1F00A3A;
	Wed,  5 Aug 2026 02:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896605;
	bh=mkMNT7+Y4Od+ACVfUpReZ9AvV/z3J1qSA+MwlGvgP0c=;
	h=Date:To:From:Subject;
	b=BIIU2RPxrA7FAVedeB1abNgRGyTbKsnNppKKIM8I20FvYlNEFG1cr2gJ8vREMGRsu
	 NavC9xRIuNpsmNJHlxgGO674ltyAuzqQ9NzvMNlhrsufIeuhqKn4z9iaB2sG2Npq8z
	 QCTEzJ2xUoXNzziaqKFJNNWigCWY1rwRO6+a2XPI=
Date: Tue, 04 Aug 2026 19:23:25 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rppt@kernel.org,nphamcs@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-clarify-the-folio_free_swap-for-do_swap_page.patch removed from -mm tree
Message-Id: <20260805022325.B0E4D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: clarify the folio_free_swap() for do_swap_page()
has been removed from the -mm tree.  Its filename was
     mm-clarify-the-folio_free_swap-for-do_swap_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm: clarify the folio_free_swap() for do_swap_page()
Date: Thu, 2 Jul 2026 07:59:55 +0800

Since commit 4b34f1d82c654 ("mm, swap: free the swap cache after folio is
mapped"), we have relied on do_wp_page() to handle the non-exclusive case,
where the folio may either be reused or require CoW.

As a result, using the refcount in do_swap_page() to decide when to free
the swap cache is no longer necessary, since do_wp_page() can handle this
more cleanly and consistently.

We can now simply use FAULT_FLAG_WRITE together with exclusivity to decide
when to free the swap cache in do_swap_page().

Link: https://lore.kernel.org/20260701235955.36126-5-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/mm/memory.c~mm-clarify-the-folio_free_swap-for-do_swap_page
+++ a/mm/memory.c
@@ -4509,7 +4509,7 @@ static vm_fault_t remove_device_exclusiv
 static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 					   struct folio *folio,
 					   struct vm_area_struct *vma,
-					   unsigned int extra_refs,
+					   bool exclusive,
 					   unsigned int fault_flags)
 {
 	if (!folio_test_swapcache(folio))
@@ -4525,14 +4525,12 @@ static inline bool should_try_to_free_sw
 	if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
 	    folio_test_mlocked(folio))
 		return true;
+
 	/*
-	 * If we want to map a page that's in the swapcache writable, we
-	 * have to detect via the refcount if we're really the exclusive
-	 * user. Try freeing the swapcache to get rid of the swapcache
-	 * reference only in case it's likely that we'll be the exclusive user.
+	 * Free the swapcache only if we are the exclusive user and
+	 * this is a write fault.
 	 */
-	return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio) &&
-		folio_ref_count(folio) == (extra_refs + folio_nr_pages(folio));
+	return (fault_flags & FAULT_FLAG_WRITE) && exclusive;
 }
 
 static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
@@ -5036,10 +5034,8 @@ check_folio:
 		if ((vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
 		    !pte_needs_soft_dirty_wp(vma, pte)) {
 			pte = pte_mkwrite(pte, vma);
-			if (vmf->flags & FAULT_FLAG_WRITE) {
+			if (vmf->flags & FAULT_FLAG_WRITE)
 				pte = pte_mkdirty(pte);
-				vmf->flags &= ~FAULT_FLAG_WRITE;
-			}
 		}
 		rmap_flags |= RMAP_EXCLUSIVE;
 	}
@@ -5079,7 +5075,7 @@ check_folio:
 	 * Do it after mapping, so raced page faults will likely see the folio
 	 * in swap cache and wait on the folio lock.
 	 */
-	if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags))
+	if (should_try_to_free_swap(si, folio, vma, exclusive, vmf->flags))
 		folio_free_swap(folio);
 
 	folio_unlock(folio);
@@ -5096,7 +5092,7 @@ check_folio:
 		folio_put(swapcache);
 	}
 
-	if (vmf->flags & FAULT_FLAG_WRITE) {
+	if ((vmf->flags & FAULT_FLAG_WRITE) && !pte_write(pte)) {
 		ret |= do_wp_page(vmf);
 		if (ret & VM_FAULT_ERROR)
 			ret &= VM_FAULT_ERROR;
_

Patches currently in -mm which might be from baohua@kernel.org are

arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch
arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch


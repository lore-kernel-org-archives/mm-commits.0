Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832476;
	b=1FIa/dY7+QKVfX3VFCvjkpid0cABGRwid1Vfy17OpUZb1NQa7dx4slYFZtlTLR7sDDlh
	 RfD6Cyfhsqt5kGycBW9JsKVgTY2KoGGzHjj+8GKdnI4Wm8LVC0+g34LDc8f3uaWBJMaOM
	 npJW2XCOSZ5YSKZGxbD6dOSKRpmqlwp3CBw4oQbkYgCZPGfvlzBcz/nOjGfXk6siEHir3
	 Eu9EYHzar0lFBRkHNztFqisZch83rV8ZaIjnXmcNqIWqUZvqFfqfU2sxg0FPaHpfY8M+M
	 uXWqnyMSZ6DGSccpcA90KdgyhLgX1UioDodTM72fh1BZmqOON+iosIFX8cm7OpRhdWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832476;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ACXwuWR/zeV4c4E/6MIaCnBpzQn8iM5l1n0j+7DsSlM=;
	b=nOe9Rc4xCdcKJFFi8PzBTNgcYRibZiz/6rTkFj3CcELStTWU95a3+4oRChe6KMFtLjt+
	 3rxIw4v0jY/k3oblBy+2tyotpM11NllQDTu7FMY7c4lQdd+Hf+sCh7us06yw5KAOewavC
	 SK9M041DbtqV/KUfWPqKDDJAYE+brceM7MpzzrGgduFdEoLT3Bgi7LiNeCGozCE0HMS8y
	 HQD/gooR8ftVshxEzGkORaYNfu7xZuS+fzvXJEy5T52IAgD6xlHuYZl3zbz8cd9c5p9/m
	 7FH9p92C3FoR9rzviH9qKCCrzs9k7Ok+3GtkYUk3p0frdE5zlx50m4ngCXi2aPzXkVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=a9ASz6de;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDF9606A31E;
	Sat, 24 Oct 2026 09:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=a9ASz6de
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190C81F01825;
	Sat, 24 Oct 2026 09:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832476;
	bh=ACXwuWR/zeV4c4E/6MIaCnBpzQn8iM5l1n0j+7DsSlM=;
	h=Date:To:From:Subject;
	b=a9ASz6deywtUr0l0y2Bp1eHk3KMru3q5jor1yQCXRpxaTgTLPlFkPcvhV8Z7gbuUh
	 iGEXihxJs9vxn6KZ3F2IB4MN0N7LYKR3YxqxuFHvcIB0ooEJlKqlWaWhjJTINEmoLz
	 UViy5PujRZyMTPIB6B1qYc/2JW7HMQ9aElwU4lVg=
Date: Sat, 24 Oct 2026 02:01:15 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,lokeshgidra@google.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,kylebot@openai.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-userfaultfd-only-allocate-anon_vma-in-cow-mappings.patch removed from -mm tree
Message-Id: <20261024090116.190C81F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/userfaultfd: only allocate anon_vma in CoW mappings
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-only-allocate-anon_vma-in-cow-mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/userfaultfd: only allocate anon_vma in CoW mappings
Date: Wed, 14 Oct 2026 13:53:11 +0200

find_vma_and_prepare_anon() can end up allocating an anon_vma in VMAs that
are not CoW mappings, which is wrong.

If we have a MAP_SHARED R/O file mapped, we lack VM_SHARED (but do have
VM_MAYSHARE) and lack VM_MAYWRITE.

While uffd later rejects such mappings (uffd registration requires
VM_MAYWRITE, see comment in validate_dst_vma) find_vma_and_prepare_anon()
still wrongly allocates an anon vma before it validates the vma.

This in turn later confuses copy_page_range()->vma_needs_copy() such
that we end up calling copy_hugetlb_page_range() with ranges that
actually do not contain *any* per-pagetable information that would
require copying, which is the basis for PMD-table sharing in the first
place.

copy_hugetlb_page_range() should not have to worry about shared
PMD tables at all: it doesn't make any sense to copy page tables that are
shared, as they can be fully recreated later. Ending up in the function
with shareable page tables is the real issue.

If a destination PMD table is shared in copy_hugetlb_page_range(), it
might get concurrently unshared as we are not holding relevant
locks, resulting in us using a page table that is no longer mapped and
possibly freed after calling:

	dst_pte = huge_pte_alloc(dst, dst_vma, addr, sz);

To fix it, do not allocate an anon_vma in non-CoW mappings and add a
safety guard to copy_hugetlb_page_range(), making sure that we never
end up messing with shared PMD tables in there.

Before commit 867a43a34ff8a ("userfaultfd: use per-vma locks in userfaultfd
operations") we would always validate the VMA before allocating an
anon_vma, and consequently never wrongly allocate an anon_vma.

As uffd_lock_vma() is part of the same lookup machinery and
also contains a misleading VM_SHARED check, change that one as well
directly for consistency.

A follow-up cleanup will stop taking the hugetlb_vma_lock_read(src_vma)
lock in copy_hugetlb_page_range() entirely. Further, the usage of
VM_SHARED in userfaultfd code should be cleaned up later to focus on
CoW vs. non-CoW mappings.

Link: https://lore.kernel.org/20261014-copy_hugetlb_page_range-v1-1-5b68e03fe7fe@kernel.org
Fixes: 867a43a34ff8 ("userfaultfd: use per-vma locks in userfaultfd operations")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Kyle Zeng <kylebot@openai.com>
Tested-by: Kyle Zeng <kylebot@openai.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb.c     |   24 ++++++++++++------------
 mm/userfaultfd.c |    5 ++---
 2 files changed, 14 insertions(+), 15 deletions(-)

--- a/mm/hugetlb.c~mm-userfaultfd-only-allocate-anon_vma-in-cow-mappings
+++ a/mm/hugetlb.c
@@ -4973,10 +4973,11 @@ int copy_hugetlb_page_range(struct mm_st
 		raw_write_seqcount_begin(&src->write_protect_seq);
 	} else {
 		/*
-		 * For shared mappings the vma lock must be held before
-		 * calling hugetlb_walk() in the src vma. Otherwise, the
-		 * returned ptep could go away if part of a shared pmd and
-		 * another thread calls huge_pmd_unshare.
+		 * Shared mappings only need copying when we could have
+		 * information stored in page tables (e.g., userfaultfd PTE
+		 * bits or markers), which is incompatible with PMD sharing.
+		 * Still take the hugetlb VMA lock for now to satisfy
+		 * hugetlb_walk()'s locking requirements.
 		 */
 		hugetlb_vma_lock_read(src_vma);
 	}
@@ -4984,6 +4985,13 @@ int copy_hugetlb_page_range(struct mm_st
 	last_addr_mask = hugetlb_mask_last_page(h);
 	for (addr = src_vma->vm_start; addr < src_vma->vm_end; addr += sz) {
 		spinlock_t *src_ptl, *dst_ptl;
+
+		if (WARN_ON_ONCE(want_pmd_share(src_vma, addr) ||
+				 want_pmd_share(dst_vma, addr))) {
+			ret = -EINVAL;
+			break;
+		}
+
 		src_pte = hugetlb_walk(src_vma, addr, sz);
 		if (!src_pte) {
 			addr |= last_addr_mask;
@@ -4995,14 +5003,6 @@ int copy_hugetlb_page_range(struct mm_st
 			break;
 		}
 
-#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
-		/* If the pagetables are shared, there is nothing to do */
-		if (ptdesc_pmd_is_shared(virt_to_ptdesc(dst_pte))) {
-			addr |= last_addr_mask;
-			continue;
-		}
-#endif
-
 		dst_ptl = huge_pte_lock(h, dst, dst_pte);
 		src_ptl = huge_pte_lockptr(h, src, src_pte);
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
--- a/mm/userfaultfd.c~mm-userfaultfd-only-allocate-anon_vma-in-cow-mappings
+++ a/mm/userfaultfd.c
@@ -115,8 +115,7 @@ struct vm_area_struct *find_vma_and_prep
 	vma = vma_lookup(mm, addr);
 	if (!vma)
 		vma = ERR_PTR(-ENOENT);
-	else if (!(vma->vm_flags & VM_SHARED) &&
-		 unlikely(anon_vma_prepare(vma)))
+	else if (vma_is_cow_mapping(vma) && unlikely(anon_vma_prepare(vma)))
 		vma = ERR_PTR(-ENOMEM);
 
 	return vma;
@@ -145,7 +144,7 @@ static struct vm_area_struct *uffd_lock_
 		 * We know we're going to need an anon rmap, so check that
 		 * early.
 		 */
-		if (!(vma->vm_flags & VM_SHARED) && unlikely(!vma_has_anon_rmap(vma)))
+		if (vma_is_cow_mapping(vma) && unlikely(!vma_has_anon_rmap(vma)))
 			vma_end_read(vma);
 		else
 			return vma;
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch


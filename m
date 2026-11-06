Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794004959;
	b=rlkfNPDU3mUJA54E5zTpeFBEBvq4GP1rDbIedwpgNEo2ze/9hrihLq8aJddkJxK9A+cg
	 B5i3T3wasAUPXYsghwgByOSai4Yv5QF95eqUorUF4nTNdv6Rns65luYseXH0mF8QwEE1H
	 oyUfKxQd+ervDC8oLERsKo+fZcg/j9t+6jLNfTfnfuqM4ygHGOGcSdctgVOZJmSYlRP0E
	 KsryoDWBYJBOZPC1pK3SlvDkJrmXWn4+M+uFee+EYeYMD2y3jDkSa57m/OYvjJq4F1brb
	 Q6UMJFsjYsTTY6+m4hzPeaOyoQJ2DowBg04yR3ymqwBEYsOTPfgaNnUHnB4bT864f4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794004959;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=uy7G0J05d1+Rnl287UaXHLqos2bJpuNnKgqCSHKAiN0=;
	b=mlOzjHws48z98HXa4usvxL8wvr0Bf97dFlFg5VmSBVvGIrXSgiIrk9OPXBKDtmk21fIy
	 r/VIKepA1rKsR74TZlZRaVnfGocwvSzfr2VjVAEyISW9KNCqqKMeCXnAPtrMZYcyXA4q8
	 e8QXvvG06RGuL1AJ7avqjHaR3Q6I+dzj4PWTFT+Y49eXCD7TVGmWO33Mrkgw5pIxrL47V
	 q8+pD25Yla0P/HGrH+1arPTC+viave+pbuVthQSCYPWX6FJgx7UOyzXUejoEGTfbkJie2
	 SMIl28m1emr+1tNFMnU8L5Uq954/l8c5RSyT7MqpJBNaEfxcQ03oRXe3Xfe5LCItZIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=roS7C58n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67E9606A33C;
	Fri,  6 Nov 2026 22:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=roS7C58n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767DD1F00904;
	Fri,  6 Nov 2026 22:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794004958;
	bh=uy7G0J05d1+Rnl287UaXHLqos2bJpuNnKgqCSHKAiN0=;
	h=Date:To:Cc:From:Subject;
	b=roS7C58nnp/qeQZs3hei9dvBYPhjpStxidu7+ydkKB9j5Q538GeGmzRCm/PxinrIq
	 6LhdyEe1Vim8+FIOygB42h4gCwVLgOuGRVEHUvwWYmZrmEe/hnKSJTRGxaiq32R7rm
	 QC14dkhzuYd8Cva7Vy4uscFaiCk2lzaKIuRcgQ/c=
Date: Fri, 06 Nov 2026 14:42:38 -0800
To: mm-commits@vger.kernel.org, ziy@nvidia.com, usama.arif@linux.dev,
 stable@vger.kernel.org, shuah@kernel.org, ryan.roberts@arm.com,
 ritesh.list@gmail.com, peterx@redhat.com, nico.pache@linux.dev,
 maddy@linux.ibm.com, loic.molinari@collabora.com, ljs@kernel.org,
 liam@infradead.org, lance.yang@linux.dev, kas@kernel.org, jgg@ziepe.ca,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 azpijr@gmail.com, alex@shazbot.org, akpm@linux-foundation.org,
 khorenko@virtuozzo.com
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-huge_memory-read-a-special-pmd-under-the-lock-in-copy_huge_pmd.patch removed from -mm tree
Message-Id: <20261106224238.767DD1F00904@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/huge_memory: read a special PMD under the lock in copy_huge_pmd()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-read-a-special-pmd-under-the-lock-in-copy_huge_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: mm/huge_memory: read a special PMD under the lock in copy_huge_pmd()
Date: Wed, 04 Nov 2026 21:40:57 +0100

copy_huge_pmd() reads a special PMD without the page table lock and
copies that value to the child. The mmap write lock held by fork does
not stop unmap_mapping_range(): it zaps under i_mmap_rwsem and the PMD
lock.

The zap visits the parent VMA before the child's, as dup_mmap() links
the child right after the parent in i_mmap. If it clears the parent PMD
after fork has read it, and passes the child before fork copies it, the
child keeps a mapping the driver has revoked, for example:

- vfio-pci: the child reaches the BAR after the device memory was
  disabled or the device was reset, instead of getting SIGBUS;
- panthor: the child maps the pages of an evicted buffer object after
  the driver has released them.

The same branch deposits no page table under the copy. ppc64 in hash
mode keeps the hash slot array of every huge PMD in that table, so the
child dereferences a NULL table on the first hash fault, in
__hash_page_thp(), and on the zap, in hash__pmdp_huge_get_and_clear().

Take the locks first and let vm_normal_page_pmd() tell a PFN mapping
from a folio under them, as copy_present_ptes() does with
vm_normal_page(). The zap clears the parent PMD under the same lock, so
either fork finds it none and skips it, or the copy is in place before
the zap reaches the child.

The copy of a PFN mapping then goes through the same tail as a folio:

- it gets a page table where the architecture needs one;
- in a shared mapping it is marked clean in the child, as a PTE is;
- in a CoW mapping, which only VM_MIXEDMAP allows, both sides are write
  protected instead of a warning being printed.

Link: https://lore.kernel.org/20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-3-c56d0d26f970@virtuozzo.com
Fixes: bc02afbd4d73 ("mm/fork: accept huge pfnmap entries")
Fixes: d1503aa9ab80 ("powerpc/64s: Add support for huge pfnmaps")
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v1-1-d225c60bc316@virtuozzo.com?part=1
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
  Link: https://lore.kernel.org/20261106084856.4b254c973694345ee58a9b63@linux-foundation.org
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>
Cc: Loïc Molinari <loic.molinari@collabora.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: <stable@vger.kernel.org>
---

 mm/huge_memory.c |   24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-read-a-special-pmd-under-the-lock-in-copy_huge_pmd
+++ a/mm/huge_memory.c
@@ -1961,25 +1961,6 @@ int copy_huge_pmd(struct mm_struct *dst_
 	int ret = -ENOMEM;
 	bool writable;
 
-	pmd = pmdp_get_lockless(src_pmd);
-	if (unlikely(pmd_present(pmd) && pmd_special(pmd) &&
-		     !is_huge_zero_pmd(pmd))) {
-		dst_ptl = pmd_lock(dst_mm, dst_pmd);
-		src_ptl = pmd_lockptr(src_mm, src_pmd);
-		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
-		/*
-		 * No need to recheck the pmd, it can't change with write
-		 * mmap lock held here.
-		 *
-		 * Meanwhile, making sure it's not a CoW VMA with writable
-		 * mapping, otherwise it means either the anon page wrongly
-		 * applied special bit, or we made the PRIVATE mapping be
-		 * able to wrongly write to the backend MMIO.
-		 */
-		VM_WARN_ON_ONCE(vma_is_cow_mapping(src_vma) && pmd_write(pmd));
-		goto set_pmd;
-	}
-
 	if (vma_is_anonymous(dst_vma) || arch_needs_pgtable_deposit()) {
 		pgtable = pte_alloc_one(dst_mm);
 		if (unlikely(!pgtable))
@@ -2021,7 +2002,9 @@ int copy_huge_pmd(struct mm_struct *dst_
 		goto copy_pmd;
 	}
 
-	src_page = pmd_page(pmd);
+	src_page = vm_normal_page_pmd(src_vma, addr, pmd);
+	if (!src_page)
+		goto copy_pmd;
 	VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
 	src_folio = page_folio(src_page);
 
@@ -2061,7 +2044,6 @@ copy_pmd:
 	}
 	if (src_vma->vm_flags & VM_SHARED)
 		pmd = pmd_mkclean(pmd);
-set_pmd:
 	pmd = pmd_mkold(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 
_

Patches currently in -mm which might be from khorenko@virtuozzo.com are

selftests-mm-test-fork-of-pmd-mapped-shmem-thps.patch


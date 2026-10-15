Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602B512B94;
	Thu, 15 Oct 2026 22:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792105106; cv=none; b=DBu9LPHIhUZN+gud1Xftj0zgJDwBoh6ENkTdT26EJmcWRGWwtWOhymRjJ4ofS62Exiu2NZMLI+0YXstYsh9tQT3txJMI3y+jTT+yUaVtx0ZL/toHENH1F7AIP6VCOwubKo/qvCoRMsHrzkloFenG7thBmWD6nBX1gVK91YtjWd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792105106; c=relaxed/simple;
	bh=OVz5eN5cvnIxgma5VB5gOmSfrkWpRsg3OSpkjIi4MwY=;
	h=Date:To:From:Subject:Message-Id; b=NyNmNseuDSjKGRTpgfjrv/sBRaxs9BhD5ekgBdkA+d/a3RVgf96dtRTJOgiFEVUw7kLCsLU5uB4y8uqvNDYVFyZw2g7Drhab64ApW5Y8Yf0jxPya3pTmwi+K5rE6RhpiGCMXcZAiAo7eBxXZdPOGe0KkGULDPsQ+sRSTAK6kakU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZUl336qK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZUl336qK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A731F000C4;
	Thu, 15 Oct 2026 22:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792105104;
	bh=TN2R+TppwG3DZZaKUftVtFmF7pmbJaQ9FMsEO3M3AHU=;
	h=Date:To:From:Subject;
	b=ZUl336qKixcdoA/f1n0JaDorDYvqp6O1sk1kpZrsSXZypKZme/mtkXMTVxBYipLFp
	 0gY3G/7yMq+uVsFh/UoJLNM/97G2CyrzHRoj40qngZgDG88RJLsJTvhQLLO8bu2hgC
	 KZD0x3DVxQ7cvTmfSBdMMnVmIuJBbasZhk0WSY80=
Date: Thu, 15 Oct 2026 15:58:23 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mel@csn.ul.ie,mason@kernel.org,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,kas@kernel.org,jannh@google.com,david@kernel.org,agl@us.ibm.com,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-dont-clear-the-resv_map-of-a-vma-whose-lock-is-held.patch added to mm-hotfixes-unstable branch
Message-Id: <20261015225823.F2A731F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: don't clear the resv_map of a VMA whose lock is held
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-dont-clear-the-resv_map-of-a-vma-whose-lock-is-held.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-dont-clear-the-resv_map-of-a-vma-whose-lock-is-held.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm/hugetlb: don't clear the resv_map of a VMA whose lock is held
Date: Thu, 15 Oct 2026 18:07:11 +0200

Since commit bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private
VMAs") the lock of a private hugetlb VMA that owns a reservation is the
rw_sema of its resv_map.  The hugetlb_vma_*lock*() helpers find it through
vma->vm_private_data, anew for every lock and every unlock.

At the end of mremap() the old VMA has to let go of the resv_map, which
now belongs to the new VMA: clear_vma_resv_huge_pages() stores NULL into
vm_private_data.  mremap() holds mmap_lock for writing and has write
locked the VMA, which keeps away everybody who comes through the mm.  It
does not keep away those who find the VMA through the file.  For hole
punch and truncation hugetlb_vmdelete_list() does

	hugetlb_vma_trylock_write(vma);		locks resv_map->rw_sema
	unmap_hugepage_range(vma, ...);
						vm_private_data = NULL
	hugetlb_vma_unlock_write(vma);		no resv_map: does nothing

and the rw_sema stays write locked for ever:

  WARNING: lock held when returning to user space!
  mremap_punch/116 is leaving the kernel with locks still held!
  locks held by mremap_punch/116: 1, last CPU#1:
   #0: (&resv_map->rw_sema){+.+.}-{4:4}, at:
                                       hugetlb_vmdelete_list+0x46/0x160

The next fault in the new VMA sleeps in hugetlb_vma_lock_read(),
uninterruptibly, and it holds its entry of hugetlb_fault_mutex_table[].
That table is global, so a fault of any other process on a page that
hashes to the same entry sleeps uninterruptibly as well.

All those who take the lock of a private VMA without taking the mmap/vma
lock are affected: rmap walks. So hold i_mmap_rwsem around the clearing
of the resv_map.

No change of behaviour, other than that mremap() of a hugetlb VMA takes
i_mmap_rwsem once more.

Original fix generated by an LLM and sent in private by Josef.

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-5-42796911043b@kernel.org
Fixes: bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
[ david: avoid local variable, move and refine comment, description cleanups+simplifications ]
---

 mm/hugetlb.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-dont-clear-the-resv_map-of-a-vma-whose-lock-is-held
+++ a/mm/hugetlb.c
@@ -7478,6 +7478,15 @@ void hugetlb_unshare_all_pmds(struct vm_
  */
 void fixup_hugetlb_reservations(struct vm_area_struct *vma)
 {
-	if (is_vm_hugetlb_page(vma))
-		clear_vma_resv_huge_pages(vma);
+	if (!is_vm_hugetlb_page(vma))
+		return;
+
+	/*
+	 * Rmap walks might still find this VMA and take the lock
+	 * inside the reservation map for __vma_private_lock(). Don't clear
+	 * the reservation map while that is possible.
+	 */
+	i_mmap_lock_write(vma->vm_file->f_mapping);
+	clear_vma_resv_huge_pages(vma);
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
 }
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-vma-dont-leak-the-commit-charge-on-mmap-failure.patch
mm-hugetlb-fix-use-after-free-of-a-new-anon-folio.patch
mm-hugetlb-unmap-the-page-where-the-other-vma-maps-it.patch
mm-hugetlb-dont-clear-the-resv_map-of-a-vma-whose-lock-is-held.patch
mm-hugetlb-fix-endless-write-fault-on-a-leftover-uffd-bit.patch
mm-hugetlb-dont-leave-a-uffd-wp-marker-when-zapping-an-rwp-entry.patch


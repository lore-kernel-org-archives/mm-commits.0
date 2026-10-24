Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832247;
	b=ltuYJEMBjQQNJN7DwHqcE/eaWk1PoRftxgTax9E97kzzCe2d4vou8Ftm8aRmk6oL0WV8
	 F22JeRUdPfsw7GdgiqIS6echpyKHZV69enZFpGIBWvh0djrgvTJgmeEquTeSDhgmG4gT6
	 R1L+OIbxAocShrrzEzVSeSX2zAbvuZBbyBPMFBB3mOt4r3kgG+oexzeraY24mEd26nyUf
	 6y7Wugz/qeT/8PbMawl16pmyo+JdvSylD8tBNwvEO3f2D+PLneCZl3TId8VrlruuR14CP
	 N1OU22dPAQ1au/9eFGgHFJb27/Oy4Gmdaml0E7QuVP5uJHjIMoHjlAFdsEZwbcDXS/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832247;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Um2KKvbljwjEOAZVFAqto1mGXJ4IjHHgwnM4+WkjivM=;
	b=Aj9sy7qn6HFdk0aSW0hOiSWil2v8dAaFglJnCKe7fNfj07RVLXvRoN0vAvZCsbxiHPKM
	 c2rUFlJNs3UAQM02E/cScGdwTqu+MDSxl4wotACSzxIms0ahAhU8OUi4w5SNxd3kWLUCD
	 j9FsAow2LBOvmX2AV7AkWJjY845W3FchFCNKEHOxpLgkm+Ki0VWFYLxUhoI3dFYER5JGu
	 Z//zpwb+Lzd71/dkkiDNmYzAEgDSC9bXY120KLPAl4p8sOyJsc/XQhAsKa/XH/FnjOdfD
	 A/vrM6uSJ7YIX7bFiH8PEYMD5xEUn+sA8rVtRkqPuK4kheQACiRFyoR82qQqVs/KdVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="kwZ/0wla";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D21606A31F;
	Sat, 24 Oct 2026 08:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kwZ/0wla
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4008B1F01825;
	Sat, 24 Oct 2026 08:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832246;
	bh=Um2KKvbljwjEOAZVFAqto1mGXJ4IjHHgwnM4+WkjivM=;
	h=Date:To:From:Subject;
	b=kwZ/0wlaWOI0wftotompOdHUGj9Z6p4LKQ8kRT2H64aQL8nVGCME3Jdz8fThpRXK6
	 r9eqVGvqbQfEzfsKCp84loYzajolHf+T5lAsUdKssE37WVjQt8OHdEX+Sk6/Y0XSeR
	 0DZNgpexVI7Q4aPbXcgd6lQC2UIOBqnjnvlGNtDk=
Date: Sat, 24 Oct 2026 01:57:25 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mgorman@techsingularity.net,mason@kernel.org,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,jannh@google.com,david@kernel.org,agl@us.ibm.com,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-dont-clear-the-resv_map-of-a-vma-whose-lock-is-held.patch removed from -mm tree
Message-Id: <20261024085726.4008B1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb: don't clear the resv_map of a VMA whose lock is held
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-dont-clear-the-resv_map-of-a-vma-whose-lock-is-held.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[david: avoid local variable, move and refine comment, description cleanups+simplifications]
Link: https://lore.kernel.org/20261015-urgent_fixes-v1-5-42796911043b@kernel.org
Fixes: bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-dont-clear-the-resv_map-of-a-vma-whose-lock-is-held
+++ a/mm/hugetlb.c
@@ -7509,6 +7509,15 @@ void hugetlb_unshare_all_pmds(struct vm_
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



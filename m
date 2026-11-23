Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415129;
	b=w0FK2Z8auZS0eF9UTHO77HfR8+kxiyCZ1YGmJYR2wHwbNu3PRvBywVEXbcfsya/d7aDR
	 9X0r0ymb2RWK2YOYzxKMxUA8e9MqsVZjXqAdguiUgpBGw3fUVANQeBPnBLotxBoibv6ST
	 Z1AZxAyNraT0FT+lE5k+1B59PQv96xmbqvXc6JFC3edgY00ee5Pc2OMay0DOiKvykm6gl
	 Ce6Rs8VNbCpPGzxnAu6Mn6EbV8BpG/HkoQQoiBm0w6GOlaYA7zBNhmBRVLSEzsI7HWXE8
	 mahmLiYiqebd9+BY7qnpgBsDKBUExVAYFv0HKZG9ilPRM/sYb9ifSQl9X+8As9TzB7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415129;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=oV2r2qbwvMzzAdSnS2MCMuQXAmB35crsp1K7IebLv2U=;
	b=wN5K1wpOYC2dNdMCVE2vonWp3G9jV5waihvNabigpzonPOH8RHE/G3Zg64EbpzuaRq9G
	 4/EYH7lyIbUMKueCMUBkHokqV6xbvEN7Q81ju+ZhWz8iZXf2TuvZfEVJF32knLZSQbWRn
	 KtKoH+9TM6LAyDGd+zQZgHmRVcKpORZza/D1Zxja7FEXAg/nGbuTNSKWeZcnVGzfj2WCF
	 P/ubqnjWuuNLELQuOCjx/feP5CenkhD7cj+qBl/m4DCf1AEgm/GjNmTHULvgPp/Nnt7Wa
	 8pEGCgwSCe/3H1Ccj7bYKMOQmEWWGqHihuTStNdwqsHytmQ13TC8sufgPxOqI7IjJYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pUMlNKTw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D4D606A681;
	Mon, 23 Nov 2026 06:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pUMlNKTw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1D61F000C0;
	Mon, 23 Nov 2026 06:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415128;
	bh=oV2r2qbwvMzzAdSnS2MCMuQXAmB35crsp1K7IebLv2U=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=pUMlNKTwcTZK3XN0D9dc9Iw9cuy8mUaDDjbjm91y4YRvNdzripU2wl8S1ue9KVTx4
	 x+DUeDbAtTQgngw12MYZyLliF4sRVeAmuEqGiAktSiWEHtQ+z5OV8HrX5jAJ0J2rrs
	 CMOe5cfyjMcOy/r+FtU8AbNUwjtXzu8kkqfyQ7ec=
Date: Sun, 22 Nov 2026 22:25:27 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vivek.kasireddy@intel.com,
	vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,
	stable@vger.kernel.org,skhan@linuxfoundation.org,rppt@kernel.org,
	riel@surriel.com,rdunlap@infradead.org,peterz@infradead.org,
	peterx@redhat.com,osalvador@suse.de,osalvador@kernel.org,npiggin@gmail.com,
	nao.horiguchi@gmail.com,muchun.song@linux.dev,mhocko@suse.com,
	mgorman@suse.de,mason@kernel.org,luojiajun3@huawei.com,ljs@kernel.org,
	linmiaohe@huawei.com,liam@infradead.org,leitao@debian.org,kraxel@redhat.com,
	josef@toxicpanda.com,jgg@ziepe.ca,hughd@google.com,hca@linux.ibm.com,
	gourry@gourry.net,gor@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,
	baolin.wang@linux.alibaba.com,arnd@arndb.de,apw@canonical.com,
	aneesh.kumar@kernel.org,airlied@redhat.com,agordeev@linux.ibm.com,
	ackerleytng@google.com,4ncienth@gmail.com,david@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261116-fixes_hugetlb-v2-6-4dd9e94ea9ac@kernel.org>
References: <20261116-fixes_hugetlb-v2-6-4dd9e94ea9ac@kernel.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-fix-mremap-racing-with-page-migration.patch removed from -mm tree
Message-Id: <20261123062528.5F1D61F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb: fix mremap() racing with page migration
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-mremap-racing-with-page-migration.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/hugetlb: fix mremap() racing with page migration
Date: Mon, 16 Nov 2026 19:29:27 +0100

Migration of anon hugetlb folios walks the anon_vma, so the file's
i_mmap_rwsem does not serialize it against move_hugetlb_page_tables().

There are various issues with that. Most importantly, move_huge_pte()
releases both page table locks before the TLB is flushed. Migration can
then find the destination entry and finish migration, reusing the old
folio while the TLB still has entries cached.

Hold the anon_vma write lock across the move and the final TLB flush.
This also prevents concurrent rmap walks from missing entries moved
during rollback.

When we must allocate a destination page table, flush the TLB before
dropping the anon_vma lock, then reacquire it after allocation.

Dropping the lock only works around lockdep: hugetlb folios are not
reclaimed or migrated by allocation compaction, but their anon_vmas
share the lock class used by ordinary anonymous memory. Having a
separate lock class for hugetlb's anon_vma (like already done for
i_mmap_rwsem via hugetlbfs_i_mmap_rwsem_key) requires more thought.

There is a concern that this can block page migration of anonymous
folios quite a while ... which is not really different to what happens
to page-cache folios today. If ever a problem, we can temporarily
release the lock.

So let's keep it simple for now.

It is a shame that hugetlb has to implement everything core-mm implements
in a different way that just screams for problems.

Link: https://patch.msgid.link/20261116-fixes_hugetlb-v2-6-4dd9e94ea9ac@kernel.org
Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
  Link: https://lore.kernel.org/179490494079.482102.4618915344813254218.b4-reply@b4
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Daehyeon Ko <4ncienth@gmail.com>
Cc: luojiajun <luojiajun3@huawei.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: <stable@vger.kernel.org>

 mm/hugetlb.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-mremap-racing-with-page-migration
+++ a/mm/hugetlb.c
@@ -5204,6 +5204,7 @@ unsigned long move_hugetlb_page_tables(s
 {
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping = vma->vm_file->f_mapping;
+	struct anon_vma *anon_vma = vma->anon_vma;
 	unsigned long sz = huge_page_size(h);
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long old_end = old_addr + len;
@@ -5227,6 +5228,8 @@ unsigned long move_hugetlb_page_tables(s
 	/* Prevent race with file truncation */
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(mapping);
+	if (anon_vma)
+		anon_vma_lock_write(anon_vma);
 	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
 		const unsigned long offset_to_last_entry =
 			(old_addr | last_addr_mask) - old_addr;
@@ -5266,7 +5269,20 @@ unsigned long move_hugetlb_page_tables(s
 			continue;
 		}
 
-		dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
+		dst_pte = hugetlb_walk(new_vma, new_addr, sz);
+		if (!dst_pte) {
+			/*
+			 * We can allocate memory under anon_vma lock with hugetlb,
+			 * but lockdep does not know about that. So for now we simply
+			 * flush the TLB and temporarily drop the lock.
+			 */
+			tlb_flush_mmu_tlbonly(&tlb);
+			if (anon_vma)
+				anon_vma_unlock_write(anon_vma);
+			dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
+			if (anon_vma)
+				anon_vma_lock_write(anon_vma);
+		}
 		if (!dst_pte)
 			break;
 
@@ -5274,7 +5290,10 @@ unsigned long move_hugetlb_page_tables(s
 		tlb_remove_huge_tlb_entry(h, &tlb, src_pte, old_addr);
 	}
 
+	/* Flush pending moves before allowing migration to walk the entries. */
 	tlb_flush_mmu_tlbonly(&tlb);
+	if (anon_vma)
+		anon_vma_unlock_write(anon_vma);
 	huge_pmd_unshare_flush(&tlb, vma);
 
 	mmu_notifier_invalidate_range_end(&range);
_

Patches currently in -mm which might be from david@kernel.org are

mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch
mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails.patch
mm-userfaultfd-prevent-poison-marker-loss.patch
mm-hugetlb-compare-against-persistent-count-when-freeing-lowmem-folios.patch
mm-hugetlb-preserve-reservations-when-shrinking-on-highmem.patch
mm-hugetlb-account-temporary-folios-separately.patch
mm-hugetlb-account-temporary-folios-separately-fix.patch
mm-hugetlb-serialize-page-cache-allocations-with-truncation.patch
mm-memfd-recheck-the-page-cache-before-allocating-a-hugetlb-folio.patch
mm-hugetlb-count-again-if-the-reserve-map-shrank.patch
mm-hugetlb-account-restored-reservations-before-freeing-folios.patch
mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4169E26158B;
	Wed, 29 Jul 2026 00:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785285488; cv=none; b=U59od74s6JUWEIykhsfaP6igy6UbpMr2orw+V8B8uOtVrsLtqUDm4ZpAHuO8e6BwsLqJxRupZ75Cu8EFO/XR6UvtS50Edf2G96D3197GaQC/Yi0dJAnQMx7nTtIQ7HGXWQgJgtfZ1Tk4NceKsFcy1yKD7jOBpZtROgk/KRmrLjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785285488; c=relaxed/simple;
	bh=562WJMZSDnpCoBzbLBrjIDYQym8UB21sVE0iwU2KW8A=;
	h=Date:To:From:Subject:Message-Id; b=Qv6z22ePkAA3ExhTe7sRGjO1uDr8T4JuxFa9LIJeLiOVsRBPCBZbMtQk66tqm6tBOYYwjxlOyVrvNw7I/hSHNMXQBvuUji2zaLfghoST6mzAX54TCOmEicRX8goViIgx6WVKuc+bCNpZ2oD/+IF8gPg9JYBz4xW8UP0v8dE1ixs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r106BSus; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r106BSus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B814E1F00A3A;
	Wed, 29 Jul 2026 00:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785285486;
	bh=BUYQae6IOj8ellyM91+zXPS4AegJT+GidygkisdLFaQ=;
	h=Date:To:From:Subject;
	b=r106BSus/BeZIJh+23sNm23OzTgWJo13BUt8O1TpHNkrN4OGWv45w4WnBM4P/F07W
	 bDxdLCanMThNYFyNmj9H1GoulssRvfDcmo0DRUfckKv3/LdN2aAMTahrBLZvgZNcuk
	 r14awsKHzRWvHROeWkDsIlty7e6RZTxJ7VAQPelM=
Date: Tue, 28 Jul 2026 17:38:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhanghao1@kylinos.cn,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,nao.horiguchi@gmail.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-unlock-i_mmap_rwsem-before-releasing-after-split-folios.patch removed from -mm tree
Message-Id: <20260729003806.B814E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: unlock i_mmap_rwsem before releasing after-split folios
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-unlock-i_mmap_rwsem-before-releasing-after-split-folios.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/huge_memory: unlock i_mmap_rwsem before releasing after-split folios
Date: Thu, 16 Jul 2026 10:54:24 +0100

__folio_split() keeps dereferencing the mapping after the split:
shmem_uncharge(mapping->host) and remap_page() while the folios are still
frozen/locked, and i_mmap_unlock_read(mapping) at the very end, after the
after-split folios have been unlocked and freed.

Nothing holds an inode reference across that.  The split relies on @folio
-- which the beyond-EOF drop loop never removes, as it starts at
folio_next(folio) -- staying locked and in the page cache to hold off
eviction.  But the unlock loop unlocks @folio before i_mmap_unlock_read()
runs.  If the caller's @lock_at is a tail beyond EOF, as memory_failure()
passes when splitting a poisoned tail of a shmem THP that reaches past
i_size during truncation, it too is gone from the page cache; so once
@folio is unlocked no locked, in-cache folio pins the inode, and a
concurrent final iput() can evict and RCU-free it before
i_mmap_unlock_read() touches i_mmap_rwsem:

  BUG: KASAN: slab-use-after-free in __up_read+0x634/0x790
   i_mmap_unlock_read include/linux/fs.h:537 [inline]
   __folio_split+0x732/0x1640 mm/huge_memory.c:4100
   try_to_split_thp_page+0xab/0x390 mm/memory-failure.c:1675
   memory_failure+0x1394/0x26e0 mm/memory-failure.c:2470

  Freed by task 4601:
   shmem_free_in_core_inode+0x54/0xb0 mm/shmem.c:5177
   evict+0x57f/0xac0 fs/inode.c:870

Do every mapping dereference while @folio still pins the inode: drop
i_mmap_rwsem right after remap_page(), before the loop that unlocks and
frees the after-split folios, and clear @mapping so the exit path does not
unlock it again.  shmem_uncharge() and remap_page() already run before
that point, so after this nothing past the unlock loop touches the inode
or the mapping.

This is now a rule the split depends on, alongside keeping @folio frozen
until the page cache is updated: no inode or mapping dereference once the
after-split folios start being unlocked.

Link: https://lore.kernel.org/20260716095424.471052-1-kirill@shutemov.name
Fixes: baa355fd3314 ("thp: file pages support for split_huge_page()")
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reported-by: Hao Zhang <zhanghao1@kylinos.cn>
Closes: https://lore.kernel.org/linux-mm/20260710071344.GA106129@zh-pc
Co-developed-by: Hao Zhang <zhanghao1@kylinos.cn>
Signed-off-by: Hao Zhang <zhanghao1@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-unlock-i_mmap_rwsem-before-releasing-after-split-folios
+++ a/mm/huge_memory.c
@@ -4114,6 +4114,18 @@ fail:
 	remap_page(folio, 1 << old_order, ttu_flags);
 
 	/*
+	 * Drop the mapping while the inode is still pinned. @folio stays
+	 * locked and present in the page cache until the loop below, so
+	 * eviction cannot free the inode yet; @lock_at is not enough, it may
+	 * be a tail beyond EOF that the split already dropped from the page
+	 * cache. Nothing past this point may touch the inode or the mapping.
+	 */
+	if (mapping) {
+		i_mmap_unlock_read(mapping);
+		mapping = NULL;
+	}
+
+	/*
 	 * Unlock all after-split folios except the one containing
 	 * @lock_at page. If @folio is not split, it will be kept locked.
 	 */
_

Patches currently in -mm which might be from kas@kernel.org are

mm-decouple-protnone-helpers-from-config_numa_balancing.patch
mm-rename-uffd-wp-pte-bit-macros-to-uffd.patch
mm-rename-uffd-wp-pte-accessors-to-uffd.patch
userfaultfd-test-uffd-vma-flags-through-the-vma_flags_t-api.patch
mm-add-vm_uffd_rwp-vma-flag.patch
mm-add-mm_cp_uffd_rwp-change_protection-flag.patch
mm-preserve-rwp-marker-across-pte-rewrites.patch
mm-handle-vm_uffd_rwp-in-khugepaged-rmap-and-gup.patch
userfaultfd-add-uffdio_register_mode_rwp-and-uffdio_rwprotect-plumbing.patch
mm-userfaultfd-add-rwp-fault-delivery-and-expose-uffdio_register_mode_rwp.patch
mm-pagemap-add-page_is_accessed-for-rwp-tracking.patch
userfaultfd-add-uffd_feature_rwp_async-for-async-fault-resolution.patch
userfaultfd-add-uffdio_set_mode-for-runtime-sync-async-toggle.patch
selftests-mm-add-userfaultfd-rwp-tests.patch
documentation-userfaultfd-document-rwp-working-set-tracking.patch
selftests-mm-add-pagemap_scan-test-for-thp-pmd-holes.patch
mm-huge_memory-remove-unused-can_split_folio.patch
mm-huge_memory-fold-split_folio_to_list_to_order-into-split_folio_to_order.patch
mm-fold-userfaultfd_rwp-to-false-without-config_arch_has_pte_protnone.patch


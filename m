Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95573914EB
	for <mm-commits@vger.kernel.org>; Fri, 16 Oct 2026 02:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792116794; cv=none; b=UBnOoP+uG8uDXYumn3vYbWugPshxLOuOBnb8ZR9sYEcyz8ClaM7C/GzLQIYyymFCMZf5f2wWFlt0osfnmCUUAFch4gKu0kfswqZJ7kJyU/dPdx7QRuRIYSqPRjPZoyaQR9ZB79j3ez9H3VpeIZsLkU7B1XAJbgcumNvr77vpQOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792116794; c=relaxed/simple;
	bh=nu4/nAXuxMRgd+jkh+Oe/I6/UMCACFCKVfCo6jcjK5Q=;
	h=Date:To:From:Subject:Message-Id; b=hlrutSgAKw5xsLiztwDJg6+9OD8BLTQStSdAj2/HPm1AuKSN1kJr7rgvadmTYKfzYuzqCK0b2arZlHLJhjTQSK+sT1v+REstC8/MiEGn1DckC+TWEw3019QlbhV7O3FRuOYitTBPBRgJQ/MIE8l0tkL8hvDh+IKaH+aNKsKKvgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k39ALfHp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k39ALfHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4DF1F000C4;
	Fri, 16 Oct 2026 02:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792116791;
	bh=vVcADz+OgzmU7HXfhzRSAdFl1R17pcO+HvtddgHbBBA=;
	h=Date:To:From:Subject;
	b=k39ALfHp5kfIU8OqOFqgDVmrOhzK92gvNLTNlEqSrUCJU6Nq82x/Xp0ZHtcuMFvIu
	 229b4LsWmnVmuyU+xonbsoe3JDtrRTf3A73uYqLYKI2qaZhIzcID1IDCVbwgn4lUf5
	 iqjsSkGNgb21HUWSCFqlLoFH8LTVQLIrRVCr4QSI=
Date: Thu, 15 Oct 2026 19:13:10 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,qi.zheng@linux.dev,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jack@suse.cz,david@kernel.org,ayushr@modal.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-fix-truncation-removing-mapped-folios.patch removed from -mm tree
Message-Id: <20261016021311.0E4DF1F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory: fix truncation removing mapped folios
has been removed from the -mm tree.  Its filename was
     mm-memory-fix-truncation-removing-mapped-folios.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: memory: fix truncation removing mapped folios
Date: Sat, 10 Oct 2026 15:22:18 +0800

Ayush reported an issue that shmem/tmpfs folios are still mapped when
truncating them on production:
"
BUG: Bad page cache in process ...  pfn:...
page dumped because: still mapped when deleted
"

I reproduced the issue with Ayush's reproducer [1] with the latest mm-unstable
branch, and I got the following crash info. From the dump message, we can
see that truncate_inode_folio() is really trying to remove mapped folios,
which is incorrect.

"
[  189.171977] page: refcount:3 mapcount:1 mapping:00000000fe168ee1
index:0x3880 pfn:0x191647
[  189.171995] memcg:ffff0000cc073d40
[  189.171997] aops:shmem_aops ino:3c01 dentry name(?):"memfd:runsc-memory"
[  189.172006] flags: 0x17fffef0002022d(locked|referenced|uptodate|lru|
workingset|swapbacked|node=0|zone=2|lastcpupid=0x3ffff)
.......
[  189.172017] page dumped because: VM_BUG_ON_FOLIO(folio_mapped(folio))
[  189.172026] ------------[ cut here ]------------
[  189.172027] kernel BUG at mm/filemap.c:155!
[  189.172057] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
.......
[  189.177721] CPU: 3 UID: 0 PID: 5521 Comm: repro Kdump: loaded Tainted:
7.3.0-rc4+ #277 PREEMPT(lazy)
.......
[  189.183986] Call trace:
[  189.184124]  filemap_unaccount_folio+0xf0/0x1e8 (P)
[  189.184391]  __filemap_remove_folio+0x34/0x160
[  189.184633]  filemap_remove_folio+0x4c/0xb0
[  189.184859]  truncate_inode_folio+0x34/0x58
[  189.185087]  shmem_undo_range+0x220/0x658
[  189.185308]  shmem_fallocate+0x2f0/0x470
[  189.185527]  vfs_fallocate+0x128/0x328
......
[  189.187078]  el0t_64_sync+0x184/0x188
"

After analysis, I believe the race exists between truncation and
MADV_DONTNEED, and shmem's ->map_pages() merely makes the issue easier to
reproduce.  Since MADV_DONTNEED synchronously releases the pagetable page
before calling tlb_flush_rmaps(), this could cause another thread's
truncation to skip zap_pte_range() (due to pmd is none) but still observe
the folio's mapcount as non-zero.  A possible race scenario is as follows:

CPU 0                           CPU 1
shmem_fallocate                 madvise_dontneed_single_vma
  unmap_mapping_range            .......
  ......
  (filemap_map_pages() remap folios)
				  zap_pte_range
  truncate_inode_folio		    zap_empty_pte_table(pmd clear)
    unmap_mapping_folio
    ......
      zap_pmd_range (saw pmd none, skip)

  filemap_remove_folio
    BUG_ON(folio_mapped)
                                    tlb_flush_rmaps(remove rmaps)

To fix this issue, we should move the pmd clear operation (via
zap_empty_pte_table()) to after tlb_flush_rmaps() and add
smp_wmb()/smp_rmb() memory barriers, so that when we find a pmd_none()
while unmapping a folio without holding the PTL, the folio's mappings are
guaranteed to have been removed via tlb_flush_rmaps().

Link: https://lore.kernel.org/542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com
Link: https://lore.kernel.org/all/20260925065013.3682431-1-ayushr@modal.com/ [1]
Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Ayush Ranjan <ayushr@modal.com>
Closes: https://lore.kernel.org/all/20260924061708.1645968-1-ayushr@modal.com/
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Jan Kara <jack@suse.cz>
---

 mm/memory.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

--- a/mm/memory.c~mm-memory-fix-truncation-removing-mapped-folios
+++ a/mm/memory.c
@@ -2073,6 +2073,15 @@ retry:
 		}
 	} while (pte += nr, addr += PAGE_SIZE * nr, addr != end);
 
+	add_mm_rss_vec(mm, rss);
+	lazy_mmu_mode_disable();
+
+	/* Do the actual TLB flush before dropping ptl */
+	if (force_flush) {
+		tlb_flush_mmu_tlbonly(tlb);
+		tlb_flush_rmaps(tlb, vma);
+	}
+
 	/*
 	 * Fast path: try to hold the pmd lock and unmap the PTE page.
 	 *
@@ -2081,16 +2090,13 @@ retry:
 	 * to ensure they are still none, thereby preventing the pte entries
 	 * from being repopulated by another thread.
 	 */
-	if (can_reclaim_pt && direct_reclaim && addr == end)
+	if (can_reclaim_pt && direct_reclaim && addr == end) {
+		/*
+		 * The rmap changes need to be observed before PTEs get zapped.
+		 * Pairs with smp_rmb() in zap_pmd_range().
+		 */
+		smp_wmb();
 		direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
-
-	add_mm_rss_vec(mm, rss);
-	lazy_mmu_mode_disable();
-
-	/* Do the actual TLB flush before dropping ptl */
-	if (force_flush) {
-		tlb_flush_mmu_tlbonly(tlb);
-		tlb_flush_rmaps(tlb, vma);
 	}
 	pte_unmap_unlock(start_pte, ptl);
 
@@ -2145,6 +2151,11 @@ static inline unsigned long zap_pmd_rang
 			sync_with_folio_pmd_zap(tlb->mm, pmd);
 		}
 		if (pmd_none(*pmd)) {
+			/*
+			 * Order this PMD read before the folio's mapcount read.
+			 * Pairs with smp_wmb() in zap_pte_range().
+			 */
+			smp_rmb();
 			addr = next;
 			continue;
 		}
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792981233;
	b=huCo8mZkujQAKRi6QZjdfcvACSSYpc3/jc3xuJHEajwx1HgjD3tFSYHo4NweHiFKfse0
	 tIuKcMPpiBteWWjYWXeTOAQfCtik/VelrbCLJX0LqKuOV7hiYD3icNr/wVKksR+UWyBuG
	 TPUg0JDFRcTS2h1qJRAzU4YXm3atULTUd6aqd+x/3+3pXyGxr4MVDo2arL6Z2O8wOukJd
	 avvd+zwRwF21vUe266w9bHRdQ04+V5afTfesI170gC7A05sdXDM5f6qs7wPPptYA0TccH
	 XtlD8U/RBWBdTIWAUhMdkwRDog/MHFJifC9JvVt1HWvaZTJ1p7FR0wiNYEx4JeJlXJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792981233;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ZPPzxSgXQ/fi9l/jxDxUXcakc3zoPIJYhpuUR/bm03w=;
	b=lEgB9R77gF6DSMCwEXGtfA0XnC41vCcqazzHdw4n3uOTFfD0gmec9CMW1UuW6QBelHXP
	 jCmq2JQT4am0yIDAcajQ8ydaw311yyj3ydcSCKb4OAzBrsPsVF8hRfRXyuGsgk8/zdQB4
	 FLvRu+K9tzsTTbZz8BNVauEo/2tBfjn4BMDdNEclJuH1lUVlnwvoZL3Kupj/VBp76mVQ1
	 +MPg5cXFAeFFn8QInVXTfwVqQkFULKR/+lAbh50Mi02IrV/VGd/5QnCuzC7mCl7FeZRaZ
	 ukNy4btzK/Y52abmu5OCHlwscNwvSd8f5B7BfVpqBgkagtD7NWe0hHiMdIIxgb8qe6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="HtjhM/Ce";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DFA606A31E
	for <mm-commits@vger.kernel.org>; Mon, 26 Oct 2026 02:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HtjhM/Ce
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79241F01825;
	Mon, 26 Oct 2026 02:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792981227;
	bh=ZPPzxSgXQ/fi9l/jxDxUXcakc3zoPIJYhpuUR/bm03w=;
	h=Date:To:From:Subject;
	b=HtjhM/CeAUY9RiHkXOSBA7Z6QXfKQ2wsB8HI1Icd2I7MeKAkGpjmE/4qu4j+f2L4r
	 AFz++SeICkZ35/wsAEDESvZsPyKTxwoTI6MuTl1EXHGX2aHGRJmrOoqbb4uCQWlh/2
	 IaDSx5KPt83wyTizbqo/16d7yTmj/LZN7CF97qp0=
Date: Sun, 25 Oct 2026 19:20:27 -0700
To: mm-commits@vger.kernel.org,baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-fix-truncation-removing-mapped-folios.patch removed from -mm tree
Message-Id: <20261026022027.B79241F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: memory: fix truncation removing mapped folios
has been removed from the -mm tree.  Its filename was
     mm-memory-fix-truncation-removing-mapped-folios.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: memory: fix truncation removing mapped folios
Date: Fri, 16 Oct 2026 09:48:08 +0800

Ayush reported an issue that shmem/tmpfs folios are still mapped when
truncating them on production:
"
BUG: Bad page cache in process ...  pfn:...
page dumped because: still mapped when deleted
"

I reproduced the issue with Ayush's reproducer [1] with the latest
mm-unstable branch, and I got the following crash info.  From the dump
message, we can see that truncate_inode_folio() is really trying to remove
mapped folios, which is incorrect.

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
zap_empty_pte_table()) to after tlb_flush_rmaps() and use
sync_with_folio_pmd_zap() to sync with concurrent zapping, so that when we
find a pmd_none() while unmapping a folio without holding the PTL, the
folio's mappings are guaranteed to have been removed via
tlb_flush_rmaps().

Link: https://lore.kernel.org/e2f76ed117b0c22a26b7688fd46a38c9d035336e.1792114445.git.baolin.wang@linux.alibaba.com
Link: https://lore.kernel.org/all/20260925065013.3682431-1-ayushr@modal.com/ [1]
Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Ayush Ranjan <ayushr@modal.com>
Closes: https://lore.kernel.org/all/20260924061708.1645968-1-ayushr@modal.com/
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jan Kara <jack@suse.cz>
---

 mm/internal.h |    9 +++++----
 mm/memory.c   |   25 ++++++++++++-------------
 2 files changed, 17 insertions(+), 17 deletions(-)

--- a/mm/internal.h~mm-memory-fix-truncation-removing-mapped-folios
+++ a/mm/internal.h
@@ -584,14 +584,15 @@ void free_pgtables(struct mmu_gather *tl
 void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
 
 /**
- * sync_with_folio_pmd_zap - sync with concurrent zapping of a folio PMD
+ * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
  * @mm: The mm_struct.
  * @pmdp: Pointer to the pmd that was found to be pmd_none().
  *
  * When we find a pmd_none() while unmapping a folio without holding the PTL,
- * zap_huge_pmd() may have cleared the PMD but not yet modified the folio to
- * indicate that it's unmapped. Skipping the PMD without synchronization could
- * make folio unmapping code assume that unmapping failed.
+ * zap_huge_pmd() or zap_empty_pte_table() may have cleared the PMD but not
+ * yet modified the mapped folios to indicate they are unmapped. Skipping the
+ * PMD without synchronization could make folio unmapping code assume that
+ * unmapping failed.
  *
  * Wait for concurrent zapping to complete by grabbing the PTL.
  */
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
@@ -2083,15 +2092,6 @@ retry:
 	 */
 	if (can_reclaim_pt && direct_reclaim && addr == end)
 		direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
-
-	add_mm_rss_vec(mm, rss);
-	lazy_mmu_mode_disable();
-
-	/* Do the actual TLB flush before dropping ptl */
-	if (force_flush) {
-		tlb_flush_mmu_tlbonly(tlb);
-		tlb_flush_rmaps(tlb, vma);
-	}
 	pte_unmap_unlock(start_pte, ptl);
 
 	/*
@@ -2139,12 +2139,11 @@ static inline unsigned long zap_pmd_rang
 				continue;
 			}
 			/* fall through */
-		} else if (details && details->single_folio &&
-			   folio_test_pmd_mappable(details->single_folio) &&
-			   next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
-			sync_with_folio_pmd_zap(tlb->mm, pmd);
 		}
+
 		if (pmd_none(*pmd)) {
+			if (details && details->single_folio)
+				sync_with_folio_pmd_zap(tlb->mm, pmd);
 			addr = next;
 			continue;
 		}
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are



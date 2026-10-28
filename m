Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793154464;
	b=psuqvxVR6rPp+P0MgQNpMBt0AYSgVBX5gum45QlHc9Y6SPExJS9YJXRTZmaWnohrlULI
	 1L0OJGGOOKfgW3C/jU3svAm9qGq16Gpet7WqLXvtem45UTM5/EhNuUCbYDjOxDKHTgcWg
	 F0OpqkoHdW3IUKYee5YbLJ6+721MKJ+Gawpt/c8FP43yfcZrPqlpjDigHJwrzmRbFLfnp
	 kN+ruioGayMXvNaosaj8YdxpkQ9+uZ2PSDlFcNKPStj/CBSwdrYFCwkmG8eORRhBDOpF0
	 1DBN7ekxM7jmQBy+1r3X22rUoVRNkH5sV4fe8mJ6FRczLKNXV/KlLGpLOmnY4HM1TJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793154464;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=f2V+QhR3ouV+4TSh8wb5W05ywr0Fs0XryAtmuVyoRSs=;
	b=NE5j7pJufGOJ3KQIKz+N4+icFBp37GjBrpMEJzr+XB5mmfJugT+invM7xm5wjw31ESQ0
	 r5iCcXougVHdQyH3hYSXEA4cNYz7kDbwmO3eTDwodQiTfixR9r88W2WELEnMT+QKj97jQ
	 dKqlOfaL2nLfNsRMUMUjxdPdWIfF/GsUpuGgGFVEtqI6O4/TvJbJZLAzl2lOYUTWqM6mv
	 GGWnF9Yr3gVf2k7zBf91+wK8IKiNjy55+NKLeZB1bad7atKjs13BinWaJm/bsMQAlu0Ku
	 YknzEp8710RAJw5vv9dxM4op6G/nTWxU61XEHUJvujv+jGNGSU/43OEfdMWyLAKWnyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0A9OvlS+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB15606A31F;
	Wed, 28 Oct 2026 02:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0A9OvlS+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70C81F01829;
	Wed, 28 Oct 2026 02:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793154464;
	bh=f2V+QhR3ouV+4TSh8wb5W05ywr0Fs0XryAtmuVyoRSs=;
	h=Date:To:From:Subject;
	b=0A9OvlS+JxUiHBPb9vXDTpKpWxq+0VQIhsQ38B9S6k/Ryna4tGQAUaRpf/KdiPqWY
	 C+vfuVXJfxvJuuJ5mGyroM0jBH4oFUSNgZL3pJ3gS/gORarho/V4c7cDOqdz3sfHS1
	 pdFy8mLf1TYsnJxjXoZlxq2hEMYyo3IH+aI2pwaQ=
Date: Tue, 27 Oct 2026 19:27:43 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	stable@vger.kernel.org,rppt@kernel.org,qi.zheng@linux.dev,pfalcato@suse.de,
	mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jack@suse.cz,
	david@kernel.org,ayushr@modal.com,baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-fix-truncation-removing-mapped-folios.patch added to mm-hotfixes-unstable branch
Message-Id: <20261028022743.E70C81F01829@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: memory: fix truncation removing mapped folios
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-fix-truncation-removing-mapped-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-fix-truncation-removing-mapped-folios.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: memory: fix truncation removing mapped folios
Date: Wed, 28 Oct 2026 08:52:57 +0800

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

After analysis, I believe the race exists between truncation and MADV_DONTNEED,
and shmem's ->map_pages() merely makes the issue easier to reproduce. Since
MADV_DONTNEED synchronously releases the pagetable page before calling
tlb_flush_rmaps(), this could cause another thread's truncation to skip
zap_pte_range() (due to pmd is none) but still observe the folio's mapcount
as non-zero. A possible race scenario is as follows:

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

To fix this issue, we should move the pmd clear operation (via zap_empty_pte_table())
to after tlb_flush_rmaps() and use sync_with_folio_pmd_zap() to sync with
concurrent zapping, so that when we find a pmd_none() while unmapping a folio
without holding the PTL, the folio's mappings are guaranteed to have been
removed via tlb_flush_rmaps().

Meanwhile move the second pmd_none() check to where it belongs: if splitting
zapped the PMD.

Link: https://lore.kernel.org/14ebbd556cc4941f0ebc43da59fa6a2fdca25dc8.1793148609.git.baolin.wang@linux.alibaba.com
Link: https://lore.kernel.org/all/20260925065013.3682431-1-ayushr@modal.com/ [1]
Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Ayush Ranjan <ayushr@modal.com>
Closes: https://lore.kernel.org/all/20260924061708.1645968-1-ayushr@modal.com/
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
---

 mm/internal.h |   10 ++++++----
 mm/memory.c   |   35 ++++++++++++++++++++---------------
 2 files changed, 26 insertions(+), 19 deletions(-)

--- a/mm/internal.h~mm-memory-fix-truncation-removing-mapped-folios
+++ a/mm/internal.h
@@ -584,14 +584,16 @@ void free_pgtables(struct mmu_gather *tl
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
+ * zap_huge_pmd() may have cleared the PMD but not yet updated the folio
+ * mapcount, and zap_empty_pte_table() clears the PMD only after the rmaps
+ * for the table have been removed, but nothing orders the pmd_none() read
+ * against later mapcount reads. Skipping the PMD without synchronization
+ * could make folio unmapping code assume that unmapping failed.
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
@@ -2080,18 +2089,12 @@ retry:
 	 * to hold the pmd lock failed, then we need to recheck all pte entries
 	 * to ensure they are still none, thereby preventing the pte entries
 	 * from being repopulated by another thread.
+	 *
+	 * Clear the PMD after the rmaps for the table have been removed, in case
+	 * an incorrect mapcount is observed after unmapping the folio.
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
@@ -2138,13 +2141,15 @@ static inline unsigned long zap_pmd_rang
 				addr = next;
 				continue;
 			}
+			/* We already synchronized with concurrent zapping. */
+			if (pmd_none(*pmd)) {
+				addr = next;
+				continue;
+			}
 			/* fall through */
-		} else if (details && details->single_folio &&
-			   folio_test_pmd_mappable(details->single_folio) &&
-			   next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
-			sync_with_folio_pmd_zap(tlb->mm, pmd);
-		}
-		if (pmd_none(*pmd)) {
+		} else if (pmd_none(*pmd)) {
+			if (details && details->single_folio)
+				sync_with_folio_pmd_zap(tlb->mm, pmd);
 			addr = next;
 			continue;
 		}
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-memory-fix-truncation-removing-mapped-folios.patch


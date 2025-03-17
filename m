Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE66215782
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188297; cv=none; b=rGpY0DrAWn25mHqUsR953Xj+i5hs15ndc3+pMAvq0wQOyXH4y8fw3ixZUm/ZFewh3ulGEhD+oGWtC1cyFVJeT5fcE7fzBg3ogBT1go2pZ6fbu2hLTCS6/2sM82hc3zPGX8yG49oto24LjGzMr7UVL8qGdAVyAqJA8Yyy5DukF7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188297; c=relaxed/simple;
	bh=d36pe1pTejTf6GGUQM0yOBKf42Gfvh4v/7Zw+KC1mSM=;
	h=Date:To:From:Subject:Message-Id; b=IiuFN6mxBCKj193DOs1297CeqTtiF9iOkSIAfM34rKrwBnFbwtKxr4+OlWLB+OxD0N+2M7Sp6tkGVNP2hy2XOcHxSfGLS91JlsLwGyT56F6fvLgBE6V1sxCU4FjiLMQgAxZNQXkBzlTD3rlSwY7qMx7qqwRMu6RiaPghpJmx5k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kaac+Ffu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kaac+Ffu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4A8C4CEEC;
	Mon, 17 Mar 2025 05:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188297;
	bh=d36pe1pTejTf6GGUQM0yOBKf42Gfvh4v/7Zw+KC1mSM=;
	h=Date:To:From:Subject:From;
	b=kaac+Ffu0l2l1nTEYTYcr0U5VHohOejb633Dt0UW8ETFwZ/lu60hV2mChafkkR7PT
	 Hr5vsznoxZ8MX1d5tfJb5ya+26uEsfFO92TqDlGrQgO6WZbBviUQh9NAJcGTjMXi97
	 /1RjJd3yPzOCZrRadwgekc8T7in0J8WJY6px3xIA=
Date: Sun, 16 Mar 2025 22:11:37 -0700
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,yosryahmed@google.com,ying.huang@intel.com,yangyicong@hisilicon.com,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shahuang@redhat.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,mingo@redhat.com,mfo@canonical.com,mark.rutland@arm.com,lorenzo.stoakes@oracle.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,ioworker0@gmail.com,hpa@zytor.com,gshan@redhat.com,david@redhat.com,dave.hansen@linux.intel.com,chrisl@kernel.org,catalin.marinas@arm.com,bp@alien8.de,baolin.wang@linux.alibaba.com,aou@eecs.berkeley.edu,anshuman.khandual@arm.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-set-folio-swapbacked-iff-folios-are-dirty-in-try_to_unmap_one.patch removed from -mm tree
Message-Id: <20250317051137.8C4A8C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: set folio swapbacked iff folios are dirty in try_to_unmap_one
has been removed from the -mm tree.  Its filename was
     mm-set-folio-swapbacked-iff-folios-are-dirty-in-try_to_unmap_one.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: set folio swapbacked iff folios are dirty in try_to_unmap_one
Date: Fri, 14 Feb 2025 22:30:12 +1300

Patch series "mm: batched unmap lazyfree large folios during reclamation",
v4.

Commit 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during
shrink_folio_list()") prevents the splitting of MADV_FREE'd THP in
madvise.c.  

However, those folios are still added to the deferred_split list in
try_to_unmap_one() because we are unmapping PTEs and removing rmap entries
one by one.

Firstly, this has rendered the following counter somewhat confusing,
/sys/kernel/mm/transparent_hugepage/hugepages-size/stats/split_deferred
The split_deferred counter was originally designed to track operations
such as partial unmap or madvise of large folios.  However, in practice,
most split_deferred cases arise from memory reclamation of aligned
lazyfree mTHPs as observed by Tangquan.  This discrepancy has made the
split_deferred counter highly misleading.

Secondly, this approach is slow because it requires iterating through each
PTE and removing the rmap one by one for a large folio.  In fact, all PTEs
of a pte-mapped large folio should be unmapped at once, and the entire
folio should be removed from the rmap as a whole.

Thirdly, it also increases the risk of a race condition where lazyfree
folios are incorrectly set back to swapbacked, as a speculative folio_get
may occur in the shrinker's callback.

deferred_split_scan() might call folio_try_get(folio) since we have added
the folio to split_deferred list while removing rmap for the 1st subpage,
and while we are scanning the 2nd to nr_pages PTEs of this folio in
try_to_unmap_one(), the entire mTHP could be transitioned back to
swap-backed because the reference count is incremented, which can make
"ref_count == 1 + map_count" within try_to_unmap_one() false.

   /*
    * The only page refs must be one from isolation
    * plus the rmap(s) (dropped by discard:).
    */
   if (ref_count == 1 + map_count &&
       (!folio_test_dirty(folio) ||
        ...
        (vma->vm_flags & VM_DROPPABLE))) {
           dec_mm_counter(mm, MM_ANONPAGES);
           goto discard;
   }

This patchset resolves the issue by marking only genuinely dirty folios as
swap-backed, as suggested by David, and transitioning to batched unmapping
of entire folios in try_to_unmap_one().  Consequently, the deferred_split
count drops to zero, and memory reclamation performance improves
significantly — reclaiming 64KiB lazyfree large folios is now 2.5x
faster(The specific data is embedded in the changelog of patch 3/4).

By the way, while the patchset is primarily aimed at PTE-mapped large
folios, Baolin and Lance also found that try_to_unmap_one() handles
lazyfree redirtied PMD-mapped large folios inefficiently — it splits the
PMD into PTEs and iterates over them.  This patchset removes the
unnecessary splitting, enabling us to skip redirtied PMD-mapped large
folios 3.5X faster during memory reclamation.  (The specific data can be
found in the changelog of patch 4/4).


This patch (of 4):

The refcount may be temporarily or long-term increased, but this does not
change the fundamental nature of the folio already being lazy- freed. 
Therefore, we only reset 'swapbacked' when we are certain the folio is
dirty and not droppable.

Link: https://lkml.kernel.org/r/20250214093015.51024-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20250214093015.51024-2-21cnbao@gmail.com
Fixes: 6c8e2a256915 ("mm: fix race between MADV_FREE reclaim and blkdev direct IO read")
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <ioworker0@gmail.com>
Cc: Mauricio Faria de Oliveira <mfo@canonical.com>
Cc: Chis Li <chrisl@kernel.org> (Google)
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Tangquan Zheng <zhengtangquan@oppo.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Shaoqin Huang <shahuang@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   49 ++++++++++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 27 deletions(-)

--- a/mm/rmap.c~mm-set-folio-swapbacked-iff-folios-are-dirty-in-try_to_unmap_one
+++ a/mm/rmap.c
@@ -1963,34 +1963,29 @@ static bool try_to_unmap_one(struct foli
 				 */
 				smp_rmb();
 
-				/*
-				 * The only page refs must be one from isolation
-				 * plus the rmap(s) (dropped by discard:).
-				 */
-				if (ref_count == 1 + map_count &&
-				    (!folio_test_dirty(folio) ||
-				     /*
-				      * Unlike MADV_FREE mappings, VM_DROPPABLE
-				      * ones can be dropped even if they've
-				      * been dirtied.
-				      */
-				     (vma->vm_flags & VM_DROPPABLE))) {
-					dec_mm_counter(mm, MM_ANONPAGES);
-					goto discard;
-				}
-
-				/*
-				 * If the folio was redirtied, it cannot be
-				 * discarded. Remap the page to page table.
-				 */
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				/*
-				 * Unlike MADV_FREE mappings, VM_DROPPABLE ones
-				 * never get swap backed on failure to drop.
-				 */
-				if (!(vma->vm_flags & VM_DROPPABLE))
+				if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
+					/*
+					 * redirtied either using the page table or a previously
+					 * obtained GUP reference.
+					 */
+					set_pte_at(mm, address, pvmw.pte, pteval);
 					folio_set_swapbacked(folio);
-				goto walk_abort;
+					goto walk_abort;
+				} else if (ref_count != 1 + map_count) {
+					/*
+					 * Additional reference. Could be a GUP reference or any
+					 * speculative reference. GUP users must mark the folio
+					 * dirty if there was a modification. This folio cannot be
+					 * reclaimed right now either way, so act just like nothing
+					 * happened.
+					 * We'll come back here later and detect if the folio was
+					 * dirtied when the additional reference is gone.
+					 */
+					set_pte_at(mm, address, pvmw.pte, pteval);
+					goto walk_abort;
+				}
+				dec_mm_counter(mm, MM_ANONPAGES);
+				goto discard;
 			}
 
 			if (swap_duplicate(entry) < 0) {
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952971DA4E
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 04:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738123796; cv=none; b=gMSJCHrvL4Ykr1IIvlvSMhhjwRZ/Ult8et5e7ba7W6PJQT4/rVi7W2cwM8FShEGiQpolluSPnJPq4l7BosUb42hyMVih5Auim+lgADHHB4wo1sGYkXkaEyqcXzC6W+bjHUu2QWbnYHDgFMclDZGNV7xMZZd/7QRKd6ENNoVi0w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738123796; c=relaxed/simple;
	bh=kKZbo+LV7Q6m89O7BKjHt9/rN7EhvQykwOXlwHlTmgM=;
	h=Date:To:From:Subject:Message-Id; b=RjlrxVJZr3R0WGwmZuiszTOuwQ95Xjps6RP13lN2lCwjncUuPkRbkexi0bw4szkWWK0HEHwiId3UwSy5coHX7oJeFdZYHT7Gz95ks1TVyNytkQx0Sn70wPfCm8j5yfhzIDKoE+As+aIxP/YmzqbYXt9wlFdsJK8O5JUxS7w4ooA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U498IRJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U498IRJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5F4C4CED3;
	Wed, 29 Jan 2025 04:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738123796;
	bh=kKZbo+LV7Q6m89O7BKjHt9/rN7EhvQykwOXlwHlTmgM=;
	h=Date:To:From:Subject:From;
	b=U498IRJeqJF5C2if/dlJYzMgc7/NuWyne7ekTfWcpmJRM0JH7oNbKI1m5cUk9XKBQ
	 WT4ZckojL6RPZxPIx1z9glk366iKzOtLX+GnmmcflvwUzAVBMGBjaLddeLsjFRRB76
	 /AQLbE5zdLeotc2ydZvMROIKYQ4WwKiX/qhT3fh8=
Date: Tue, 28 Jan 2025 20:09:55 -0800
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,yosryahmed@google.com,ying.huang@intel.com,yangyicong@hisilicon.com,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shahuang@redhat.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,mingo@redhat.com,mfo@canonical.com,mark.rutland@arm.com,lorenzo.stoakes@oracle.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,ioworker0@gmail.com,hpa@zytor.com,gshan@redhat.com,david@redhat.com,dave.hansen@linux.intel.com,chrisl@kernel.org,catalin.marinas@arm.com,bp@alien8.de,baolin.wang@linux.alibaba.com,aou@eecs.berkeley.edu,anshuman.khandual@arm.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-set-folio-swapbacked-iff-folios-are-dirty-in-try_to_unmap_one.patch added to mm-unstable branch
Message-Id: <20250129040956.1B5F4C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: set folio swapbacked iff folios are dirty in try_to_unmap_one
has been added to the -mm mm-unstable branch.  Its filename is
     mm-set-folio-swapbacked-iff-folios-are-dirty-in-try_to_unmap_one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-set-folio-swapbacked-iff-folios-are-dirty-in-try_to_unmap_one.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: set folio swapbacked iff folios are dirty in try_to_unmap_one
Date: Wed, 15 Jan 2025 16:38:05 +1300

Patch series "mm: batched unmap lazyfree large folios during reclamation",
v3.

Commit 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during
shrink_folio_list()") prevents the splitting of MADV_FREE'd THP in
madvise.c.  However, those folios are still added to the deferred_split
list in try_to_unmap_one() because we are unmapping PTEs and removing rmap
entries one by one.

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
may occur in the shrinker's callback.  deferred_split_scan() might call
folio_try_get(folio) since we have added the folio to split_deferred list
while removing rmap for the 1st subpage, and while we are scanning the 2nd
to nr_pages PTEs of this folio in try_to_unmap_one(), the entire mTHP
could be transitioned back to swap-backed because the reference count is
incremented, which can make "ref_count == 1 + map_count" within
try_to_unmap_one() false.

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

Link: https://lkml.kernel.org/r/20250115033808.40641-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20250115033808.40641-2-21cnbao@gmail.com
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
@@ -1868,34 +1868,29 @@ static bool try_to_unmap_one(struct foli
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

mm-set-folio-swapbacked-iff-folios-are-dirty-in-try_to_unmap_one.patch
mm-support-tlbbatch-flush-for-a-range-of-ptes.patch
mm-support-batched-unmap-for-lazyfree-large-folios-during-reclamation.patch
mm-avoid-splitting-pmd-for-lazyfree-pmd-mapped-thp-in-try_to_unmap.patch


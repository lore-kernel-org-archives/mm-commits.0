Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C2553E24
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 20:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718742735; cv=none; b=q0otCUDjmMJ3RyXOTpNYW/uFHf+fESM4XGDAEp33Js0ksFPOg3957OjyFHmspQckWLW7df6p1ABwIFG/mLkrdeBORIB9BYW/76NhahxYMy5l2MrlDe4FCBRrJsevNOeJ1fQIbw3DN6RO4v4s739+AKMsOOjd2HMSHTJLoPPQDac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718742735; c=relaxed/simple;
	bh=DvazxhjRmrenTb0+A99jBxGi7/Bom3Lv+L2XtoXH2/Q=;
	h=Date:To:From:Subject:Message-Id; b=ZN5KEDeOPLPxWU4a3K9fXUS5cxr3qkrZyAi+IOOiq4ED3hUxhDysYS5IwXsbB21knS+F89dfNQq2d0Nzi6OqfV3FCqCRt7hE6DVLRPx1q4REd0elG5jHjOfC7soIBqxDfQ2cQl099Ow0wCNORURp4YWhuixq7jEb+kL1mDSSHoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lKKctQH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lKKctQH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E626C3277B;
	Tue, 18 Jun 2024 20:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718742735;
	bh=DvazxhjRmrenTb0+A99jBxGi7/Bom3Lv+L2XtoXH2/Q=;
	h=Date:To:From:Subject:From;
	b=lKKctQH59wWBEy3RDhowVVrBvEZVqS5BS41M0fGj82Ol2DJ8/dolnFvkQ2zpsgpLQ
	 ZpljjKlKcFJUAPTUYiMgwXeCywtgga4L8ZUwOHbhM0p94U9sF/LraUtzCg9B8OHOJg
	 yEmSlEm+cdOfmHe0onOH5O24bWy0ykz2MgcfJJko=
Date: Tue, 18 Jun 2024 13:32:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-add-validation-before-spliting-shmem-large-folio.patch added to mm-unstable branch
Message-Id: <20240618203215.1E626C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: add validation before spliting shmem large folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-add-validation-before-spliting-shmem-large-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-add-validation-before-spliting-shmem-large-folio.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: vmscan: add validation before spliting shmem large folio
Date: Tue, 18 Jun 2024 14:54:13 +0800

Patch series "support large folio swap-out and swap-in for shmem", v2.

Shmem will support large folio allocation [1] [2] to get a better
performance, however, the memory reclaim still splits the precious large
folios when trying to swap-out shmem, which may lead to the memory
fragmentation issue and can not take advantage of the large folio for
shmeme.

Moreover, the swap code already supports for swapping out large folio
without split, and large folio swap-in[3] series is queued into
mm-unstable branch.  Hence this patch set also supports the large folio
swap-out and swap-in for shmem.

Functional testing
==================

Machine environment: 32 Arm cores, 120G memory and 50G swap device.

1. Run xfstests suite to test tmpfs filesystem, and I did not catch any
   regressions with this patch set.

FSTYP=tmpfs
export TEST_DIR=/mnt/tempfs_mnt
export TEST_DEV=/mnt/tempfs_mnt
export SCRATCH_MNT=/mnt/scratchdir
export SCRATCH_DEV=/mnt/scratchdir

2. Run all mm selftests in tools/testing/selftests/mm/, and no
   regressions found.

3. I also wrote several shmem swap test cases, including shmem
   splitting, shmem swapout, shmem swapin, swapoff during shmem swapout,
   shmem reclaim, shmem swapin replacement, etc.  I tested these cases
   under 4K and 64K shmem folio sizes with a swap device, and shmem swap
   functionality works well on my machine (I can share these test cases if
   needed).

[1] https://lore.kernel.org/all/cover.1717495894.git.baolin.wang@linux.alibaba.com/
[2] https://lore.kernel.org/all/20240515055719.32577-1-da.gomez@samsung.com/
[3] https://lore.kernel.org/all/20240508224040.190469-6-21cnbao@gmail.com/T/
[4] https://lore.kernel.org/all/8db63194-77fd-e0b8-8601-2bbf04889a5b@google.com/


This patch (of 9):

Add swap available space validation before spliting shmem large folio to
avoid redundant split, since we can not write shmem folio to the swap
device in this case.

Link: https://lkml.kernel.org/r/cover.1718690645.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/413866f2f2d996cfbb5c906467b36c96b1a82e2d.1718690645.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/vmscan.c~mm-vmscan-add-validation-before-spliting-shmem-large-folio
+++ a/mm/vmscan.c
@@ -1237,6 +1237,14 @@ retry:
 			}
 		} else if (folio_test_swapbacked(folio) &&
 			   folio_test_large(folio)) {
+
+			/*
+			 * Do not split shmem folio if no swap memory
+			 * available.
+			 */
+			if (!total_swap_pages)
+				goto activate_locked;
+
 			/* Split shmem folio */
 			if (split_folio_to_list(folio, folio_list))
 				goto keep_locked;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix-fix.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-3.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem-fix.patch
mm-memcontrol-add-vm_bug_on_folio-to-catch-lru-folio-in-mem_cgroup_migrate.patch
mm-vmscan-add-validation-before-spliting-shmem-large-folio.patch
mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch
mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch
mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch
mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch
mm-shmem-support-large-folio-swap-out.patch


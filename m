Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F19B217659;
	Fri, 22 May 2026 02:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779415620; cv=none; b=oQYqHNMkT6nhR12Wu/5WMhdHfWTn7vMP389gt3ilQ8HyrhQuxF905CeuP+lsARdyeXeE6cQ7Xl7FUxvKGm6eyGVofo3GYtUC4l40IP92KHJ62aZubTaVrePVKX1Dwc0NTklEXt68At7/Xc1k5QQz2OvEgDO97NpXMaqEnddj5Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779415620; c=relaxed/simple;
	bh=NyqgvsGe4QmJdovZ0+0/NcL5LjkkjgrWeSDVqrbdlMA=;
	h=Date:To:From:Subject:Message-Id; b=kV40c8dlybSsRHpqOObn+dTnsAvlCXYPLfs4EFqWn8kVhQbCeaswSH/S1xK0Xvn86AoTd4X3CUJ5Cj3UGs5juVXCySDPYyUiIfzaJBe7G6R+F/WA8XjElF/fzhISqYjfeXERQJ0CDd9QpBkS6T0aXcnaRPbMIVfF9JV9tY51RoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O7+EWDTy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O7+EWDTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6703F1F00A3D;
	Fri, 22 May 2026 02:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779415619;
	bh=UBt7RjRz3IdEUM013ugty2AkkP3olofew1BSbrqZfEM=;
	h=Date:To:From:Subject;
	b=O7+EWDTyTwHVYoVSMLwi1B4Oir8OTZRSoCJwGJKi2rGrLkUvJR3ckxAlMdbuWRp8k
	 zt5A3tBe6bePwb1HuKSqaJpzSQdk5NaLUMlNzFiSXbrFRtU6Zx+LAZl5I/myCi0VZS
	 rF94VZQ4CXJbFmXNaOrZo8MBlxQ+/JdG3tQPBdwE=
Date: Thu, 21 May 2026 19:06:59 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,riel@surriel.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,harry@kernel.org,david@kernel.org,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-rmap-initialize-nr_pages-to-1-at-loop-start-in-try_to_unmap_one.patch removed from -mm tree
Message-Id: <20260522020659.6703F1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: initialize nr_pages to 1 at loop start in try_to_unmap_one
has been removed from the -mm tree.  Its filename was
     mm-rmap-initialize-nr_pages-to-1-at-loop-start-in-try_to_unmap_one.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/rmap: initialize nr_pages to 1 at loop start in try_to_unmap_one
Date: Mon, 18 May 2026 12:06:56 +0530

Initialize nr_pages to 1 at the start of each loop iteration, like
folio_referenced_one() does.

Without this, nr_pages computed by a previous folio_unmap_pte_batch() call
can be reused on a later iteration that does not run
folio_unmap_pte_batch() again.

mmap a 64K large folio with MAP_ANONYMOUS | MAP_DROPPABLE, then call
madvise(MADV_FREE), then make the last page device-exclusive via
HMM_DMIRROR_EXCLUSIVE.

Trigger node reclaim through sysfs.  Now, in try_to_unmap_one(), we will
first clear the first 15 out of 16 entries mapping the lazyfree folio. 
This will set nr_pages to 15.  In the next pvmw walk, this nr_pages gets
reused on a device-exclusive pte, thus potentially corrupting folio
refcount/mapcount.

At the moment, I have a userspace program which can make the kernel spit
out a trace, but the blow up is in folio_referenced_one(), because there
are existing bugs in the interaction between device-private and rmap
(which too I am investigating).  I did a one liner kernel change to avoid
going into folio_referenced_one(), and the kernel blows up at
folio_remove_rmap_ptes in try_to_unmap_one which is what I wanted.

Note that the bug is there not since file folio batching but lazyfree
folio batching, since device-exclusive only works for anonymous folios.

Userspace visible effect is simply kernel crashing somewhere due to
refcount/mapcount corruption.

Link: https://lore.kernel.org/20260518063656.3721056-1-dev.jain@arm.com
Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/rmap.c~mm-rmap-initialize-nr_pages-to-1-at-loop-start-in-try_to_unmap_one
+++ a/mm/rmap.c
@@ -2030,6 +2030,8 @@ static bool try_to_unmap_one(struct foli
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(&pvmw)) {
+		nr_pages = 1;
+
 		/*
 		 * If the folio is in an mlock()d vma, we must not swap it out.
 		 */
_

Patches currently in -mm which might be from dev.jain@arm.com are

selftests-mm-simplify-byte-pattern-checking-in-mremap_test.patch
mm-khugepaged-generalize-alloc_charge_folio.patch


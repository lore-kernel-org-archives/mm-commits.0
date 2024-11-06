Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164F71534E9
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854735; cv=none; b=j7tEuETuuIKIr+B+bHZLiAoiVir5YwcA33u/eZbtQYlTz1iwhqnWwAZvk0tL91/84c074liGhy0XSoxtyA/HTAv86irLuT7gOpEOzSaJ3D5zFGxjtsui9FOQk1b70PiojEBTJuR3oZQ0GqFDC6ovyQTSepBKx4SR2EPwvTTnqVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854735; c=relaxed/simple;
	bh=F4k5zQakCs2oIc43q+hNFfheaOm4qThJqGncsOdsuq4=;
	h=Date:To:From:Subject:Message-Id; b=MO2ovPozxGoc+pkLNNU9+K7K2T2gD6kKAh07aY7quNZYXcDp365xf2IReAbzFbVPxkngueMw44vfkgNMnc6MEOAVQS4LiRM8YNtWFiyxKtpER1Aq9uqIsQRn6AGugM5jl08hwvM1nksxC9oBVrQBWbhme9mN1s++357H/8tz9QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yqWPqJqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yqWPqJqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF0CC4CECF;
	Wed,  6 Nov 2024 00:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854735;
	bh=F4k5zQakCs2oIc43q+hNFfheaOm4qThJqGncsOdsuq4=;
	h=Date:To:From:Subject:From;
	b=yqWPqJqjIQn4VwjqsR0/IcxWkCKFbxq8GTx8MJRBYBOw+yO/AWUH04GSSxKRl4RmX
	 YFuYIT31aDeXvqeJALEVHW02aJCuyUCiUi/tHU1+1Mp5CbfPTDz9JaubDl/3BbXhqi
	 xR6OVbYxJ7G4Hx3CM8vFM//Rig7PDQVW9uFHRCfo=
Date: Tue, 05 Nov 2024 16:58:54 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-move_ptes-use-pte_offset_map_rw_nolock.patch removed from -mm tree
Message-Id: <20241106005854.DFF0CC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mremap: move_ptes() use pte_offset_map_rw_nolock()
has been removed from the -mm tree.  Its filename was
     mm-mremap-move_ptes-use-pte_offset_map_rw_nolock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: mremap: move_ptes() use pte_offset_map_rw_nolock()
Date: Thu, 26 Sep 2024 14:46:22 +0800

In move_ptes(), we may modify the new_pte after acquiring the new_ptl, so
convert it to using pte_offset_map_rw_nolock().  Now new_pte is none, so
hpage_collapse_scan_file() path can not find this by traversing
file->f_mapping, so there is no concurrency with retract_page_tables(). 
In addition, we already hold the exclusive mmap_lock, so this new_pte page
is stable, so there is no need to get pmdval and do pmd_same() check.

Link: https://lkml.kernel.org/r/9d582a09dbcf12e562ac5fe0ba05e9248a58f5e0.1727332572.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-move_ptes-use-pte_offset_map_rw_nolock
+++ a/mm/mremap.c
@@ -140,6 +140,7 @@ static int move_ptes(struct vm_area_stru
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *old_pte, *new_pte, pte;
+	pmd_t dummy_pmdval;
 	spinlock_t *old_ptl, *new_ptl;
 	bool force_flush = false;
 	unsigned long len = old_end - old_addr;
@@ -175,7 +176,15 @@ static int move_ptes(struct vm_area_stru
 		err = -EAGAIN;
 		goto out;
 	}
-	new_pte = pte_offset_map_nolock(mm, new_pmd, new_addr, &new_ptl);
+	/*
+	 * Now new_pte is none, so hpage_collapse_scan_file() path can not find
+	 * this by traversing file->f_mapping, so there is no concurrency with
+	 * retract_page_tables(). In addition, we already hold the exclusive
+	 * mmap_lock, so this new_pte page is stable, so there is no need to get
+	 * pmdval and do pmd_same() check.
+	 */
+	new_pte = pte_offset_map_rw_nolock(mm, new_pmd, new_addr, &dummy_pmdval,
+					   &new_ptl);
 	if (!new_pte) {
 		pte_unmap_unlock(old_pte, old_ptl);
 		err = -EAGAIN;
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are



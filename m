Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE1C189913
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854888; cv=none; b=rB8nt2HNV5dbUuuX1pa4B1BsW0GMetliiOL1T5Qg02NZpKtSo/zY19GZWvyLUT1IXUKCz2SEZMeK7EW4a2Nhp5hh6q7dxomJq0B/D/n8bUoJDn/dfQzSLz1BLbhhjyW/4SzBqzB2x45vLj5pJKtQ4H/ep1dHDM1LJJL3rsiBFzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854888; c=relaxed/simple;
	bh=sQWXVlE17Xc7DsnZx8g3utPmTZc+fYAMrtC7kx+ZRQU=;
	h=Date:To:From:Subject:Message-Id; b=utCH7btEHol5fMV3PFaZtE/k4qRGCs9fS+2sVjC+RgHoTTKz8FwTzhCBQ9p7snPaVuynJUHatU1SPoTUrCATW+qmUBx5s83DugSAtc2hFsdh6qnkUe3V+5a2g3jUo1nfZGL6vx9OS0yuLqaijo1r/j6xoH+uzZJ3CRNiyTY0BQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1m7fHe8z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1m7fHe8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706D2C4CECF;
	Wed,  6 Nov 2024 01:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854888;
	bh=sQWXVlE17Xc7DsnZx8g3utPmTZc+fYAMrtC7kx+ZRQU=;
	h=Date:To:From:Subject:From;
	b=1m7fHe8zEI7aAY2RF1ZoCyqlr4iWg4V8XOFBAVIhhnf/dShnF2NmUwr1fCampVJm1
	 px2UwOoVHn2KJlsSrKQ6iaXgib9xfRjzTlHKO+MzyADy4tTEmv2Y3QGwQbbQWZzhjO
	 ujAeR1plAGhE4qg+pCaaTpyd/av8D845BC8/yeJw=
Date: Tue, 05 Nov 2024 17:01:27 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-the-pgoff-is-correct-if-can_merge_right.patch removed from -mm tree
Message-Id: <20241106010128.706D2C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: the pgoff is correct if can_merge_right
has been removed from the -mm tree.  Its filename was
     mm-vma-the-pgoff-is-correct-if-can_merge_right.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/vma: the pgoff is correct if can_merge_right
Date: Thu, 24 Oct 2024 09:33:47 +0000

By this point can_vma_merge_right() must have returned true, which implies
can_vma_merge_before() also returned true, which already asserts that the
pgoff is as expected for a merge with the following VMA, thus this
assignment is redundant.

Below is a more detail explanation.

Current definition of can_vma_merge_right() is:

	static bool can_vma_merge_right(struct vma_merge_struct *vmg,
					bool can_merge_left)
	{
		if (!vmg->next || vmg->end != vmg->next->vm_start ||
		    !can_vma_merge_before(vmg))
			return false;
		...
	}

And:

	static bool can_vma_merge_before(struct vma_merge_struct *vmg)
	{
		pgoff_t pglen = PHYS_PFN(vmg->end - vmg->start);
	...
			if (vmg->next->vm_pgoff == vmg->pgoff + pglen)
				return true;
	...
	}

Which implies vmg->pgoff == vmg->next->vm_pgoff - pglen.

None of these values are changed between the check and prior assignment,
so this was an entirely redundant assignment.


[akpm@linux-foundation.org: remove now-unused local]
[lorenzo.stoakes@oracle.com: rephrase the changelog]
Link: https://lkml.kernel.org/r/20241024093347.18057-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/vma.c~mm-vma-the-pgoff-is-correct-if-can_merge_right
+++ a/mm/vma.c
@@ -962,9 +962,7 @@ struct vm_area_struct *vma_merge_new_ran
 {
 	struct vm_area_struct *prev = vmg->prev;
 	struct vm_area_struct *next = vmg->next;
-	unsigned long start = vmg->start;
 	unsigned long end = vmg->end;
-	pgoff_t pglen = PHYS_PFN(end - start);
 	bool can_merge_left, can_merge_right;
 	bool just_expand = vmg->merge_flags & VMG_FLAG_JUST_EXPAND;
 
@@ -986,7 +984,6 @@ struct vm_area_struct *vma_merge_new_ran
 	if (can_merge_right) {
 		vmg->end = next->vm_end;
 		vmg->vma = next;
-		vmg->pgoff = next->vm_pgoff - pglen;
 	}
 
 	/* If we can merge with the previous VMA, adjust vmg accordingly. */
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mlock-set-the-correct-prev-on-failure.patch
maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch
maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch
maple_tree-not-necessary-to-check-index-last-again.patch
maple_tree-refine-mas_store_root-on-storing-null.patch
maple_tree-add-a-test-checking-storing-null.patch


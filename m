Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38421318BB3
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 02:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790131618; cv=none; b=iAsz7bOo5uFYwwPQfNkRak8ZPjEGL9CwCrgztWE20K4VLUjtxwgVZsnfLduo9uMpc2VuYAKEe237u7IF8O7WqNcPJcN/HJf7br/tj7XPBcaoeyoAi4JmjIXRM2ZFxLeSJepXawIpGpJxWq/V/ZXrshy7SYioDr/Aq0hz9tSsceA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790131618; c=relaxed/simple;
	bh=8IcN5fQU4piYiKH9BVCoIL1IJvGxxgipbHKqvaJBZos=;
	h=Date:To:From:Subject:Message-Id; b=DJq9Q4PO+Ku+fHuytfbSq0Bc1oYopM//I4vn/fuioZrnjvm4WkaUfv1kvNoSNuqqxEcLYWqLgO9l3Tx+YfmVCGqalqFlQkA7F2/Ir3j/+lr77/HtzSzw+DO1N/W0sRGY1sr+4l26uUGPFn4mRqs6g0vh9PPsiRAFGQnjL52GEOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W79k7nIv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W79k7nIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FC31F000FF;
	Wed, 23 Sep 2026 02:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790131607;
	bh=cawD4KIeRVhWTsh5fDEYJ84Ig8+x3+cWJDy4u+E1HK0=;
	h=Date:To:From:Subject;
	b=W79k7nIvCnH7uikOxwR7o5fgLZ8cPYxVWZjyfaqZRRTmyoGsxEZzuh+3hOKOcLaXy
	 pmm0d9gL9MalwKlYK0OrMxVVrCucUbj2JZSX45vFwA7oB824G4s0GVYdQEqc0NKzgG
	 bHkYVy4L5XX/bPGvN8ohSfZWQEixwTfdWt4aPY60=
Date: Tue, 22 Sep 2026 19:46:47 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,zhenghui.hao@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-fix-stale-comment-in-hugetlbfs_file_mmap.patch added to mm-unstable branch
Message-Id: <20260923024647.92FC31F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlbfs: fix stale comment in hugetlbfs_file_mmap()
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlbfs-fix-stale-comment-in-hugetlbfs_file_mmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-fix-stale-comment-in-hugetlbfs_file_mmap.patch

This patch will later appear in the mm-unstable branch at
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
From: Zhenghui Hao <zhenghui.hao@qq.com>
Subject: hugetlbfs: fix stale comment in hugetlbfs_file_mmap()
Date: Wed, 23 Sep 2026 10:28:58 +0800

The comment above the VMA flag setup in hugetlbfs_file_mmap() says the VMA
address alignment has already been checked by prepare_hugepage_range(). 
That function no longer exists: it was removed by commit eff41389d824
("mm/hugetlb: remove prepare_hugepage_range()"), and the check now lives
in hugetlb_get_unmapped_area().

The comment also mentions ia64, which was removed from the tree by commit
cf8e8658100d ("arch: Remove Itanium (IA-64) architecture").

Point the comment at the current function and drop the ia64 reference. 
The rest of the comment, which tells future edits to add any error return
only after VM_HUGETLB has been set, is still accurate and is left
untouched.

No functional change.

Link: https://lore.kernel.org/tencent_AA61551D1F50E61F46C8542F5C8874512C05@qq.com
Signed-off-by: Zhenghui Hao <zhenghui.hao@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
---

 fs/hugetlbfs/inode.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-fix-stale-comment-in-hugetlbfs_file_mmap
+++ a/fs/hugetlbfs/inode.c
@@ -106,11 +106,10 @@ static int hugetlbfs_file_mmap(struct fi
 
 	/*
 	 * vma address alignment (but not the pgoff alignment) has
-	 * already been checked by prepare_hugepage_range.  If you add
-	 * any error returns here, do so after setting VM_HUGETLB, so
-	 * vma_is_hugetlb tests below unmap_region go the right
-	 * way when do_mmap unwinds (may be important on powerpc
-	 * and ia64).
+	 * already been checked by hugetlb_get_unmapped_area().  If you
+	 * add any error returns here, do so after setting VM_HUGETLB,
+	 * so vma_is_hugetlb tests below unmap_region go the right
+	 * way when do_mmap unwinds (may be important on powerpc).
 	 */
 	vma_set_flags(vma, VMA_HUGETLB_BIT, VMA_DONTEXPAND_BIT);
 	vma->vm_ops = &hugetlb_vm_ops;
_

Patches currently in -mm which might be from zhenghui.hao@qq.com are

mm-hugetlb-fix-misspelled-parameter-names-in-comment.patch
hugetlbfs-fix-stale-comment-in-hugetlbfs_file_mmap.patch


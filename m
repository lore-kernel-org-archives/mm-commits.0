Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832434;
	b=NlADOB6c2hN7XZINIV6C2PoGY+qDn25DHDk2AliUf6f3OKOxX1Cz7T05ZWWkKlQFx52H
	 Tj6xBBT82VCqLXIa/JrQ6W9235sZFunmSitFjJGTRqCOIaB1fpwHoFWMuUrAlpeyVoNNW
	 7R8sY5CJZnR8dqQNgyrmjMLx+Jvyk9cL+6zmrgni+OvxPWcas3D7IbCj2oQQchvAxtFQv
	 QRbxqmY5+p9cuIH9httsnqGiOYpt8yCZnSUvnT8udhogWUvs+3Ks7tZQ2wuzulrj3a+4U
	 q+TCDsLiwjrVcGiNkSRWfm9Ffpms4Gzs6aJjpEEmYeUEFps5rhO6Yesa6h/WZFYi+UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832434;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=NwUUpqjWy4xZRVRuODkupj7q+kayGDIXRaPE68iG6nA=;
	b=FPU/wSe1cZNMETcEUs6py+pBiyh8elmKilRV40nWRcY4k1Eh3anjMsWhJw4CJCeq5wKN
	 YxZbFZT+0X27vO45YRE+tFCvPJN8tRS0yNBHXogwMkxrmDIeNZeGNU3Sr0c0Qtmiks1Tl
	 o+pVBQk4bmbXt0Mk8zhNvQxbZjNoQ6ZBs4nRTsbiCYPmnIZB/wt9D41hii+RNCFvkeXeT
	 9JmcZKNbwOwe5w0OCYXfm5bMpTheyqdBscGfCLurTRuGi3TpmVTJOxf0oY/Kdcx9/o+BB
	 KK4L12c0H59xOIWtT/Q0Qog+uibeBr+zJB9kcqjxMfw8veEzS7pFwWptHdbPNix755g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=a8HSZ+n9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9680606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=a8HSZ+n9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31381F01825;
	Sat, 24 Oct 2026 09:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832433;
	bh=NwUUpqjWy4xZRVRuODkupj7q+kayGDIXRaPE68iG6nA=;
	h=Date:To:From:Subject;
	b=a8HSZ+n9nm95cxZykgCsLI4WuSp/VK/+VuQp76rkJzdpmBUUyW9VFRb+9DqAmpVsQ
	 cGciGK6PIOb6Vg8rGO5gw+UBhMY+8jIj6PZ7rJprUc0ok01F1405mUmpfhzxjCTDb9
	 zoPwvag1q+fOGY88MVm7oeXwvuavyY35E0622HfA=
Date: Sat, 24 Oct 2026 02:00:33 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,zhenghui.hao@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlbfs-fix-stale-comment-in-hugetlbfs_file_mmap.patch removed from -mm tree
Message-Id: <20261024090033.B31381F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: hugetlbfs: fix stale comment in hugetlbfs_file_mmap()
has been removed from the -mm tree.  Its filename was
     hugetlbfs-fix-stale-comment-in-hugetlbfs_file_mmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



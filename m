Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6232C390CA9
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298429; cv=none; b=F07epslXBTjGcn1klsWUJl/NNEmr7PzcBsG7Hx3+c8CDIYA+jFA66e9tMJNlOuKYT54stFHb1Ia5lQXwbS+TlYKakPjslLgJkel7cmZW5SARMibPD8W2rtsAPKWdXALYs3/PU+e3C9jGdgVoj+InwEKSc/lu+A88ap3mnZEOR7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298429; c=relaxed/simple;
	bh=3HuRm51ozRMpTeHyUUCOUnrD3uF60ZaFUhooBC7tk28=;
	h=Date:To:From:Subject:Message-Id; b=B5hdQZqb3A6bJfkQaMdOeD2874OAtYW9RLe5g8bNVN6CoXjYmykSCXtarUz+CKZxE0uzOvRqn6YQxaeBEpSRONh+Ky+Pg0GAJdYWjrBmKtSq3Kr4NuH/7OzOYakwIs6oG4bqLjSsLieDqKpTcfaxjvtz5BuPgnYRiy8RPALFsxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XKZk3+iZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XKZk3+iZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A1A1F00A3A;
	Wed, 29 Jul 2026 04:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298428;
	bh=v2+1XjMyRkNl7vTq7EfWNWqu/Nnm/xefCpVn+XUS7sI=;
	h=Date:To:From:Subject;
	b=XKZk3+iZ/8+ysx5SnlDc+THXgDr0N3zO7RjDLUEku/3yQIeGO6rTC+M3f/YCEoKWR
	 lVLIqQCKk3euAS7NhDkBHJCd2cQip4en/C9ERS8cP84dn0C5ioZ7R1h5Ojaaj+ESp/
	 Q4IpSI6g23zqGtwFAV65HFm+NgLicg8A2pUuqrTI=
Date: Tue, 28 Jul 2026 21:13:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,rakie.kim@sk.com,pfalcato@suse.de,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mlock-use-walk_page_range_vma-in-mlock_vma_pages_range.patch removed from -mm tree
Message-Id: <20260729041348.32A1A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mlock: use walk_page_range_vma() in mlock_vma_pages_range()
has been removed from the -mm tree.  Its filename was
     mm-mlock-use-walk_page_range_vma-in-mlock_vma_pages_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mlock: use walk_page_range_vma() in mlock_vma_pages_range()
Date: Thu, 18 Jun 2026 17:28:44 +0800

The mlock_vma_pages_range() uses walk_page_range() to walk the page table.
Fortunately, the caller always passes start/end that falls within a
single VMA, apply_vma_lock_flags() iterates per-VMA, and
apply_mlockall_flags() passes the whole VMA.

Since there is no .test_walk in mlock_walk_ops and VM_PFNMAP was filtered
by vma_supports_mlock(), it's safe to replace walk_page_range() with
walk_page_range_vma() to eliminate an unnecessary find_vma() lookup.

Link: https://lore.kernel.org/20260618092845.3905740-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mlock.c~mm-mlock-use-walk_page_range_vma-in-mlock_vma_pages_range
+++ a/mm/mlock.c
@@ -446,7 +446,7 @@ static void mlock_vma_pages_range(struct
 	vma_flags_reset_once(vma, new_vma_flags);
 
 	lru_add_drain();
-	walk_page_range(vma->vm_mm, start, end, &mlock_walk_ops, NULL);
+	walk_page_range_vma(vma, start, end, &mlock_walk_ops, NULL);
 	lru_add_drain();
 
 	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-introduce-pud_is_huge-helper.patch
mm-mincore-remove-special-handling-for-vm_pfnmap.patch
mm-mincore-remove-special-handling-for-vm_pfnmap-fix.patch
mm-mincore-replace-__get_free_page-with-kmalloc.patch
mm-mincore-remove-xa_is_value-in-mincore_swap.patch
mm-mincore-improve-mincore_hugetlb.patch
mm-mincore-improve-mincore_hugetlb-fix.patch
mm-mincore-refactor-mincore_page.patch


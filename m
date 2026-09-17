Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598CE3BFAFA
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 04:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789619258; cv=none; b=AyzWHP/OL7T/4IiNFwZ/J+0XYbgJ1nSZqVZ5C/cUuC6rGrBfO92XGsY/M8uz/OPFsSXHkAcg7d0o/+55bVFBHbgNA3NyWCE5kkKLxJa1wK6FhB8ZvoY4VaamlPZ7Xl7S5EYwTr6+qp+BoUEHv4IGLZRsogsqaN6l8n0ORycEHws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789619258; c=relaxed/simple;
	bh=26rJQCZ0LOQ0kqbkASexgYxcgXK2vXpz/swttprom38=;
	h=Date:To:From:Subject:Message-Id; b=hOu0LkH4ghLiofz71ZbPO/o57V3cdFUkLzG+2Lsf8qlekTOer9mZYk4dpKP2H1zx3WGvVyIcWzG06TBH4lrcZtAwd3EY05d3SIaNFV59GCXoqD4Qfy5mmRiTJdmnsBJairxMnFeeq9+nC/5uxAIMk0ULU1xs6RRtmwE3ahkxlhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yLsSwMSi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yLsSwMSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B551F000FF;
	Thu, 17 Sep 2026 04:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789619254;
	bh=3kpO9SwXnLUjld8rrroVSjyRoy3NF7mawpGPKj4npsk=;
	h=Date:To:From:Subject;
	b=yLsSwMSiBlj+kvRewP/KzByu6WFznxwuDGV7DEuSx0uJxpsbLdzWie6S04pewOvyd
	 tkDe+Ub2XisaXI0SWd6L20dLEK4ckyZiNCz/64jgbM0riklCFzFSn7WGqW2vG6tOGb
	 MRwnSHk9v5vbENLpkiwrFhTbmR98hoXShWb2VFDw=
Date: Wed, 16 Sep 2026 21:27:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mincore-use-per-vma-lock-during-page-table-walk.patch added to mm-new branch
Message-Id: <20260917042734.15B551F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mincore: use per-vma lock during page table walk
has been added to the -mm mm-new branch.  Its filename is
     mm-mincore-use-per-vma-lock-during-page-table-walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mincore-use-per-vma-lock-during-page-table-walk.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mincore: use per-vma lock during page table walk
Date: Wed, 16 Sep 2026 12:31:52 +0800

do_mincore() performs a read-only, per-VMA residency query, making it a
good candidate for per-VMA locking.  Convert it to acquire the per-VMA
lock, thereby reducing contention on the per-MM mmap_lock.

Link: https://lore.kernel.org/20260916043153.2631696-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 mm/mincore.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/mm/mincore.c~mm-mincore-use-per-vma-lock-during-page-table-walk
+++ a/mm/mincore.c
@@ -235,24 +235,22 @@ static const struct mm_walk_ops mincore_
 	.pmd_entry		= mincore_pte_range,
 	.pte_hole		= mincore_unmapped_range,
 	.hugetlb_entry		= mincore_hugetlb,
-	.walk_lock		= PGWALK_RDLOCK,
+	.walk_lock		= PGWALK_VMA_RDLOCK_VERIFY,
 };
 
 /*
  * Do a chunk of "sys_mincore()". We've already checked
- * all the arguments, we hold the mmap semaphore: we should
+ * all the arguments, we hold the VMA read lock: we should
  * just return the amount of info we're asked for.
  */
-static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *vec)
+static long do_mincore(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pages, unsigned char *vec)
 {
-	struct vm_area_struct *vma;
-	unsigned long end;
+	unsigned long end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
 	int err;
 
-	vma = vma_lookup(current->mm, addr);
-	if (!vma)
-		return -ENOMEM;
-	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
+	vma_assert_locked(vma);
+
 	if (!can_do_mincore(vma)) {
 		unsigned long pages = DIV_ROUND_UP(end - addr, PAGE_SIZE);
 		memset(vec, 1, pages);
@@ -319,13 +317,20 @@ SYSCALL_DEFINE3(mincore, unsigned long,
 
 	retval = 0;
 	while (pages) {
+		struct vm_area_struct *vma;
+
+		vma = vma_start_read_unlocked(current->mm, start);
+		if (!vma) {
+			retval = -ENOMEM;
+			break;
+		}
+
 		/*
 		 * Do at most PAGE_SIZE entries per iteration, due to
 		 * the temporary buffer size.
 		 */
-		mmap_read_lock(current->mm);
-		retval = do_mincore(start, min(pages, PAGE_SIZE), tmp);
-		mmap_read_unlock(current->mm);
+		retval = do_mincore(vma, start, min(pages, PAGE_SIZE), tmp);
+		vma_end_read(vma);
 
 		if (retval <= 0)
 			break;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

xfs-remove-dead-kswapd-flag-inheritance-from-btree-split-worker.patch
iomap-simplify-writepages-reclaim-guard.patch
mm-replace-pf_kswapd-flag-with-kthread_func-check.patch
mm-replace-pf_kcompactd-flag-with-kthread_func-check.patch
mm-zswap-convert-zswap_invalidate-to-take-a-range.patch
mm-zswap-skip-xarray-walk-in-zswap_invalidate-when-zswap-is-unused.patch
mm-zswap-reuse-zswap_invalidate-in-zswap_store.patch
mm-mincore-use-per-vma-lock-during-page-table-walk.patch


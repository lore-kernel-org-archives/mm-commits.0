Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5113477281
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865962; cv=none; b=DniGtgFiJH9EasLGcAsnMiS7FWExWa2uct6LNtzGlTx1RB898KRW0S0mRQ6Xvi8I9AJqfpP8pM1u5bJsbb2KsUDWDFxfkgjNccpIMY1byJ9zt8wGEcEt6OGKrFFJmk6ciyPOhCqjVoCIDyHJd+UvBmj7KszEIm4qZcf3HP3OdMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865962; c=relaxed/simple;
	bh=MrJfENk+d0sio2WzFA4yK8NMzLaWSPGPqtsl7sPzRFg=;
	h=Date:To:From:Subject:Message-Id; b=Vbst1TFHHwxs4JshUXidUgtP4p0UyGqeVsXlUHmYJxYCV1oo3miZbeYWUXTGQ3DFOuI2oWDOmJxMxplrZeB29xKoaLw+G7cuqhYQtx1Ss7u9nvllf5JEkhBHSgvWG6rZ+/6tCJ/3eNXsS8RNjbXIctgh/jiQXuyJIBsjrPUREuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0k+sdupn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0k+sdupn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7F11F00893;
	Tue, 13 Oct 2026 04:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865960;
	bh=xdL2fpni5GYrXHST/VtVnz0g+c+ahB6fUGwlC8E1JSo=;
	h=Date:To:From:Subject;
	b=0k+sdupnVXiceqUK/FwKTvDq6ghD4gbf05AsVbZhWzjEW/IqRarR3nL5OYbcskofw
	 8IRotk+QB5fMxcpJRPSvMRDmAvxMwpT3CZeZfvfqSgGbU33QTxooeBMLGXAxgAfdlZ
	 wgzf3Fp5Eq9W9+OVqifO/CNQvHCNMvavOw+LMzZ8=
Date: Mon, 12 Oct 2026 21:32:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mincore-use-per-vma-lock-during-page-table-walk.patch removed from -mm tree
Message-Id: <20261013043240.AB7F11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mincore: use per-vma lock during page table walk
has been removed from the -mm tree.  Its filename was
     mm-mincore-use-per-vma-lock-during-page-table-walk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



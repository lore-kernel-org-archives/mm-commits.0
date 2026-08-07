Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7767E3B2D24
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068112; cv=none; b=OqhzgBudinpURkzxs9QnW9pzcY+Kt+gfWPYGYMijNtR0H8nLq6XZaDzEdkMS2+lYErSUpGyz4wrlOWk+caZ5xnVSL6ztfYuoLwBsbfdfKUQY9qx0ZkNMpZNSYMeSqM00fwhZfS4z6JdFjK/hGZfb7r8kaj6EZyQteT/s5J080qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068112; c=relaxed/simple;
	bh=rVJ8YzU85sHsQTOa7YG2IQcV9EXSIFGGkWcHA70BhCU=;
	h=Date:To:From:Subject:Message-Id; b=Pz+ZS8zQMiEDiqO2USGqvCsg8doXQAov8TMKV0ZHnKAoP2DMNCnaOkpxEG+Q7kCKN3VRsAPhMABV+msdpVzl1cmnYp43nyx8X4+v7SeRnkJzvQtdc4H+Ye68ftjab3O3MlLCh4xYQqCVnlQ9LZelV1jQOrSfsMsfunGIHGXGnbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JpGGvYZc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JpGGvYZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF6B1F000E9;
	Fri,  7 Aug 2026 02:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068111;
	bh=n7GVBaMaFi0UaY6gtYwLDQb7cz3egoTjWoofHk0JBJw=;
	h=Date:To:From:Subject;
	b=JpGGvYZcM0glwRWyH9zaL5HPgW4hVtGzA2aMx9mO/KZiisOjKBIKTyWHTjhQCPBlS
	 PjbpaYjnoq+WuoFOzh+DdCcHDbFrnL51+CtOgxHNSHRKkhD1+4j8P8K9BL0/qXwwID
	 TmF2oK/5xg12aQ+TF/O/b+g6AD9G3YQ9bWp/JkVc=
Date: Thu, 06 Aug 2026 19:01:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mincore-improve-mincore_hugetlb.patch removed from -mm tree
Message-Id: <20260807020151.4EF6B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mincore: improve mincore_hugetlb()
has been removed from the -mm tree.  Its filename was
     mm-mincore-improve-mincore_hugetlb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mincore: improve mincore_hugetlb()
Date: Fri, 17 Jul 2026 17:13:46 +0800

walk_hugetlb_range() always passes a non-NULL pte, so remove the dead NULL
check.  Replace the per-page iteration loop with memset() for better
performance.

[wangkefeng.wang@huawei.com: fixup improve mincore_hugetlb()]
  Link: https://lore.kernel.org/20260720124252.1483984-1-wangkefeng.wang@huawei.com
Link: https://lore.kernel.org/20260717091347.1144789-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

--- a/mm/mincore.c~mm-mincore-improve-mincore_hugetlb
+++ a/mm/mincore.c
@@ -28,30 +28,16 @@ static int mincore_hugetlb(pte_t *pte, u
 			unsigned long end, struct mm_walk *walk)
 {
 #ifdef CONFIG_HUGETLB_PAGE
-	unsigned char present;
-	unsigned char *vec = walk->private;
+	const unsigned long nr = (end - addr) >> PAGE_SHIFT;
+	unsigned char resident;
 	spinlock_t *ptl;
+	pte_t ptep;
 
 	ptl = huge_pte_lock(hstate_vma(walk->vma), walk->mm, pte);
-
-	/*
-	 * Hugepages under user process are always in RAM and never
-	 * swapped out, but theoretically it needs to be checked.
-	 */
-	if (!pte) {
-		present = 0;
-	} else {
-		const pte_t ptep = huge_ptep_get(walk->mm, addr, pte);
-
-		if (huge_pte_none(ptep) || pte_is_marker(ptep))
-			present = 0;
-		else
-			present = 1;
-	}
-
-	for (; addr != end; vec++, addr += PAGE_SIZE)
-		*vec = present;
-	walk->private = vec;
+	ptep = huge_ptep_get(walk->mm, addr, pte);
+	resident = !huge_pte_none(ptep) && !pte_is_marker(ptep);
+	memset(walk->private, resident, nr);
+	walk->private += nr;
 	spin_unlock(ptl);
 #else
 	BUG();
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are



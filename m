Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7020A36F8F0
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067191; cv=none; b=Gk2xmMKGyVI2F78Zqg4NpranSf0QiylDAQo2nmzb6Rj8UnjMe2PAZHrNkXK/zkltbySr5l3KOvKHLy0AX24NAcq4ApbEY8u/b+1qa9zfJp/ACt+P2ejIjkuX2PHk05x3rvgedxFL5ubBk/Nkrp2YkJ/Jjk+pNxu/ivdbqLFQwPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067191; c=relaxed/simple;
	bh=3L0rwh6+5avfHTknHTZPXJJnsr3RXwZ8mO5S+hD+C+c=;
	h=Date:To:From:Subject:Message-Id; b=aDwBPt6ebGqFyIpu1BTRmkzEWvnNCI/vy/sLuqi9Vv4bk7oT1yPurP02+qPAjKqvwJevk0KIEyeV9EDHnpfBuig8SxuWB9KDIxiRuVKEqlH+u4mSmVnjjnVyrfiK9TT3XLMHCemYy6uPhm5mDcrem5GjM4LJJXIH4+D4MvbGcb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zxVo+6MX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zxVo+6MX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F5D1F00A3A;
	Sun, 21 Jun 2026 18:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067190;
	bh=401V/hfUFFq7DfaxHwOWTMTK3mfoS+delpVPkvHLjFg=;
	h=Date:To:From:Subject;
	b=zxVo+6MXZYEECraykepOe01z177UxepFOJ4jt+Spqpl02H/DuNj7kD9rf0aQopvJ8
	 vJgWU2FcwO4qMeAufm9cuK9Vk9GKABABhu1H+Vv1ygTlF1Q7pa4qIy9JhOywBYkZMh
	 K9nCVElqfSqmzBKzkWGX+2Re1DGUpkEl1uJEzycY=
Date: Sun, 21 Jun 2026 11:39:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,chenwandun@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-avoid-underflow-in-madvise_collapse-for-sub-pmd-madv_collapse.patch removed from -mm tree
Message-Id: <20260621183950.42F5D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: avoid underflow in madvise_collapse for sub-PMD MADV_COLLAPSE
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-avoid-underflow-in-madvise_collapse-for-sub-pmd-madv_collapse.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chen Wandun <chenwandun@lixiang.com>
Subject: mm/khugepaged: avoid underflow in madvise_collapse for sub-PMD MADV_COLLAPSE
Date: Wed, 13 May 2026 13:54:28 +0800

madvise_collapse() computes the THP-aligned window:

    hstart = ALIGN(start, HPAGE_PMD_SIZE); 	/* round up */
    hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);	/* round down */

The following case will cause hstart > hend, and result in underflow in
the return statement, avoid it by returning zero early when hstart > hend.
The return value is due to input is valid to madvise(), and there is
nothing to collapse.

    madvise(PMD-aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE);

In addition, kmalloc_obj(), mmgrab() and lru_add_drain_all() are
unnecessary when hstart == hend, so skip these operations by returning
early too.

Link: https://lore.kernel.org/20260513055428.1664898-1-chenwandun@lixiang.com
Signed-off-by: Chen Wandun <chenwandun@lixiang.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-avoid-underflow-in-madvise_collapse-for-sub-pmd-madv_collapse
+++ a/mm/khugepaged.c
@@ -3198,6 +3198,12 @@ int madvise_collapse(struct vm_area_stru
 	if (!collapse_possible(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
 		return -EINVAL;
 
+	hstart = ALIGN(start, HPAGE_PMD_SIZE);
+	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
+
+	if (hstart >= hend)
+		return 0;
+
 	cc = kmalloc_obj(*cc);
 	if (!cc)
 		return -ENOMEM;
@@ -3207,9 +3213,6 @@ int madvise_collapse(struct vm_area_stru
 	mmgrab(mm);
 	lru_add_drain_all();
 
-	hstart = ALIGN(start, HPAGE_PMD_SIZE);
-	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
-
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;
 
_

Patches currently in -mm which might be from chenwandun@lixiang.com are



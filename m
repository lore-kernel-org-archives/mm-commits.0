Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7741280029
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2fL5I7RS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6D8C433C8;
	Tue, 12 Dec 2023 18:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407580;
	bh=94bH93JeeKx74/9CbWeQb0HzgsNXSJbGyz1/0M2SMDE=;
	h=Date:To:From:Subject:From;
	b=2fL5I7RSXmQLqmLbt7skSn8Clt88LnpxT/e7a+p5t49x141AE7KbjeS+hWxmPeISn
	 L2mTpph5JPo7CpNwxHGD1l3fdVOAZuLjnl+BKrQigNIJnpkR+8F5pdY/2Av1LZR7QA
	 A8LdMglfBWGg7gws1LfBkoorRs6+evWcuuIyfwJI=
Date: Tue, 12 Dec 2023 10:59:39 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-rename-page_copy_prealloc-to-folio_prealloc.patch removed from -mm tree
Message-Id: <20231212185940.3F6D8C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory: rename page_copy_prealloc() to folio_prealloc()
has been removed from the -mm tree.  Its filename was
     mm-memory-rename-page_copy_prealloc-to-folio_prealloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: rename page_copy_prealloc() to folio_prealloc()
Date: Sat, 18 Nov 2023 10:32:30 +0800

Let's rename page_copy_prealloc() to folio_prealloc(), which could be
reused in more functons, as it maybe zero the new page, pass a new
need_zero to it, and call the vma_alloc_zeroed_movable_folio() if
need_zero is true.

Link: https://lkml.kernel.org/r/20231118023232.1409103-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-memory-rename-page_copy_prealloc-to-folio_prealloc
+++ a/mm/memory.c
@@ -992,12 +992,17 @@ copy_present_pte(struct vm_area_struct *
 	return 0;
 }
 
-static inline struct folio *page_copy_prealloc(struct mm_struct *src_mm,
-		struct vm_area_struct *vma, unsigned long addr)
+static inline struct folio *folio_prealloc(struct mm_struct *src_mm,
+		struct vm_area_struct *vma, unsigned long addr, bool need_zero)
 {
 	struct folio *new_folio;
 
-	new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, addr, false);
+	if (need_zero)
+		new_folio = vma_alloc_zeroed_movable_folio(vma, addr);
+	else
+		new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma,
+					    addr, false);
+
 	if (!new_folio)
 		return NULL;
 
@@ -1129,7 +1134,7 @@ again:
 	} else if (ret == -EBUSY) {
 		goto out;
 	} else if (ret ==  -EAGAIN) {
-		prealloc = page_copy_prealloc(src_mm, src_vma, addr);
+		prealloc = folio_prealloc(src_mm, src_vma, addr, false);
 		if (!prealloc)
 			return -ENOMEM;
 	} else if (ret) {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-fix-vma-heap-bounds-checking.patch


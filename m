Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FA4A945
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628200; cv=none; b=VS0r86f1agVBT/Lqfn2rP7glyGJQwTOegm9X6TV4WpLxuhJZyEP+qU6MOA14DALE7HMOJ8nBOdBqxA5qvjgqBTtMOnKA/0YyV7F/rq7AROxuhRFlrK65ce2+Bge8W76ux4aHFsylSrlYQ0C5xvKiHaRWbGqb0j93fTv85dUUOpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628200; c=relaxed/simple;
	bh=xBhv1GLz3e1Z8satf9ZHwvRFzKvOdT1YHWSbhtlNVHc=;
	h=Date:To:From:Subject:Message-Id; b=ph/LXTGe9TOTXuaRMIodBG1LiqWXZdh1J2ErF74KACo073Z5pTi5fKIXNmi2iPy4t2F1rtIoXfEYgZgMnhEFP5xGfYxEdqb1ySdEribqMBRrCC0eopigu9yrcce4GjEO68NCn2syuQNLoQV1Aabu6u00QK8GcbOgFqQ9zpp4Snc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZINhSZZt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZINhSZZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4E8C116B1;
	Sat, 29 Jun 2024 02:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628200;
	bh=xBhv1GLz3e1Z8satf9ZHwvRFzKvOdT1YHWSbhtlNVHc=;
	h=Date:To:From:Subject:From;
	b=ZINhSZZt5UOqQiODDLd7F6cm/J/Otvv3DjnjQp3x8JMGYhmkcjGMMYlz0swhuwHuk
	 OVTWDt1kT+zsnOKNV9aM1LWbaT7zan3jVHRnbjElFaRsPPy3bzBMzvANVoX+tYch5k
	 i4BAxMlIUMJV4uvY3foKrW3ZQTN1kBTjQfH4EfbA=
Date: Fri, 28 Jun 2024 19:30:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,deller@gmx.de,david@redhat.com,daniel@ffwll.ch,corbet@lwn.net,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch removed from -mm tree
Message-Id: <20240629023000.8B4E8C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: use folio API in pte_is_pinned()
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: fs/proc/task_mmu: use folio API in pte_is_pinned()
Date: Tue, 4 Jun 2024 19:48:19 +0800

Patch series "mm: remove page_maybe_dma_pinned() and page_mkclean()".

Most page_maybe_dma_pinned() and page_mkclean() callers have been
converted to the folio equivalents, after two more convertsions,
remove them and update the comment and documention.


This patch (of 4):

Convert to use vm_normal_folio() and folio_maybe_dma_pinned() API, which
helps to remove page_maybe_dma_pinned() in the subsequent change.

Link: https://lkml.kernel.org/r/20240604114822.2089819-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240604114822.2089819-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-use-folio-api-in-pte_is_pinned
+++ a/fs/proc/task_mmu.c
@@ -1100,7 +1100,7 @@ struct clear_refs_private {
 
 static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
 {
-	struct page *page;
+	struct folio *folio;
 
 	if (!pte_write(pte))
 		return false;
@@ -1108,10 +1108,10 @@ static inline bool pte_is_pinned(struct
 		return false;
 	if (likely(!test_bit(MMF_HAS_PINNED, &vma->vm_mm->flags)))
 		return false;
-	page = vm_normal_page(vma, addr, pte);
-	if (!page)
+	folio = vm_normal_folio(vma, addr, pte);
+	if (!folio)
 		return false;
-	return page_maybe_dma_pinned(page);
+	return folio_maybe_dma_pinned(folio);
 }
 
 static inline void clear_soft_dirty(struct vm_area_struct *vma,
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch


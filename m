Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CE180035
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NR9kzqY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488A8C433C7;
	Tue, 12 Dec 2023 18:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407582;
	bh=Fksm8o58RUZZd8URB8XZC9U+OQfPaRIjTdNiNNwDlSM=;
	h=Date:To:From:Subject:From;
	b=NR9kzqY+80DgU/fgxNVfxrRQrQHaZa//AFDds3unO5Sm7WyYyCmeS0XG8dr3itsyS
	 49nDN4SCXFgfd2L0Ucp5j99zx32X7zV6pe7jvyOSbcmdhdTXqBDNXoBuFAS813xBWw
	 RYpHrLAPyw5jFhC6hs6K/x4/7OJfvMWYZuRfqQjU=
Date: Tue, 12 Dec 2023 10:59:41 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-use-folio_prealloc-in-wp_page_copy.patch removed from -mm tree
Message-Id: <20231212185942.488A8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory: use folio_prealloc() in wp_page_copy()
has been removed from the -mm tree.  Its filename was
     mm-memory-use-folio_prealloc-in-wp_page_copy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: use folio_prealloc() in wp_page_copy()
Date: Sat, 18 Nov 2023 10:32:32 +0800

Use folio_prealloc() helper to simplify code a bit.

Link: https://lkml.kernel.org/r/20231118023232.1409103-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

--- a/mm/memory.c~mm-memory-use-folio_prealloc-in-wp_page_copy
+++ a/mm/memory.c
@@ -3117,6 +3117,7 @@ static vm_fault_t wp_page_copy(struct vm
 	int page_copied = 0;
 	struct mmu_notifier_range range;
 	vm_fault_t ret;
+	bool pfn_is_zero;
 
 	delayacct_wpcopy_start();
 
@@ -3126,16 +3127,13 @@ static vm_fault_t wp_page_copy(struct vm
 	if (unlikely(ret))
 		goto out;
 
-	if (is_zero_pfn(pte_pfn(vmf->orig_pte))) {
-		new_folio = vma_alloc_zeroed_movable_folio(vma, vmf->address);
-		if (!new_folio)
-			goto oom;
-	} else {
+	pfn_is_zero = is_zero_pfn(pte_pfn(vmf->orig_pte));
+	new_folio = folio_prealloc(mm, vma, vmf->address, pfn_is_zero);
+	if (!new_folio)
+		goto oom;
+
+	if (!pfn_is_zero) {
 		int err;
-		new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma,
-				vmf->address, false);
-		if (!new_folio)
-			goto oom;
 
 		err = __wp_page_copy_user(&new_folio->page, vmf->page, vmf);
 		if (err) {
@@ -3156,10 +3154,6 @@ static vm_fault_t wp_page_copy(struct vm
 		kmsan_copy_page_meta(&new_folio->page, vmf->page);
 	}
 
-	if (mem_cgroup_charge(new_folio, mm, GFP_KERNEL))
-		goto oom_free_new;
-	folio_throttle_swaprate(new_folio, GFP_KERNEL);
-
 	__folio_mark_uptodate(new_folio);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
@@ -3258,8 +3252,6 @@ static vm_fault_t wp_page_copy(struct vm
 
 	delayacct_wpcopy_end();
 	return 0;
-oom_free_new:
-	folio_put(new_folio);
 oom:
 	ret = VM_FAULT_OOM;
 out:
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-fix-vma-heap-bounds-checking.patch


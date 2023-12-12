Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C20580035
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eP6XcVLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4577EC433C9;
	Tue, 12 Dec 2023 18:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407581;
	bh=7h9+vu5sKIBMKuoK2rDHnCSJrHxpLm4mJ6tI3SpMGGA=;
	h=Date:To:From:Subject:From;
	b=eP6XcVLrDKIs6hYGyW96JbpaXoqiBjF+7/uCAKb0hBh+5Swdd68tckYzsyhM6KQqS
	 KeO2QUyP3u7NPp5sK9RDgiNLB5hjQNCkw0UCnaesvI2o/1IXtwhcM5WjTHMGbQqWvS
	 Mv2P8AxlC0oop9TVoLVmD90NB9iEpK5wGXS4SGmY=
Date: Tue, 12 Dec 2023 10:59:40 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-use-a-folio-in-do_cow_fault.patch removed from -mm tree
Message-Id: <20231212185941.4577EC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory: use a folio in do_cow_fault()
has been removed from the -mm tree.  Its filename was
     mm-memory-use-a-folio-in-do_cow_fault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: use a folio in do_cow_fault()
Date: Sat, 18 Nov 2023 10:32:31 +0800

Use folio_prealloc() helper and convert to use a folio in do_cow_fault(),
which save five compound_head() calls.

Link: https://lkml.kernel.org/r/20231118023232.1409103-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/mm/memory.c~mm-memory-use-a-folio-in-do_cow_fault
+++ a/mm/memory.c
@@ -4656,6 +4656,7 @@ static vm_fault_t do_read_fault(struct v
 static vm_fault_t do_cow_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	struct folio *folio;
 	vm_fault_t ret;
 
 	ret = vmf_can_call_fault(vmf);
@@ -4664,16 +4665,11 @@ static vm_fault_t do_cow_fault(struct vm
 	if (ret)
 		return ret;
 
-	vmf->cow_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vmf->address);
-	if (!vmf->cow_page)
+	folio = folio_prealloc(vma->vm_mm, vma, vmf->address, false);
+	if (!folio)
 		return VM_FAULT_OOM;
 
-	if (mem_cgroup_charge(page_folio(vmf->cow_page), vma->vm_mm,
-				GFP_KERNEL)) {
-		put_page(vmf->cow_page);
-		return VM_FAULT_OOM;
-	}
-	folio_throttle_swaprate(page_folio(vmf->cow_page), GFP_KERNEL);
+	vmf->cow_page = &folio->page;
 
 	ret = __do_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
@@ -4682,7 +4678,7 @@ static vm_fault_t do_cow_fault(struct vm
 		return ret;
 
 	copy_user_highpage(vmf->cow_page, vmf->page, vmf->address, vma);
-	__SetPageUptodate(vmf->cow_page);
+	__folio_mark_uptodate(folio);
 
 	ret |= finish_fault(vmf);
 	unlock_page(vmf->page);
@@ -4691,7 +4687,7 @@ static vm_fault_t do_cow_fault(struct vm
 		goto uncharge_out;
 	return ret;
 uncharge_out:
-	put_page(vmf->cow_page);
+	folio_put(folio);
 	return ret;
 }
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-fix-vma-heap-bounds-checking.patch


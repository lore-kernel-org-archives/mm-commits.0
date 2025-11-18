Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2981C30F542
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 22:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763504265; cv=none; b=KugHkq/GA0/2Ymq4AQ56riBXpPR3zZ1BzHU5dY+7safdBFYFIU5jk9PvPNS8WhiFTHQfT66CWuSlwUSze6Sm7B5BDDXkn6xBlHtQ/IviY2ic70N7BUNWvGztoMDARm5e27I/34F2TeOk2g4Yw8IoX/UqIloOCL52EMEZYQ+/uLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763504265; c=relaxed/simple;
	bh=iOKfkGIU0YPH4FbxfpeV1WZAzQ78Zpnab1LYYYf3akM=;
	h=Date:To:From:Subject:Message-Id; b=ZAc/UFjrt0mgpbl2jYyYebvNhtE68jKDN8WaCPqiCbabBtCck03UaJpOx3zE9JUa7G5Cm41Gz2UCDYvWJJr7X+AGJYfzC7k5z6SwRgMn492ZJJbACE5EiaE+gMVbscjdO84hhQFyVCYdeGchJUt0yed0W01KnpVmaH9ZuwpYAcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tajba9+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tajba9+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72758C2BCB5;
	Tue, 18 Nov 2025 22:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763504264;
	bh=iOKfkGIU0YPH4FbxfpeV1WZAzQ78Zpnab1LYYYf3akM=;
	h=Date:To:From:Subject:From;
	b=tajba9+TSuqqm65pa3XyinXSb/nB/YYbMlYN4kH345Br/MLarOSACweBk3bFBsP8G
	 8CL4CGoUwsn+ZPpkoXIIGfw4NJmv614Pa4hsstWVT7ZN27YLcXbpdezc2xgb2uXdyR
	 fGq/mtE6GxuEUx0Z4E0y2vlSCAnj0tA6G8KrOZ+Q=
Date: Tue, 18 Nov 2025 14:17:42 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kho-free-already-restored-pages-when-kho_restore_vmalloc-fails.patch removed from -mm tree
Message-Id: <20251118221744.72758C2BCB5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: free already restored pages when kho_restore_vmalloc() fails
has been removed from the -mm tree.  Its filename was
     kho-free-already-restored-pages-when-kho_restore_vmalloc-fails.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Pratyush Yadav <pratyush@kernel.org>
Subject: kho: free already restored pages when kho_restore_vmalloc() fails
Date: Tue, 18 Nov 2025 19:18:10 +0100

When kho_restore_vmalloc() fails, it frees up the pages array, but not the
pages it contains.  These are the pages that were successfully restored
using kho_restore_pages().  If the failure happens when restoring the
pages, the ones successfully restored are leaked.  If the failure happens
when allocating the vm_area or when mapping the pages, all the pages of
the preserved vmalloc buffer are leaked.

Free all of the successfully restored pages before returning error.

Link: https://lkml.kernel.org/r/20251118181811.47336-1-pratyush@kernel.org
Fixes: a667300bd53f2 ("kho: add support for preserving vmalloc allocations")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-free-already-restored-pages-when-kho_restore_vmalloc-fails
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1088,11 +1088,11 @@ void *kho_restore_vmalloc(const struct k
 			phys_addr_t phys = chunk->phys[i];
 
 			if (idx + contig_pages > total_pages)
-				goto err_free_pages_array;
+				goto err_free_pages;
 
 			page = kho_restore_pages(phys, contig_pages);
 			if (!page)
-				goto err_free_pages_array;
+				goto err_free_pages;
 
 			for (int j = 0; j < contig_pages; j++)
 				pages[idx++] = page;
@@ -1102,20 +1102,20 @@ void *kho_restore_vmalloc(const struct k
 
 		page = kho_restore_pages(virt_to_phys(chunk), 1);
 		if (!page)
-			goto err_free_pages_array;
+			goto err_free_pages;
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
 		__free_page(page);
 	}
 
 	if (idx != total_pages)
-		goto err_free_pages_array;
+		goto err_free_pages;
 
 	area = __get_vm_area_node(total_pages * PAGE_SIZE, align, shift,
 				  vm_flags, VMALLOC_START, VMALLOC_END,
 				  NUMA_NO_NODE, GFP_KERNEL,
 				  __builtin_return_address(0));
 	if (!area)
-		goto err_free_pages_array;
+		goto err_free_pages;
 
 	addr = (unsigned long)area->addr;
 	size = get_vm_area_size(area);
@@ -1130,7 +1130,10 @@ void *kho_restore_vmalloc(const struct k
 
 err_free_vm_area:
 	free_vm_area(area);
-err_free_pages_array:
+err_free_pages:
+	for (int i = 0; i < idx; i++)
+		__free_page(pages[i]);
+
 	kvfree(pages);
 	return NULL;
 }
_

Patches currently in -mm which might be from pratyush@kernel.org are

maintainers-add-test_kho-to-khos-entry.patch
maintainers-add-myself-as-a-reviewer-for-kho.patch
liveupdate-luo_file-add-private-argument-to-store-runtime-state.patch
kho-free-chunks-using-free_page-instead-of-kfree.patch


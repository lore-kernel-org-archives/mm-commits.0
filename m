Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9CC37031D
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 22:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763504183; cv=none; b=KohJ5uOcGlB569y/Upm5H5l853IpWnSn2FYp49wP+B2E4B7qNa4uxQOfuHKwkUEiKkxeWTDWcIL1yBOhow8MyLgpHG2EAQJumd9qVpCAg11fJEG5a0KyJvhGbWWZNOT8HOlLucrG5m4+Gzostg2e415xSVSrnGeg6EizqMiAcgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763504183; c=relaxed/simple;
	bh=Mby4mcIBBf8AGdEsN/RK/rzTtNXUFFz3F4Zb0JrHW2M=;
	h=Date:To:From:Subject:Message-Id; b=Xz3GETUFYHMW+iAuXilDzfcS122H3nBflmtY2vOImdEe1HBU5QO7xqy/iuI8xZPPlRduOjUUthT4MDS0FbHU/C5axl9hLMTmBt6Vxm1o7KVTjrx8Az9X6KRB7+mkkez9/lJOlru6XE3g8DGJvvYR403b8PwUe0S36lcOgkH5Rp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HUqF4QGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HUqF4QGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02DBC2BCAF;
	Tue, 18 Nov 2025 22:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763504182;
	bh=Mby4mcIBBf8AGdEsN/RK/rzTtNXUFFz3F4Zb0JrHW2M=;
	h=Date:To:From:Subject:From;
	b=HUqF4QGvppTDG80N/+EPYrpVBSuCJTYX3IYadoylX/UqFMpNFWH6vav4sDQShArYz
	 w7zvHQsdaPuGlP5fPj4/yi94nBRdS9hrj7gJuNvmkeftzUHpUAcjMEnw8KUzaSLKz5
	 wYfYp2b0nm95nen04fXFo6AVv21+be6uvP59pHIg=
Date: Tue, 18 Nov 2025 14:16:20 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-free-already-restored-pages-when-kho_restore_vmalloc-fails.patch added to mm-nonmm-unstable branch
Message-Id: <20251118221621.B02DBC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: free already restored pages when kho_restore_vmalloc() fails
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-free-already-restored-pages-when-kho_restore_vmalloc-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-free-already-restored-pages-when-kho_restore_vmalloc-fails.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
kho-free-already-restored-pages-when-kho_restore_vmalloc-fails.patch


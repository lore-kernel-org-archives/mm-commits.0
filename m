Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD941FBEA2
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282442; cv=none; b=Wgxag7No62PjgtLCJBBCcRR5Jp9pSLbOpe7TnMCPl/kPO/5mn6MmzUezKtDhaskvsybMIvG0MpA3FSokNPPsUgT8TqnNgO6HP/aNZodeqG3heGIqZpgMHpjJypxHTbLiNUMWpxRAjXN4Wh3y5+9DQ+LzANGf/6Aq2NXlOZeht9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282442; c=relaxed/simple;
	bh=bHfCLnXVYlHnQO6VWwrnVLGxmGivbxXu6Vc0kFbzlyw=;
	h=Date:To:From:Subject:Message-Id; b=i5PdnX8URYS453j/buKarklT/JLdcgkxQsYmeDHVwa+8Kv6AOsKZeBPyvqNIIklZUD2cYBrobkb2sFzayJeKSP1hufuazsu0zuG1zEVQj6MMKvtd0esNqlGVKtA0MFjxRlS0Nz0OntZQM0zcnDkupkFF2s2T3J4qXlk0Iffk2EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lLMYLX5C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lLMYLX5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5783C4CEF8;
	Thu, 27 Nov 2025 22:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282441;
	bh=bHfCLnXVYlHnQO6VWwrnVLGxmGivbxXu6Vc0kFbzlyw=;
	h=Date:To:From:Subject:From;
	b=lLMYLX5C7IvB468anviME3nGvRbCgl5bgNDqOwTSOiN50HFThRcM0cUvtWUCoSLw4
	 LfT8zqYWqtqCsSb3dzXn1W/1gTjHda4xfSqGxVS+7n8+fqmXeD3fapXf1oPAiuPjJZ
	 zMEZIf4MYTewbBx1g4YmtjmmV9We1wx5U2uZITKs=
Date: Thu, 27 Nov 2025 14:27:21 -0800
To: mm-commits@vger.kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-kho_restore_vmalloc-fix-initialization-of-pages-array.patch removed from -mm tree
Message-Id: <20251127222721.D5783C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: kho_restore_vmalloc: fix initialization of pages array
has been removed from the -mm tree.  Its filename was
     kho-kho_restore_vmalloc-fix-initialization-of-pages-array.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: kho: kho_restore_vmalloc: fix initialization of pages array
Date: Tue, 25 Nov 2025 13:09:16 +0200

Patch series "kho: fixes for vmalloc restoration".

Pratyush reported off-list that when kho_restore_vmalloc() is used to
restore a vmalloc_huge() allocation it hits VM_BUG_ON() when we
reconstruct the struct pages in kho_restore_pages().

These patches fix the issue.


This patch (of 2):

In case a preserved vmalloc allocation was using huge pages, all pages in
the array of pages added to vm_struct during kho_restore_vmalloc() are
wrongly set to the same page.

Fix the indexing when assigning pages to that array.

Link: https://lkml.kernel.org/r/20251125110917.843744-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20251125110917.843744-2-rppt@kernel.org
Fixes: a667300bd53f ("kho: add support for preserving vmalloc allocations")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-kho_restore_vmalloc-fix-initialization-of-pages-array
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1096,7 +1096,7 @@ void *kho_restore_vmalloc(const struct k
 				goto err_free_pages_array;
 
 			for (int j = 0; j < contig_pages; j++)
-				pages[idx++] = page;
+				pages[idx++] = page + j;
 
 			phys += contig_pages * PAGE_SIZE;
 		}
_

Patches currently in -mm which might be from rppt@kernel.org are

maintainers-add-mike-rapoport-as-maintainer-for-userfaultfd.patch


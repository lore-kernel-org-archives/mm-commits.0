Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134022C0280
	for <mm-commits@vger.kernel.org>; Thu, 18 Sep 2025 21:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758229655; cv=none; b=p+tpXN+HSXk0gKPB+FDU/OyCXXeO/4Ypo+JIyzzREP8CjtXnzppaykpcYGrcEftMr/oQGXzqjQXX7D23jPIZ6RNbRpfkzouJTvMgTV6NPAL610wtxOSz030QDRyiLurhHf/2gth9/Tpgw9g1x+cpGbNVV5kfyRIHG7GNxNeqnHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758229655; c=relaxed/simple;
	bh=9JpmiIodSfiZTfCDmFL702R5MIUZRgiqAI6bAkIyepE=;
	h=Date:To:From:Subject:Message-Id; b=Bs8+giYDMRYe0KGpesPHAx8rpkGSMr6qJDPLcipsBN/L0rVwV4UFudZZtoQFxSNofzPjRJ/xLVN7M7MnC+jOuAbjP7AuJFCB7PLMPXGRC86G7F0iHFbYBDbHRcz4m//bZ7lbSJT8THtxSBYxH/dWQKhVrHbCBEIvXOxSzY5Cgjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TqTQA9Kk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TqTQA9Kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB49C4CEE7;
	Thu, 18 Sep 2025 21:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758229654;
	bh=9JpmiIodSfiZTfCDmFL702R5MIUZRgiqAI6bAkIyepE=;
	h=Date:To:From:Subject:From;
	b=TqTQA9KkpvOIRLXCPQc22FI4+ZdKBCI0GkerXpsblqnR8zXuuwEL7j2nxSPxkJtux
	 49/Duo0SCaI9BEFvQLjxLo03GAO6Rg4sDhSeu4HB6I/ZqkKV8oASX0O+T3Hbbztqxh
	 ImyEbOMew+dptC3MYrE5XwPw3sUUZWUKqBi5/Ork=
Date: Thu, 18 Sep 2025 14:07:33 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,rppt@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pmd-alignment-constraint-in-execmem_vmalloc.patch added to mm-new branch
Message-Id: <20250918210734.6BB49C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove PMD alignment constraint in execmem_vmalloc()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-pmd-alignment-constraint-in-execmem_vmalloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pmd-alignment-constraint-in-execmem_vmalloc.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Dev Jain <dev.jain@arm.com>
Subject: mm: remove PMD alignment constraint in execmem_vmalloc()
Date: Thu, 18 Sep 2025 15:04:53 +0530

When using vmalloc with VM_ALLOW_HUGE_VMAP flag, it will set the alignment
to PMD_SIZE internally, if it deems huge mappings to be eligible. 
Therefore, setting the alignment in execmem_vmalloc is redundant.  Apart
from this, it also reduces the probability of allocation in case vmalloc
fails to allocate hugepages - in the fallback case, vmalloc tries to use
the original alignment and allocate basepages, which unfortunately will
again be PMD_SIZE passed over from execmem_vmalloc, thus constraining the
search for a free space in vmalloc region.

Therefore, remove this constraint.

Link: https://lkml.kernel.org/r/20250918093453.75676-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/execmem.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/execmem.c~mm-remove-pmd-alignment-constraint-in-execmem_vmalloc
+++ a/mm/execmem.c
@@ -38,9 +38,6 @@ static void *execmem_vmalloc(struct exec
 	if (kasan)
 		vm_flags |= VM_DEFER_KMEMLEAK;
 
-	if (vm_flags & VM_ALLOW_HUGE_VMAP)
-		align = PMD_SIZE;
-
 	p = __vmalloc_node_range(size, align, start, end, gfp_flags,
 				 pgprot, vm_flags, NUMA_NO_NODE,
 				 __builtin_return_address(0));
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-enable-khugepaged-anonymous-collapse-on-non-writable-regions.patch
mm-drop-all-references-of-writable-and-scan_page_ro.patch
mm-remove-pmd-alignment-constraint-in-execmem_vmalloc.patch


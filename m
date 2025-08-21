Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0941D35E4D4
	for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2025 20:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755809065; cv=none; b=LL5XLwD9SJnETpfN+AadT3xzVdk1VGAOOQ5rrI5UkKJCQakZ77+PkGJb9PKH30yFk5Z7eGnOrVksNP639DtIhuF1weNlUsRwFDgNQJL60oZuX1L4G/lAcQhAKHmkYaFMxBB0NPcv6kiLGZEYDAc3NhksBqEU1x+d5GjTOPnGOOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755809065; c=relaxed/simple;
	bh=HPSMnjdFMMn1N4A63LuPKqyEI+o+a8tFfKxzwl+Rjp4=;
	h=Date:To:From:Subject:Message-Id; b=tkwOqEWx5faZd9ZjAmaI38Pzd2zodXsQ90ri/rckNbpGQri6y+emrTJsGQMPwIl95R405vsefvhh/+S/TBZRugKQ8Md3jJiwCTtqlawg9rL7YSvYaFY4PtkVT7OuIqgvzinVj/Ph0WqBEsf7daVsSx1rf66HSp3qEAyhRAtlPfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pWiJGTCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pWiJGTCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5AFC4CEEB;
	Thu, 21 Aug 2025 20:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755809064;
	bh=HPSMnjdFMMn1N4A63LuPKqyEI+o+a8tFfKxzwl+Rjp4=;
	h=Date:To:From:Subject:From;
	b=pWiJGTCexdg6RZsNZ8F1FrWtClYqL4pxtqxk4WQiILQoq30fjqrd4J/WgDWB1D05M
	 5yfm1GsxEcdFrQeLkk99wiS6A7/TRonHAwyePpcbBfEjZtuM2B1T87k4U8GE8pQzG7
	 9IPQQa+92MOVZVe10AYRVOHpr60j1J6vYMoouWCw=
Date: Thu, 21 Aug 2025 13:44:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-remove-enforce_sysfs-from-__thp_vma_allowable_orders.patch added to mm-new branch
Message-Id: <20250821204424.5B5AFC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: remove enforce_sysfs from __thp_vma_allowable_orders
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-remove-enforce_sysfs-from-__thp_vma_allowable_orders.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-remove-enforce_sysfs-from-__thp_vma_allowable_orders.patch

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm/huge_memory: remove enforce_sysfs from __thp_vma_allowable_orders
Date: Thu, 21 Aug 2025 16:00:38 +0100

Using forced_collapse directly is clearer and enforce_sysfs is not really
needed.

Link: https://lkml.kernel.org/r/20250821150038.2025521-1-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-enforce_sysfs-from-__thp_vma_allowable_orders
+++ a/mm/huge_memory.c
@@ -105,7 +105,6 @@ unsigned long __thp_vma_allowable_orders
 	const bool smaps = type == TVA_SMAPS;
 	const bool in_pf = type == TVA_PAGEFAULT;
 	const bool forced_collapse = type == TVA_FORCED_COLLAPSE;
-	const bool enforce_sysfs = !forced_collapse;
 	unsigned long supported_orders;
 
 	/* Check the intersection of requested and supported orders. */
@@ -168,14 +167,14 @@ unsigned long __thp_vma_allowable_orders
 	if (!in_pf && shmem_file(vma->vm_file))
 		return orders & shmem_allowable_huge_orders(file_inode(vma->vm_file),
 						   vma, vma->vm_pgoff, 0,
-						   !enforce_sysfs);
+						   forced_collapse);
 
 	if (!vma_is_anonymous(vma)) {
 		/*
-		 * Enforce sysfs THP requirements as necessary. Anonymous vmas
+		 * Enforce THP collapse requirements as necessary. Anonymous vmas
 		 * were already handled in thp_vma_allowable_orders().
 		 */
-		if (enforce_sysfs &&
+		if (!forced_collapse &&
 		    (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
 						    !hugepage_global_always())))
 			return 0;
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

docs-transhuge-document-process-level-thp-controls.patch
selftest-mm-extract-sz2ord-function-into-vm_utilh.patch
selftests-prctl-introduce-tests-for-disabling-thps-completely.patch
selftests-prctl-introduce-tests-for-disabling-thps-completely-fix.patch
selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise.patch
selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise-fix.patch
mm-huge_memory-remove-enforce_sysfs-from-__thp_vma_allowable_orders.patch


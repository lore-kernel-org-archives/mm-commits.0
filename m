Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CF87E1
	for <mm-commits@vger.kernel.org>; Sat, 14 Jun 2025 00:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749860301; cv=none; b=eTP0+OUQFsmV/LYzh923J+9bkFp8qMaLvOncld1H1kA+oG0usmHCBXejuH0Kkql2PMfTfhbHotlNxoD7F7EVMWT0ZpIt44fBdTJYIw/9FIN51+TBaU1VIXgdy+3ERbYNMjJGWQHBynMIrWl9OL9icteB2mbbHX78NQSIhtNL3zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749860301; c=relaxed/simple;
	bh=oY82Z9ZpOGy547gEb6uPpXOzyuaGq33QYFBuOnD9vRI=;
	h=Date:To:From:Subject:Message-Id; b=WXM6ujNqYL0aRqFLXX9aYxq3PyI30STs90iBYxF6VYWu5amEf0LnxxRJZrZGVFdOmxTvPiuk6iQUJpzOdtt78OpzqrViq7D/D+IDTQlz3Va82wa1adUzRu17GjGZcPOX+R39wgUiJREk5MWfURRv5t8fMEMu5bXGECQ02b+JzUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mri/hDN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mri/hDN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B07CC4CEE3;
	Sat, 14 Jun 2025 00:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749860300;
	bh=oY82Z9ZpOGy547gEb6uPpXOzyuaGq33QYFBuOnD9vRI=;
	h=Date:To:From:Subject:From;
	b=mri/hDN5wRjITUxMQMKLOgRtihkm/r9Dt6RpF7K7QmKItePxXT42DSRZPHE8kCXEH
	 oOS2VO929zrA8Xt8G6Tj2CogK2O0wgO9MgS38Yojk1DK2l8M8rFWZzDWjRhZ4gYQqd
	 B5ugyp8YVnwtGFFjo1FgmpykG3HByH+x/35x5dhc=
Date: Fri, 13 Jun 2025 17:18:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-the-check-for-allowed-huge-orders-in-shmem.patch added to mm-new branch
Message-Id: <20250614001820.4B07CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: huge_memory: fix the check for allowed huge orders in shmem
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-fix-the-check-for-allowed-huge-orders-in-shmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-the-check-for-allowed-huge-orders-in-shmem.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: huge_memory: fix the check for allowed huge orders in shmem
Date: Fri, 13 Jun 2025 17:12:19 +0800

Shmem already supports mTHP, and shmem_allowable_huge_orders() will return
the huge orders allowed by shmem.  However, there is no check against the
'orders' parameter passed by __thp_vma_allowable_orders(), which can lead
to incorrect check results for __thp_vma_allowable_orders().

For example, when a user wants to check if shmem supports PMD-sized THP by
thp_vma_allowable_order(), if shmem only enables 64K mTHP, the current
logic would cause thp_vma_allowable_order() to return true, implying that
shmem allows PMD-sized THP allocation, which it actually does not.

I don't think this will cause a significant impact on users, and this will
only have some impact on the shmem THP collapse.  That is to say, even
though the shmem sysfs setting does not enable the PMD-sized THP, the
thp_vma_allowable_order() still indicates that shmem allows PMD-sized
collapse, meaning it might successfully collapse into THP, or it might not
(for example, thp_vma_suitable_order() check failed in the collapse
process).  However, this still does not align with the shmem sysfs
configuration, fix it.

Link: https://lkml.kernel.org/r/529affb3220153d0d5a542960b535cdfc33f51d7.1749804835.git.baolin.wang@linux.alibaba.com
Fixes: 26c7d8413aaf ("mm: thp: support "THPeligible" semantics for mTHP with anonymous shmem")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-the-check-for-allowed-huge-orders-in-shmem
+++ a/mm/huge_memory.c
@@ -166,7 +166,7 @@ unsigned long __thp_vma_allowable_orders
 	 * own flags.
 	 */
 	if (!in_pf && shmem_file(vma->vm_file))
-		return shmem_allowable_huge_orders(file_inode(vma->vm_file),
+		return orders & shmem_allowable_huge_orders(file_inode(vma->vm_file),
 						   vma, vma->vm_pgoff, 0,
 						   !enforce_sysfs);
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-fix-the-inaccurate-memory-statistics-issue-for-users.patch
selftests-khugepaged-fix-the-shmem-collapse-failure.patch
selftests-mm-add-shmem-collapse-as-a-default-test-item.patch
mm-huge_memory-fix-the-check-for-allowed-huge-orders-in-shmem.patch


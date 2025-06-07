Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC4C4C81
	for <mm-commits@vger.kernel.org>; Sat,  7 Jun 2025 21:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749333055; cv=none; b=o6FVHpBlNknV3BTbNbNVMdRr4OFVInD0yJ5Qvi/cC9CwAK9yVuvTjrq3d4s8LykQHdNNMliJFZa34B1b8cAQfYPlqAkVi+0pbQLR+iu7oKBCnPUTUp70+wCOfoPz7OYUDxdpLQBFwW6LlsB8P3aRdAGAOK5/Hc3h21D/sI5RBqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749333055; c=relaxed/simple;
	bh=FMucfan2n+Kmz8sNrRfMlRwHKDJatXUSuDdNJnCwj7k=;
	h=Date:To:From:Subject:Message-Id; b=eFZvYUXfKjD7ycH9lwp2KvEaWSzW/pg3MuI1ULnxAwCNFCd7hhLq2gCdD/yUnlgVTGg/R6Wq5ggZUb6zCc3Ru8BH8Ui1AWfmPghVC+TAMhUe9L3h8T2NPZlndBfC/0o1HvCirFAPJQnFdAYUDZuVNDoOjBzL/hp4I+ATXtMV0bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gG2VPkSC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gG2VPkSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C90C4CEF0;
	Sat,  7 Jun 2025 21:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749333055;
	bh=FMucfan2n+Kmz8sNrRfMlRwHKDJatXUSuDdNJnCwj7k=;
	h=Date:To:From:Subject:From;
	b=gG2VPkSC5On7Yxz0leF/FTRcxQQCDzJzDHj7SrrRN/JkYlFkjA5SXJYQwGKaVd/FU
	 sFMwE3ioQpP7pDMjUkBNtf0C+YaXI0dPOmWgoK4VqaZkD87y2kNp6OsktLQk54IqFb
	 pJLH7j7CUmpecfCUDO5D3cyowsVuPkTAcCDM8Ayg=
Date: Sat, 07 Jun 2025 14:50:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-shmem-disallow-hugepages-if-the-system-wide-shmem-thp-sysfs-settings-are-disabled.patch removed from -mm tree
Message-Id: <20250607215055.09C90C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: disallow hugepages if the system-wide shmem THP sysfs settings are disabled
has been removed from the -mm tree.  Its filename was
     mm-shmem-disallow-hugepages-if-the-system-wide-shmem-thp-sysfs-settings-are-disabled.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: disallow hugepages if the system-wide shmem THP sysfs settings are disabled
Date: Thu, 5 Jun 2025 16:00:59 +0800

MADV_COLLAPSE will ignore the system-wide shmem THP sysfs settings, which
means that even though we have disabled the shmem THP configuration,
MADV_COLLAPSE will still attempt to collapse into a shmem THP.  This
violates the rule we have agreed upon: never means never.

Another rule for madvise, referring to David's suggestion: “allowing for
collapsing in a VM without VM_HUGEPAGE in the "madvise" mode would be
fine".

Then the current strategy is:

For shmem, if none of always, madvise, within_size, and inherit have
enabled PMD-sized THP, then MADV_COLLAPSE will be prohibited from
collapsing PMD-sized THP.

For tmpfs, if the mount option is set with the 'huge=never' parameter,
then MADV_COLLAPSE will be prohibited from collapsing PMD-sized THP.

Link: https://lkml.kernel.org/r/39d7617a6142c6091f233357171c5793e0992d36.1749109709.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 mm/shmem.c       |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-shmem-disallow-hugepages-if-the-system-wide-shmem-thp-sysfs-settings-are-disabled
+++ a/mm/huge_memory.c
@@ -166,7 +166,7 @@ unsigned long __thp_vma_allowable_orders
 	 * own flags.
 	 */
 	if (!in_pf && shmem_file(vma->vm_file))
-		return shmem_allowable_huge_orders(file_inode(vma->vm_file),
+		return orders & shmem_allowable_huge_orders(file_inode(vma->vm_file),
 						   vma, vma->vm_pgoff, 0,
 						   !enforce_sysfs);
 
--- a/mm/shmem.c~mm-shmem-disallow-hugepages-if-the-system-wide-shmem-thp-sysfs-settings-are-disabled
+++ a/mm/shmem.c
@@ -625,7 +625,7 @@ static unsigned int shmem_huge_global_en
 		return 0;
 	if (shmem_huge == SHMEM_HUGE_DENY)
 		return 0;
-	if (shmem_huge_force || shmem_huge == SHMEM_HUGE_FORCE)
+	if (shmem_huge == SHMEM_HUGE_FORCE)
 		return maybe_pmd_order;
 
 	/*
@@ -660,7 +660,7 @@ static unsigned int shmem_huge_global_en
 
 		fallthrough;
 	case SHMEM_HUGE_ADVISE:
-		if (vm_flags & VM_HUGEPAGE)
+		if (shmem_huge_force || (vm_flags & VM_HUGEPAGE))
 			return maybe_pmd_order;
 		fallthrough;
 	default:
@@ -1783,7 +1783,7 @@ unsigned long shmem_allowable_huge_order
 	/* Allow mTHP that will be fully within i_size. */
 	mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);
 
-	if (vm_flags & VM_HUGEPAGE)
+	if (shmem_huge_force || (vm_flags & VM_HUGEPAGE))
 		mask |= READ_ONCE(huge_shmem_orders_madvise);
 
 	if (global_orders > 0)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-fix-the-inaccurate-memory-statistics-issue-for-users.patch


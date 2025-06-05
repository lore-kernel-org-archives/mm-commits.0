Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3382E20330
	for <mm-commits@vger.kernel.org>; Thu,  5 Jun 2025 21:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749159611; cv=none; b=n20w02hfha8xqqKYr1ZTJLkRJPUISqz4kq37ftnUkLn0uzHvj95ZdH12sASamjlfDyShIDNtTzWzGsah3pD2tIyrjoqexDJX9L8Gej5iLf4TponRNE7dWZHuiqbaVnpSHmhf5JsK+MlOcWPZiVQ+FiH174vvGAk7ASH7RfwYBE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749159611; c=relaxed/simple;
	bh=qlbr8wh1fH/YjMYhJEcfzBe+L8i3QvMy1L9qtQWoV5I=;
	h=Date:To:From:Subject:Message-Id; b=HnYMyUPiLLXB0/HzTYDlgRcxpwTzzMw1RmR9kE+z+mzvpkN0+QRLrHDtsgnebXVTges0SbwNQbc9jTbAihwgZ4JLKe4fQOM6x2LJcMvDFfVxVhAvK5SUsGcEOlCSMSWax4LCqbkATjqprWUew8UVZs2jenjsAk/SDWlKyQ+PhMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sk+HCE7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sk+HCE7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D6CC4CEE7;
	Thu,  5 Jun 2025 21:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749159610;
	bh=qlbr8wh1fH/YjMYhJEcfzBe+L8i3QvMy1L9qtQWoV5I=;
	h=Date:To:From:Subject:From;
	b=Sk+HCE7LBBCGaEzYjNFK7h8LNb2zyXFqCgMTvtRIGQG1EYgZkLjZIL/F1XkwK/QGq
	 IUisiVoNYkQqF+ykYovjcFMmJhjgnjMyk3lJQ7RjDIQbGDPO1crMfN+vf6jkMW+Mtj
	 g744bB+0ExUL3uGnt0G6TgvpBC1E7YRiO+HmAsdY=
Date: Thu, 05 Jun 2025 14:40:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-disallow-hugepages-if-the-system-wide-shmem-thp-sysfs-settings-are-disabled.patch added to mm-new branch
Message-Id: <20250605214010.80D6CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: disallow hugepages if the system-wide shmem THP sysfs settings are disabled
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-disallow-hugepages-if-the-system-wide-shmem-thp-sysfs-settings-are-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-disallow-hugepages-if-the-system-wide-shmem-thp-sysfs-settings-are-disabled.patch

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
mm-huge_memory-disallow-hugepages-if-the-system-wide-thp-sysfs-settings-are-disabled.patch
mm-shmem-disallow-hugepages-if-the-system-wide-shmem-thp-sysfs-settings-are-disabled.patch


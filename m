Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0838DD310;
	Fri, 26 Jan 2024 07:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255770; cv=none; b=i43yZSClurNxn77bbhL0Zxgg/GC1VlvWm3p9U0xqFCHXhkO3ZSE+R+xbwm0Mv14g/F8XXOIH0yE9H37iEKo4xpZMGMVsku0cA1DiKKwuREvui0HyH3VRgjV+H4Zuwk4gf62nSXZQS3aMxh0xkWRux//6qY/xTGRvN4Tn3//5JnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255770; c=relaxed/simple;
	bh=Zi1EolKFBaHdpx2dVBRYo8aPqoYuSt20CmHkzeYrKU4=;
	h=Date:To:From:Subject:Message-Id; b=B8cNa2UVeQyY5mWRrElooBdTHbf0RY+txIS3T6lqcmdRW6MVLwKMr13MAOguMJaiR7k1cL7a6ZF9beceM0IOD4HOW61g/5zjcFiCWts/68qGgopKigXS/Yfj1yfvkP3hiX1OlvmXpT91EAqVW8OGASM/eAdjJX/L/3Yzq6+X7us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qahRMILD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qahRMILD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092D8C433C7;
	Fri, 26 Jan 2024 07:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255769;
	bh=Zi1EolKFBaHdpx2dVBRYo8aPqoYuSt20CmHkzeYrKU4=;
	h=Date:To:From:Subject:From;
	b=qahRMILDDC0QwF5fS53oy9awc15RSwHfjr63AvIEILpup6T0V3cdqnAWy4AEKP0xn
	 ScnXYVm83pu37Y98eIQEG5c5LV/aqIDy1WZ91nLj6XxO7oEw+NcIT/Z080oJ0/WBSI
	 WB/eUMG/Ovi4RQ8ovJvJAlkBQqs0CFbBa9cb1x3o=
Date: Thu, 25 Jan 2024 23:56:06 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,shy828301@gmail.com,riel@surriel.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp_get_unmapped_area-must-honour-topdown-preference.patch removed from -mm tree
Message-Id: <20240126075609.092D8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: thp_get_unmapped_area must honour topdown preference
has been removed from the -mm tree.  Its filename was
     mm-thp_get_unmapped_area-must-honour-topdown-preference.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: thp_get_unmapped_area must honour topdown preference
Date: Tue, 23 Jan 2024 17:14:20 +0000

The addition of commit efa7df3e3bb5 ("mm: align larger anonymous mappings
on THP boundaries") caused the "virtual_address_range" mm selftest to
start failing on arm64.  Let's fix that regression.

There were 2 visible problems when running the test; 1) it takes much
longer to execute, and 2) the test fails.  Both are related:

The (first part of the) test allocates as many 1GB anonymous blocks as it
can in the low 256TB of address space, passing NULL as the addr hint to
mmap.  Before the faulty patch, all allocations were abutted and contained
in a single, merged VMA.  However, after this patch, each allocation is in
its own VMA, and there is a 2M gap between each VMA.  This causes the 2
problems in the test: 1) mmap becomes MUCH slower because there are so
many VMAs to check to find a new 1G gap.  2) mmap fails once it hits the
VMA limit (/proc/sys/vm/max_map_count).  Hitting this limit then causes a
subsequent calloc() to fail, which causes the test to fail.

The problem is that arm64 (unlike x86) selects
ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT.  But __thp_get_unmapped_area()
allocates len+2M then always aligns to the bottom of the discovered gap. 
That causes the 2M hole.

Fix this by detecting cases where we can still achive the alignment goal
when moved to the top of the allocated area, if configured to prefer
top-down allocation.

While we are at it, fix thp_get_unmapped_area's use of pgoff, which should
always be zero for anonymous mappings.  Prior to the faulty change, while
it was possible for user space to pass in pgoff!=0, the old
mm->get_unmapped_area() handler would not use it.  thp_get_unmapped_area()
does use it, so let's explicitly zero it before calling the handler.  This
should also be the correct behavior for arches that define their own
get_unmapped_area() handler.

Link: https://lkml.kernel.org/r/20240123171420.3970220-1-ryan.roberts@arm.com
Fixes: efa7df3e3bb5 ("mm: align larger anonymous mappings on THP boundaries")
Closes: https://lore.kernel.org/linux-mm/1e8f5ac7-54ce-433a-ae53-81522b2320e1@arm.com/
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 ++++++++--
 mm/mmap.c        |    6 ++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-thp_get_unmapped_area-must-honour-topdown-preference
+++ a/mm/huge_memory.c
@@ -810,7 +810,7 @@ static unsigned long __thp_get_unmapped_
 {
 	loff_t off_end = off + len;
 	loff_t off_align = round_up(off, size);
-	unsigned long len_pad, ret;
+	unsigned long len_pad, ret, off_sub;
 
 	if (IS_ENABLED(CONFIG_32BIT) || in_compat_syscall())
 		return 0;
@@ -839,7 +839,13 @@ static unsigned long __thp_get_unmapped_
 	if (ret == addr)
 		return addr;
 
-	ret += (off - ret) & (size - 1);
+	off_sub = (off - ret) & (size - 1);
+
+	if (current->mm->get_unmapped_area == arch_get_unmapped_area_topdown &&
+	    !off_sub)
+		return ret + size;
+
+	ret += off_sub;
 	return ret;
 }
 
--- a/mm/mmap.c~mm-thp_get_unmapped_area-must-honour-topdown-preference
+++ a/mm/mmap.c
@@ -1825,15 +1825,17 @@ get_unmapped_area(struct file *file, uns
 		/*
 		 * mmap_region() will call shmem_zero_setup() to create a file,
 		 * so use shmem's get_unmapped_area in case it can be huge.
-		 * do_mmap() will clear pgoff, so match alignment.
 		 */
-		pgoff = 0;
 		get_area = shmem_get_unmapped_area;
 	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		/* Ensures that larger anonymous mappings are THP aligned. */
 		get_area = thp_get_unmapped_area;
 	}
 
+	/* Always treat pgoff as zero for anonymous memory. */
+	if (!file)
+		pgoff = 0;
+
 	addr = get_area(file, addr, len, pgoff, flags);
 	if (IS_ERR_VALUE(addr))
 		return addr;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-userfaultfd-uffdio_move-implementation-should-use-ptep_get.patch
tools-mm-add-thpmaps-script-to-dump-thp-usage-info.patch
arm64-mm-make-set_ptes-robust-when-oas-cross-48-bit-boundary.patch


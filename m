Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332EA1B4159;
	Tue, 18 Feb 2025 06:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739860847; cv=none; b=qeZsDrRz756w8ziVnIychwOS5/mwXIVwKutezGVrHFxsfZVPLplNgeLBnprZ31FQjAuaSW9xv+YT0HkapkFVCVW+HlfQSX9aR8UCdRauttdWddtoS7xTAo1Pm9vsBPpg77xysVyDfD1CpsyyC0T2bGhwbyTlbqgYrq2Q722HGNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739860847; c=relaxed/simple;
	bh=QiNdiN8LZuVeMhiPg+rqN+jFIUMM583w2b4BVwweG2o=;
	h=Date:To:From:Subject:Message-Id; b=cv8KnDq/Z+xj9OrPLfUHvSMwmrVDNEFdzds2KwI7F8lAfx2Fxt2tFRNFkVYZqKEEg34Sz3o8oa3EMsB/HcCAz5PLs9NaQxCFgAFy+3DJ7FM9NLxWnZw2z+vjmdk39Neb7m2t3i0bTR3pSLNBLs/sQX/tNqVfWVazuvlHp+xNL+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a5A8AJeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a5A8AJeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45CCC4CEE2;
	Tue, 18 Feb 2025 06:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739860847;
	bh=QiNdiN8LZuVeMhiPg+rqN+jFIUMM583w2b4BVwweG2o=;
	h=Date:To:From:Subject:From;
	b=a5A8AJeRmSSny9koLT8+cS0cBONRyrq5hFftLUkc1meeQANsThVMlrrmkXJgmm7g7
	 6bZzWhbmQLXvNTDOBVDsVLElCm5WM5zVZu2QDKRLGaljwPswA9HP5hiVgC36Ku2wAq
	 5AZQnApJe4gbimv6VdwtVnNl8GdqyTwWK8sjAYvc=
Date: Mon, 17 Feb 2025 22:40:46 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,riel@surriel.com,revest@google.com,osalvador@suse.de,rcn@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mmmadvisehugetlb-check-for-0-length-range-after-end-address-adjustment.patch removed from -mm tree
Message-Id: <20250218064046.E45CCC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,madvise,hugetlb: check for 0-length range after end address adjustment
has been removed from the -mm tree.  Its filename was
     mmmadvisehugetlb-check-for-0-length-range-after-end-address-adjustment.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ricardo Cañuelo Navarro <rcn@igalia.com>
Subject: mm,madvise,hugetlb: check for 0-length range after end address adjustment
Date: Mon, 3 Feb 2025 08:52:06 +0100

Add a sanity check to madvise_dontneed_free() to address a corner case in
madvise where a race condition causes the current vma being processed to
be backed by a different page size.

During a madvise(MADV_DONTNEED) call on a memory region registered with a
userfaultfd, there's a period of time where the process mm lock is
temporarily released in order to send a UFFD_EVENT_REMOVE and let
userspace handle the event.  During this time, the vma covering the
current address range may change due to an explicit mmap done concurrently
by another thread.

If, after that change, the memory region, which was originally backed by
4KB pages, is now backed by hugepages, the end address is rounded down to
a hugepage boundary to avoid data loss (see "Fixes" below).  This rounding
may cause the end address to be truncated to the same address as the
start.

Make this corner case follow the same semantics as in other similar cases
where the requested region has zero length (ie.  return 0).

This will make madvise_walk_vmas() continue to the next vma in the range
(this time holding the process mm lock) which, due to the prev pointer
becoming stale because of the vma change, will be the same hugepage-backed
vma that was just checked before.  The next time madvise_dontneed_free()
runs for this vma, if the start address isn't aligned to a hugepage
boundary, it'll return -EINVAL, which is also in line with the madvise
api.

From userspace perspective, madvise() will return EINVAL because the start
address isn't aligned according to the new vma alignment requirements
(hugepage), even though it was correctly page-aligned when the call was
issued.

Link: https://lkml.kernel.org/r/20250203075206.1452208-1-rcn@igalia.com
Fixes: 8ebe0a5eaaeb ("mm,madvise,hugetlb: fix unexpected data loss with MADV_DONTNEED on hugetlbfs")
Signed-off-by: Ricardo Cañuelo Navarro <rcn@igalia.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Florent Revest <revest@google.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/madvise.c~mmmadvisehugetlb-check-for-0-length-range-after-end-address-adjustment
+++ a/mm/madvise.c
@@ -933,7 +933,16 @@ static long madvise_dontneed_free(struct
 			 */
 			end = vma->vm_end;
 		}
-		VM_WARN_ON(start >= end);
+		/*
+		 * If the memory region between start and end was
+		 * originally backed by 4kB pages and then remapped to
+		 * be backed by hugepages while mmap_lock was dropped,
+		 * the adjustment for hugetlb vma above may have rounded
+		 * end down to the start address.
+		 */
+		if (start == end)
+			return 0;
+		VM_WARN_ON(start > end);
 	}
 
 	if (behavior == MADV_DONTNEED || behavior == MADV_DONTNEED_LOCKED)
_

Patches currently in -mm which might be from rcn@igalia.com are



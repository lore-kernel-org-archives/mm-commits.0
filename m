Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8688E1EC011
	for <mm-commits@vger.kernel.org>; Fri, 31 Jan 2025 22:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738362208; cv=none; b=BKHjWMQ5lNHe0CG++qoMLG+DXHcsNRcrSbPvyN+JQPQkzYlxYLC66TW2QkOKyISvw71pTdxW50STYseqg8/xUs+BcLxzhl6MXLj2l/DQQkjxmC76AtiEzpTwSRflUDJwTfsbUVNMuTyvu8/6uzNQvFz8201lVEH75GvHer9Kci4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738362208; c=relaxed/simple;
	bh=35XxKi2sZqpBFurIw99cz5w30jS3DYS/PMJK8wnvUtM=;
	h=Date:To:From:Subject:Message-Id; b=aG0pIHvVOIOfAgRUMwRjkGVN9SYqSSO1kyg3WVuuHLHb0K81bwNWIPIQaB06X9c9KiSP/sSQBP4jAqmtnzSffWb1LcelHxTfT1hnWJ+fB9Hh7rd9w6zuch093oPkHVcb3cTv/AAnaYub9fpyykyRUxGkHUhcORPEyyioLE+V/bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Leg4TMjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Leg4TMjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC35EC4CEE1;
	Fri, 31 Jan 2025 22:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738362207;
	bh=35XxKi2sZqpBFurIw99cz5w30jS3DYS/PMJK8wnvUtM=;
	h=Date:To:From:Subject:From;
	b=Leg4TMjWDwL9ajxb35b24jKBU2HLREvQFE02QHuzDiEVYuFBkZM49kOh3iXHlcCQF
	 q1J3Itjcyd3p5W+wc3jTVvvp8G1viaFnOvJXm6Yz5mqHyLIBurs3UJyOYI/ssOZb/4
	 rKucegvdOFAk9h1apzlHhdPfrd7OFUvENUQU5WhU=
Date: Fri, 31 Jan 2025 14:23:27 -0800
To: mm-commits@vger.kernel.org,riel@surriel.com,revest@google.com,rcn@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmmadvisehugetlb-check-for-0-length-range-after-end-address-adjustment.patch added to mm-hotfixes-unstable branch
Message-Id: <20250131222327.DC35EC4CEE1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,madvise,hugetlb: check for 0-length range after end address adjustment
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mmmadvisehugetlb-check-for-0-length-range-after-end-address-adjustment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmmadvisehugetlb-check-for-0-length-range-after-end-address-adjustment.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ricardo Cañuelo Navarro <rcn@igalia.com>
Subject: mm,madvise,hugetlb: check for 0-length range after end address adjustment
Date: Fri, 31 Jan 2025 15:37:49 +0100

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

Link: https://lkml.kernel.org/r/20250131143749.1435006-1-rcn@igalia.com
Fixes: 8ebe0a5eaaeb ("mm,madvise,hugetlb: fix unexpected data loss with MADV_DONTNEED on hugetlbfs")
Cc: stable@vger.kernel.org
Signed-off-by: Ricardo Cañuelo Navarro <rcn@igalia.com>
Cc: Florent Revest <revest@google.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/madvise.c~mmmadvisehugetlb-check-for-0-length-range-after-end-address-adjustment
+++ a/mm/madvise.c
@@ -933,7 +933,9 @@ static long madvise_dontneed_free(struct
 			 */
 			end = vma->vm_end;
 		}
-		VM_WARN_ON(start >= end);
+		if (start == end)
+			return 0;
+		VM_WARN_ON(start > end);
 	}
 
 	if (behavior == MADV_DONTNEED || behavior == MADV_DONTNEED_LOCKED)
_

Patches currently in -mm which might be from rcn@igalia.com are

mmmadvisehugetlb-check-for-0-length-range-after-end-address-adjustment.patch


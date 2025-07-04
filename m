Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E99E1FE461
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 20:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751660415; cv=none; b=msAUKPnVNW8H8R55hP8fbxD0NZkX4TvrIQm49A8Clt19tL+MVbskgfKhkViR/ExGumHn51VVhGtwjH7LqWlCGLETucCHjSEXU4y1s6qdHq0bbowZNzP35EgzKoC8ZCYzCANqrZmdyd4aJiHNEYGGdxFQx7MbGtOQMDFNPG+F7cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751660415; c=relaxed/simple;
	bh=LI0E6UdPKB/BlV5OrwNTnjEuMpnL01IhAuPGLtS/PBo=;
	h=Date:To:From:Subject:Message-Id; b=Bspf3DTlK+qxscDZDOSzvpIQThltAKB4kN+60gOOl+WNRlaPoLhUPhg/+J8+EQcNKOjaVR8OP9fmKA/xMVuwAcZ9wfLUHvcmJV2zeeu7oXQHoaP3X8CM3n6gimn9anR14NLNqY1X3B8ayyl4/BS6Uakn/yVSIrKhIz1C+0O+bMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q/17CY4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q/17CY4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3380AC4CEE3;
	Fri,  4 Jul 2025 20:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751660415;
	bh=LI0E6UdPKB/BlV5OrwNTnjEuMpnL01IhAuPGLtS/PBo=;
	h=Date:To:From:Subject:From;
	b=Q/17CY4xpfClHPh7vLNEOZ9WLxSHz8r2JjyhqzqxgNexWAqUemYXOSukWjyeiH9Kg
	 e5QYzahwWgwDvVKY0GuYHlTYVqbLGpRmp8HM04UK60rTe1BMMY7XyVDqpoGDjUWlIb
	 BQynBryBZdKUs86mOjR3Z/EUg5YpR3s22n/MQs5g=
Date: Fri, 04 Jul 2025 13:20:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-fix-major-fault-counting.patch added to mm-unstable branch
Message-Id: <20250704202015.3380AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem, swap: fix major fault counting
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-swap-fix-major-fault-counting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-fix-major-fault-counting.patch

This patch will later appear in the mm-unstable branch at
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
From: Kairui Song <kasong@tencent.com>
Subject: mm/shmem, swap: fix major fault counting
Date: Sat, 5 Jul 2025 02:17:48 +0800

If the swapin failed, don't update the major fault count.  There is a long
existing comment for doing it this way, now with previous cleanups, we can
finally fix it.

Link: https://lkml.kernel.org/r/20250704181748.63181-10-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-fix-major-fault-counting
+++ a/mm/shmem.c
@@ -2321,12 +2321,6 @@ static int shmem_swapin_folio(struct ino
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
 	if (!folio) {
-		/* Or update major stats only when swapin succeeds?? */
-		if (fault_type) {
-			*fault_type |= VM_FAULT_MAJOR;
-			count_vm_event(PGMAJFAULT);
-			count_memcg_event_mm(fault_mm, PGMAJFAULT);
-		}
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
 			/* Direct mTHP swapin skipping swap cache & readhaed */
 			folio = shmem_swapin_direct(inode, vma, index, swap,
@@ -2346,6 +2340,11 @@ static int shmem_swapin_folio(struct ino
 				goto failed;
 			}
 		}
+		if (fault_type) {
+			*fault_type |= VM_FAULT_MAJOR;
+			count_vm_event(PGMAJFAULT);
+			count_memcg_event_mm(fault_mm, PGMAJFAULT);
+		}
 	}
 
 	if (order > folio_order(folio)) {
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-list_lru-refactor-the-locking-code.patch
mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-tidy-up-thp-swapin-checks.patch
mm-shmem-swap-tidy-up-swap-entry-splitting.patch
mm-shmem-swap-avoid-false-positive-swap-cache-lookup.patch
mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling.patch
mm-shmem-swap-simplify-swap-entry-and-index-calculation-of-large-swapin.patch
mm-shmem-swap-fix-major-fault-counting.patch


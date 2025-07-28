Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA3A8488
	for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2025 22:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753740331; cv=none; b=EJe5UUAbySDVv9UvMVJFNmfdEoxCd9EB+QqdHNTuXeTPXlns7YkCy8LpYz9MOYb5seg49VewQ/2SJ/zy3QdBoX5oP+Ga8AUNJgUtd0MJzecpbJOEC47UFfA5Qbs7fNt058eq1ZTsz2QzzzV+pPn1OLY/0AEJUJiggkLmd4jBmKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753740331; c=relaxed/simple;
	bh=A7m50JHXbxIS8Bn2xUALfcd1VRMWSU3xPU0qwbYImno=;
	h=Date:To:From:Subject:Message-Id; b=uJ3WpAQNC/ju+Iswt06D0m/x6vDlivmu8rjOAD6R3Z9u4ch+XBTOhb7s4C54h6sON17ueOO5WVUigxaTS/B2soRyEoCL8jf/AtZUOtvRbQB2pT9oIG/RkLz4Pmk8TEl9nFxzioEAnDHQJjEf9R5/I8gkzPxjaOdRzPy6mUVKlnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P+7hWNpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P+7hWNpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F67C4CEE7;
	Mon, 28 Jul 2025 22:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753740330;
	bh=A7m50JHXbxIS8Bn2xUALfcd1VRMWSU3xPU0qwbYImno=;
	h=Date:To:From:Subject:From;
	b=P+7hWNpkHG8fWk0whyJlqxo/v2/zYOKfk+ZSEGTC6c6vxddKD7BBMq4CEzFV8E2RV
	 Ilk0kUtnov1EuI89F35YWhuSEMEr6RetU6GQ91FtzxxyTahcajzIMg2bP6H5xFNMZB
	 SY/P0VxeFYkNZMIBi/T0ZR0zk+HwZ8P92AUUALL4=
Date: Mon, 28 Jul 2025 15:05:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-fix-major-fault-counting.patch added to mm-new branch
Message-Id: <20250728220530.B8F67C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem, swap: fix major fault counting
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-swap-fix-major-fault-counting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-fix-major-fault-counting.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/shmem, swap: fix major fault counting
Date: Mon, 28 Jul 2025 15:53:06 +0800

If the swapin failed, don't update the major fault count.  There is a long
existing comment for doing it this way, now with previous cleanups, we can
finally fix it.

Link: https://lkml.kernel.org/r/20250728075306.12704-9-ryncsn@gmail.com
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

 mm/shmem.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-fix-major-fault-counting
+++ a/mm/shmem.c
@@ -2356,13 +2356,6 @@ static int shmem_swapin_folio(struct ino
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
 	if (!folio) {
-		/* Or update major stats only when swapin succeeds?? */
-		if (fault_type) {
-			*fault_type |= VM_FAULT_MAJOR;
-			count_vm_event(PGMAJFAULT);
-			count_memcg_event_mm(fault_mm, PGMAJFAULT);
-		}
-
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
 			/* Direct swapin skipping swap cache & readahead */
 			folio = shmem_swap_alloc_folio(inode, vma, index,
@@ -2381,6 +2374,11 @@ static int shmem_swapin_folio(struct ino
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

mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hang.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-tidy-up-thp-swapin-checks.patch
mm-shmem-swap-tidy-up-swap-entry-splitting.patch
mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling.patch
mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin.patch
mm-shmem-swap-fix-major-fault-counting.patch


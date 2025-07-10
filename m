Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57DCB660
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 03:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752119240; cv=none; b=Q1WiLpYaYlwkm42jSs2fLWHuKwuyw+tKrvoS7PT7/BTxTuHlqPD0MHtutS9udegyRcxnyWn8NMv/ja/Dwv3mFbnatY7aWgfap9nJNKomMcTxDEzXKM6fGDhRgSHeA/OFRLfgaXU3JOAlo9iv97gu1cs7SBCyYocQeMaJLbo6Dec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752119240; c=relaxed/simple;
	bh=7QAvyirA1b9xy9DbpEQIqGh1GJ66n2wtSqcWKohsYVA=;
	h=Date:To:From:Subject:Message-Id; b=MwnSNpbSLNcoDBN6q+l5FdP37f0JDM3bZGzlmwl786wW9UFSQcveGPczNwLO9/zkK3jGlrgIzz/mjeoAIYO6XfdC0IjTk82XpH09C4leewN9D/OJLxQ55vQ1mu414stynC855W0pZ4EbhLpfQLQO7mdz9rkQ5K3tIoCg/JwA28s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kEvTFfS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kEvTFfS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2A8C4CEE3;
	Thu, 10 Jul 2025 03:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752119240;
	bh=7QAvyirA1b9xy9DbpEQIqGh1GJ66n2wtSqcWKohsYVA=;
	h=Date:To:From:Subject:From;
	b=kEvTFfS4/8w2JSPjnaU8tHY5PDZ4TGPUuRcilubkvj3oQP+cPP5xJ07e8Yhg5NKkD
	 pMmtJXXA/aPbwY/Rtd2HKvHy5lvq338pTpx1MNwYecevotZ2ik1hPuFjfjI0ywvs6S
	 AEon0gJ3rBB7kh2pzLH2lq8vx1fu2axCd0JJ5DUo=
Date: Wed, 09 Jul 2025 20:47:19 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-fix-major-fault-counting.patch added to mm-new branch
Message-Id: <20250710034720.3E2A8C4CEE3@smtp.kernel.org>
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
Date: Thu, 10 Jul 2025 11:37:06 +0800

If the swapin failed, don't update the major fault count.  There is a long
existing comment for doing it this way, now with previous cleanups, we can
finally fix it.

Link: https://lkml.kernel.org/r/20250710033706.71042-9-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
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
@@ -2319,13 +2319,6 @@ static int shmem_swapin_folio(struct ino
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
 			/* Direct mTHP swapin skipping swap cache & readhaed */
 			folio = shmem_swap_alloc_folio(inode, vma, index,
@@ -2344,6 +2337,11 @@ static int shmem_swapin_folio(struct ino
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
 		/*
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-list_lru-refactor-the-locking-code.patch
mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-tidy-up-thp-swapin-checks.patch
mm-shmem-swap-tidy-up-swap-entry-splitting.patch
mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling.patch
mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin.patch
mm-shmem-swap-fix-major-fault-counting.patch


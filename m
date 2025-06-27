Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F2B20E6F9
	for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2025 20:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751055411; cv=none; b=L7NsCvaYSrM4oRLeFbYAHXWZaTzS7gls7NGnep4izQ5n2cGhOHenZOWg9cayVEid7XQQfFhRnlEOBmqqYP7WvFfzVyQBcS2rznz+bLWBXsoI1T88BJvDa6e/VhGe6hy+5SjP7h5/CsLOowEjfOfx91OaJA4cqGtg5d13l3uccBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751055411; c=relaxed/simple;
	bh=2YPSXc4cGBFwy3qHwtfNNbW6rt6/wmHa4M8azHy/z5k=;
	h=Date:To:From:Subject:Message-Id; b=HPAncrWlaOtdtcLyRoVjWH/OP0bPf38/KPBZ7g0tjSoSGBWlqeA1hwMsSJeIZG67Y+10KVhmf+xpbqzssKfGk5iRBCNjOtijTEquTwcwTaElZHheP0ofAZJOYQTDTBAM9uOcjJfUOS7nP7gK6ENB/glgeHFjQ2k0Reb4/dso3Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JOO7K0lP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JOO7K0lP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C057C4CEE3;
	Fri, 27 Jun 2025 20:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751055411;
	bh=2YPSXc4cGBFwy3qHwtfNNbW6rt6/wmHa4M8azHy/z5k=;
	h=Date:To:From:Subject:From;
	b=JOO7K0lPHVKnqEql1/+iY9ImIjpPuh+rDVr6VB114V0DYk+Ksivf8v+1jeImMYoCH
	 VRKY+rCnPHJ90dUer3PI5mPy6n6GbIIPKmCUXbxySVzaJ5Wgxvmc5cjQE2Xrj50saR
	 P1m5YW7Xgtm8PkwQDtChhRkAhW4MqtTU5KeXh838=
Date: Fri, 27 Jun 2025 13:16:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-fix-major-fault-counting.patch added to mm-new branch
Message-Id: <20250627201651.8C057C4CEE3@smtp.kernel.org>
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
Date: Fri, 27 Jun 2025 14:20:19 +0800

If the swapin failed, don't update the major fault count.  There is a long
existing comment for doing it this way, now with previous cleanups, we can
finally fix it.

Link: https://lkml.kernel.org/r/20250627062020.534-7-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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
@@ -2316,12 +2316,6 @@ static int shmem_swapin_folio(struct ino
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
 			/* Direct mTHP swapin without swap cache or readahead */
 			folio = shmem_swapin_direct(inode, vma, index,
@@ -2341,6 +2335,11 @@ static int shmem_swapin_folio(struct ino
 		}
 		if (!folio)
 			goto failed;
+		if (fault_type) {
+			*fault_type |= VM_FAULT_MAJOR;
+			count_vm_event(PGMAJFAULT);
+			count_memcg_event_mm(fault_mm, PGMAJFAULT);
+		}
 	}
 	/*
 	 * We need to split an existing large entry if swapin brought in a
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-list_lru-refactor-the-locking-code.patch
mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-tidy-up-thp-swapin-checks.patch
mm-shmem-swap-clean-up-swap-entry-splitting.patch
mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch
mm-shmem-swap-fix-major-fault-counting.patch
mm-shmem-swap-avoid-false-positive-swap-cache-lookup.patch


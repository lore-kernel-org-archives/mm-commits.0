Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D2C130495
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725924815; cv=none; b=Udv4Ye5e8Osmo54r/NiU2/J5xGC9AXNzPN5zwj92vvzv680kGWbBMGY4aOCwxV2J2MWvWe2yHT0M3amPD+b0n0c7CXC9joCf11Wx6Z8SMEm4DJarrKPb7t3u3G9INQSrGulhkOlVYQkCB8Ch8dupG8rUMdHkcmlcy95EaLI09qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725924815; c=relaxed/simple;
	bh=1BRcZ2z1wt7N/gcIycZ2KScqRqOeOLA9EWVe9R5z9V4=;
	h=Date:To:From:Subject:Message-Id; b=uzgakfXoNcO73JzvR5SbRusqQZbHq+LPBVIqm7flGr7ozavgGRMpdCjHiEtUKUQeto2ouuEVkxJ44cbGbawODWva6eUsJjkFn3iivB1tU4BYbed/LRUagFdLXPsN7eqNGABey3Lmm4PCZ4pRJLTmOIKgh6vmKbWUlfkkofc3XXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ur5BRyKO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ur5BRyKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EA9C4CEC6;
	Mon,  9 Sep 2024 23:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725924815;
	bh=1BRcZ2z1wt7N/gcIycZ2KScqRqOeOLA9EWVe9R5z9V4=;
	h=Date:To:From:Subject:From;
	b=Ur5BRyKOh54ikQeGeq63Ct3rDmxY0OmC795LiKpuOT6pBLJuUYH2GTWHs7eewyAq8
	 o2JWs2THoMD9YQWpQOU5ZWnHICQaZHCsJI/JctttQJwgZXcZo6LRiCznjprVZ2DXid
	 HNZSZd7cY1sj9hy8JxZBGbD7EBZwp3bBcsjFBsds=
Date: Mon, 09 Sep 2024 16:33:34 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,mjguzik@gmail.com,dave@stgolabs.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch removed from -mm tree
Message-Id: <20240909233335.35EA9C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-hugetlb-sort-out-global-lock-annotations-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch

This patch was dropped because it was folded into mm-hugetlb-sort-out-global-lock-annotations.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-sort-out-global-lock-annotations-fix-fix
Date: Wed Aug 28 01:40:09 PM PDT 2024

DEFINE_SPINLOCK doesn't permit section modifiers at end-of-definition

Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-sort-out-global-lock-annotations-fix-fix
+++ a/mm/hugetlb.c
@@ -72,7 +72,7 @@ static unsigned int default_hugepages_in
  * Protects updates to hugepage_freelists, hugepage_activelist, nr_huge_pages,
  * free_huge_pages, and surplus_huge_pages.
  */
-DEFINE_SPINLOCK(hugetlb_lock) __cacheline_aligned_in_smp;
+__cacheline_aligned_in_smp DEFINE_SPINLOCK(hugetlb_lock);
 
 /*
  * Serializes faults on the same logical page.  This is used to
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hugetlb-sort-out-global-lock-annotations.patch
mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes.patch
mm-page_alloc-fix-build-with-config_unaccepted_memory=n.patch
mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas-fix.patch


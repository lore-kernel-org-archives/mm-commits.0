Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DBD5B211
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 03:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740454004; cv=none; b=EilTNQQt+vKxFr8w/bcjnPKMGECNVbb3rLCSksxOoorurvk9i6RhSjMageKwtDpHqZEVUoqecoL/f4FmuqF9Htk0rHBjQrMbCngcjJemObO74jJ27zy7LErtLqYeGytZrUvlDzyOutXNdCr3Xko+8BgSAWjUxuaaae5Kju7vKcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740454004; c=relaxed/simple;
	bh=SRhpFn1onKZU4ToACbcIeh0LKRUX3pAEkxq2tR0sreY=;
	h=Date:To:From:Subject:Message-Id; b=Cq43pKt5pF+UbZhGN1Dzp1sbQqbsxDDCG/tZkzsg3ClLmIn399ToGe5VmZIcLgQ7TcYjSuQLZ+42E6jO2Gr6BQAu2yQidFb8N4k21TdOZrKokI34t5JQPK8YxemklZI0pVt0IxalmivpUX+iTY+CZNqvs/+gvC0VwQ3ENSXrepE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oxI/2fsp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oxI/2fsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BE8C4CED6;
	Tue, 25 Feb 2025 03:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740454004;
	bh=SRhpFn1onKZU4ToACbcIeh0LKRUX3pAEkxq2tR0sreY=;
	h=Date:To:From:Subject:From;
	b=oxI/2fsp8ooKsfBwfp2U7LVpmtXwiWc6YKmMtXLVdXlPTTOKn9rO8uZfsalcR4GI3
	 aEiv/dHzChI3NxwtUl7yPlCYgS86m5xW+snhV9MH+zAafy+hqZHQVBGsD7r6uFSqTd
	 nu2rYY/KqEnB8NFacf4kq8XSTF4EF3GeDYEhx5l8=
Date: Mon, 24 Feb 2025 19:26:43 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,v-songbaohua@oppo.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-dont-update-the-counter-up-front.patch added to mm-unstable branch
Message-Id: <20250225032643.E6BE8C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: don't update the counter up-front
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-dont-update-the-counter-up-front.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-dont-update-the-counter-up-front.patch

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
Subject: mm, swap: don't update the counter up-front
Date: Tue, 25 Feb 2025 02:02:09 +0800

The counter update before allocation design was useful to avoid
unnecessary scan when device is full, so it will abort early if the
counter indicates the device is full.  But that is an uncommon case, and
now scanning of a full device is very fast, so the up-front update is not
helpful any more.

Remove it and simplify the slot allocation logic.

Link: https://lkml.kernel.org/r/20250224180212.22802-5-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

--- a/mm/swapfile.c~mm-swap-dont-update-the-counter-up-front
+++ a/mm/swapfile.c
@@ -1201,22 +1201,10 @@ int get_swap_pages(int n_goal, swp_entry
 	int order = swap_entry_order(entry_order);
 	unsigned long size = 1 << order;
 	struct swap_info_struct *si, *next;
-	long avail_pgs;
 	int n_ret = 0;
 	int node;
 
 	spin_lock(&swap_avail_lock);
-
-	avail_pgs = atomic_long_read(&nr_swap_pages) / size;
-	if (avail_pgs <= 0) {
-		spin_unlock(&swap_avail_lock);
-		goto noswap;
-	}
-
-	n_goal = min3((long)n_goal, (long)SWAP_BATCH, avail_pgs);
-
-	atomic_long_sub(n_goal * size, &nr_swap_pages);
-
 start_over:
 	node = numa_node_id();
 	plist_for_each_entry_safe(si, next, &swap_avail_heads[node], avail_lists[node]) {
@@ -1250,10 +1238,8 @@ start_over:
 	spin_unlock(&swap_avail_lock);
 
 check_out:
-	if (n_ret < n_goal)
-		atomic_long_add((long)(n_goal - n_ret) * size,
-				&nr_swap_pages);
-noswap:
+	atomic_long_sub(n_ret * size, &nr_swap_pages);
+
 	return n_ret;
 }
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-avoid-reclaiming-irrelevant-swap-cache.patch
mm-swap-drop-the-flag-ttrs_direct.patch
mm-swap-avoid-redundant-swap-device-pinning.patch
mm-swap-dont-update-the-counter-up-front.patch
mm-swap-use-percpu-cluster-as-allocation-fast-path.patch
mm-swap-remove-swap-slot-cache.patch
mm-swap-simplify-folio-swap-allocation.patch


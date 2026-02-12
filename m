Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FA13EBF1B;
	Thu, 12 Feb 2026 23:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939647; cv=none; b=ozTdB4JH1OeyiUnfE1y1BREMRSpfa/WGIm0snav6+rdfalVu89xifnRc1CKnPkl0QZpNMweAdsVnSN0A6TAewrBnfObEwwOL2jHtpAfB7T3IvWnNsvAY4EFWc45aWGtqLZe95FM/DJo2h+S0cb7/xLdwvrVkIR6EPi+S2SRuc3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939647; c=relaxed/simple;
	bh=x+KoL5lqHzBK80U+S3TuqtzQIa6x6bM94GUorfw/Ewo=;
	h=Date:To:From:Subject:Message-Id; b=oe3vsJ2lZi8trO38To5lii2LH4lcmL8quwrFo+MT8hWLXzcYx5grL+6ApaKiBy2QVfms4eO4pDv0U++F2l1qSRT10cq7BaJkZ7sT589MP0dOtfMvng0y45eTCpcLth4hsWGgwRpa7S3KqX1F+4QJKGCBLwEKFXSW1h0nxrLr9cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a8/eVDgt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a8/eVDgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AF4C4CEF7;
	Thu, 12 Feb 2026 23:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939646;
	bh=x+KoL5lqHzBK80U+S3TuqtzQIa6x6bM94GUorfw/Ewo=;
	h=Date:To:From:Subject:From;
	b=a8/eVDgt6geeqFjvM0OPLySWYxbvF2ZTJqbQvAT4zun/xGZxJA91m6qrQA1ShyAU+
	 6IZ9slMx3KCOr13hw4uJxqRzFT9UkktykmcVhFY7ZpUKId0vywhvRvyDmTTuqwLcKJ
	 1CKG28xvitSFzELKgd72AJEh0uA25LpeHU8MxlzU=
Date: Thu, 12 Feb 2026 15:40:44 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,usama.arif@linux.dev,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,mawupeng1@huawei.com,lorenzo.stoakes@oracle.com,longman@redhat.com,Liam.Howlett@oracle.com,david@kernel.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-restore-failed-global-reservations-to-subpool.patch removed from -mm tree
Message-Id: <20260212234046.B9AF4C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: restore failed global reservations to subpool
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-restore-failed-global-reservations-to-subpool.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/hugetlb: restore failed global reservations to subpool
Date: Fri, 16 Jan 2026 15:40:36 -0500

Commit a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
fixed an underflow error for hstate->resv_huge_pages caused by incorrectly
attributing globally requested pages to the subpool's reservation.

Unfortunately, this fix also introduced the opposite problem, which would
leave spool->used_hpages elevated if the globally requested pages could
not be acquired.  This is because while a subpool's reserve pages only
accounts for what is requested and allocated from the subpool, its "used"
counter keeps track of what is consumed in total, both from the subpool
and globally.  Thus, we need to adjust spool->used_hpages in the other
direction, and make sure that globally requested pages are uncharged from
the subpool's used counter.

Each failed allocation attempt increments the used_hpages counter by how
many pages were requested from the global pool.  Ultimately, this renders
the subpool unusable, as used_hpages approaches the max limit.

The issue can be reproduced as follows:
1. Allocate 4 hugetlb pages
2. Create a hugetlb mount with max=4, min=2
3. Consume 2 pages globally
4. Request 3 pages from the subpool (2 from subpool + 1 from global)
	4.1 hugepage_subpool_get_pages(spool, 3) succeeds.
		used_hpages += 3
	4.2 hugetlb_acct_memory(h, 1) fails: no global pages left
		used_hpages -= 2
5. Subpool now has used_hpages = 1, despite not being able to
   successfully allocate any hugepages. It believes it can now only
   allocate 3 more hugepages, not 4.

With each failed allocation attempt incrementing the used counter, the
subpool eventually reaches a point where its used counter equals its
max counter.  At that point, any future allocations that try to
allocate hugeTLB pages from the subpool will fail, despite the subpool
not having any of its hugeTLB pages consumed by any user.

Once this happens, there is no way to make the subpool usable again,
since there is no way to decrement the used counter as no process is
really consuming the hugeTLB pages.

The underflow issue that the original commit fixes still remains fixed
as well.

Without this fix, used_hpages would keep on leaking if
hugetlb_acct_memory() fails.

Link: https://lkml.kernel.org/r/20260116204037.2270096-1-joshua.hahnjy@gmail.com
Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-restore-failed-global-reservations-to-subpool
+++ a/mm/hugetlb.c
@@ -6717,6 +6717,15 @@ out_put_pages:
 		 */
 		hugetlb_acct_memory(h, -gbl_resv);
 	}
+	/* Restore used_hpages for pages that failed global reservation */
+	if (gbl_reserve && spool) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&spool->lock, flags);
+		if (spool->max_hpages != -1)
+			spool->used_hpages -= gbl_reserve;
+		unlock_or_release_subpool(spool, flags);
+	}
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
 					    chg * pages_per_huge_page(h), h_cg);
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are



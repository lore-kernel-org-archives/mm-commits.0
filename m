Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0623B4E9D
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068032; cv=none; b=Ckjb7TzuBjtvNGVZ3afs7jZSZQ1JJlWfNKNei01CRIaUfQ5fYcODO8flvGQDORv6+OzVxGSm3u/jzHZ1qX7U+NXgLifRvAv33bb238+lFC6gb6pclTlEBCnXhi9KN0dL52eTVyTC+KQfMNLmcSOUbK13oOCqpZcnZgRzpstNOEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068032; c=relaxed/simple;
	bh=DQh6A7+39GJibkesLg4fy3fDBeNrWQYkRuY3MuvOHRI=;
	h=Date:To:From:Subject:Message-Id; b=Wr5xlxuzO0ghimVnx9OWr4i3HSUoUUB6G20Pr+m/xFhIKai/aUXD9wzHRMEhWFLsx+TesLmSustuS26t7mnUOKHEwcqBHICqldfAZkIVCGpPiuHhEw1L9oiXiS51QbYoAYvqMRIvGj1RZAwtxtmlrPQvnhTsQqhlIa1XWLW13lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WgQBk/gP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WgQBk/gP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066AD1F00A3D;
	Fri,  7 Aug 2026 02:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068020;
	bh=c0+guf4pUmJgSJK/VIv/IGdr0uT9EueNjyK2LXldjrA=;
	h=Date:To:From:Subject;
	b=WgQBk/gPP9wtRcfUL0Q6dIBBFk+T/DHuRYeuR9WVoBYV3xX9pqLWt0/M6DDntEjDu
	 adoCqZ7fXBH/Kt8pYVENoJpVcCwx5BCiSLkC1qBgjIAucKCbrZyONlS7OHbClpiAoP
	 1pB96ROlymuGY2b0SyF4ohlf8nJ14QWteto+zZyc=
Date: Thu, 06 Aug 2026 19:00:19 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-clarify-unreachable-cond_resched-in-swap_reclaim_full_clusters.patch removed from -mm tree
Message-Id: <20260807020020.066AD1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: clarify unreachable cond_resched() in swap_reclaim_full_clusters
has been removed from the -mm tree.  Its filename was
     mm-swap-clarify-unreachable-cond_resched-in-swap_reclaim_full_clusters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm/swap: clarify unreachable cond_resched() in swap_reclaim_full_clusters
Date: Mon, 13 Jul 2026 13:50:14 +0900

Commit 66366d291f66 ("mm/swap: add cond_resched() in
swap_reclaim_full_clusters to prevent softlockup") added cond_resched() to
prevent soft lockups during heavy swap reclaim.

Currently, there are two call sites for this function:
1. swap_reclaim_work(): called with force=true in a workqueue context.
2. cluster_alloc_swap_entry(): called with force=false, holding a
   local_lock and potentially a global cluster spinlock (atomic context).

In the second case, calling cond_resched() would normally cause a
"scheduling while atomic" bug.  However, it is currently safe because when
force=false, 'to_scan' is initialized to 1.  The loop decrements it to 0
and breaks before ever reaching cond_resched().

This implicit dependency is hard to notice and recently triggered a false
positive in AI Sashiko review.

Add a comment to explicitly clarify that cond_resched() is unreachable in
atomic contexts.  This improves readability and prevents future misuse if
the loop logic or 'to_scan' initialization is modified.

Link: https://sashiko.dev/#/patchset/20260713025644.170839-1-youngjun.park@lge.com?part=4
Link: https://lore.kernel.org/20260713045014.219653-1-youngjun.park@lge.com
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/swapfile.c~mm-swap-clarify-unreachable-cond_resched-in-swap_reclaim_full_clusters
+++ a/mm/swapfile.c
@@ -1072,6 +1072,12 @@ static void swap_reclaim_full_clusters(s
 		swap_cluster_unlock(ci);
 		if (to_scan <= 0)
 			break;
+
+		/*
+		 * When 'force' is false, 'to_scan' is initialized to 1.
+		 * The loop breaks above, making this cond_resched() unreachable
+		 * in atomic contexts.
+		 */
 		cond_resched();
 	}
 }
_

Patches currently in -mm which might be from youngjun.park@lge.com are



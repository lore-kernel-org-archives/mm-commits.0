Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A9A170A11;
	Tue,  7 Oct 2025 21:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759870899; cv=none; b=QV7Xhd9jhGOikUPRNZriQ5Sv1LDIN+p4L/1Tji2ku+TYhrxwOcwj2f19uuEv8aY2fZcqJTMXR9Dv1CmxwcXg1Xg/GZV/Mc/fXpEb0K/5QkbF48POgh9pxkS8/LFu0WfMpaB7lU8vPvA4IU15n61+4Rp+M79jIuq5D9Zr9GaI99c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759870899; c=relaxed/simple;
	bh=BtLCjkWNOeq2l7CPDf1cDx+hmeUIAqYEu7AEm1ab3pA=;
	h=Date:To:From:Subject:Message-Id; b=AunNcZJwdk+RspI61JLbHKd3/LBYLeb2uDBGe3Dl9nb8e5LYqleadK/lzKeUPnSaqb/VKsMncSGH7l2UmCXzwUY1nWFcYvTX44FHTl+ghYkTwI8K9zVJE0AxgniWQTe7WlLbn+SQdcbM5ZyDfH+YfpAFssbhmW+CXwDoAb0we8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UY7rXv7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UY7rXv7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EABC4CEFE;
	Tue,  7 Oct 2025 21:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759870899;
	bh=BtLCjkWNOeq2l7CPDf1cDx+hmeUIAqYEu7AEm1ab3pA=;
	h=Date:To:From:Subject:From;
	b=UY7rXv7Z97mr2rrmxyygYO6CPNq38Ih/zXU+WDzuZ+OhJ3BXI7uHcpmRZ/po7pm2N
	 g0tve9z5q4pvpaGqqbhhRps5GtmcGVi7hwHbRJvUQtxXay++4MhJ0vb1KB64lKKrWP
	 SLp/ysr74+3zncfx0oV3WWavKxfMm0T3YBT+bU/M=
Date: Tue, 07 Oct 2025 14:01:39 -0700
To: mm-commits@vger.kernel.org,zhengxinyu6@huawei.com,stable@vger.kernel.org,hughd@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-vaddr-do-not-repeat-pte_offset_map_lock-until-success.patch removed from -mm tree
Message-Id: <20251007210139.A6EABC4CEFE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: do not repeat pte_offset_map_lock() until success
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-do-not-repeat-pte_offset_map_lock-until-success.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: do not repeat pte_offset_map_lock() until success
Date: Mon, 29 Sep 2025 17:44:09 -0700

DAMON's virtual address space operation set implementation (vaddr) calls
pte_offset_map_lock() inside the page table walk callback function.  This
is for reading and writing page table accessed bits.  If
pte_offset_map_lock() fails, it retries by returning the page table walk
callback function with ACTION_AGAIN.

pte_offset_map_lock() can continuously fail if the target is a pmd
migration entry, though.  Hence it could cause an infinite page table walk
if the migration cannot be done until the page table walk is finished. 
This indeed caused a soft lockup when CPU hotplugging and DAMON were
running in parallel.

Avoid the infinite loop by simply not retrying the page table walk.  DAMON
is promising only a best-effort accuracy, so missing access to such pages
is no problem.

Link: https://lkml.kernel.org/r/20250930004410.55228-1-sj@kernel.org
Fixes: 7780d04046a2 ("mm/pagewalkers: ACTION_AGAIN if pte_offset_map_lock() fails")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Xinyu Zheng <zhengxinyu6@huawei.com>
Closes: https://lore.kernel.org/20250918030029.2652607-1-zhengxinyu6@huawei.com
Acked-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-do-not-repeat-pte_offset_map_lock-until-success
+++ a/mm/damon/vaddr.c
@@ -328,10 +328,8 @@ static int damon_mkold_pmd_entry(pmd_t *
 	}
 
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	if (!pte) {
-		walk->action = ACTION_AGAIN;
+	if (!pte)
 		return 0;
-	}
 	if (!pte_present(ptep_get(pte)))
 		goto out;
 	damon_ptep_mkold(pte, walk->vma, addr);
@@ -481,10 +479,8 @@ regular_page:
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	if (!pte) {
-		walk->action = ACTION_AGAIN;
+	if (!pte)
 		return 0;
-	}
 	ptent = ptep_get(pte);
 	if (!pte_present(ptent))
 		goto out;
_

Patches currently in -mm which might be from sj@kernel.org are



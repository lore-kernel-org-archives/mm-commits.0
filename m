Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2A21B4140;
	Tue, 18 Feb 2025 06:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739860856; cv=none; b=be4y/OX+Aw7Rq/j1tjIs15s/GjDVZAw7trHpmfinUOyPk7n76bt/pdcEZWylu8wR/kuTPn+P4Ta2fdq0bgqs7d33t+LDCN0tjRTiTc2Tbi1M0sqgiRB+hkTu/rFiP2wZEDqCAW42xsahIcWYGJzQFxbdYe7NDwX+jPYwTvOeMTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739860856; c=relaxed/simple;
	bh=gs6mtvp4P0Ya6VJk4kuR/CrvEr3+3L5RehoK7CIIL84=;
	h=Date:To:From:Subject:Message-Id; b=s5GlEaZ6eiGbPndcSRgi7RyxtxYt3a89+xpcYVY+vXcXKZsd8PJ9ImU3w4mFgryIU6dzbFN1hIgq+A5chb9wDxp2Z7+bllzOwOr+XgHOeXhbvi1HmxZpAVVEj9Hm5kyQ3s9Cvs34H7vFDkbG5nxNjcVs3YKDs9uSr/p75PkdeWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IeNKLa9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IeNKLa9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0BEC4CEE2;
	Tue, 18 Feb 2025 06:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739860855;
	bh=gs6mtvp4P0Ya6VJk4kuR/CrvEr3+3L5RehoK7CIIL84=;
	h=Date:To:From:Subject:From;
	b=IeNKLa9SsqfrzpFbJyqcz087cLJxPwXK4LAaEdRldy6T/8idYTwIpnjxbj+VtPqmf
	 QIDXJbF4r7WdDMIuhdh46uzRw9ZqHXZyzbB4gxGOPfH1P85gQT+4manIxPx8HWdjVh
	 ezAn1ZfD76+OMlrmsrkHr6Lxo90XZ9vwx/Q6JAYc=
Date: Mon, 17 Feb 2025 22:40:55 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,stable@vger.kernel.org,quwenruo.btrfs@gmx.com,muchun.song@linux.dev,jannh@google.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,brauner@kernel.org,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-pgtable-fix-incorrect-reclaim-of-non-empty-pte-pages.patch removed from -mm tree
Message-Id: <20250218064055.DB0BEC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pgtable: fix incorrect reclaim of non-empty PTE pages
has been removed from the -mm tree.  Its filename was
     mm-pgtable-fix-incorrect-reclaim-of-non-empty-pte-pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: pgtable: fix incorrect reclaim of non-empty PTE pages
Date: Tue, 11 Feb 2025 15:26:25 +0800

In zap_pte_range(), if the pte lock was released midway, the pte entries
may be refilled with physical pages by another thread, which may cause a
non-empty PTE page to be reclaimed and eventually cause the system to
crash.

To fix it, fall back to the slow path in this case to recheck if all pte
entries are still none.

Link: https://lkml.kernel.org/r/20250211072625.89188-1-zhengqi.arch@bytedance.com
Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reported-by: Christian Brauner <brauner@kernel.org>
Closes: https://lore.kernel.org/all/20250207-anbot-bankfilialen-acce9d79a2c7@brauner/
Reported-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Closes: https://lore.kernel.org/all/152296f3-5c81-4a94-97f3-004108fba7be@gmx.com/
Tested-by: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-pgtable-fix-incorrect-reclaim-of-non-empty-pte-pages
+++ a/mm/memory.c
@@ -1719,7 +1719,7 @@ static unsigned long zap_pte_range(struc
 	pmd_t pmdval;
 	unsigned long start = addr;
 	bool can_reclaim_pt = reclaim_pt_is_enabled(start, end, details);
-	bool direct_reclaim = false;
+	bool direct_reclaim = true;
 	int nr;
 
 retry:
@@ -1734,8 +1734,10 @@ retry:
 	do {
 		bool any_skipped = false;
 
-		if (need_resched())
+		if (need_resched()) {
+			direct_reclaim = false;
 			break;
+		}
 
 		nr = do_zap_pte_range(tlb, vma, pte, addr, end, details, rss,
 				      &force_flush, &force_break, &any_skipped);
@@ -1743,11 +1745,20 @@ retry:
 			can_reclaim_pt = false;
 		if (unlikely(force_break)) {
 			addr += nr * PAGE_SIZE;
+			direct_reclaim = false;
 			break;
 		}
 	} while (pte += nr, addr += PAGE_SIZE * nr, addr != end);
 
-	if (can_reclaim_pt && addr == end)
+	/*
+	 * Fast path: try to hold the pmd lock and unmap the PTE page.
+	 *
+	 * If the pte lock was released midway (retry case), or if the attempt
+	 * to hold the pmd lock failed, then we need to recheck all pte entries
+	 * to ensure they are still none, thereby preventing the pte entries
+	 * from being repopulated by another thread.
+	 */
+	if (can_reclaim_pt && direct_reclaim && addr == end)
 		direct_reclaim = try_get_and_clear_pmd(mm, pmd, &pmdval);
 
 	add_mm_rss_vec(mm, rss);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

arm-pgtable-fix-null-pointer-dereference-issue.patch


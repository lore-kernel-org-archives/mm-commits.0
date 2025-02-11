Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD751F03E3;
	Tue, 11 Feb 2025 08:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739261865; cv=none; b=nN6KZ40t5KHOwHH5nvWx8Jz3VrZ4fVQlt4BG3JL11dd8a0SuMVXaNwadmBzMhqCQmL0PJhB4gaqs917qOOPCZup+LG+oIahSTjS7B+yjwWyZEQv7mqYsAeOFwphDSFlopDpKzJtgz0AgdCpV55yAPv49Q+m1opNFMChVY84qa9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739261865; c=relaxed/simple;
	bh=qkIl5ltPX0YApXOGHqfhoPfd5q89bARAxoWrG7XEiWs=;
	h=Date:To:From:Subject:Message-Id; b=C5GK/jIgvSloTlq6MNkuQvuNW+kEG+Pkbcq/qArb+6MI7Egr+j6rYeJGob62jwy7RFqWcP9xJSCpb4q3myZxJmjCc/0dcWK+zbLMhuQjGP5mfO7j4Be3vuvyvC/kq2xfg+LBwYEaQJoOTduYgZWRs0o9Yh4rojmy6RFmEor0+VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GnBV91x/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GnBV91x/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3BFC4CEDD;
	Tue, 11 Feb 2025 08:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739261864;
	bh=qkIl5ltPX0YApXOGHqfhoPfd5q89bARAxoWrG7XEiWs=;
	h=Date:To:From:Subject:From;
	b=GnBV91x/HrZMzUgzijUo3vkUQ+ocYNYGmDNhZwpMNKUsAizasz35/v4JPt/NrkRVE
	 Oa77TeqTxedjKGUAJjQgqtteynfv+0rqYwcJLzh4JiKjf9JcNyLm8/deXylPY4m4ON
	 iDO1zBYAG7mRd6K1KNvt0B8Xf1VkozjKQuBesrgI=
Date: Tue, 11 Feb 2025 00:17:43 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,stable@vger.kernel.org,quwenruo.btrfs@gmx.com,muchun.song@linux.dev,jannh@google.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,brauner@kernel.org,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-fix-incorrect-reclaim-of-non-empty-pte-pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20250211081744.6F3BFC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pgtable: fix incorrect reclaim of non-empty PTE pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-pgtable-fix-incorrect-reclaim-of-non-empty-pte-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-fix-incorrect-reclaim-of-non-empty-pte-pages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-pgtable-fix-incorrect-reclaim-of-non-empty-pte-pages.patch


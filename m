Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5066436F8F3;
	Fri, 29 May 2026 04:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027626; cv=none; b=huJT5TubGrW4+v2y5bGcoKuiHPvY+4vZvRtkCpldVZeZCs4GWRluqhIJUwhnSXwqYeyEW6UbqQJ0HZ/NJfktJHFGAuWP2Fsmr1vOU1fT0wccT8fQ5LRNpa7J5G2O9Dg+OVuk8N7FZhHWvMLbC5U110w7uIv7KwPp1q5aWHo4gDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027626; c=relaxed/simple;
	bh=Vm/5ZY9yBnUCt0p+ejFLJg5wN425Gc4KYXYyU8ShOTI=;
	h=Date:To:From:Subject:Message-Id; b=GMezJOI+1+abxsVHvhJ7pHYWCf3JCQVlt6wmz0tbSQdVqWR+xoSxEaEIribhPvw6eF59G3cNTFgsQuUu6dIh4YGwRgTj48rD35gg3kOuV2O9oe/i9onpgk3bDx9He4J2328tuD3I8TLoY0ZK4HX1YzMcaRA1u9LznspcjrmUQR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K91Q9EI4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K91Q9EI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246D81F00893;
	Fri, 29 May 2026 04:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027623;
	bh=WvAva1x8+ftDyxYKlJo6Nf6lqDHfd5B57x5w6jkTaTU=;
	h=Date:To:From:Subject;
	b=K91Q9EI4fgWKmJuNHcPf9doc9Kh11pKzjNJSsreovPxVp5TljR74NhCnQm0x6DTWn
	 g+WvAfqIA6Is76+6Vwjj+x6ta+4OUAXKswJ/XbEQLGHAbUiPSpnWVzFWGGrrOZqq79
	 v/2aEruflBimFH3GZtaczG1YFEwSnwLbAxamG0ps=
Date: Thu, 28 May 2026 21:07:02 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,almasrymina@google.com,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-hugetlb-cgroup-rsvd-charge-uncharge-mismatch.patch removed from -mm tree
Message-Id: <20260529040703.246D81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix hugetlb cgroup rsvd charge/uncharge mismatch
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-hugetlb-cgroup-rsvd-charge-uncharge-mismatch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: mm/hugetlb: fix hugetlb cgroup rsvd charge/uncharge mismatch
Date: Sat, 28 Mar 2026 12:25:34 +0530

In alloc_hugetlb_folio(), a single h_cg pointer is used for both the rsvd
and non-rsvd hugetlb cgroup charges.  When map_chg is set,
hugetlb_cgroup_charge_cgroup_rsvd() stores the charged cgroup in h_cg, but
the immediately following hugetlb_cgroup_charge_cgroup() overwrites h_cg
with the non-rsvd cgroup pointer.

As a result, hugetlb_cgroup_commit_charge_rsvd() stores the wrong
(non-rsvd) cgroup pointer into the folio's rsvd slot.

When the folio is later freed, free_huge_folio() unconditionally calls
both hugetlb_cgroup_uncharge_folio() and
hugetlb_cgroup_uncharge_folio_rsvd().  The rsvd uncharge reads back the
wrong cgroup from the folio and decrements a counter that was never
charged for that cgroup, causing a page_counter underflow:

  page_counter underflow: -512 nr_pages=512
  WARNING: mm/page_counter.c:61 at page_counter_cancel

Fix this by introducing a separate h_cg_rsvd pointer exclusively for the
rsvd charge path, keeping the rsvd and non-rsvd charges fully independent
through their charge, commit, and error uncharge paths.

Link: https://lore.kernel.org/20260328065534.346053-1-kartikey406@gmail.com
Fixes: 08cf9faf7558 ("hugetlb_cgroup: support noreserve mappings")
Reported-by: syzbot+226c1f947186f8fef796@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=226c1f947186f8fef796
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mina Almasry <almasrymina@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-hugetlb-cgroup-rsvd-charge-uncharge-mismatch
+++ a/mm/hugetlb.c
@@ -2859,6 +2859,7 @@ struct folio *alloc_hugetlb_folio(struct
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
+	struct hugetlb_cgroup *h_cg_rsvd = NULL;
 	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
 
 	idx = hstate_index(h);
@@ -2909,7 +2910,7 @@ struct folio *alloc_hugetlb_folio(struct
 	 */
 	if (map_chg) {
 		ret = hugetlb_cgroup_charge_cgroup_rsvd(
-			idx, pages_per_huge_page(h), &h_cg);
+			idx, pages_per_huge_page(h), &h_cg_rsvd);
 		if (ret)
 			goto out_subpool_put;
 	}
@@ -2951,7 +2952,7 @@ struct folio *alloc_hugetlb_folio(struct
 	 */
 	if (map_chg) {
 		hugetlb_cgroup_commit_charge_rsvd(idx, pages_per_huge_page(h),
-						  h_cg, folio);
+						  h_cg_rsvd, folio);
 	}
 
 	spin_unlock_irq(&hugetlb_lock);
@@ -3003,7 +3004,7 @@ out_uncharge_cgroup:
 out_uncharge_cgroup_reservation:
 	if (map_chg)
 		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
-						    h_cg);
+						    h_cg_rsvd);
 out_subpool_put:
 	/*
 	 * put page to subpool iff the quota of subpool's rsv_hpages is used
_

Patches currently in -mm which might be from kartikey406@gmail.com are



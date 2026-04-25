Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8B737AA98;
	Sat, 25 Apr 2026 14:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777129076; cv=none; b=mGKxrZqGnQ68k1tXDLoRifNclrzHdEr0NoJlg4JOBjfNfttEcaM0DYDrykFT/yRRzJF8dwMcfIc3d7UQUHAk0oF5uSw+TBhQK96/PaEGbHXmPUpmN8x6EVr4FlH7Xrzi502oZDmobF5kMedIrCZoMiKRP4vTMI0MkrqN6I5U2c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777129076; c=relaxed/simple;
	bh=67hmXrViKvKry/8B7QltivmfAtZgEBeYOC93U5ulNcs=;
	h=Date:To:From:Subject:Message-Id; b=tZ6tFGaHgkrsD1N7nD0hRGGzwc+GW/+SsXFrVMl7BxWj1N3FM/H7pDe7W1tOPxyhAV9MbFjlc4AmtRiDj576U0GKre/38fLQyzTLoS8EjaEuHh7KCZYHte3ZUyZ05MdJHDSahkFsp7O2fSrpZBYrvIZhelXmuxS1iMP/n5txXW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FPgMLjUe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FPgMLjUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63ED5C2BCB5;
	Sat, 25 Apr 2026 14:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777129076;
	bh=67hmXrViKvKry/8B7QltivmfAtZgEBeYOC93U5ulNcs=;
	h=Date:To:From:Subject:From;
	b=FPgMLjUedZ8+HjE2hQ8YOjnK3j0+PspqWCpjrCi1y2mIoQdcfE5QxCgu9N9lruAoI
	 z5MtSVAu3pEKM4r2yitUobfEftdxoK5AD7IIl+mldhfF6BO/FaCAAGcNcxJAbeeveL
	 3El9bm7Kz0xo8Sw65L1O3K/DbIB/B7Yf/ryUWerE=
Date: Sat, 25 Apr 2026 07:57:55 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,almasrymina@google.com,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-hugetlb-cgroup-rsvd-charge-uncharge-mismatch.patch added to mm-new branch
Message-Id: <20260425145756.63ED5C2BCB5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix hugetlb cgroup rsvd charge/uncharge mismatch
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-fix-hugetlb-cgroup-rsvd-charge-uncharge-mismatch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-hugetlb-cgroup-rsvd-charge-uncharge-mismatch.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mina Almasry <almasrymina@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-hugetlb-cgroup-rsvd-charge-uncharge-mismatch
+++ a/mm/hugetlb.c
@@ -2879,6 +2879,7 @@ struct folio *alloc_hugetlb_folio(struct
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
+	struct hugetlb_cgroup *h_cg_rsvd = NULL;
 	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
 
 	idx = hstate_index(h);
@@ -2929,7 +2930,7 @@ struct folio *alloc_hugetlb_folio(struct
 	 */
 	if (map_chg) {
 		ret = hugetlb_cgroup_charge_cgroup_rsvd(
-			idx, pages_per_huge_page(h), &h_cg);
+			idx, pages_per_huge_page(h), &h_cg_rsvd);
 		if (ret)
 			goto out_subpool_put;
 	}
@@ -2971,7 +2972,7 @@ struct folio *alloc_hugetlb_folio(struct
 	 */
 	if (map_chg) {
 		hugetlb_cgroup_commit_charge_rsvd(idx, pages_per_huge_page(h),
-						  h_cg, folio);
+						  h_cg_rsvd, folio);
 	}
 
 	spin_unlock_irq(&hugetlb_lock);
@@ -3023,7 +3024,7 @@ out_uncharge_cgroup:
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

mm-hugetlb-fix-hugetlb-cgroup-rsvd-charge-uncharge-mismatch.patch
kernel-fork-validate-exit_signal-in-kernel_clone.patch


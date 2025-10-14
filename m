Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FEB2EA73B
	for <mm-commits@vger.kernel.org>; Tue, 14 Oct 2025 22:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760479979; cv=none; b=DvERpELVGfMhWA76XSWSlrdkBsyX6mLGe+AxPHnJ7ZwCuJyfi0JzsSFf8rg06eYYJ63iHCNPur/El2AcSVVLD7UX+JgpEXYvndGNqpkq02zh9hL9z7tijOv3ZfmwmHLqc4JaIcdcvtAq3gzg6nibvJmmgNTxhztESwPt2itbzDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760479979; c=relaxed/simple;
	bh=ethT13eGDfnDmT+VfKufXXVXjkRnWzg3SiK2yDGacHo=;
	h=Date:To:From:Subject:Message-Id; b=F8cO70mPiJGf9/vLCx1I5FQqSe7Uu8CZzBs8/LPXJqllr9yIpRk6JqnV0gL8PSNkGu35s6clAQOiSOpytWkD5hUBs9k4HfCyVqIUGlhPg/fB+/qmn0JeaFC6WX2SvZWrOH1Fe4wq10eBxE5mESTkCW4b7H+ggyL3WIkNolewtZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tzO5uubt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tzO5uubt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D29AC4CEE7;
	Tue, 14 Oct 2025 22:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760479978;
	bh=ethT13eGDfnDmT+VfKufXXVXjkRnWzg3SiK2yDGacHo=;
	h=Date:To:From:Subject:From;
	b=tzO5uubtNfFb4v9K0lI6aAOtVG8HZ0ViF7zVhHCmKrfdiovb7VQE4R+4m8T0nhxCY
	 HdezvIJupn/15PUEEiJPHEipyUH24b696CnSeZnyTzdlULQtwt1oR90QWHuC5u7uxt
	 rn66pCiveFq+4/x2ZaIULi9v53oNDmvHgA0po454=
Date: Tue, 14 Oct 2025 15:12:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,mhocko@suse.com,kirill@shutemov.name,jackmanb@google.com,hannes@cmpxchg.org,clm@fb.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit-fix.patch added to mm-new branch
Message-Id: <20251014221258.6D29AC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit-fix.patch

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
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit-fix
Date: Tue, 14 Oct 2025 12:28:22 -0700

checking for 0-ness is sufficient, per Vlastimil

Since to_free and pcp->count cannot become negative, make the checks into an
equality check instead.

Link: https://lkml.kernel.org/r/20251014192827.851389-1-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Chris Mason <clm@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit-fix
+++ a/mm/page_alloc.c
@@ -2884,7 +2884,7 @@ static bool free_frozen_page_commit(stru
 		free_pcppages_bulk(zone, to_free_batched, pcp, pindex);
 		to_free -= to_free_batched;
 
-		if (to_free <= 0 || pcp->count <= 0)
+		if (to_free == 0 || pcp->count == 0)
 			break;
 
 		pcp_spin_unlock(pcp);
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-page_alloc-clarify-batch-tuning-in-zone_batchsize.patch
mm-page_alloc-prevent-reporting-pcp-batch-=-0.patch
mm-page_alloc-vmstat-simplify-refresh_cpu_vm_stats-change-detection.patch
mm-page_alloc-batch-page-freeing-in-decay_pcp_high.patch
mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit.patch
mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit-fix.patch


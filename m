Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334F117A300
	for <mm-commits@vger.kernel.org>; Thu,  6 Nov 2025 00:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762388650; cv=none; b=k+QZmgfhe3d+trr8o47uEecqkUEK0LJEgyH2EYyg0dWc47DINkgphpYhjglaqSyx9YHxRUV+UAQ1R7pRTK8RfNgq12AA2IsCcPhrzbilnaydhRqVhZK4AeC6rq+4t1UBOdevtFvNfuYC0tN9d6KhzZ1iauNuUZje7oAy0oMw6+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762388650; c=relaxed/simple;
	bh=6Kd97k1pOLx34i3wZngaG+v2Wf3yipFi4lwwRdUKrww=;
	h=Date:To:From:Subject:Message-Id; b=gDJ8Kgai4GSLIfsFELxCWelLCFiBrmBzILAHiGzFujp3ZWHmH5ugEkdx+RzyoDLnDQBvRgNoNtgOTE+q6A5l1LUianAB13zsJpYzoyxmQ3rXZPFmaznyArh6BF006iqHvTLoCsqYIHvTcadRnBZzea9beNEn5nmZ/eM55mOOpeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vgbCR5Pg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vgbCR5Pg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D148EC4CEF5;
	Thu,  6 Nov 2025 00:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762388649;
	bh=6Kd97k1pOLx34i3wZngaG+v2Wf3yipFi4lwwRdUKrww=;
	h=Date:To:From:Subject:From;
	b=vgbCR5Pg23fB6Q8Rj9VQLi4XDPYyNQ+ZKGC/PODRd6+NyMk3Vt7FH+MPdbghbxrUV
	 88p2cGvwNkXCjon8eyZb810g+j75BIlEH3w9EQ3exPvyv29zDY39OsiuLRZD7ObiOS
	 yokgIZ4REbPOu9q/hd8cfHg41Dib8bFhRFIVtpyc=
Date: Wed, 05 Nov 2025 16:24:09 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yi.zhang@huawei.com,yangerkun@huawei.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,mhocko@suse.com,jack@suse.cz,jackmanb@google.com,hannes@cmpxchg.org,libaokun1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-dont-warn-about-large-allocations-with-__gfp_nofail.patch added to mm-unstable branch
Message-Id: <20251106002409.D148EC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: don't warn about large allocations with __GFP_NOFAIL
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-dont-warn-about-large-allocations-with-__gfp_nofail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-dont-warn-about-large-allocations-with-__gfp_nofail.patch

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
From: Baokun Li <libaokun1@huawei.com>
Subject: mm/page_alloc: don't warn about large allocations with __GFP_NOFAIL
Date: Wed, 5 Nov 2025 16:56:52 +0800

Filesystems use __GFP_NOFAIL to allocate block-sized folios for metadata
reads at critical points, since they cannot afford to go read-only, shut
down, or enter an inconsistent state due to memory pressure.

Currently, attempting to allocate page units greater than order-1 with the
__GFP_NOFAIL flag triggers a WARN_ON() in __alloc_pages_slowpath(). 
However, filesystems supporting large block sizes (blocksize > PAGE_SIZE)
can easily require allocations larger than order-1.

As Matthew Wilcox noted in [1], if we have a filesystem with 64KiB
sectors, there will be many clean folios in the page cache that are 64KiB
or larger.  He also explained in [2] why kvmalloc isn't a valid approach
here.

With gfp flags and order already included in the OOM report, both
Vlastimil Babka and Michal Hocko suggested that we can take the risk of
removing this warning first and then observe whether a large number of
related OOM reports appear.

If that happens, we can consider adding special handling in other places.

Link: https://lkml.kernel.org/r/20251105085652.4081123-1-libaokun@huaweicloud.com
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Link: https://lore.kernel.org/all/aQPX1-XWQjKaMTZB@casper.infradead.org [1]
Link: https://lore.kernel.org/all/aQTHMI3t5mNXp0M1@casper.infradead.org [2]
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Link: https://lore.kernel.org/all/188a95ba-6384-4319-bb74-c0d9ec6c4079@suse.cz
Suggested-by: Michal Hocko <mhocko@suse.com>
Link: https://lore.kernel.org/all/aQotQBjnDDeL_wHx@tiehlicka
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: ErKun Yang <yangerkun@huawei.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-dont-warn-about-large-allocations-with-__gfp_nofail
+++ a/mm/page_alloc.c
@@ -4684,11 +4684,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 
 	if (unlikely(nofail)) {
 		/*
-		 * We most definitely don't want callers attempting to
-		 * allocate greater than order-1 page units with __GFP_NOFAIL.
-		 */
-		WARN_ON_ONCE(order > 1);
-		/*
 		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
 		 * otherwise, we may result in lockup.
 		 */
_

Patches currently in -mm which might be from libaokun1@huawei.com are

mm-page_alloc-dont-warn-about-large-allocations-with-__gfp_nofail.patch


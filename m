Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CCC2BE026
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 19:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777059127; cv=none; b=ZYZiIv8cY/VvrXUccQkLFCh49i5afFrjKJNvXYG7QbTZz1FmbCrtrqiOFtywFLH4Mu7DKovMTE06bHY4GJZ+iMjmpVyIWIF+S/C7CqjwbfqaO8G/ykXRNS7XXV5NMjzZZsvv1x4I9MalwgrE1/B1njWrIl1cYuH9tDbVaEP7yTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777059127; c=relaxed/simple;
	bh=gQhbb7zqC4DTWua9YJ4GvwdNHssEO5T6P5+d6Hlqy2o=;
	h=Date:To:From:Subject:Message-Id; b=nH4OG5v4AZ1BVyTrtnBp4lS8vOLC5fHs0DusMdYXIOMAQ+8qgxNanJrxQSqvunwYYZB0eAZKv+cOAmjtYcCyRK8lEI41wpmOysGVdLoreOMu+LGn/t5m8YQdtRTTuk+qXy6q5897fHAYS/GZ1yWgwS9rWhnp4ljQJfZ7WH14IAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JURfKNx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JURfKNx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29178C19425;
	Fri, 24 Apr 2026 19:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777059127;
	bh=gQhbb7zqC4DTWua9YJ4GvwdNHssEO5T6P5+d6Hlqy2o=;
	h=Date:To:From:Subject:From;
	b=JURfKNx8hrljGkZokt+f47hplCqaUNsDnDDcYRkZl6/hr8z5xz5ScSaaqDdy3HbsQ
	 VE0sOIjnejWE7YHvS4Ju8jcl6retPDzXOSJtPd7yOtFcfDxVqVpH8WDZeYhsgWq7qL
	 NZC+RJu+D60BLFQ7NCv+qhT4TCuZHfxUACv6JNTs=
Date: Fri, 24 Apr 2026 12:32:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,anshuman.khandual@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-cleanup-flag-vars-in-alloc_pages_bulk_noprof.patch added to mm-new branch
Message-Id: <20260424193207.29178C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: cleanup flag vars in alloc_pages_bulk_noprof()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-cleanup-flag-vars-in-alloc_pages_bulk_noprof.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-cleanup-flag-vars-in-alloc_pages_bulk_noprof.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: cleanup flag vars in alloc_pages_bulk_noprof()
Date: Tue, 31 Mar 2026 10:52:13 +0000

These two variables are redundant, squash them to align
alloc_pages_bulk_noprof() with the style used in
alloc_frozen_pages_nolock_noprof().

Link: https://lore.kernel.org/20260331-b4-prepare_alloc_pages-flags-v1-1-ea2416def698@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vishal Moola <vishal.moola@gmail.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-cleanup-flag-vars-in-alloc_pages_bulk_noprof
+++ a/mm/page_alloc.c
@@ -5044,7 +5044,6 @@ unsigned long alloc_pages_bulk_noprof(gf
 	struct per_cpu_pages *pcp;
 	struct list_head *pcp_list;
 	struct alloc_context ac;
-	gfp_t alloc_gfp;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
 	int nr_populated = 0, nr_account = 0;
 
@@ -5085,10 +5084,8 @@ unsigned long alloc_pages_bulk_noprof(gf
 
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
 	gfp &= gfp_allowed_mask;
-	alloc_gfp = gfp;
-	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &alloc_gfp, &alloc_flags))
+	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
 		goto out;
-	gfp = alloc_gfp;
 
 	/* Find an allowed local zone that meets the low watermark. */
 	z = ac.preferred_zoneref;
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-cleanup-flag-vars-in-alloc_pages_bulk_noprof.patch


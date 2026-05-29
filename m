Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15B536F91D
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027618; cv=none; b=BRd2i8FlEjvNEdbhsI7qLEYK98ZlezG8q+aMx5HXbStxFj4FwPHXJw6zIbT22zGe2XiprSOA9UVODzWD0hUHL/niuPYvgyVfsyVGQ+g1PjD4t37L23A96UMnYhacVX0CDgWHSu3xrAEaVWzJ7gzbzlWP6bKsfBem3/q2GQWIL0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027618; c=relaxed/simple;
	bh=oIAg3Et4YNW3SjdblmiJAAJLLMZQpeWd4PPx6YgUq8k=;
	h=Date:To:From:Subject:Message-Id; b=HZuaRb3Wlyz6+pGqlt96Lrv6L369IUiaGLJJbcYpNvttxjbWbbOntYc7kQ9cvYYKoQEL9Jr5r2VUEIUfctiNfdx+7d9YOI5GqyIbScloLEETdZ0xzAnuuinkmdwzZ4xXsSt19AW6VRCuSJaBvvw23NKCyAcuW5tg/x7EH45xdIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XAwNr5+B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XAwNr5+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DE11F00893;
	Fri, 29 May 2026 04:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027617;
	bh=xc4Xq7t8W4zT/kIMDLIcZng+VsQf2iGd/TUaEiBMPco=;
	h=Date:To:From:Subject;
	b=XAwNr5+BxWBW9Sa3RWEKepK1GbwoCuQtVnAEFn8daPc6ILiidWyPdUR23H0wCTLxH
	 XhmTMCXpaqAlqvoQWgu2GpU+XVCOARk8Rfu46hXZ5q/qYqYoNOnPzpnX6lZBjinAvR
	 0/XEkPhuC1RT9f0FcWHRYTmzl4ZJbxrQ295B9I1c=
Date: Thu, 28 May 2026 21:06:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,anshuman.khandual@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-cleanup-flag-vars-in-alloc_pages_bulk_noprof.patch removed from -mm tree
Message-Id: <20260529040657.84DE11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: cleanup flag vars in alloc_pages_bulk_noprof()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-cleanup-flag-vars-in-alloc_pages_bulk_noprof.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -5054,7 +5054,6 @@ unsigned long alloc_pages_bulk_noprof(gf
 	struct per_cpu_pages *pcp;
 	struct list_head *pcp_list;
 	struct alloc_context ac;
-	gfp_t alloc_gfp;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
 	int nr_populated = 0, nr_account = 0;
 
@@ -5095,10 +5094,8 @@ unsigned long alloc_pages_bulk_noprof(gf
 
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

mm-introduce-for_each_free_list.patch
mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback.patch
mm-rejig-pageblock-mask-definitions.patch
mm-page_alloc-remove-ifdefs-from-pindex-helpers.patch
mm-page_alloc-drop-a-misleading-__always_inline.patch
mm-page_alloc-document-that-alloc_pages_nolock-uses-rcu.patch
mm-page_alloc-remove-vm_bug_ons-from-pindex-helpers.patch


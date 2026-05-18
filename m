Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB79D38A716
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 18:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779128090; cv=none; b=r5qDyubwiqu2JhnNGcJv0Ri+bgwa73utREuhtVQnKNVsjvAea8hZkoOLMOVidleYYVEG8OCPFikTdcAhDzPXhqfV84yTUu95hmVL5xl88hBvNd6ZgjSmNm4x/LEo1j8fazcwzbLb0TY9whzxCnzLZRDI5pZNg98x9w7hjTWCUJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779128090; c=relaxed/simple;
	bh=mI9zqKuU2umvjH20wdLlny7zyOpjQ3pENXCGo6P931w=;
	h=Date:To:From:Subject:Message-Id; b=S9F+zhaKxCDTfzsy3GWmyJtT+puNQWcs7eUTtOIy52sLYHIcpkBEN2fe1K5QX/Z9fJUOtLxHoTtvRg0B1t8qIWR9BfTMkwq6ocu68t+VbJhxJZnBudsU4kNyMznPppfZzAb4oJxBl+HxczwyNOd/nV0DpO7DNC8xsjAXFQC5AAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NJeV0ShI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NJeV0ShI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E95C2BCB7;
	Mon, 18 May 2026 18:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779128090;
	bh=mI9zqKuU2umvjH20wdLlny7zyOpjQ3pENXCGo6P931w=;
	h=Date:To:From:Subject:From;
	b=NJeV0ShITtDs7QbSNGcZc1QKwtoKeNc6KYlPiBRIYTM7k5fUN93Oadb7bjKwfa34F
	 2LxJTo2icQiOyHVXBxDUPa3ON59Rv5OFzm3QZXQscSUBjmPx3zmbxxAnrYF5/vPS9B
	 jdDzX5HbLzwrw+oycSZOCnbcxSYknq+NAqX6glEk=
Date: Mon, 18 May 2026 11:14:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lenb@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-ifdefs-from-pindex-helpers.patch added to mm-new branch
Message-Id: <20260518181450.67E95C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: remove ifdefs from pindex helpers
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-remove-ifdefs-from-pindex-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-ifdefs-from-pindex-helpers.patch

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
Subject: mm/page_alloc: remove ifdefs from pindex helpers
Date: Wed, 13 May 2026 12:35:16 +0000

The ifdefs are not technically needed here, everything used here is
always defined.

Switching to IS_ENABLED() makes the code a bit less tiresome to read.

Link: https://lore.kernel.org/20260513-page_alloc-unmapped-prep-v1-4-dacdf5402be8@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-ifdefs-from-pindex-helpers
+++ a/mm/page_alloc.c
@@ -650,19 +650,17 @@ out:
 
 static inline unsigned int order_to_pindex(int migratetype, int order)
 {
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		bool movable = migratetype == MIGRATE_MOVABLE;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	bool movable;
-	if (order > PAGE_ALLOC_COSTLY_ORDER) {
-		VM_BUG_ON(!is_pmd_order(order));
+		if (order > PAGE_ALLOC_COSTLY_ORDER) {
+			VM_BUG_ON(!is_pmd_order(order));
 
-		movable = migratetype == MIGRATE_MOVABLE;
-
-		return NR_LOWORDER_PCP_LISTS + movable;
+			return NR_LOWORDER_PCP_LISTS + movable;
+		}
+	} else {
+		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
 	}
-#else
-	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
-#endif
 
 	return (MIGRATE_PCPTYPES * order) + migratetype;
 }
@@ -671,12 +669,12 @@ static inline int pindex_to_order(unsign
 {
 	int order = pindex / MIGRATE_PCPTYPES;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pindex >= NR_LOWORDER_PCP_LISTS)
-		order = HPAGE_PMD_ORDER;
-#else
-	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
-#endif
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		if (pindex >= NR_LOWORDER_PCP_LISTS)
+			order = HPAGE_PMD_ORDER;
+	} else {
+		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
+	}
 
 	return order;
 }
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-cleanup-flag-vars-in-alloc_pages_bulk_noprof.patch
drm-managed-use-special-gfp_t-format-specifier.patch
mm-kfence-use-special-gfp_t-format-specifier.patch
net-rds-use-special-gfp_t-format-specifier.patch
mm-introduce-for_each_free_list.patch
mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback.patch
mm-rejig-pageblock-mask-definitions.patch
mm-page_alloc-remove-ifdefs-from-pindex-helpers.patch


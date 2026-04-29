Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AAF3803DC
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 15:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777477076; cv=none; b=UOQY13QtyWCS+mM5X18Xb7JEK5tAtJm/z1KrN0GLNbtkybCLiNtxbiI/JjUBX0DHXDuS2uZPrwGxtisXXmpuER52HD1TuLmdAGm1rZ0MEW/sCUm7iYvqK/Bm/JRI2yKi+HhBFLjUl0hEWWYrX5epeNeQfbXY0QAQAZ90+7bj/xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777477076; c=relaxed/simple;
	bh=6yq9f3HwNpr9yIxEKnhs3oryUVRZNCGHI7YKM33InPQ=;
	h=Date:To:From:Subject:Message-Id; b=Gu7NCWKVrDwWRhihIPkDTOI/RBTX6Bdx3bLkg+JFP41WQttIxDKQEKiRYRABvjVUGUI2dZYNGZD+POf4S0BcAFbkTWGr/fadFXyVmYyVm/xuoxSJEhjM/ZaMcpWZduVMJXgL8qLw/1Ztckh0LsWJljgmHSedS2Ahtj7++ce9MqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PzEBmLUz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PzEBmLUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C16C19425;
	Wed, 29 Apr 2026 15:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777477076;
	bh=6yq9f3HwNpr9yIxEKnhs3oryUVRZNCGHI7YKM33InPQ=;
	h=Date:To:From:Subject:From;
	b=PzEBmLUz3sQbmLiYGCEnwwLje6fqirDfreduCbR3uMCxw7caz4n2kpkLSHoXJ34zj
	 BmXhJ6mITZyJq/2dKt+hfdyrSQIDfqZQV9eNxAjmkVeKpNSb6ogrZ4IK/VUltk6KxR
	 B2ibBuNdFAdXEpBeadtP4Cji5+Mk3dfjNyM2bSLc=
Date: Wed, 29 Apr 2026 08:37:55 -0700
To: mm-commits@vger.kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-zone-lock-guard-in-put_page_back_buddy.patch added to mm-new branch
Message-Id: <20260429153755.E9C16C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use zone lock guard in put_page_back_buddy()
has been added to the -mm mm-new branch.  Its filename is
     mm-use-zone-lock-guard-in-put_page_back_buddy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-zone-lock-guard-in-put_page_back_buddy.patch

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
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: use zone lock guard in put_page_back_buddy()
Date: Wed, 29 Apr 2026 12:02:11 +0000

Use spinlock_irqsave zone lock guard in put_page_back_buddy() to replace
the explicit lock/unlock pattern with automatic scope-based cleanup.

Link: https://lore.kernel.org/b0fceedca37139da36aa626ac72eb9840b641021.1777462630.git.d@ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-use-zone-lock-guard-in-put_page_back_buddy
+++ a/mm/page_alloc.c
@@ -7665,23 +7665,19 @@ bool take_page_off_buddy(struct page *pa
 bool put_page_back_buddy(struct page *page)
 {
 	struct zone *zone = page_zone(page);
-	unsigned long flags;
-	bool ret = false;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 	if (put_page_testzero(page)) {
 		unsigned long pfn = page_to_pfn(page);
 		int migratetype = get_pfnblock_migratetype(page, pfn);
 
 		ClearPageHWPoisonTakenOff(page);
 		__free_one_page(page, pfn, zone, 0, migratetype, FPI_NONE);
-		if (TestClearPageHWPoison(page)) {
-			ret = true;
-		}
+		if (TestClearPageHWPoison(page))
+			return true;
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
 
-	return ret;
+	return false;
 }
 #endif
 
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-use-zone-lock-guard-in-reserve_highatomic_pageblock.patch
mm-use-zone-lock-guard-in-unset_migratetype_isolate.patch
mm-use-zone-lock-guard-in-unreserve_highatomic_pageblock.patch
mm-use-zone-lock-guard-in-set_migratetype_isolate.patch
mm-use-zone-lock-guard-in-take_page_off_buddy.patch
mm-use-zone-lock-guard-in-put_page_back_buddy.patch
mm-use-zone-lock-guard-in-free_pcppages_bulk.patch
mm-use-zone-lock-guard-in-__offline_isolated_pages.patch


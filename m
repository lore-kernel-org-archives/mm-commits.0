Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D841531F8
	for <mm-commits@vger.kernel.org>; Sat, 26 Oct 2024 23:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729985571; cv=none; b=LI76fJYMDaOxi4JkC0Due8AAaBr5qxnzuqRzIbZ0rRa5i/8ZHyc2Dt6IvJxftG+Sj4JZIN7QJW4N4nEHP+8VRCuarPrGR6dn7viodqnlr1jRtvNjK9G/AUDf3YX6Ast16HdqTW+DZWqPMGBHFkR3CwOVE7qkjlHlU+P2RFMoqK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729985571; c=relaxed/simple;
	bh=yA8eK3tjD9ksGIykVDEJ/UV8eul+KIQVSriA4jd35GI=;
	h=Date:To:From:Subject:Message-Id; b=V0Ma2yAMb9Jaex9sN7K4svjOiEc7TDoIobTdO7zH8fVGMgWX+m0lYhymm/T/5ztCknda39cpoSfN99odnbHTkKpjKoVpupPmr6cQq7+BjI0DXvBxPSEyLXQGx7egfnqRXf2sI85bEJQoJIQfq2JdglFoOPinmVRwH3+Xq2U6Wzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X3Xd7mWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X3Xd7mWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E04CC4CEC6;
	Sat, 26 Oct 2024 23:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729985570;
	bh=yA8eK3tjD9ksGIykVDEJ/UV8eul+KIQVSriA4jd35GI=;
	h=Date:To:From:Subject:From;
	b=X3Xd7mWoZvM/Zh0G8oAEbTEGCACNBdp2QaxZEJ9iM3rMUsQBEbST9HejnNtaU4uCG
	 ra4NIc4bBu1GCoEv472u+irSZsRRNt58jhrF40ZrLd+Z6ShxEMyocnXX3Qix4Iaoui
	 6FPLYyrnOIwxWZhpbLnMCyIRG7F5DdMjQ+yiZpAE=
Date: Sat, 26 Oct 2024 16:32:49 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rientjes@google.com,linkl@google.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-keep-track-of-free-highatomic.patch added to mm-unstable branch
Message-Id: <20241026233250.5E04CC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: keep track of free highatomic
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-keep-track-of-free-highatomic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-keep-track-of-free-highatomic.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm/page_alloc: keep track of free highatomic
Date: Fri, 25 Oct 2024 21:36:25 -0600

OOM kills due to vastly overestimated free highatomic reserves were
observed:

  ... invoked oom-killer: gfp_mask=0x100cca(GFP_HIGHUSER_MOVABLE), order=0 ...
  Node 0 Normal free:1482936kB boost:0kB min:410416kB low:739404kB high:1068392kB reserved_highatomic:1073152KB ...
  Node 0 Normal: 1292*4kB (ME) 1920*8kB (E) 383*16kB (UE) 220*32kB (ME) 340*64kB (E) 2155*128kB (UE) 3243*256kB (UE) 615*512kB (U) 1*1024kB (M) 0*2048kB 0*4096kB = 1477408kB

The second line above shows that the OOM kill was due to the following
condition:

  free (1482936kB) - reserved_highatomic (1073152kB) = 409784KB < min (410416kB)

And the third line shows there were no free pages in any
MIGRATE_HIGHATOMIC pageblocks, which otherwise would show up as type
'H'. Therefore __zone_watermark_unusable_free() underestimated the
usable free memory by over 1GB, which resulted in the unnecessary OOM
kill above.

The comments in __zone_watermark_unusable_free() warns about the
potential risk, i.e.,

  If the caller does not have rights to reserves below the min
  watermark then subtract the high-atomic reserves. This will
  over-estimate the size of the atomic reserve but it avoids a search.

However, it is possible to keep track of free pages in reserved highatomic
pageblocks with a new per-zone counter nr_free_highatomic protected by the
zone lock, to avoid a search when calculating the usable free memory.  And
the cost would be minimal, i.e., simple arithmetics in the highatomic
alloc/free/move paths.

Link: https://lkml.kernel.org/r/20241026033625.2237102-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: Link Lin <linkl@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 +
 mm/page_alloc.c        |   23 ++++++++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-keep-track-of-free-highatomic
+++ a/include/linux/mmzone.h
@@ -825,6 +825,7 @@ struct zone {
 	unsigned long watermark_boost;
 
 	unsigned long nr_reserved_highatomic;
+	unsigned long nr_free_highatomic;
 
 	/*
 	 * We don't know if the memory that we're going to allocate will be
--- a/mm/page_alloc.c~mm-page_alloc-keep-track-of-free-highatomic
+++ a/mm/page_alloc.c
@@ -644,6 +644,18 @@ static inline void account_freepages(str
 		__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, nr_pages);
 }
 
+static void account_highatomic_freepages(struct zone *zone, unsigned int order,
+					 int old_mt, int new_mt)
+{
+	int delta = 1 << order;
+
+	if (is_migrate_highatomic(old_mt))
+		WRITE_ONCE(zone->nr_free_highatomic, zone->nr_free_highatomic - delta);
+
+	if (is_migrate_highatomic(new_mt))
+		WRITE_ONCE(zone->nr_free_highatomic, zone->nr_free_highatomic + delta);
+}
+
 /* Used for pages not on another list */
 static inline void __add_to_free_list(struct page *page, struct zone *zone,
 				      unsigned int order, int migratetype,
@@ -660,6 +672,8 @@ static inline void __add_to_free_list(st
 	else
 		list_add(&page->buddy_list, &area->free_list[migratetype]);
 	area->nr_free++;
+
+	account_highatomic_freepages(zone, order, -1, migratetype);
 }
 
 /*
@@ -681,6 +695,8 @@ static inline void move_to_free_list(str
 
 	account_freepages(zone, -(1 << order), old_mt);
 	account_freepages(zone, 1 << order, new_mt);
+
+	account_highatomic_freepages(zone, order, old_mt, new_mt);
 }
 
 static inline void __del_page_from_free_list(struct page *page, struct zone *zone,
@@ -698,6 +714,8 @@ static inline void __del_page_from_free_
 	__ClearPageBuddy(page);
 	set_page_private(page, 0);
 	zone->free_area[order].nr_free--;
+
+	account_highatomic_freepages(zone, order, migratetype, -1);
 }
 
 static inline void del_page_from_free_list(struct page *page, struct zone *zone,
@@ -3081,11 +3099,10 @@ static inline long __zone_watermark_unus
 
 	/*
 	 * If the caller does not have rights to reserves below the min
-	 * watermark then subtract the high-atomic reserves. This will
-	 * over-estimate the size of the atomic reserve but it avoids a search.
+	 * watermark then subtract the free pages reserved for highatomic.
 	 */
 	if (likely(!(alloc_flags & ALLOC_RESERVES)))
-		unusable_free += z->nr_reserved_highatomic;
+		unusable_free += READ_ONCE(z->nr_free_highatomic);
 
 #ifdef CONFIG_CMA
 	/* If allocation can't use CMA areas don't use free CMA pages */
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-allow-set-clear-page_type-again.patch
mm-multi-gen-lru-remove-mm_leaf_old-and-mm_nonleaf_total-stats.patch
mm-multi-gen-lru-use-pteppmdp_clear_young_notify.patch
mm-page_alloc-keep-track-of-free-highatomic.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3537A369996
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027562; cv=none; b=P2mlpUG8KaSwEufB+qtLgiQtuag4zbJyDajkmacyEvhUgsybMoDy/7yFAKK4FIrJHATvEy8y9rESOuI0IXYYq8xz9+VRT6Rw6Wcqo8FEI/cbw2fdOaskJxjfFfse+JXqOiztk9HKkzr7uAIXspYMzB6f2FAX4sgh2Ft74N08zos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027562; c=relaxed/simple;
	bh=nNGxPDZy3RSoHSyJTH/fwblCvirhYZ3DCLv09vIEH9M=;
	h=Date:To:From:Subject:Message-Id; b=svyA4Rgap7LJXi+CqcgfGQ1XEFMDT0Zz04PEVwLhs4xIGAlaJQzzaCktJLnDRPit5ogfYOnXi2jLluZBJeEsuJpHWAl7Fcs0gUJ0LYUzpb1XOBw0IohCxK+IdnY2HUVHnVzjnhUZz3v0QFx//5s99pj/sitsRNVyqSgm2mDY9b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cI8kZSxx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cI8kZSxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77441F00893;
	Fri, 29 May 2026 04:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027560;
	bh=pcBX8jL2Xu0MR//sHaKA+PT+LQEiw/MzCD/LJPx1Yp0=;
	h=Date:To:From:Subject;
	b=cI8kZSxxyeut6mU/JesKCJVHhhy/bbg51ev3N3EKxLUPyna5fNJiU+dP/kMfmw/64
	 pefNlR2LhRS4BeZW3pmd4cMv6MG15ypQG5RIwoAKYOo8gSp1EtmlmMFNcmLCYVTjAq
	 Qzc9yS8DhtqS+EIRZrhkkDsOxsO8nQtbggkrMD0k=
Date: Thu, 28 May 2026 21:06:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,shikemeng@huaweicloud.com,ryan.roberts@arm.com,nphamcs@gmail.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-fix-outdated-comment-about-freeing-subpages-in-__folio_split.patch removed from -mm tree
Message-Id: <20260529040600.C77441F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: fix outdated comment about freeing subpages in __folio_split
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-outdated-comment-about-freeing-subpages-in-__folio_split.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/huge_memory: fix outdated comment about freeing subpages in __folio_split
Date: Thu, 23 Apr 2026 11:49:17 +0800

The comment appears to be outdated.  add_to_swap() no longer exists,
and the explanation of why we need to call put_page() after splitting
could be made more general.

Link: https://lore.kernel.org/20260423034917.8234-1-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-outdated-comment-about-freeing-subpages-in-__folio_split
+++ a/mm/huge_memory.c
@@ -4190,11 +4190,10 @@ fail:
 
 		folio_unlock(new_folio);
 		/*
-		 * Subpages may be freed if there wasn't any mapping
-		 * like if add_to_swap() is running on a lru page that
-		 * had its mapping zapped. And freeing these pages
-		 * requires taking the lru_lock so we do the put_page
-		 * of the tail pages after the split is complete.
+		 * Subpages whose mapping has been zapped may be freed
+		 * earlier, but freeing them requires taking the
+		 * lru_lock, so we defer put_page() on tail pages until
+		 * after the split completes.
 		 */
 		free_folio_and_swap_cache(new_folio);
 	}
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-mglru-use-folio_mark_accessed-to-replace-folio_set_active.patch
mm-mglru-avoid-reclaim-type-fall-back-when-isolation-makes-no-progress.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA359292B2E
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 02:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782786113; cv=none; b=Ymzlkt0Fg67aSWQy5uNkZJDTPsbpqYTTBZt+bu8T9nclqYS5V44xYryrYu8uqX9u8oHfuv0fxN7fjGMAo/5G8lA55PPY+JLTIUEWYL8U6RjkjpVgC+x1t7Uc9eY5CAGaQwS9smVQv9rmHbSqfYHrE6jtigg8JePkBfBXjTXeYH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782786113; c=relaxed/simple;
	bh=Jt4joTvZ767pJ4EXdnOdx0XMry8odHQKKk5xucahewA=;
	h=Date:To:From:Subject:Message-Id; b=Nj5eLeMMWa0HKRF8nXZ81aQ+Ldtbo80tRBhwjfqDVDysLvz8ZZlD05+Z6TUqO7vkU9GjrjlIw4A28vmqdhlOM69tK65eM7bY8sXYx7G++EvCoZuEpEroW+pVArAng+B04Lt1rAvG9+InhxB+V7TpCCzJuK6VxJzRH54Pnq321Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J4zbKA+D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J4zbKA+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BAD1F000E9;
	Tue, 30 Jun 2026 02:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782786112;
	bh=9mBcVgabOYe/oCaakkjZa6dizfqLawh8/PizZNuedcM=;
	h=Date:To:From:Subject;
	b=J4zbKA+DryQMxSeiTYjZa1X0Dm7tDX7+8xowleewNAIUS1k+zFk8v1c8SPuqzjQGQ
	 2Aijz5cbgY3Vi4OnVg2YfzidMaaBxizASxTWh6bzQzjpAqND6Kt94EJXFK2bY5h0F3
	 gRMTIsASUbFmshIO7DMmS0bTbqSul/5oT1m+LRSY=
Date: Mon, 29 Jun 2026 19:21:51 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_vma_mapped-fix-device-private-pmd-handling.patch removed from -mm tree
Message-Id: <20260630022152.20BAD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_vma_mapped: fix device-private PMD handling
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mapped-fix-device-private-pmd-handling.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_vma_mapped: fix device-private PMD handling
Date: Wed, 24 Jun 2026 06:53:53 +0000

Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
device-private entries") introduced the concept of device-private PMD
entries, but did not correctly update the rmap walk code to account for
them.

As a result, when page_vma_mapped_walk() encounters device-private PMD
entries, it takes no action other than to acquire the PMD lock and exit.

However this is highly problematic for two reasons - firstly, device
private entries possess a PFN so check_pmd() needs to be called to ensure
an overlapping PFN range.

Secondly, and more importantly, if PVMW_MIGRATION is set the caller
assumes the returned entry is a migration entry, resulting in memory
corruption when the caller tries to interpret the device private entry as
such.

In addition, commit 146287290023 ("mm/huge_memory: implement
device-private THP splitting") allowed device private PMDs to be split
like THP mappings, but again did not update this code path.

As a result, we might race a PMD split prior to acquiring the PMD lock.

This patch addresses all of these issues by invoking check_pmd(), ensuring
PVMW_MIGRATION is not set and checks whether a split raced as we do for
PMD THP and migration entries.

Link: https://lore.kernel.org/20260624065353.1622-1-richard.weiyang@gmail.com
Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: David Hildenbrand <david@kernel.org>
Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped-fix-device-private-pmd-handling
+++ a/mm/page_vma_mapped.c
@@ -269,14 +269,24 @@ restart:
 			/* THP pmd was split under us: handle on pte level */
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
-		} else if (!pmd_present(pmde)) {
-			const softleaf_t entry = softleaf_from_pmd(pmde);
+		} else if (pmd_is_device_private_entry(pmde)) {
+			softleaf_t entry;
+
+			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
+			pmde = *pvmw->pmd;
+			entry = softleaf_from_pmd(pmde);
 
-			if (softleaf_is_device_private(entry)) {
-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
+			if (likely(softleaf_is_device_private(entry))) {
+				if (pvmw->flags & PVMW_MIGRATION)
+					return not_found(pvmw);
+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
+					return not_found(pvmw);
 				return true;
 			}
-
+			/* device-private pmd was split under us: handle on pte level */
+			spin_unlock(pvmw->ptl);
+			pvmw->ptl = NULL;
+		} else if (!pmd_present(pmde)) {
 			if ((pvmw->flags & PVMW_SYNC) &&
 			    thp_vma_suitable_order(vma, pvmw->address,
 						   PMD_ORDER) &&
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are



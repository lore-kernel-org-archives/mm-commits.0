Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D4531F99A;
	Thu,  9 Jul 2026 22:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783637394; cv=none; b=Zst8QyoiCeUryXJ4WvYB0dNMntYnTcR3zUO8yMo5c+ZoE/ruRb478qI610EwXQfhAEV8++E5H/NVt457HZErjafFpnI+xkB8iWZvlYLP3KDCZlygjm+ycyJZTCE/Wl/0EgNEQDxA3du4KOeJgzdMNPHdEDAVu63qmcE/eJvF74U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783637394; c=relaxed/simple;
	bh=Okqp7MLfijeHbLRmU4RLIPd328cKzS9iZVT5PGhMZE4=;
	h=Date:To:From:Subject:Message-Id; b=p874YptvTT9rx8OagFyUVZxq29qOw+Y2scIS9KrYGcLhNZjqiKPzmg7loQ8w2f8oVRdzi4WcqVJWjVyQ33HkIsQ2BikaxRJPJ3RMtxenL73zft348RSXF8mfYKrLrD9Zh+Vsbf3aPTs4bUFedAnuV1MasYNULgwx0ZWFephzu4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CMJW5v9Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CMJW5v9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556241F00A3A;
	Thu,  9 Jul 2026 22:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783637392;
	bh=0Lo1AHINaaeIUQHLTwQMOvobS1f/aUGZxPodZlyVvU4=;
	h=Date:To:From:Subject;
	b=CMJW5v9YqhldQcYr35/PgaaX3oHYUr2UH3EBL+C80vpTC2sersOC0+gYLWyA3vJqM
	 gCxsn4t28PhfRmiiwm6VwfQfs/NkLzEuwK6Ast/934Eb2Y7vSHj3xX9DNqUFrY4i3L
	 5aVVZWlqH3c1cgIxO6v4brW5SQHv2XzhWt2493hk=
Date: Thu, 09 Jul 2026 15:49:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,stable@vger.kernel.org,sj@kernel.org,ljs@kernel.org,lance.yang@linux.dev,klarasmodin@gmail.com,david@kernel.org,balbirs@nvidia.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_vma_mapped-fix-device-private-pmd-handling.patch removed from -mm tree
Message-Id: <20260709224952.556241F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_vma_mapped: fix device-private PMD handling
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mapped-fix-device-private-pmd-handling.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_vma_mapped: fix device-private PMD handling
Date: Tue, 30 Jun 2026 02:15:40 +0000

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
PMVW_MIGRATION is not set and checks whether a split raced us we do for
PMD THP and migration entries.

Instead of checking for a subset of the cases after taking the pmd_lock(),
put device-private along with pmd_trans_huge() and
pmd_is_migration_entry().  Also remove thp_migration_supported() as it is
already guarded by pmd_is_migration_entry().

[akpm@linux-foundation.org: fix Raspberry Pi 1 build, per David]
Link: https://lore.kernel.org/20260630021540.17297-1-richard.weiyang@gmail.com
Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: David Hildenbrand <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Tested-by: Klara Modin <klarasmodin@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: <stable@vger.kernel.org>q
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped-fix-device-private-pmd-handling
+++ a/mm/page_vma_mapped.c
@@ -243,21 +243,31 @@ restart:
 		 */
 		pmde = pmdp_get_lockless(pvmw->pmd);
 
-		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
+		if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+		    (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
+		    pmd_is_device_private_entry(pmde))) {
 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
 			pmde = *pvmw->pmd;
-			if (!pmd_present(pmde)) {
+			if (pmd_is_migration_entry(pmde)) {
 				softleaf_t entry;
 
-				if (!thp_migration_supported() ||
-				    !(pvmw->flags & PVMW_MIGRATION))
+				if (!(pvmw->flags & PVMW_MIGRATION))
 					return not_found(pvmw);
 				entry = softleaf_from_pmd(pmde);
+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
+					return not_found(pvmw);
+				return true;
+			} else if (pmd_is_device_private_entry(pmde)) {
+				softleaf_t entry;
 
-				if (!softleaf_is_migration(entry) ||
-				    !check_pmd(softleaf_to_pfn(entry), pvmw))
+				if (pvmw->flags & PVMW_MIGRATION)
+					return not_found(pvmw);
+				entry = softleaf_from_pmd(pmde);
+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
 					return not_found(pvmw);
 				return true;
+			} else if (!pmd_present(pmde)) {
+				return not_found(pvmw);
 			}
 			if (likely(pmd_trans_huge(pmde))) {
 				if (pvmw->flags & PVMW_MIGRATION)
@@ -266,17 +276,10 @@ restart:
 					return not_found(pvmw);
 				return true;
 			}
-			/* THP pmd was split under us: handle on pte level */
+			/* THP/device-private pmd was split under us: handle on pte level */
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
 		} else if (!pmd_present(pmde)) {
-			const softleaf_t entry = softleaf_from_pmd(pmde);
-
-			if (softleaf_is_device_private(entry)) {
-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
-				return true;
-			}
-
 			if ((pvmw->flags & PVMW_SYNC) &&
 			    thp_vma_suitable_order(vma, pvmw->address,
 						   PMD_ORDER) &&
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are



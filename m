Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F5433556D
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465753; cv=none; b=css8lZwe66WLnY8pw8lgW7lVTJ92XQaEAUHVoq8ygbNYywySF1yNAPWLxgFjDS4ppM96/xySyoq+vVU5Ln+kNQ8eBPKScI5QCJF4PQCEVWVO1Psvdmpx1gVx7e/KSHDvf4ZfEA0yyXvpHZcOk5idQOaVy3aq+YzhGu8bG90MXpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465753; c=relaxed/simple;
	bh=bhhIXnm9LvCaQsiPgUQofsKOuRxCZoHewa5U6gO86Fs=;
	h=Date:To:From:Subject:Message-Id; b=ADEEBwry/rMolcGv75KRAHbVILXfp1h8CtNO7Pp2LpKg3JtEXlpWeit3YFL0vmwHM+W89KHg9RW0+E2nzLGmBex5pOu+NQfGFF0xrELzR5891XNK/zCCX+GSGa+DpxitMkN8i6bKdtUX5/rn5Wi59/RH2+i69RDeeP9wcRIEoDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wtWskhQ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wtWskhQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830ED1F000E9;
	Fri, 31 Jul 2026 02:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465751;
	bh=BsTLSiSK3GqzgeseKjNIieWCPBKmGAcLYF910zd2mFE=;
	h=Date:To:From:Subject;
	b=wtWskhQ+T3NNdserqBYdIlM8i5Rxxfl7335noLAJf6yZdo076BNDbcef5lKv3oavc
	 2SPBaHNIo93cMhL9Kc7CkMaE+cmx/jk17MqTKqn+8kS7AIydgovyrHlx511yYK5AbS
	 Mb5rWAPU0I9vop2mRHVvfiEG40vPQNCXIVjpypWs=
Date: Thu, 30 Jul 2026 19:42:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,sj@kernel.org,shakeel.butt@linux.dev,sashiko-bot@kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,lance.yang@linux.dev,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_device-pin-large-folios-before-splitting.patch removed from -mm tree
Message-Id: <20260731024231.830ED1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate_device: pin large folios before splitting
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-pin-large-folios-before-splitting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm/migrate_device: pin large folios before splitting
Date: Wed, 1 Jul 2026 07:06:38 -0700

migrate_vma_collect_pmd() can detect a large folio while holding the PTE
lock, then drop the PTE lock before calling migrate_vma_split_folio(). 
The split helper took its own reference, but only after the lock had
already been dropped.

One way to hit this is device migration over a range that contains a large
folio.  The walker reads the PTE while holding the PTE lock and derives
the folio either from a present PTE via vm_normal_page(), or from a
non-present PTE that encodes a device-private softleaf entry.  It then has
to drop the PTE lock because split_folio() can block.  Before
migrate_vma_split_folio() gets a folio reference, concurrent reclaim,
migration, or truncation can replace or clear the entry and drop the last
reference to the folio.  The split helper would then take a reference and
lock on a stale folio pointer.

Take a temporary reference before dropping the PTE lock and pass that
reference into migrate_vma_split_folio().  The helper consumes the
reference, so split_folio() still sees only the expected caller pin
instead of an extra pin that could make the split fail.

[usama.arif@linux.dev: condense comment about folio reference]
  Link: https://lore.kernel.org/87bbf335-648f-4065-abc8-3eaab5a3beeb@linux.dev
Link: https://lore.kernel.org/20260701140638.840773-1-usama.arif@linux.dev
Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260630164143.1595669-1-usama.arif%40linux.dev
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-pin-large-folios-before-splitting
+++ a/mm/migrate_device.c
@@ -77,6 +77,9 @@ static int migrate_vma_collect_hole(unsi
  * @folio: the folio to split
  * @fault_page: struct page associated with the fault if any
  *
+ * If @folio is not the folio containing @fault_page, the caller must hold a
+ * reference on @folio. The helper consumes that reference.
+ *
  * Returns 0 on success
  */
 static int migrate_vma_split_folio(struct folio *folio,
@@ -86,10 +89,8 @@ static int migrate_vma_split_folio(struc
 	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
 	struct folio *new_fault_folio = NULL;
 
-	if (folio != fault_folio) {
-		folio_get(folio);
+	if (folio != fault_folio)
 		folio_lock(folio);
-	}
 
 	ret = split_folio(folio);
 	if (ret) {
@@ -310,6 +311,9 @@ again:
 			if (folio_test_large(folio)) {
 				int ret;
 
+				/* migrate_vma_split_folio() consumes this reference */
+				if (folio != fault_folio)
+					folio_get(folio);
 				lazy_mmu_mode_disable();
 				pte_unmap_unlock(ptep, ptl);
 				ret = migrate_vma_split_folio(folio,
@@ -353,6 +357,9 @@ again:
 			if (folio && folio_test_large(folio)) {
 				int ret;
 
+				/* migrate_vma_split_folio() consumes this reference */
+				if (folio != fault_folio)
+					folio_get(folio);
 				lazy_mmu_mode_disable();
 				pte_unmap_unlock(ptep, ptl);
 				ret = migrate_vma_split_folio(folio,
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-mempolicy-skip-non-present-pmds-when-queueing-folios.patch
mm-madvise-skip-device-private-pmds-in-cold-and-pageout-walks.patch
mm-huge_memory-skip-device-private-pmds-in-madvise_free_huge_pmd.patch
mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers.patch
mm-vmscan-reduce-lru_lock-contention-via-vmstat-derived-scan-balance-cost.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F48128373
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 22:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202200; cv=none; b=QqcAe6cUaEghTy2xKuVxifWxkOLn2QjDhOt9qRYcXml1j8NVPmQTznAMEd61If9hxlCk+SA0e4CYJ4asRkgKffvgdZg06/CD5BeHsaTWUkzcx3/SVdV/R6m6Lco34ERxAqCGOUkTy4FuoLos20syOOKVb9BaEOnVA0AM2RPr24I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202200; c=relaxed/simple;
	bh=W1cZuRYOcpbBfPmp/vKp6TvFe6LV8UywFmWntLns+Xw=;
	h=Date:To:From:Subject:Message-Id; b=nNOg3p60Bfbkhisnu09/6jhBxC2a28GonJGP9DobVflSSo2ivVb3CaOsLYLAylg/yKvKz/zY1tJ/k1Ttnjvo28D29eZ7Brp4USEfGfZvbYLG8iXF9U06Eg8fnLbaYHb7TlJHSizlsQ0hs+PeEV9ndmkZe9kBFuxYYmFIRp+p8wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QRd7nZDy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QRd7nZDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566FF1F00893;
	Wed, 23 Sep 2026 22:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790202199;
	bh=KNw/NAEUB58QIlreAJIztGGAf/NTIjprnTK9t3g3Tt0=;
	h=Date:To:From:Subject;
	b=QRd7nZDyjOmY7b0eE0TeOG2E0b0aI0CLEwK/oc+P/TQfhg1XlP/FzMIE7OkO28Vwl
	 AYvcz2HcKwU0lNBuqyT72LnRAuZReV0+8h664phzCVJ9ArUoF7j8ysUtsmp2Yqs8jd
	 LEER7JQ0bnKQE+di1XJzGslKtdRVgYW6uRpV9pVY=
Date: Wed, 23 Sep 2026 15:23:18 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-rename-remap_page-to-remap_anon_folio.patch removed from -mm tree
Message-Id: <20260923222319.566FF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: rename remap_page() to remap_anon_folio()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-rename-remap_page-to-remap_anon_folio.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: rename remap_page() to remap_anon_folio()
Date: Tue, 15 Sep 2026 01:14:50 +0800

remap_page() now only has one caller, __folio_freeze_split_anon(), and is
only ever called for anon folios: unmap_folio() currently leaves file
folios unmapped after the split, so they need no remapping.

Rename it to remap_anon_folio() to make that explicit, and add a
VM_WARN_ON_FOLIO() documenting it.

Link: https://lore.kernel.org/20260915-swap-thp-cleanup-v5-9-39878b37dfb0@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/huge_memory.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-rename-remap_page-to-remap_anon_folio
+++ a/mm/huge_memory.c
@@ -3551,7 +3551,7 @@ static void unmap_folio(struct folio *fo
 	/*
 	 * Anon pages need migration entries to preserve them, but file
 	 * pages can simply be left unmapped, then faulted back on demand.
-	 * If that is ever changed (perhaps for mlock), update remap_page().
+	 * If that is ever changed (perhaps for mlock), update remap_anon_folio().
 	 */
 	if (folio_test_anon(folio))
 		try_to_migrate(folio, ttu_flags);
@@ -3636,10 +3636,17 @@ bool unmap_huge_pmd_locked(struct vm_are
 	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
 }
 
-static void remap_page(struct folio *folio, unsigned long nr, int flags)
+static void remap_anon_folio(struct folio *folio, unsigned long nr, int flags)
 {
 	int i = 0;
 
+	/*
+	 * unmap_folio() installs migration entries only for anon folios,
+	 * so currently only anon folios need to be remapped. File folios
+	 * stay unmapped after the split and are faulted back on demand.
+	 */
+	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
+
 	for (;;) {
 		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
 		i += folio_nr_pages(folio);
@@ -3723,7 +3730,7 @@ static void __split_folio_to_order(struc
 		 *
 		 * Note that for mapped sub-pages of an anonymous THP,
 		 * PG_anon_exclusive has been cleared in unmap_folio() and is stored in
-		 * the migration entry instead from where remap_page() will restore it.
+		 * the migration entry instead from where remap_anon_folio() will restore it.
 		 * We can still have PG_anon_exclusive set on effectively unmapped and
 		 * unreferenced sub-pages of an anonymous THP: we can simply drop
 		 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
@@ -4083,7 +4090,7 @@ out_no_split:
 	if (need_remap) {
 		if (!ret && !folio_is_device_private(folio))
 			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
-		remap_page(folio, 1 << old_order, ttu_flags);
+		remap_anon_folio(folio, 1 << old_order, ttu_flags);
 	}
 
 	return ret;
@@ -4205,7 +4212,7 @@ static int __folio_freeze_split_file(str
 fail:
 	/*
 	 * If we want to use try_to_migrate() on file in unmap_folio,
-	 * remember to add remap_page() and adapt it.
+	 * remember to add remap_anon_folio() and adapt it.
 	 */
 	xas_unlock_irq(xas);
 	if (nr_shmem_dropped)
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch
mm-huge_memory-move-the-racy-refcount-check-into-unmap_folio.patch
mm-huge_memory-move-filemap-management-into-the-file-split-helper.patch
mm-huge_memory-move-anon_vma-handling-into-the-anon-split-helper.patch
mm-huge_memory-move-memcg-switch-into-the-file-split-helper.patch
mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper.patch
mm-huge_memory-clean-up-after-split-folio-freeing-in-__folio_split.patch
mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split.patch
mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch


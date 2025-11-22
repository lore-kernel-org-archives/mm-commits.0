Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171EE1D555
	for <mm-commits@vger.kernel.org>; Sat, 22 Nov 2025 22:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763848935; cv=none; b=VT7h1eY/bVqfccBtOg47KGOHLYl0XKj8tGeEGQqp7ku2GKQi4MLv3/5yI7aMqUevXyZsAAFbnQb8f09u3Om+t8y6JTJU1XYiJ1sowZF+rCSpNHQIALUjHqSowG6euCQWvrqTmrvIIvswKvfGTroZgTk58KDxSu5x8Ml3BW4NiPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763848935; c=relaxed/simple;
	bh=z2hL41KvibxxGngzUwjUgJ7/7L2OEdOCK7UmoP9KsqQ=;
	h=Date:To:From:Subject:Message-Id; b=AOpnsgno/8SFgb4BELnC6zM07ak3aFMjtynyRo9SpOnEGBDfN85HwDkwrCfGQsBPBhuw+Ij9urBYcNgFSCnijVNf2KpLsal26rMQo1lUMsjOyKUOpEvzeUM2/cIPIv2ePMTELdK8lWazM9NIACCj/G3I4W1Puw+6AcCKOyTA5G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0C4pMi70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0C4pMi70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85654C4CEF5;
	Sat, 22 Nov 2025 22:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763848934;
	bh=z2hL41KvibxxGngzUwjUgJ7/7L2OEdOCK7UmoP9KsqQ=;
	h=Date:To:From:Subject:From;
	b=0C4pMi70T8CrwPbT5KbX4SPO6TolhttRT9FvNRKmU3kjD7RvItBbF0+oKuAW1u5sI
	 A0QD0rasBMB12CID5eqk8frNbkI2MNt37nh3RBn0VVYki+A+JjAP1FVK2PWyqUC+E3
	 YaZeYC2xleifvI8O0GMdbeSu0P97Sa3TXDv0jSRc=
Date: Sat, 22 Nov 2025 14:02:14 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-replace-can_split_folio-with-direct-refcount-calculation.patch added to mm-new branch
Message-Id: <20251122220214.85654C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: replace can_split_folio() with direct refcount calculation
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-replace-can_split_folio-with-direct-refcount-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-replace-can_split_folio-with-direct-refcount-calculation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: replace can_split_folio() with direct refcount calculation
Date: Fri, 21 Nov 2025 21:55:27 -0500

can_split_folio() is just a refcount comparison, making sure only the
split caller holds an extra pin.  Open code it with
folio_expected_ref_count() != folio_ref_count() - 1.  For the extra_pins
used by folio_ref_freeze(), add folio_cache_references() to calculate it.

Link: https://lkml.kernel.org/r/20251122025529.1562592-3-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    1 
 mm/huge_memory.c        |   43 +++++++++++++++-----------------------
 mm/vmscan.c             |    3 +-
 3 files changed, 19 insertions(+), 28 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-replace-can_split_folio-with-direct-refcount-calculation
+++ a/include/linux/huge_mm.h
@@ -369,7 +369,6 @@ enum split_type {
 	SPLIT_TYPE_NON_UNIFORM,
 };
 
-bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order);
 int folio_split_unmapped(struct folio *folio, unsigned int new_order);
--- a/mm/huge_memory.c~mm-huge_memory-replace-can_split_folio-with-direct-refcount-calculation
+++ a/mm/huge_memory.c
@@ -3455,23 +3455,6 @@ static void lru_add_split_folio(struct f
 	}
 }
 
-/* Racy check whether the huge page can be split */
-bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
-{
-	int extra_pins;
-
-	/* Additional pins from page cache */
-	if (folio_test_anon(folio))
-		extra_pins = folio_test_swapcache(folio) ?
-				folio_nr_pages(folio) : 0;
-	else
-		extra_pins = folio_nr_pages(folio);
-	if (pextra_pins)
-		*pextra_pins = extra_pins;
-	return folio_mapcount(folio) == folio_ref_count(folio) - extra_pins -
-					caller_pins;
-}
-
 static bool page_range_has_hwpoisoned(struct page *page, long nr_pages)
 {
 	for (; nr_pages; page++, nr_pages--)
@@ -3776,17 +3759,26 @@ int folio_check_splittable(struct folio
 	return 0;
 }
 
+/* Number of folio references from the pagecache or the swapcache. */
+static unsigned int folio_cache_references(const struct folio *folio)
+{
+	if (folio_test_anon(folio) && !folio_test_swapcache(folio))
+		return 0;
+	return folio_nr_pages(folio);
+}
+
 static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
 					     struct page *split_at, struct xa_state *xas,
 					     struct address_space *mapping, bool do_lru,
 					     struct list_head *list, enum split_type split_type,
-					     pgoff_t end, int *nr_shmem_dropped, int extra_pins)
+					     pgoff_t end, int *nr_shmem_dropped)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
 	int old_order = folio_order(folio);
 	int ret = 0;
 	struct deferred_split *ds_queue;
+	int extra_pins = folio_cache_references(folio);
 
 	VM_WARN_ON_ONCE(!mapping && end);
 	/* Prevent deferred_split_scan() touching ->_refcount */
@@ -3956,7 +3948,7 @@ static int __folio_split(struct folio *f
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
 	int remap_flags = 0;
-	int extra_pins, ret;
+	int ret;
 	pgoff_t end = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4036,7 +4028,7 @@ static int __folio_split(struct folio *f
 	 * Racy check if we can split the page, before unmap_folio() will
 	 * split PMDs
 	 */
-	if (!can_split_folio(folio, 1, &extra_pins)) {
+	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1) {
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
@@ -4059,8 +4051,7 @@ static int __folio_split(struct folio *f
 	}
 
 	ret = __folio_freeze_and_split_unmapped(folio, new_order, split_at, &xas, mapping,
-						true, list, split_type, end, &nr_shmem_dropped,
-						extra_pins);
+						true, list, split_type, end, &nr_shmem_dropped);
 fail:
 	if (mapping)
 		xas_unlock(&xas);
@@ -4134,20 +4125,20 @@ out:
  */
 int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 {
-	int extra_pins, ret = 0;
+	int ret = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
 
-	if (!can_split_folio(folio, 1, &extra_pins))
+	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
 		return -EAGAIN;
 
 	local_irq_disable();
 	ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page, NULL,
 						NULL, false, NULL, SPLIT_TYPE_UNIFORM,
-						0, NULL, extra_pins);
+						0, NULL);
 	local_irq_enable();
 	return ret;
 }
@@ -4640,7 +4631,7 @@ static int split_huge_pages_pid(int pid,
 		 * can be split or not. So skip the check here.
 		 */
 		if (!folio_test_private(folio) &&
-		    !can_split_folio(folio, 0, NULL))
+		    folio_expected_ref_count(folio) != folio_ref_count(folio))
 			goto next;
 
 		if (!folio_trylock(folio))
--- a/mm/vmscan.c~mm-huge_memory-replace-can_split_folio-with-direct-refcount-calculation
+++ a/mm/vmscan.c
@@ -1284,7 +1284,8 @@ retry:
 					goto keep_locked;
 				if (folio_test_large(folio)) {
 					/* cannot split folio, skip it */
-					if (!can_split_folio(folio, 1, NULL))
+					if (folio_expected_ref_count(folio) !=
+					    folio_ref_count(folio) - 1)
 						goto activate_locked;
 					/*
 					 * Split partially mapped folios right away.
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-add-split_huge_page_to_order.patch
mm-memory-failure-improve-large-block-size-folio-handling.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix-2.patch
mm-huge_memory-change-folio_split_supported-to-folio_check_splittable.patch
mm-huge_memory-replace-can_split_folio-with-direct-refcount-calculation.patch
mm-huge_memory-make-min_order_for_split-always-return-an-order.patch
mm-huge_memory-fix-folio-split-stats-counting.patch


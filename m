Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8531DFFD
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334123; cv=none; b=GlyjeLscaPI1ROaERD4ShqM9DB9yCQtm9nTn+LYCMkTIMiHPBmUiSdoSpx0SeH10ZomcsUYpbA79fpVW90cdeSZDbhgyFmw8H+sMyvKVvA7T2VI8vxwQ3CMeW0N1fkRD2GHPqcaqGZB0HatRZKoufXPOIcMCJL0ckBf97f9+A5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334123; c=relaxed/simple;
	bh=CnjJwnOQd57n9H5tap7X4Ov1BF3A3xH9SxFxlyOdHlg=;
	h=Date:To:From:Subject:Message-Id; b=isRenZDJAVovW27HOValTHLNyXySeSzN8hPxcX+FuMrMhtuck3oxjob8ZKcvgNT38Sm9Mn/zIURpUtha4Qos6KyIQzpJZc47GGcXAsmbDqkM8EJ57uWE4qXH3E+tTakc8h0D2g7v1OatEHGBHu8y67t+CMcrgFrUlcQm16MTUwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B7Rpx9pa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B7Rpx9pa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A561F0089B;
	Wed,  7 Oct 2026 00:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334122;
	bh=Xc9dWla3rjbMvWKICeq2ygcOM0w+pRp3gFGcfeyCw7M=;
	h=Date:To:From:Subject;
	b=B7Rpx9pauOPNlGTyawVLvv8K/U5NHwUjNg56Y1fNROhoVLdDw5A6Id/irf9rZL207
	 MLsS1ONptrO/tUtty8dLmNwYAcrzCxd7hBsAqtFIPjyl4KAYCOGLCLxyOsSXc4usIM
	 Zq7l3bloIfIdJ9UeCONPwS6/+apclzI5HCrUQ7OA=
Date: Tue, 06 Oct 2026 17:48:41 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,anshuman.khandual@arm.com,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-a-folio-in-the-softleaf_is_device_private-path.patch removed from -mm tree
Message-Id: <20261007004842.35A561F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use a folio in the softleaf_is_device_private path
has been removed from the -mm tree.  Its filename was
     mm-use-a-folio-in-the-softleaf_is_device_private-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm: use a folio in the softleaf_is_device_private path
Date: Wed, 19 Aug 2026 17:51:43 +0800

Use the folio APIs in the device_private migration path of do_swap_page(),
replacing four calls to compound_head() with two page_folio() calls.  The
second one re-fetches the folio from vmf->page after migrate_to_ram(),
which might have split the folio.

Link: https://lore.kernel.org/20260819095144.45660-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Link: https://lore.kernel.org/all/e20678ed-3fa1-4677-a1d7-e2af481e8302@kernel.org/
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/memory.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-use-a-folio-in-the-softleaf_is_device_private-path
+++ a/mm/memory.c
@@ -4926,18 +4926,21 @@ vm_fault_t do_swap_page(struct vm_fault
 				goto unlock;
 
 			/*
-			 * Get a page reference while we know the page can't be
-			 * freed.
+			 * Get a folio reference while we know the folio can't
+			 * be freed.
 			 */
-			if (trylock_page(vmf->page)) {
+			folio = page_folio(vmf->page);
+			if (folio_trylock(folio)) {
 				struct dev_pagemap *pgmap;
 
-				get_page(vmf->page);
+				folio_get(folio);
 				pte_unmap_unlock(vmf->pte, vmf->ptl);
 				pgmap = page_pgmap(vmf->page);
 				ret = pgmap->ops->migrate_to_ram(vmf);
-				unlock_page(vmf->page);
-				put_page(vmf->page);
+				/* migrate_to_ram() might have split the folio. */
+				folio = page_folio(vmf->page);
+				folio_unlock(folio);
+				folio_put(folio);
 			} else {
 				pte_unmap(vmf->pte);
 				softleaf_entry_wait_on_locked(entry, vmf->ptl);
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-page_owner-preserve-original-free_pid-free_tgid-during-folio-migration.patch
mm-memfd-fix-hugetlb-reservation-accounting-in-error-paths.patch
selftests-mm-fix-ptrace-peekdata-check-in-memfd_secret-test.patch
mm-hugetlb_cgroup-move-per-node-usage-on-cross-node-migration.patch
mm-hugetlb_cgroup-move-per-node-usage-on-cgroup-reparenting.patch
mm-hugetlb-account-migration-target-folio-in-per-node-nr_hugetlb-vmstat.patch
mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio.patch


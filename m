Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B2636493F
	for <mm-commits@vger.kernel.org>; Mon, 17 Aug 2026 19:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786994220; cv=none; b=d1WtNbuO+hwAXnaX63Pdwp6YUms/kHauZnfCBWW0q3zo42DuQY0FHQ6ZcnQCyQqBwmeaPA7UB+W3jWoHT4lCa5QGUDJdHT+de7J9offkQtGZL9OVq/A5fkkoiXArUb7YIgSikXBMTVwo7ZCE0RtYAtsNq1oJ3AB0ERtuwtrmxF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786994220; c=relaxed/simple;
	bh=EPj/Rq5NA6FuTahbMd6d43LwcJBj25Sl08vNw3NIXKw=;
	h=Date:To:From:Subject:Message-Id; b=n6++vl9BvG2R576z+cTk9P4Kc01uh/MOm33W1SsB8UpOT2wUwqA2LbfkU6xk+vV3WnePTWqh9gLzcyqnoOLbpni6PQUyZlp905H4l3SoqqvLXIOOYIPuMkAN2qPcMtZuFAUEO7yM1Aos9kXHGFGEml5v0JEnZkBtDRSxQ/crY/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hMY9GEXi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hMY9GEXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CA91F00A3A;
	Mon, 17 Aug 2026 19:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786994218;
	bh=vJGqGT5Rz/15Y20VcIcDPyUh0REkqR3AsVlGODcA+UY=;
	h=Date:To:From:Subject;
	b=hMY9GEXiuPbVr16/ciKJpjtFuR+CpnIpS4rxK0V2LTxkSXh6tHAESmM1G7eI28spc
	 hqHSnDY7AsY8eG/uF5UiuAVgU9UY01Qr9SsCqED4bSwEKyK1t1JgTXkZBmwBd2pfvl
	 MIyIaJhnyC56w1qi5r6IZtXaz09RLGiz0l5oA55M=
Date: Mon, 17 Aug 2026 12:16:58 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,anshuman.khandual@arm.com,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-use-a-folio-in-the-softleaf_is_device_private-path.patch removed from -mm tree
Message-Id: <20260817191658.63CA91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use a folio in the softleaf_is_device_private path
has been removed from the -mm tree.  Its filename was
     mm-use-a-folio-in-the-softleaf_is_device_private-path.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm: use a folio in the softleaf_is_device_private path
Date: Mon, 3 Aug 2026 11:15:54 +0800

Use the folio APIs in the device_private migration path of do_swap_page(),
replacing four calls to compound_head() with one.

Link: https://lore.kernel.org/20260803031554.30421-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Anshumman Khandual <anshuman.khandual@arm.com>
Cc: Hongfu Li <lihongfu@kylinos.cn>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-use-a-folio-in-the-softleaf_is_device_private-path
+++ a/mm/memory.c
@@ -4926,18 +4926,19 @@ vm_fault_t do_swap_page(struct vm_fault
 				goto unlock;
 
 			/*
-			 * Get a page reference while we know the page can't be
+			 * Get a folio reference while we know the folio can't be
 			 * freed.
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
+				folio_unlock(folio);
+				folio_put(folio);
 			} else {
 				pte_unmap(vmf->pte);
 				softleaf_entry_wait_on_locked(entry, vmf->ptl);
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

ksm-update-comments-and-docs-to-reference-folio-mapping.patch
selftests-mm-drop-duplicate-test_seal_mprotect_two_vma_with_gap-call.patch
selftests-mm-fix-read_file-return-value-check.patch
mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch
mm-cma-remove-stray-newline-from-auto-generated-cma-area-name.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B6D3CC7EB
	for <mm-commits@vger.kernel.org>; Mon, 27 Jul 2026 19:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785178860; cv=none; b=unSKlNiLhsgZ8K4dOymeFm/+105TGGED/QUfuPcaaizSFWTW3/uGIKSi/T3qPiKOX14BrFlOhzli/dvaHz8B9JgABcpx+A/j2Vfj4COuf1huYwxttP97y2X9jGwrh/1YrA2XCQbG3BGZP76qQoZiVAEJMkb0Ew8k53bkrHu5ESY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785178860; c=relaxed/simple;
	bh=TmTwC85nIfGjsGS+KLy1cPnijOInTLvh6XOUa2wUhqc=;
	h=Date:To:From:Subject:Message-Id; b=oL43oyrsf/WN7QfUlFPfRID001NPFt4bRyLyxJed013rXdP1ZeLlPs8YHvfJY/qvPyGPfhtRu2EkiUbKIA+ZeDxQUopxGNQHI1TEg+4ZV6EqgBzcoB0P2alrKPZCppco5if2r5zLNlXwjl1USPac5FXQ3V85NjVUZWAz0TPS+Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ipahnIAc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ipahnIAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02291F00A3A;
	Mon, 27 Jul 2026 19:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785178852;
	bh=w2dJSwlnYP9QUpNRwP2CI12dPWsl6vT0/vStP/dlN8g=;
	h=Date:To:From:Subject;
	b=ipahnIAcYaT3L/FbxXtjyZKfJK/mT8jb4LoNoZVBDvZ2nXuhvHFSUijcQ0WiLAadl
	 3e2tEMCkgkcNiD4tRbo/4m0Gqn27E5cZPunVZ2JNrHRm7gMMH5MqNBQqx5S3AnTEXZ
	 SLef7K4pUsyE+dPPvq8S1ssNK+NGT498iUDZrjHc=
Date: Mon, 27 Jul 2026 12:00:52 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-use-a-folio-in-the-softleaf_is_device_private-path.patch removed from -mm tree
Message-Id: <20260727190052.A02291F00A3A@smtp.kernel.org>
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
Date: Thu, 23 Jul 2026 11:07:51 +0800

Patch series "mm: folio conversion and refactoring in do_swap_page()", v2.

Convert the device-private migration path in do_swap_page() to use folio
APIs, then extract all non-swap entry handling into a new
do_non_swap_page() helper to improve readability and reduce the size of
the main swap fault function.


This patch (of 2):

Use the folio APIs in the device_private migration path of do_swap_page(),
replacing four calls to compound_head() with one.

Link: https://lore.kernel.org/20260723030752.16979-1-hongfu.li@linux.dev
Link: https://lore.kernel.org/20260723030752.16979-2-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Hongfu Li <lihongfu@kylinos.cn>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
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
@@ -4922,18 +4922,19 @@ vm_fault_t do_swap_page(struct vm_fault
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

selftests-mm-move-pkey-selftest-helpers-to-pkey_utilc.patch
selftests-mm-unify-pkey-sighandler-selftest-assertions-and-tracing.patch
selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch
selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch
selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch
selftests-mm-fix-clone-cleartid-race-in-pkey-sighandler-tests.patch
selftests-mm-fix-memleak-in-migration-benchmark.patch
selftests-mm-factor-out-hmm_buffer_alloc-to-consolidate-buffer-setup.patch
selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap.patch
mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch
mm-extract-non-swap-page-handling-to-do_non_swap_page.patch


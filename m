Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FF1350A35
	for <mm-commits@vger.kernel.org>; Mon,  3 Aug 2026 23:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798582; cv=none; b=TkPkQZ/rYWvBtD/kyNfOrFtYlIiI/+sKcRJg3r8BQFWItBxS3czSmjNvEaveblmRd/BH+/FZHmop3XKArgFiN9mVt0w7fOnlEY7dPpfgXcwrmO/GRXl3K3htsjIsG8g6lmbHhKCVZFijOUyWI5En5HvYLgbKenT+vhTVoiitS3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798582; c=relaxed/simple;
	bh=WBVVSR775Gvv1R7vPlM5TJ+Cj+2oNsxOEtJJ8oBe6ZI=;
	h=Date:To:From:Subject:Message-Id; b=QGDGUavS2GddmSWYzm6C/Yi1MTGdjONnq5vOSMp98EJE4WqnATfHYUnBaJ7uDY/i6rjUU0XkCmygFeVz4CDWCeeo0x7zEUaQkomxZikouFxI5Xlle3LQ1UEa+4QVgg4A5Y//esZqs2uArBICvHbBSnu/mJmEbNVlD2KnxPcTZ2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uB3ma4Br; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uB3ma4Br"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E041F000E9;
	Mon,  3 Aug 2026 23:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785798580;
	bh=SY5D8o3OZmjcaealtXDrsyql6tx0qNPVPRVh2+gveUE=;
	h=Date:To:From:Subject;
	b=uB3ma4Br1XEyk4gNNkhkMqgIyb8R90JArAwGMGO4nFPpy1nv2wd+La/lHaZ+B+YEq
	 MAVul0RHeFPqlSr085AlWgF0Es/g637tODxkvcEEanF8BmF2khZJJuBtcd7QyIJwIo
	 KR/LRzrB5a47BuJhB17h6emdk5/cdHIYQg0stPAc=
Date: Mon, 03 Aug 2026 16:09:40 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,anshuman.khandual@arm.com,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-a-folio-in-the-softleaf_is_device_private-path.patch added to mm-new branch
Message-Id: <20260803230940.98E041F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use a folio in the softleaf_is_device_private path
has been added to the -mm mm-new branch.  Its filename is
     mm-use-a-folio-in-the-softleaf_is_device_private-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-a-folio-in-the-softleaf_is_device_private-path.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

selftests-mm-fix-memleak-in-migration-benchmark.patch
selftests-mm-factor-out-hmm_buffer_alloc-to-consolidate-buffer-setup.patch
selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap.patch
mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch
mm-use-a-folio-in-the-softleaf_is_device_private-path.patch
selftests-prctl-fix-non-anonymous-vma-mapping-in-set-anon-vma-name-test.patch


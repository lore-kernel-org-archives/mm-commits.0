Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381A23D7A18
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 04:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789620154; cv=none; b=eInkjE8HFRl6fWrWBv4KGtwXpziW82Vq3CD4AK6gLFfZWxOH0rEvPu3/4FAIZB3y3r2wBZrEa1lG2fO4xk2fYZeCOso5AiLg8eeGhN7ymexDalTGSYg+pJFZdczTIuQ7z1+CW2o7M6M/Tj66XaHgOs2HnoJ07TsxpzjhL0Z+6IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789620154; c=relaxed/simple;
	bh=ly0c3pJmP9pxY2DunW1qi2CcXyhnnNLNsWInPxNGWxo=;
	h=Date:To:From:Subject:Message-Id; b=K6udPPxmN4UvXm/JU5EWeTm46ZZhVwH6I/Oi3lY0wrsoViZrTnenfTcjV7pH3qhkFOqaFfx2zV18yQmGOiqLSeNBzpUu7AmnTm1+ldhAz9oXddB4ZzwQuuQZgUMozOIewh3I1qJkhKaXS6DYBAHH75ARyLuVoHcVfVNkXT+zxPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k/1ib9uE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k/1ib9uE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AF01F000FF;
	Thu, 17 Sep 2026 04:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789620152;
	bh=OlJ6supEwJZwLKU2CFoEAfqLnveKR94TcsDWpmmeFws=;
	h=Date:To:From:Subject;
	b=k/1ib9uE6aR4Ls/hCMq0KvSXs6NeeDfwnPA3QtDj+M3jPaOMA05ncOK+1lJWkw/v3
	 Rh/patoxtbV2Pzdy3MYrYizAOQN7jTvvW08iU0JIJQyNkiGp+Hg3Uf1nz0nihuKKFZ
	 oUPEfS3MjjrNBlTsV77BQeq+fUbBscjed225yvMU=
Date: Wed, 16 Sep 2026 21:42:32 -0700
To: mm-commits@vger.kernel.org,ruirui.yang@linux.dev,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,baoquan.he@linux.dev,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmcore-convert-mmap_vmcore_fault-to-use-folios.patch added to mm-new branch
Message-Id: <20260917044232.C5AF01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmcore: convert mmap_vmcore_fault() to use folios
has been added to the -mm mm-new branch.  Its filename is
     vmcore-convert-mmap_vmcore_fault-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmcore-convert-mmap_vmcore_fault-to-use-folios.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: vmcore: convert mmap_vmcore_fault() to use folios
Date: Tue, 15 Sep 2026 19:42:15 -0400

Use a folio for the page cache page the s390 fault handler reads the old
kernel's memory into.  This removes four compound_head() calls and one of
the last callers of find_or_create_page().

The vmcore mapping only has order-0 folios, so the logic is unchanged.

Compile tested for s390.

Link: https://lore.kernel.org/20260915-vmcore-fault-folio-v1-1-a0cb6278670f@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
---

 fs/proc/vmcore.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/fs/proc/vmcore.c~vmcore-convert-mmap_vmcore_fault-to-use-folios
+++ a/fs/proc/vmcore.c
@@ -474,29 +474,30 @@ static vm_fault_t mmap_vmcore_fault(stru
 	pgoff_t index = vmf->pgoff;
 	struct iov_iter iter;
 	struct kvec kvec;
-	struct page *page;
+	struct folio *folio;
 	loff_t offset;
 	int rc;
 
-	page = find_or_create_page(mapping, index, GFP_KERNEL);
-	if (!page)
+	folio = __filemap_get_folio(mapping, index,
+			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, GFP_KERNEL);
+	if (IS_ERR(folio))
 		return VM_FAULT_OOM;
-	if (!PageUptodate(page)) {
-		offset = (loff_t) index << PAGE_SHIFT;
-		kvec.iov_base = page_address(page);
-		kvec.iov_len = PAGE_SIZE;
-		iov_iter_kvec(&iter, ITER_DEST, &kvec, 1, PAGE_SIZE);
+	if (!folio_test_uptodate(folio)) {
+		offset = folio_pos(folio);
+		kvec.iov_base = folio_address(folio);
+		kvec.iov_len = folio_size(folio);
+		iov_iter_kvec(&iter, ITER_DEST, &kvec, 1, folio_size(folio));
 
 		rc = __read_vmcore(&iter, &offset);
 		if (rc < 0) {
-			unlock_page(page);
-			put_page(page);
+			folio_unlock(folio);
+			folio_put(folio);
 			return vmf_error(rc);
 		}
-		SetPageUptodate(page);
+		folio_mark_uptodate(folio);
 	}
-	unlock_page(page);
-	vmf->page = page;
+	folio_unlock(folio);
+	vmf->page = folio_file_page(folio, index);
 	return 0;
 #else
 	return VM_FAULT_SIGBUS;
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-page_io-convert-write-completion-handlers-to-folios.patch
mm-remove-pagereclaim.patch
mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch
mm-page_io-rename-bio_associate_blkg_from_page.patch
mm-page_io-refer-to-folios-in-swap_writeout-comments.patch
mm-swap-rename-__swap_writepage-to-__swap_writeout.patch
mm-remove-unused-mark_page_reserved.patch
mm-remove-unused-totalram_pages_inc-and-totalram_pages_dec.patch
mm-remove-pagewriteback.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix.patch
mm-huge_memory-add-a-comment-to-the-open-coded-swap-entry.patch
mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch
mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch
mm-swapfile-use-folio_page_swap_entry.patch
arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch
arm64-mte-pass-the-swap-entry-to-mte_save_tags.patch
mm-swap-remove-page_swap_entry.patch
mm-memcontrol-take-a-const-folio-in-folio_memcg-and-friends.patch
mm-memcontrol-constify-obj_cgroup_memcg-and-friends.patch
mm-memcontrol-constify-the-lruvec-helpers.patch
mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch
mm-memcontrol-constify-the-mem_cgroup-accessors.patch
mm-page_counter-constify-page_counter_read-and-page_counter_margin.patch
mm-memcontrol-constify-the-reclaim-protection-helpers.patch
mm-memcontrol-constify-the-memcg-and-lruvec-stat-readers.patch
mm-memcontrol-constify-the-swap-accounting-helpers.patch
mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max.patch
mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch
vmcore-convert-mmap_vmcore_fault-to-use-folios.patch


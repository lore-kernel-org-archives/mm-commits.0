Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3422128E0F
	for <mm-commits@vger.kernel.org>; Sun,  6 Sep 2026 00:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788653896; cv=none; b=trm9RrXMcUpCDLEfn8djoGkLZ4bhIGglomm14wR5tORhQ0tp7d5CriJWdlyZJZyXD5zGkp2KiD4rIRHRwdCxuCB6lnTLiXaz8L1gpgT2Ezp2Z8xUFmeAra588KG0n01DWQW1RtNAlcqiMDrLjn8iFvIIA/u8svi6fd6HiOyUmJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788653896; c=relaxed/simple;
	bh=UgdmKxY74OYOpdmBaYIVnbBTOunxSLvhsGZUl9LvQyc=;
	h=Date:To:From:Subject:Message-Id; b=hfknGBCWS5TSQRvsnuzKfNM8bC9hosVhdp08BybiAjGs+egjrHQg1w3ygozFoVMswYWcM3S5GAYCe4ksLCFi9hd6NvMygtM0LKiDlWxUllkF/W8xx/on7GAq7exgVXvus3NdLGf70CumtJ06oQ3sXRvqSS2C7VdZ/vgxvje4MYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZISypgqy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZISypgqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4951F00A3A;
	Sun,  6 Sep 2026 00:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788653894;
	bh=R9ryUsMdyzwUuTv7OXikeOJ25QJhTKvb4lLyja9REC0=;
	h=Date:To:From:Subject;
	b=ZISypgqyLsXq2dUSVhFG/yQwjLEZzGhYXIcEQPbaI/iQtVJKf6/65K3oUk9PfvMrQ
	 0V7LmMm4zKML+8dBKWm+o+1mer/suwEZZLytOl0N0xqO+fKaBA3t7k+CBaUbXmYN+O
	 dt6JAUoHUWRZgTPBhcOjJWvLYxyifWWWMix2iUvg=
Date: Sat, 05 Sep 2026 17:18:14 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,pfalcato@suse.de,mike@recall.ai,liam@infradead.org,jannh@google.com,david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch added to mm-new branch
Message-Id: <20260906001814.9F4951F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on MADV_WILLNEED
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on MADV_WILLNEED
Date: Thu, 3 Sep 2026 20:08:39 +0100

Currently MADV_WILLNEED treats file-backed and pure anonymous mappings
entirely separately - using POSIX_FADV_WILLNEED (equivalent of a
readahead) for the former and a tree walk and swap in to swap cache for
the latter.

MAP_PRIVATE-file backed mappings straddle the two and currently get
treated as if they were purely file-backed, meaning any swapped out
private pages remain swapped out.

Resolve the issue by explicitly checking for CoW'd MAP_PRIVATE-file backed
mappings and performing both walks in this case.

Since the logic checks for vma->anon_vma this means un-CoW'd
MAP_PRIVATE-file backed mappings retain only the single file walk.

Link: https://lore.kernel.org/aprjOxDy3JCPb2oa@gremlin
Reported-by: Mike Kaplinskiy <mike@recall.ai>
Closes: https://lore.kernel.org/all/CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com/
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/madvise.c~mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed
+++ a/mm/madvise.c
@@ -297,11 +297,12 @@ static long madvise_willneed(struct madv
 	loff_t offset;
 
 #ifdef CONFIG_SWAP
-	if (!file) {
+	if (vma_is_cow_mapping(vma) && vma->anon_vma) {
 		walk_page_range_vma(vma, start, end, &swapin_walk_ops, vma);
 		lru_add_drain(); /* Push any new pages onto the LRU now */
-		return 0;
 	}
+	if (!file)
+		return 0;
 
 	if (shmem_mapping(file->f_mapping)) {
 		shmem_swapin_range(vma, start, end, file->f_mapping);
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-correctly-unaccount-on-mmap_prepare-failure.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch


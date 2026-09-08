Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3E9534457
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 17:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788890134; cv=none; b=pYRabbtIYnWfrMIpfw1rJVmv2jbCBojHF59hWiip0//uEJe8I64jpgDTi7sSg4zdi3dBrJQMfXt3LpIpdAcARdngyOXpgXS6FBSQc2dchN12K1pynZ2aTxRHFzRG65g8B0nvCyoryZmpnBTFwULvLWOTAkS+Ay79chG1UbLnqmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788890134; c=relaxed/simple;
	bh=nDXVdPZBAfIiT3M15L/eeUhkBv6Aqdx3/NlxwXxnNOc=;
	h=Date:To:From:Subject:Message-Id; b=ULD9bvpHxnqs1/0VpWOMgambM2RwPSMgC2wgGilQLGvdnFTao0Zg+iA2+IwLAannDJ1FiZIdAD4QvASfARzVbF6/z6WYIFjbSrjXuOF2swEPhvOOYTriG6BJlEmg5gLScQhwPEl24tmaxMNd8y4rQUcwP4ho4Rgb781RygkrT/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m6hXwpGG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m6hXwpGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959081F00A3D;
	Tue,  8 Sep 2026 17:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788890132;
	bh=+EpU4JYNwdgi75um4b+BhhTI35NY6SszwPmTFbkvzhs=;
	h=Date:To:From:Subject;
	b=m6hXwpGGJBDDsjdcosr/VIxLkZSbDE1oyC7LxNGCltBO+OR6ew7igvJ4hqG1fW1wd
	 ZvOWnloYw00SuksAOn4rUYFf5HVToilnCMMmG9HIxcEN5fUA/vLCMdePm5DKUiebGg
	 oA+fcYuK23L0kz4z7siIRHb60O1CLfO7Zxu95nNY=
Date: Tue, 08 Sep 2026 10:55:32 -0700
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-use-folio_page_swap_entry.patch added to mm-new branch
Message-Id: <20260908175532.959081F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swapfile: use folio_page_swap_entry()
has been added to the -mm mm-new branch.  Its filename is
     mm-swapfile-use-folio_page_swap_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-use-folio_page_swap_entry.patch

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
Subject: mm/swapfile: use folio_page_swap_entry()
Date: Tue, 08 Sep 2026 11:16:35 -0400

folio_dup_swap() and folio_put_swap() open-code the swap entry computation
from folio->swap and folio_page_idx().  Use folio_page_swap_entry()
instead.

No functional change.

Link: https://lore.kernel.org/20260908-folio_swap_entry-v2-5-ee6d01dfa5e1@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-use-folio_page_swap_entry
+++ a/mm/swapfile.c
@@ -1822,7 +1822,7 @@ int folio_dup_swap(struct folio *folio,
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
 	if (page) {
-		entry.val += folio_page_idx(folio, page);
+		entry = folio_page_swap_entry(folio, page);
 		nr_pages = 1;
 	}
 
@@ -1849,7 +1849,7 @@ void folio_put_swap(struct folio *folio,
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
 	if (page) {
-		entry.val += folio_page_idx(folio, page);
+		entry = folio_page_swap_entry(folio, page);
 		nr_pages = 1;
 	}
 
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
mm-huge_memory-add-a-comment-to-the-open-coded-swap-entry.patch
mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch
mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch
mm-swapfile-use-folio_page_swap_entry.patch
arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch
arm64-mte-pass-the-swap-entry-to-mte_save_tags.patch
mm-swap-remove-page_swap_entry.patch


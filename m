Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E7B28E611
	for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2025 21:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752699803; cv=none; b=hgSN5oTnA8X+ZBGLKzMF4IOouzv7/opK8lN25bF1dKAQungBrhRpTzkcZ53yBhCOAAeVuz5I32CrOLXSRaEPG/t73T8XYrSFTFgaj5N2ZMkGkSabcVMZ6B6P5NUtJYaSHUQDHMmiUgOeRRIp/u8nGNKP191qGQErhUwz/8jfI6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752699803; c=relaxed/simple;
	bh=wzdZUFmHlM8jkTgNBvGnQdgDdJfBv+Emn5+NfV7iZn8=;
	h=Date:To:From:Subject:Message-Id; b=I0KBtHGAT3JVlJtfgk5RnI7JHvRsosKh1mPjFiEJ0OprfPc4PqJ/3IO1tRkoXArq7+ye/gtg9Go6NwBeLBy6jIIwaoCcL5ZV1lCeeumVAuy7zfrcIL5eJ9Zl3u0UwFHoefyquma/Nvr1Gn9YT2tWwABsIyCaKvFvxjpv6bHfZck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UTjTXPUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UTjTXPUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2836C4CEF4;
	Wed, 16 Jul 2025 21:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752699803;
	bh=wzdZUFmHlM8jkTgNBvGnQdgDdJfBv+Emn5+NfV7iZn8=;
	h=Date:To:From:Subject:From;
	b=UTjTXPUT29ul/ZPll++CdkSJaIfgdYgQLoPBP4nJy0RASbk4BOloh6Py+KOmEY7b0
	 VwOJMu0YVmJDkeuqdFyCETxxMoHl8uruwHwxb2pf3RM1WyWs/pBXJVmIHB9FCRpOWu
	 7C0eCW8PJEYWcFpc5pkI6T1ZsBVf0hPrdUtMU0/o=
Date: Wed, 16 Jul 2025 14:03:22 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,k.shutemov@gmail.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,dan.carpenter@linaro.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,antonio@mandelbit.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-refactor-after-split-page-cache-code.patch added to mm-new branch
Message-Id: <20250716210322.E2836C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: refactor after-split (page) cache code.
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-refactor-after-split-page-cache-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-refactor-after-split-page-cache-code.patch

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
Subject: mm/huge_memory: refactor after-split (page) cache code.
Date: Wed, 16 Jul 2025 13:11:12 -0400

Smatch/coverity checkers report NULL mapping referencing issues[1][2][3]
every time the code is modified, because they do not understand that
mapping cannot be NULL when a folio is in page cache in the code. 
Refactor the code to make it explicit.

No functional change is intended.

[1]https://lore.kernel.org/linux-mm/2afe3d59-aca5-40f7-82a3-a6d976fb0f4f@stanley.mountain/
[2]https://lore.kernel.org/oe-kbuild/64b54034-f311-4e7d-b935-c16775dbb642@suswa.mountain/
[3]https://lore.kernel.org/linux-mm/20250716145804.4836-1-antonio@mandelbit.com/

Link: https://lkml.kernel.org/r/20250716171112.3666150-1-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Antonio Quartulli <antonio@mandelbit.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <k.shutemov@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   43 ++++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-refactor-after-split-page-cache-code
+++ a/mm/huge_memory.c
@@ -3804,6 +3804,8 @@ static int __folio_split(struct folio *f
 		 */
 		for (new_folio = folio_next(folio); new_folio != next_folio;
 		     new_folio = next) {
+			unsigned long nr_pages = folio_nr_pages(new_folio);
+
 			next = folio_next(new_folio);
 
 			expected_refs = folio_expected_ref_count(new_folio) + 1;
@@ -3811,25 +3813,36 @@ static int __folio_split(struct folio *f
 
 			lru_add_split_folio(folio, new_folio, lruvec, list);
 
-			/* Some pages can be beyond EOF: drop them from cache */
-			if (new_folio->index >= end) {
-				if (shmem_mapping(mapping))
-					nr_shmem_dropped += folio_nr_pages(new_folio);
-				else if (folio_test_clear_dirty(new_folio))
-					folio_account_cleaned(
-						new_folio,
-						inode_to_wb(mapping->host));
-				__filemap_remove_folio(new_folio, NULL);
-				folio_put_refs(new_folio,
-					       folio_nr_pages(new_folio));
-			} else if (mapping) {
-				__xa_store(&mapping->i_pages, new_folio->index,
-					   new_folio, 0);
-			} else if (swap_cache) {
+			/*
+			 * Anonymous folio with swap cache.
+			 * NOTE: shmem in swap cache is not supported yet.
+			 */
+			if (swap_cache) {
 				__xa_store(&swap_cache->i_pages,
 					   swap_cache_index(new_folio->swap),
 					   new_folio, 0);
+				continue;
 			}
+
+			/* Anonymouse folio without swap cache */
+			if (!mapping)
+				continue;
+
+			/* Add the new folio to the page cache. */
+			if (new_folio->index < end) {
+				__xa_store(&mapping->i_pages, new_folio->index,
+					   new_folio, 0);
+				continue;
+			}
+
+			/* Drop folio beyond EOF: ->index >= end */
+			if (shmem_mapping(mapping))
+				nr_shmem_dropped += nr_pages;
+			else if (folio_test_clear_dirty(new_folio))
+				folio_account_cleaned(
+					new_folio, inode_to_wb(mapping->host));
+			__filemap_remove_folio(new_folio, NULL);
+			folio_put_refs(new_folio, nr_pages);
 		}
 		/*
 		 * Unfreeze @folio only after all page cache entries, which
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-fix-split_huge_page_test-for-folio_split-tests.patch
mm-huge_memory-move-unrelated-code-out-of-__split_unmapped_folio.patch
mm-huge_memory-use-folio_expected_ref_count-to-calculate-ref_count.patch
mm-huge_memory-refactor-after-split-page-cache-code.patch


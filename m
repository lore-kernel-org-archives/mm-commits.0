Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4F527F73A
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 00:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754958274; cv=none; b=NoSkTgoNnoGetXGIPhuY6pdIeuKf1I3VoalBM3MLFf7SzJAjurVLOI76IKgolE3/Fk+EdcpQMb/pT+FKecuNArWFpQvu1xCaX9tciIzUFsMdp1Enaxg6bIwh6u+2cNPASVPj/PshDqEbLSRinrdnghzK5MPUhZPi4Q83RVVzdWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754958274; c=relaxed/simple;
	bh=Yo/YiT966zusKkMiIjOmy02hiFebpXFJC/DrblxRyV0=;
	h=Date:To:From:Subject:Message-Id; b=Z3miAhJWfA2aHdgptoqbwYx+KQNRiACVlz61U3TxjklHaTE+ijuPWf3VDNWaLsVFx0ZaqtdnJqXNvX2LUWl0rX+9CdZp2wxIiHqWmacnoCxT4ATJQLjEIBI9oJ6CRHivaiiN9Uj53kyj8FtoS3mw0jx1Jd+6nQ+D2zzDKGnP42A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cZ1tRGt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cZ1tRGt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EFDC4CEED;
	Tue, 12 Aug 2025 00:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754958274;
	bh=Yo/YiT966zusKkMiIjOmy02hiFebpXFJC/DrblxRyV0=;
	h=Date:To:From:Subject:From;
	b=cZ1tRGt6NiLpeNm9f4WzhG9FPHHMh37RQt+9llRrGzN1VLzcy1PRLpxDuMptONyX3
	 1kaeoNuJ3CQm+hFJQFzl7xe6JPDMUuLgTaOfTHt30n2KPWq1d8LSjKdU7t9z6MXo8W
	 rm78koCQa7XSXwHQAkbLZbm8XHTssyPFfNFzQ53Y=
Date: Mon, 11 Aug 2025 17:24:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shikemeng@huaweicloud.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mincore-use-a-helper-for-checking-the-swap-cache.patch added to mm-new branch
Message-Id: <20250812002434.41EFDC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mincore: use a helper for checking the swap cache
has been added to the -mm mm-new branch.  Its filename is
     mm-mincore-use-a-helper-for-checking-the-swap-cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mincore-use-a-helper-for-checking-the-swap-cache.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/mincore: use a helper for checking the swap cache
Date: Tue, 12 Aug 2025 01:20:18 +0800

Introduce a mincore_swap helper for checking swap entries.  Move all swap
related logic and sanity debug check into it, and separate them from page
cache checking.

The performance is better after this commit.  mincore_page is never called
on a swap cache space now, so the logic can be simpler.  The sanity check
also covers more potential cases now, previously the WARN_ON only catches
potentially corrupted page table, now if shmem contains a swap entry with
!CONFIG_SWAP, a WARN will be triggered.  This changes the mincore value
when the WARN is triggered, but this shouldn't matter.  The WARN_ON means
the data is already corrupted or something is very wrong, so it really
should not happen.

Before this series:
mincore on a swaped out 16G anon mmap range:
Took 488220 us
mincore on 16G shmem mmap range:
Took 530272 us.

After this commit:
mincore on a swaped out 16G anon mmap range:
Took 446763 us
mincore on 16G shmem mmap range:
Took 460496 us.

About ~10% faster.

Link: https://lkml.kernel.org/r/20250811172018.48901-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   90 ++++++++++++++++++++++++++-----------------------
 1 file changed, 49 insertions(+), 41 deletions(-)

--- a/mm/mincore.c~mm-mincore-use-a-helper-for-checking-the-swap-cache
+++ a/mm/mincore.c
@@ -47,6 +47,48 @@ static int mincore_hugetlb(pte_t *pte, u
 	return 0;
 }
 
+static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
+{
+	struct swap_info_struct *si;
+	struct folio *folio = NULL;
+	unsigned char present = 0;
+
+	if (!IS_ENABLED(CONFIG_SWAP)) {
+		WARN_ON(1);
+		return 0;
+	}
+
+	/*
+	 * Shmem mapping may contain swapin error entries, which are
+	 * absent. Page table may contain migration or hwpoison
+	 * entries which are always uptodate.
+	 */
+	if (non_swap_entry(entry))
+		return !shmem;
+
+	/*
+	 * Shmem mapping lookup is lockless, so we need to grab the swap
+	 * device. mincore page table walk locks the PTL, and the swap
+	 * device is stable, avoid touching the si for better performance.
+	 */
+	if (shmem) {
+		si = get_swap_device(entry);
+		if (!si)
+			return 0;
+	}
+	folio = filemap_get_entry(swap_address_space(entry),
+				  swap_cache_index(entry));
+	if (shmem)
+		put_swap_device(si);
+	/* The swap cache space contains either folio, shadow or NULL */
+	if (folio && !xa_is_value(folio)) {
+		present = folio_test_uptodate(folio);
+		folio_put(folio);
+	}
+
+	return present;
+}
+
 /*
  * Later we can get more picky about what "in core" means precisely.
  * For now, simply check to see if the page is in the page cache,
@@ -64,33 +106,15 @@ static unsigned char mincore_page(struct
 	 * any other file mapping (ie. marked !present and faulted in with
 	 * tmpfs's .fault). So swapped out tmpfs mappings are tested here.
 	 */
-	if (IS_ENABLED(CONFIG_SWAP) && shmem_mapping(mapping)) {
-		folio = filemap_get_entry(mapping, index);
-		/*
-		 * shmem/tmpfs may return swap: account for swapcache
-		 * page too.
-		 */
+	folio = filemap_get_entry(mapping, index);
+	if (folio) {
 		if (xa_is_value(folio)) {
-			struct swap_info_struct *si;
-			swp_entry_t swp = radix_to_swp_entry(folio);
-			/* There might be swapin error entries in shmem mapping. */
-			if (non_swap_entry(swp))
-				return 0;
-			/* Prevent swap device to being swapoff under us */
-			si = get_swap_device(swp);
-			if (si) {
-				folio = filemap_get_folio(swap_address_space(swp),
-							  swap_cache_index(swp));
-				put_swap_device(si);
-			} else {
+			if (shmem_mapping(mapping))
+				return mincore_swap(radix_to_swp_entry(folio),
+						    true);
+			else
 				return 0;
-			}
 		}
-	} else {
-		folio = filemap_get_folio(mapping, index);
-	}
-
-	if (!IS_ERR_OR_NULL(folio)) {
 		present = folio_test_uptodate(folio);
 		folio_put(folio);
 	}
@@ -168,23 +192,7 @@ static int mincore_pte_range(pmd_t *pmd,
 			for (i = 0; i < step; i++)
 				vec[i] = 1;
 		} else { /* pte is a swap entry */
-			swp_entry_t entry = pte_to_swp_entry(pte);
-
-			if (non_swap_entry(entry)) {
-				/*
-				 * migration or hwpoison entries are always
-				 * uptodate
-				 */
-				*vec = 1;
-			} else {
-#ifdef CONFIG_SWAP
-				*vec = mincore_page(swap_address_space(entry),
-						    swap_cache_index(entry));
-#else
-				WARN_ON(1);
-				*vec = 1;
-#endif
-			}
+			*vec = mincore_swap(pte_to_swp_entry(pte), false);
 		}
 		vec += step;
 	}
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-only-scan-one-cluster-in-fragment-list.patch
mm-swap-remove-fragment-clusters-counter.patch
mm-swap-prefer-nonfull-over-free-clusters.patch
mm-mincore-swap-consolidate-swap-cache-checking-for-mincore.patch
mm-mincore-use-a-helper-for-checking-the-swap-cache.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A667406F
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423528; cv=none; b=iUgMmCPV+vqajCnn03O0keDq4ImSifcjuY0379K7GHH2YLpOLr4Yq2HNAmr1iuWOtOPbn9acOvnFuJ3ChzlZ8LW5Ubz9Ljn4jVryhY18ZeiRGVoKuQAdLI8kk/fPfydaAjUz74Tj09cUtm+aFi9LAt1oykpaLdg2KFZMhSSaZyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423528; c=relaxed/simple;
	bh=T/byVcJ826nC/mS1/ybJX0BPoPkzC13zFQQr2gXcXAo=;
	h=Date:To:From:Subject:Message-Id; b=RGBgqOmwpl35ADpVLslz+M2kZ6vODl2QbOZ/ouHSRmHN1BiXSvtOtA+OUMm7rU1m8lehiH7Fv1x6tnEYYntGGfiURaD818nXfkFeDwTKDUJeypOiv6ylafrDHcjLSSCsfruMPaW42S4ltKwnAKYqGWbbUfImSR4TaTgeEu1g++Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kuZVR/xz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kuZVR/xz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC38C4CEC2;
	Wed,  4 Sep 2024 04:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423528;
	bh=T/byVcJ826nC/mS1/ybJX0BPoPkzC13zFQQr2gXcXAo=;
	h=Date:To:From:Subject:From;
	b=kuZVR/xzjiTSq943VdaSX37f06bYlWIl+tXBWb7iZ1uLIIxyrg91+DHu0/pYsOGIg
	 JNEZwFezuM2rZ2r0ebASgoYAMBU8fb0+ZMHvIzJEkMthnUgeStgPlMIFIDkYcrqX0N
	 FMIf3QskObZ4/mBSraeQisiArFpH/wyzMno07IIU=
Date: Tue, 03 Sep 2024 21:18:47 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-pageswapcache.patch removed from -mm tree
Message-Id: <20240904041848.4EC38C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove PageSwapCache
has been removed from the -mm tree.  Its filename was
     mm-remove-pageswapcache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove PageSwapCache
Date: Wed, 21 Aug 2024 20:34:37 +0100

This flag is now only used on folios, so we can remove all the page
accessors and reword the comments that refer to them.

Link: https://lkml.kernel.org/r/20240821193445.2294269-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h   |    2 +-
 include/linux/page-flags.h |   11 +++--------
 mm/ksm.c                   |   19 ++++++++++---------
 mm/migrate.c               |    3 ++-
 mm/shmem.c                 |   11 ++++++-----
 5 files changed, 22 insertions(+), 24 deletions(-)

--- a/include/linux/mm_types.h~mm-remove-pageswapcache
+++ a/include/linux/mm_types.h
@@ -109,7 +109,7 @@ struct page {
 			/**
 			 * @private: Mapping-private opaque data.
 			 * Usually used for buffer_heads if PagePrivate.
-			 * Used for swp_entry_t if PageSwapCache.
+			 * Used for swp_entry_t if swapcache flag set.
 			 * Indicates order in the buddy system if PageBuddy.
 			 */
 			unsigned long private;
--- a/include/linux/page-flags.h~mm-remove-pageswapcache
+++ a/include/linux/page-flags.h
@@ -574,15 +574,10 @@ static __always_inline bool folio_test_s
 			test_bit(PG_swapcache, const_folio_flags(folio, 0));
 }
 
-static __always_inline bool PageSwapCache(const struct page *page)
-{
-	return folio_test_swapcache(page_folio(page));
-}
-
-SETPAGEFLAG(SwapCache, swapcache, PF_NO_TAIL)
-CLEARPAGEFLAG(SwapCache, swapcache, PF_NO_TAIL)
+FOLIO_SET_FLAG(swapcache, FOLIO_HEAD_PAGE)
+FOLIO_CLEAR_FLAG(swapcache, FOLIO_HEAD_PAGE)
 #else
-PAGEFLAG_FALSE(SwapCache, swapcache)
+FOLIO_FLAG_FALSE(swapcache)
 #endif
 
 PAGEFLAG(Unevictable, unevictable, PF_HEAD)
--- a/mm/ksm.c~mm-remove-pageswapcache
+++ a/mm/ksm.c
@@ -909,12 +909,13 @@ again:
 	 */
 	while (!folio_try_get(folio)) {
 		/*
-		 * Another check for page->mapping != expected_mapping would
-		 * work here too.  We have chosen the !PageSwapCache test to
-		 * optimize the common case, when the page is or is about to
-		 * be freed: PageSwapCache is cleared (under spin_lock_irq)
-		 * in the ref_freeze section of __remove_mapping(); but Anon
-		 * folio->mapping reset to NULL later, in free_pages_prepare().
+		 * Another check for folio->mapping != expected_mapping
+		 * would work here too.  We have chosen to test the
+		 * swapcache flag to optimize the common case, when the
+		 * folio is or is about to be freed: the swapcache flag
+		 * is cleared (under spin_lock_irq) in the ref_freeze
+		 * section of __remove_mapping(); but anon folio->mapping
+		 * is reset to NULL later, in free_pages_prepare().
 		 */
 		if (!folio_test_swapcache(folio))
 			goto stale;
@@ -945,7 +946,7 @@ again:
 
 stale:
 	/*
-	 * We come here from above when page->mapping or !PageSwapCache
+	 * We come here from above when folio->mapping or the swapcache flag
 	 * suggests that the node is stale; but it might be under migration.
 	 * We need smp_rmb(), matching the smp_wmb() in folio_migrate_ksm(),
 	 * before checking whether node->kpfn has been changed.
@@ -1452,7 +1453,7 @@ static int try_to_merge_one_page(struct
 		goto out;
 
 	/*
-	 * We need the page lock to read a stable PageSwapCache in
+	 * We need the folio lock to read a stable swapcache flag in
 	 * write_protect_page().  We use trylock_page() instead of
 	 * lock_page() because we don't want to wait here - we
 	 * prefer to continue scanning and merging different pages,
@@ -3123,7 +3124,7 @@ void folio_migrate_ksm(struct folio *new
 		 * newfolio->mapping was set in advance; now we need smp_wmb()
 		 * to make sure that the new stable_node->kpfn is visible
 		 * to ksm_get_folio() before it can see that folio->mapping
-		 * has gone stale (or that folio_test_swapcache has been cleared).
+		 * has gone stale (or that the swapcache flag has been cleared).
 		 */
 		smp_wmb();
 		folio_set_stable_node(folio, NULL);
--- a/mm/migrate.c~mm-remove-pageswapcache
+++ a/mm/migrate.c
@@ -639,7 +639,8 @@ void folio_migrate_flags(struct folio *n
 	folio_migrate_ksm(newfolio, folio);
 	/*
 	 * Please do not reorder this without considering how mm/ksm.c's
-	 * ksm_get_folio() depends upon ksm_migrate_page() and PageSwapCache().
+	 * ksm_get_folio() depends upon ksm_migrate_page() and the
+	 * swapcache flag.
 	 */
 	if (folio_test_swapcache(folio))
 		folio_clear_swapcache(folio);
--- a/mm/shmem.c~mm-remove-pageswapcache
+++ a/mm/shmem.c
@@ -502,8 +502,8 @@ static int shmem_replace_entry(struct ad
  * Sometimes, before we decide whether to proceed or to fail, we must check
  * that an entry was not already brought back from swap by a racing thread.
  *
- * Checking page is not enough: by the time a SwapCache page is locked, it
- * might be reused, and again be SwapCache, using the same swap as before.
+ * Checking folio is not enough: by the time a swapcache folio is locked, it
+ * might be reused, and again be swapcache, using the same swap as before.
  */
 static bool shmem_confirm_swap(struct address_space *mapping,
 			       pgoff_t index, swp_entry_t swap)
@@ -1965,9 +1965,10 @@ static int shmem_replace_folio(struct fo
 
 	if (unlikely(error)) {
 		/*
-		 * Is this possible?  I think not, now that our callers check
-		 * both PageSwapCache and page_private after getting page lock;
-		 * but be defensive.  Reverse old to newpage for clear and free.
+		 * Is this possible?  I think not, now that our callers
+		 * check both the swapcache flag and folio->private
+		 * after getting the folio lock; but be defensive.
+		 * Reverse old to newpage for clear and free.
 		 */
 		old = new;
 	} else {
_

Patches currently in -mm which might be from willy@infradead.org are

swap-convert-swapon-to-use-a-folio.patch


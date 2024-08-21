Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153FF16F8F5
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 20:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724272442; cv=none; b=TQlEbHYtoGkVXts08fey4aQ94mFkT6KDea7UBnvdAVPoTWWQMjIoxNtZLFoqOfF6XTdxXsf1RloiCm1DkmbEuoH9i88yYhVwIw054l3cTE3bm7LKtgOlADVAcAw2i5ohylBpmn92si46jyOaYVeA/S93592BJBduvtrjuia9454=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724272442; c=relaxed/simple;
	bh=G/xrdYYd1ta4uT1xWK1j+IcjH+YllX8/9Ii63RyU414=;
	h=Date:To:From:Subject:Message-Id; b=XX0fF2/PA8PkRlEz/a5AZ16GgEwzAlvQ4bFWIl/j5M3HDQTq6cs9bstQLqSr64PGcKsWbHLSZ9X3T8aFLUV6auxF0VKIp0opVZdLNmr3H6Wvg9tfLsH3s8VRY3lz20H9jEhqfk/S7phBcmkg8hySuVZI/xxOOgCpE4TDaN2+k8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UdUIfQJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UdUIfQJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5FDC32781;
	Wed, 21 Aug 2024 20:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724272441;
	bh=G/xrdYYd1ta4uT1xWK1j+IcjH+YllX8/9Ii63RyU414=;
	h=Date:To:From:Subject:From;
	b=UdUIfQJr+ONplGb2+C+PZgyKOFMxVybF+5HByVfDPl9GZ15u477vW8kkBCeWLkm7p
	 BB+2zVg6Y5Jt958TqX9+l90FzO6mtx/rVb72SStnpChU+5RZyH0PJJrtMpFQoVsb4a
	 HYO2msyjXxMi1+tNpp7TFewBPxuOCG33PvKxMBp0=
Date: Wed, 21 Aug 2024 13:34:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pageswapcache.patch added to mm-unstable branch
Message-Id: <20240821203401.8D5FDC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove PageSwapCache
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-pageswapcache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pageswapcache.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -666,7 +666,8 @@ void folio_migrate_flags(struct folio *n
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
@@ -1940,9 +1940,10 @@ static int shmem_replace_folio(struct fo
 
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

fs-remove-calls-to-set-and-clear-the-folio-error-flag.patch
mm-remove-pg_error.patch
mm-return-the-folio-from-swapin_readahead.patch
printf-remove-%pgt-support.patch
mm-introduce-page_mapcount_is_type.patch
mm-support-only-one-page_type-per-page.patch
zsmalloc-use-all-available-24-bits-of-page_type.patch
mm-remove-pageactive.patch
mm-remove-pageswapbacked.patch
mm-remove-pagereadahead.patch
mm-remove-pageswapcache.patch
mm-remove-pageunevictable.patch
mm-remove-pagemlocked.patch
mm-remove-pageownerpriv1.patch
mm-remove-page_has_private.patch
mm-rename-pg_mappedtodisk-to-pg_owner_2.patch
x86-remove-pg_uncached.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11F21A2393
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 19:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749065988; cv=none; b=eBYokxKMDZVeMiRpx0tlGQkGG5DJ7DknLJbeqaP4lyvNf57cne52v12A6kNeqK0p24y9HqGevDnT0Z4zTQ6qHSBq+eGC9pYUoVI0WrdM4KJ1OqCeehpQyZg4TRR4Lp7KyZlNb5kSDt5Pwo1PFUJQbmsParTe+wNo1FlaK0rT4Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749065988; c=relaxed/simple;
	bh=UxTWa8ScBh4pcrJU50c/eZB9J4reLQ/2u6RilOUQDsQ=;
	h=Date:To:From:Subject:Message-Id; b=e3uf6vkzllI/XOg8bL27d18kuYpge2JNvOqt3fAk38hWvStNvAGVX+8Sqsu5YqJHO2V/wkBTiHZsBmMgO9dHRJfEWjZT59dxLjbbUbejAdKW1RUk2PqB2wWn91iIzAt/3XOrBxTbeqinmoa19MpOsL2eyRwbzm76/KvIjQ0K9Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T48pExQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T48pExQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6053CC4CEE4;
	Wed,  4 Jun 2025 19:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749065987;
	bh=UxTWa8ScBh4pcrJU50c/eZB9J4reLQ/2u6RilOUQDsQ=;
	h=Date:To:From:Subject:From;
	b=T48pExQVGO3MUtnlbAqxS7mtMs/378hgW3Zo4ngyKr87rLA1Y0QVIM+ea2zlOx9FD
	 3epdYK6puHc+HKnAL/Er0CcHU79ShU0CYF4pmtWDlLKKrrJKpsWus3DdBuzu2fs2TW
	 RuuLJ1FOCFMfzF6KkCJyJOgdj+sb8R0Etx/KPYoU=
Date: Wed, 04 Jun 2025 12:39:46 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,ast@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-restore-documentation-for-__free_pages.patch added to mm-unstable branch
Message-Id: <20250604193947.6053CC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: restore documentation for __free_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-restore-documentation-for-__free_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-restore-documentation-for-__free_pages.patch

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
Subject: mm: restore documentation for __free_pages()
Date: Wed, 4 Jun 2025 20:03:26 +0100

The documentation was converted to be for ___free_pages(), which doesn't
need documentation as it's static.

Link: https://lkml.kernel.org/r/20250604190327.814086-1-willy@infradead.org
Fixes: 8c57b687e833 (mm, bpf: Introduce free_pages_nolock())
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/mm/page_alloc.c~mm-restore-documentation-for-__free_pages
+++ a/mm/page_alloc.c
@@ -5028,11 +5028,28 @@ unsigned long get_zeroed_page_noprof(gfp
 }
 EXPORT_SYMBOL(get_zeroed_page_noprof);
 
+static void ___free_pages(struct page *page, unsigned int order,
+			  fpi_t fpi_flags)
+{
+	/* get PageHead before we drop reference */
+	int head = PageHead(page);
+	/* get alloc tag in case the page is released by others */
+	struct alloc_tag *tag = pgalloc_tag_get(page);
+
+	if (put_page_testzero(page))
+		__free_frozen_pages(page, order, fpi_flags);
+	else if (!head) {
+		pgalloc_tag_sub_pages(tag, (1 << order) - 1);
+		while (order-- > 0)
+			__free_frozen_pages(page + (1 << order), order,
+					    fpi_flags);
+	}
+}
+
 /**
- * ___free_pages - Free pages allocated with alloc_pages().
+ * __free_pages - Free pages allocated with alloc_pages().
  * @page: The page pointer returned from alloc_pages().
  * @order: The order of the allocation.
- * @fpi_flags: Free Page Internal flags.
  *
  * This function can free multi-page allocations that are not compound
  * pages.  It does not check that the @order passed in matches that of
@@ -5049,23 +5066,6 @@ EXPORT_SYMBOL(get_zeroed_page_noprof);
  * Context: May be called in interrupt context or while holding a normal
  * spinlock, but not in NMI context or while holding a raw spinlock.
  */
-static void ___free_pages(struct page *page, unsigned int order,
-			  fpi_t fpi_flags)
-{
-	/* get PageHead before we drop reference */
-	int head = PageHead(page);
-	/* get alloc tag in case the page is released by others */
-	struct alloc_tag *tag = pgalloc_tag_get(page);
-
-	if (put_page_testzero(page))
-		__free_frozen_pages(page, order, fpi_flags);
-	else if (!head) {
-		pgalloc_tag_sub_pages(tag, (1 << order) - 1);
-		while (order-- > 0)
-			__free_frozen_pages(page + (1 << order), order,
-					    fpi_flags);
-	}
-}
 void __free_pages(struct page *page, unsigned int order)
 {
 	___free_pages(page, order, FPI_NONE);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-restore-documentation-for-__free_pages.patch


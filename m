Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D422905
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126189; cv=none; b=D+KLzz6vGpRHbj7soQRBlbRO6upGKfdww7Sjw9waRlgmzy9BN34stPn79Nm7tNpqwRvpKnNQ3ZDV50hx0n/XYLI+185NAIMsnbzbnVdFDxbLjr1OsNlqFN7jEX4a80NskzWNCG7mOb+s03mC0y+MOMcC666yzea7vKKqUVU+fOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126189; c=relaxed/simple;
	bh=SfBK1WkxaYyEC6BTx60jaanj0r2T0YF7ybenNT9DaxU=;
	h=Date:To:From:Subject:Message-Id; b=VAoXydZo0rQs2vb4Sij+kbZdtue7gsJeMgZmBwdyK5GcQKUpy+HsVo5mDP1IQ3oEcd/Bmq5XdduY8eSG7Zd2G1uG7BAEOFGpmlm5PDLolMDbv9O/u1YOM3um3vqYxPwV+sGgYQy5WC4EhI/r1l7Ep6Q3PSunsyu98TAwiIjg/9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DxnXKmhV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DxnXKmhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFE3C4CEE3;
	Thu, 10 Jul 2025 05:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126188;
	bh=SfBK1WkxaYyEC6BTx60jaanj0r2T0YF7ybenNT9DaxU=;
	h=Date:To:From:Subject:From;
	b=DxnXKmhVJyZsydxQRn31QNQkMaDxwgCZRYh5tBXHI0QemWfPViYY3DQlc1bH3mOsK
	 Tlkz+i0RC7rleHnLB6xTE/vUDPwo7YeuQOYSFJntLvKjM8yXzu6j+qCQequbL89Mvz
	 unaCTrFyeCYT+bUUQyC3kIzhau1F99a9dww6HrCs=
Date: Wed, 09 Jul 2025 22:43:07 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,ast@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-restore-documentation-for-__free_pages.patch removed from -mm tree
Message-Id: <20250710054308.8AFE3C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: restore documentation for __free_pages()
has been removed from the -mm tree.  Its filename was
     mm-restore-documentation-for-__free_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: restore documentation for __free_pages()
Date: Wed, 4 Jun 2025 20:03:26 +0100

The documentation was converted to be for ___free_pages(), which doesn't
need documentation as it's static.

Link: https://lkml.kernel.org/r/20250604190327.814086-1-willy@infradead.org
Fixes: 8c57b687e833 (mm, bpf: Introduce free_pages_nolock())
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <ast@kernel.org>
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

squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch
squashfs-use-folios-in-squashfs_bio_read_cached.patch


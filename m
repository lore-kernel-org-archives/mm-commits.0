Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17290422E3E
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525589; cv=none; b=pjbJjZjtU2H4nYTz9WOQIVsg7z3+09bu/XxXIxN/UzEWN5hndyPudXpezF47PmiWf8YaHCNzzAI1M0VboueW9Emdpt6hvMEVOD79uLMLdZZ6hwltX3O20+9rdVcK1vE7qikD6w6EQLlVSwNVb2Jd3M9PfHpEYusJAjTADy2k8CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525589; c=relaxed/simple;
	bh=O4aSD2KBpCdBRtn42e1sSoM09PrS70LzA+8wKXwxIDo=;
	h=Date:To:From:Subject:Message-Id; b=OZOcS33Fr47chhY80jV3AxcZeNiyA6gqyArCI+bnTHzwXymB52f2Oeik6FoDAbZU2fWAWa6YADjmRVFlExOl30JOqxPI0Y4pK+VBFLeur+f6xwUlsanQr66XliPG7VkuNL3yVlNcPUY+wGyPZ10Npmc4Mrh8tMk3lU/AiDkPOos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GVfg6pwy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GVfg6pwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E174D1F000FF;
	Fri,  9 Oct 2026 05:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525588;
	bh=pN0H70VJpZNK1jG4K4aC3iw66roDcwENCtPaY0lSmNk=;
	h=Date:To:From:Subject;
	b=GVfg6pwyA5lz6GvfBumSM3uqLH/NIcpdGgin5j2eVHi5/cWTR1li0jlrL5BHZUUqB
	 jkY9xpxM+n0mS4gsOwH9GKuPIlbXOJpufAOIRqAB93Rg0Ulw75jm5w/ziuvcbyn6Ai
	 +kui4zHfrVxNrbbRAcNYdPbHUHShWPR7Z8F+LvOY=
Date: Thu, 08 Oct 2026 22:59:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,david@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] md-remove-the-last-use-of-page_buffers.patch removed from -mm tree
Message-Id: <20261009055947.E174D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: md: remove the last use of page_buffers()
has been removed from the -mm tree.  Its filename was
     md-remove-the-last-use-of-page_buffers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: md: remove the last use of page_buffers()
Date: Sun, 20 Sep 2026 22:28:11 -0400

Convert the page to a folio and use folio_buffers() instead.  This does
introduce one extra call to compound_head(), but will simplify a later
conversion of md-bitmap to use folios instead of pages.

Link: https://lore.kernel.org/20260920-remove-pg_private-v5-15-bb68b6a21869@nvidia.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---

 drivers/md/md-bitmap.c      |    3 ++-
 include/linux/buffer_head.h |    7 +------
 2 files changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/md/md-bitmap.c~md-remove-the-last-use-of-page_buffers
+++ a/drivers/md/md-bitmap.c
@@ -516,7 +516,8 @@ static void end_bitmap_write(struct bio
 
 static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
 {
-	struct buffer_head *bh = page_buffers(page);
+	struct folio *folio = page_folio(page);
+	struct buffer_head *bh = folio_buffers(folio);
 
 	while (bh && bh->b_blocknr) {
 		atomic_inc(&bitmap->pending_writes);
--- a/include/linux/buffer_head.h~md-remove-the-last-use-of-page_buffers
+++ a/include/linux/buffer_head.h
@@ -175,12 +175,7 @@ static inline unsigned long bh_offset(co
 	return (unsigned long)(bh)->b_data & (page_size(bh->b_page) - 1);
 }
 
-/* If we *know* page->private refers to buffer_heads */
-#define page_buffers(page)					\
-	({							\
-		BUG_ON(!PagePrivate(page));			\
-		((struct buffer_head *)page_private(page));	\
-	})
+/* If we *know* folio->private refers to buffer_heads */
 #define folio_buffers(folio)		folio_get_private(folio)
 
 void buffer_check_dirty_writeback(struct folio *folio,
_

Patches currently in -mm which might be from willy@infradead.org are



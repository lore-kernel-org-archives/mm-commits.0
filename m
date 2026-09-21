Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF48345EB5
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 04:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789963814; cv=none; b=E3fFpLeh5Ln+FI9FTL7f423hdoIRS6N75X7LoE46DlbETkObVeVzNr8RjBpKYaZF6HOzEnOheo0nlOr1Hu/S1UsW6ZtvwEpv0rCFVYMtar3bcMY3Qt+WK0dC+FqemFOeyNJ2Hj5PvmnOwbBeL9XhdKRgqk0mrxZffku/VauYJ2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789963814; c=relaxed/simple;
	bh=pjH7Lg023GyhHym1VNf032tzwYelo3p6UPYJw0DpvPo=;
	h=Date:To:From:Subject:Message-Id; b=Mj5M/XuV9PrC1u05EYtZzQ0mxL6k2q3BugHAquDk8Z/aHeMqmQxZQiW+qr3rmORCuGDlwpHAA0XF/fR0BxIvLaOEJkJN5YisK12o4Gyea6K/HEhEJ7cEES9sWIXXC1bX0k9z5ETWYcTpwhS4zFZXnYNVPhUetH4dx6Oo7AgMR68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z7D9W8Nq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z7D9W8Nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C988A1F000FF;
	Mon, 21 Sep 2026 04:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789963812;
	bh=3DylJwObcKL8jwrHgt4zyhqgyPMcX+kAwV7bkoCJy1Q=;
	h=Date:To:From:Subject;
	b=z7D9W8Nqdrcbvyh6K2EdjZw749UuBnbNkqrbnpg/sMSlhzELJFD/nUEX+AweCDJB7
	 qTTjeRF5/JNcOdCesJbfL9MdhAf8wBmg+tGgvOkNalYAI6Vp5g008kKncp1ynykTM9
	 TrAV18OzICuH499fYNsX6nyp3t4Ncp+qUmyz4JlE=
Date: Sun, 20 Sep 2026 21:10:12 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + md-remove-the-last-use-of-page_buffers.patch added to mm-unstable branch
Message-Id: <20260921041012.C988A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: md: remove the last use of page_buffers()
has been added to the -mm mm-unstable branch.  Its filename is
     md-remove-the-last-use-of-page_buffers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/md-remove-the-last-use-of-page_buffers.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

md-use-folio_alloc_buffers.patch
md-use-folio-apis-in-free_page.patch
md-remove-the-last-use-of-page_buffers.patch


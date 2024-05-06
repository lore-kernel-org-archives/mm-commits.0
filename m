Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B10822089
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957104; cv=none; b=iRJFCsKPg254DKns2/+hlhHqojAy7HhKkalzEaQ44Pok0f01CYeQB3yO0TFimmwzIXziRNQrKBFa7Vgfq+/dsAIhGgAVaPV+mDFaMeOws7ZE0K69c7nuFNUrp3BYM1SOB5/gforMPFPr6h6koPyqE+XOi6X3pqgQsQpsJamu9qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957104; c=relaxed/simple;
	bh=w6JVrBe4TTI9Y60qjKJ0JTERUNSTdIaBEAw6lT5NdO4=;
	h=Date:To:From:Subject:Message-Id; b=AZuOFaQBYOifor9eFyOyFRFWerNiTER/HmoNMpR1fvGshzNYiUlC6yoCTGITZ8t5d8MaVMftJ7SuWK+FqjZYTV5Dh4QTLdsL8L1Bgz6Ug7Q0LS7Q9HIK4u+CIXCP/jFgd/W9ggc3NrvCfhMH6z+cUKKthlehSsNrRup8OqTwXnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sy/CYNp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sy/CYNp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D1CC113CC;
	Mon,  6 May 2024 00:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957104;
	bh=w6JVrBe4TTI9Y60qjKJ0JTERUNSTdIaBEAw6lT5NdO4=;
	h=Date:To:From:Subject:From;
	b=sy/CYNp3OgNwfpY7Dl+IFAAWc5gsbLs/bShtatXYoFj2EMlcrm1PY4s4KDzKg6jMS
	 pbPhN48RrlmqxDk5DjoEeMRQiAFb/wqtvGP0la3HR0tA+RlYHHan6W+FqltUmvCA1a
	 uAaWGzWtR3ARLc6yCsqOzX541Ulxbp/U/wMddkPE=
Date: Sun, 05 May 2024 17:58:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] gup-use-folios-for-gup_devmap.patch removed from -mm tree
Message-Id: <20240506005824.71D1CC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: gup: use folios for gup_devmap
has been removed from the -mm tree.  Its filename was
     gup-use-folios-for-gup_devmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: gup: use folios for gup_devmap
Date: Wed, 24 Apr 2024 20:19:10 +0100

Use try_grab_folio() instead of try_grab_page() so we get the folio back
that we calculated, and then use folio_set_referenced() instead of
SetPageReferenced().  Correspondingly, use gup_put_folio() to put any
unneeded references.

Link: https://lkml.kernel.org/r/20240424191914.361554-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/mm/gup.c~gup-use-folios-for-gup_devmap
+++ a/mm/gup.c
@@ -2877,13 +2877,10 @@ static void __maybe_unused gup_fast_undo
 		unsigned int flags, struct page **pages)
 {
 	while ((*nr) - nr_start) {
-		struct page *page = pages[--(*nr)];
+		struct folio *folio = page_folio(pages[--(*nr)]);
 
-		ClearPageReferenced(page);
-		if (flags & FOLL_PIN)
-			unpin_user_page(page);
-		else
-			put_page(page);
+		folio_clear_referenced(folio);
+		gup_put_folio(folio, 1, flags);
 	}
 }
 
@@ -3024,6 +3021,7 @@ static int gup_fast_devmap_leaf(unsigned
 	struct dev_pagemap *pgmap = NULL;
 
 	do {
+		struct folio *folio;
 		struct page *page = pfn_to_page(pfn);
 
 		pgmap = get_dev_pagemap(pfn, pgmap);
@@ -3037,12 +3035,13 @@ static int gup_fast_devmap_leaf(unsigned
 			break;
 		}
 
-		SetPageReferenced(page);
-		pages[*nr] = page;
-		if (unlikely(try_grab_page(page, flags))) {
+		folio = try_grab_folio(page, 1, flags);
+		if (!folio) {
 			gup_fast_undo_dev_pagemap(nr, nr_start, flags, pages);
 			break;
 		}
+		folio_set_referenced(folio);
+		pages[*nr] = page;
 		(*nr)++;
 		pfn++;
 	} while (addr += PAGE_SIZE, addr != end);
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch


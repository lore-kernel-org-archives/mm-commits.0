Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95D3C13B
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739465; cv=none; b=fM2Nc6EyK65d6mIc0tTPmtJNBEn5BSXRtJHllGzck1F7D3WkxHjbMt0WAheefBXGdtnb5oxZFtYSEVZi7c/MXHsl6FYOkqrxJCj+if3smo3ZyKP1HK057SkUhj0YnsfV474pm66iRmUmSqz1ZvKIQWNUxV3a8o5i8NKgbPCACLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739465; c=relaxed/simple;
	bh=S4kGFkk6aBQOuHYYXhmwLuvQWGxEf69RxQEKlhbpCEA=;
	h=Date:To:From:Subject:Message-Id; b=ZLM4D71RWHduT6PFk/TPEZZa0G69JGNALZyJtC1ImTRUAF2sUug9bub+p32dyQciP6YioVWKrjqUBXJmidOf2UXI2SVW5tXtWbiVmp1ZVc4gKiuMgpCIpeSsdmP0yk9YPCbZgqaLBqz2wtoh9/imHD6cls6yrUnKoxDL7XcksFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YE+60Ohm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YE+60Ohm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2FBC43394;
	Sat, 24 Feb 2024 01:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739465;
	bh=S4kGFkk6aBQOuHYYXhmwLuvQWGxEf69RxQEKlhbpCEA=;
	h=Date:To:From:Subject:From;
	b=YE+60OhmJe0q81uW/edq91C09SwTITVtWUQ9Y29h1FMqj2uSz+Qdsr8MUasbxgj2Z
	 dRt3KLGclJ+KBhgqG7SwSmh6oZhqfnL6g4ETHNfW9k3UKPBVfFSgelOrKMQbO1VUYc
	 N9lQUtho+VnyFQ2guT8EOHckdAp2I6xIr5bXCCTQ=
Date: Fri, 23 Feb 2024 17:51:05 -0800
To: mm-commits@vger.kernel.org,jack@suse.cz,hch@lst.de,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-simplify-the-loops-in-write_cache_pages.patch removed from -mm tree
Message-Id: <20240224015105.AD2FBC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: simplify the loops in write_cache_pages()
has been removed from the -mm tree.  Its filename was
     writeback-simplify-the-loops-in-write_cache_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: writeback: simplify the loops in write_cache_pages()
Date: Thu, 15 Feb 2024 07:36:44 +0100

Collapse the two nested loops into one.  This is needed as a step towards
turning this into an iterator.

Note that this drops the "index <= end" check in the previous outer loop
and just relies on filemap_get_folios_tag() to return 0 entries when index
> end.  This actually has a subtle implication when end == -1 because then
the returned index will be -1 as well and thus if there is page present on
index -1, we could be looping indefinitely.  But as the comment in
filemap_get_folios_tag documents this as already broken anyway we should
not worry about it here either.  The fix for that would probably a change
to the filemap_get_folios_tag() calling convention.

[hch@lst.de: update the commit log per Jan]
Link: https://lkml.kernel.org/r/20240215063649.2164017-10-hch@lst.de
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   83 ++++++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 43 deletions(-)

--- a/mm/page-writeback.c~writeback-simplify-the-loops-in-write_cache_pages
+++ a/mm/page-writeback.c
@@ -2454,6 +2454,7 @@ int write_cache_pages(struct address_spa
 	int error;
 	struct folio *folio;
 	pgoff_t end;		/* Inclusive */
+	int i = 0;
 
 	if (wbc->range_cyclic) {
 		wbc->index = mapping->writeback_index; /* prev offset */
@@ -2467,53 +2468,49 @@ int write_cache_pages(struct address_spa
 
 	folio_batch_init(&wbc->fbatch);
 
-	while (wbc->index <= end) {
-		int i;
-
-		writeback_get_batch(mapping, wbc);
-
+	for (;;) {
+		if (i == wbc->fbatch.nr) {
+			writeback_get_batch(mapping, wbc);
+			i = 0;
+		}
 		if (wbc->fbatch.nr == 0)
 			break;
 
-		for (i = 0; i < wbc->fbatch.nr; i++) {
-			folio = wbc->fbatch.folios[i];
+		folio = wbc->fbatch.folios[i++];
+
+		folio_lock(folio);
+		if (!folio_prepare_writeback(mapping, wbc, folio)) {
+			folio_unlock(folio);
+			continue;
+		}
+
+		trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
+
+		error = writepage(folio, wbc, data);
+		wbc->nr_to_write -= folio_nr_pages(folio);
+
+		if (error == AOP_WRITEPAGE_ACTIVATE) {
+			folio_unlock(folio);
+			error = 0;
+		}
 
-			folio_lock(folio);
-			if (!folio_prepare_writeback(mapping, wbc, folio)) {
-				folio_unlock(folio);
-				continue;
-			}
-
-			trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
-
-			error = writepage(folio, wbc, data);
-			wbc->nr_to_write -= folio_nr_pages(folio);
-
-			if (error == AOP_WRITEPAGE_ACTIVATE) {
-				folio_unlock(folio);
-				error = 0;
-			}
-
-			/*
-			 * For integrity writeback we have to keep going until
-			 * we have written all the folios we tagged for
-			 * writeback above, even if we run past wbc->nr_to_write
-			 * or encounter errors.
-			 * We stash away the first error we encounter in
-			 * wbc->saved_err so that it can be retrieved when we're
-			 * done.  This is because the file system may still have
-			 * state to clear for each folio.
-			 *
-			 * For background writeback we exit as soon as we run
-			 * past wbc->nr_to_write or encounter the first error.
-			 */
-			if (wbc->sync_mode == WB_SYNC_ALL) {
-				if (error && !ret)
-					ret = error;
-			} else {
-				if (error || wbc->nr_to_write <= 0)
-					goto done;
-			}
+		/*
+		 * For integrity writeback we have to keep going until we have
+		 * written all the folios we tagged for writeback above, even if
+		 * we run past wbc->nr_to_write or encounter errors.
+		 * We stash away the first error we encounter in wbc->saved_err
+		 * so that it can be retrieved when we're done.  This is because
+		 * the file system may still have state to clear for each folio.
+		 *
+		 * For background writeback we exit as soon as we run past
+		 * wbc->nr_to_write or encounter the first error.
+		 */
+		if (wbc->sync_mode == WB_SYNC_ALL) {
+			if (error && !ret)
+				ret = error;
+		} else {
+			if (error || wbc->nr_to_write <= 0)
+				goto done;
 		}
 	}
 
_

Patches currently in -mm which might be from willy@infradead.org are



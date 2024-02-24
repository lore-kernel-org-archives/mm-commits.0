Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01989BA5E
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739463; cv=none; b=pa2L4n0TAMkDCRbarmcAD8xc0FbI61caxLSDa3EJI2+akA1mqlKST8rsdvPn8fpK/WSA0vfAiigusD35ub47r5u18PgCgpz1tE/jzMMmtkk9QP1Zo26iOxr9bjXg5XVcAKN10g4YFNWbbt+WbR9LVST1f1KKkTdBYEchvMJBqhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739463; c=relaxed/simple;
	bh=5wcd7AhCoVp5zN7+DQMg2p5IsJimACQ9aRBBoznNfBc=;
	h=Date:To:From:Subject:Message-Id; b=Dq0DAEL+DvRs+5fdUm+/Ljr8uWi4eoyLRfR0ruXsz0XkEs+m4Y7hr7NRbGv4wIDibTWDzlm5GZ/baZStf2kvb5+GPsVsRMXVYoGl1HO3yMXioAJFj7gs6wGUcTnW09crSIKlZlPsXlbrqIIzexEUQ2jaP5jLu6/hBn4/Pq+JirA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fHMvLY0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fHMvLY0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC46AC43394;
	Sat, 24 Feb 2024 01:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739462;
	bh=5wcd7AhCoVp5zN7+DQMg2p5IsJimACQ9aRBBoznNfBc=;
	h=Date:To:From:Subject:From;
	b=fHMvLY0aZYNocjhBsSAsCzbOucZWbj4aSiD/nXFvpLmygYDB1ngrbKAaQdZaFeIUR
	 GPFmNfKGaWlNcCtcad/NQozSQfsuIS+Ron/+FbqATVRmmP8RLsJBjsbBJ8S8M/+QEv
	 Bck22oopU+qTZAFWF5B7YtGu+GrNncCP+cp2dUYQ=
Date: Fri, 23 Feb 2024 17:51:02 -0800
To: mm-commits@vger.kernel.org,jack@suse.cz,hch@lst.de,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-factor-folio_prepare_writeback-out-of-write_cache_pages.patch removed from -mm tree
Message-Id: <20240224015102.CC46AC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: factor folio_prepare_writeback() out of write_cache_pages()
has been removed from the -mm tree.  Its filename was
     writeback-factor-folio_prepare_writeback-out-of-write_cache_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: writeback: factor folio_prepare_writeback() out of write_cache_pages()
Date: Thu, 15 Feb 2024 07:36:42 +0100

Reduce write_cache_pages() by about 30 lines; much of it is commentary,
but it all bundles nicely into an obvious function.

[hch@lst.de: rename should_writeback_folio to folio_prepare_writeback per Jan]
Link: https://lkml.kernel.org/r/20240215063649.2164017-8-hch@lst.de
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   61 +++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 27 deletions(-)

--- a/mm/page-writeback.c~writeback-factor-folio_prepare_writeback-out-of-write_cache_pages
+++ a/mm/page-writeback.c
@@ -2360,6 +2360,38 @@ void tag_pages_for_writeback(struct addr
 }
 EXPORT_SYMBOL(tag_pages_for_writeback);
 
+static bool folio_prepare_writeback(struct address_space *mapping,
+		struct writeback_control *wbc, struct folio *folio)
+{
+	/*
+	 * Folio truncated or invalidated. We can freely skip it then,
+	 * even for data integrity operations: the folio has disappeared
+	 * concurrently, so there could be no real expectation of this
+	 * data integrity operation even if there is now a new, dirty
+	 * folio at the same pagecache index.
+	 */
+	if (unlikely(folio->mapping != mapping))
+		return false;
+
+	/*
+	 * Did somebody else write it for us?
+	 */
+	if (!folio_test_dirty(folio))
+		return false;
+
+	if (folio_test_writeback(folio)) {
+		if (wbc->sync_mode == WB_SYNC_NONE)
+			return false;
+		folio_wait_writeback(folio);
+	}
+	BUG_ON(folio_test_writeback(folio));
+
+	if (!folio_clear_dirty_for_io(folio))
+		return false;
+
+	return true;
+}
+
 /**
  * write_cache_pages - walk the list of dirty pages of the given address space and write all of them.
  * @mapping: address space structure to write
@@ -2430,38 +2462,13 @@ int write_cache_pages(struct address_spa
 		for (i = 0; i < nr_folios; i++) {
 			folio = fbatch.folios[i];
 			folio_lock(folio);
-
-			/*
-			 * Page truncated or invalidated. We can freely skip it
-			 * then, even for data integrity operations: the page
-			 * has disappeared concurrently, so there could be no
-			 * real expectation of this data integrity operation
-			 * even if there is now a new, dirty page at the same
-			 * pagecache address.
-			 */
-			if (unlikely(folio->mapping != mapping)) {
-continue_unlock:
+			if (!folio_prepare_writeback(mapping, wbc, folio)) {
 				folio_unlock(folio);
 				continue;
 			}
 
-			if (!folio_test_dirty(folio)) {
-				/* someone wrote it for us */
-				goto continue_unlock;
-			}
-
-			if (folio_test_writeback(folio)) {
-				if (wbc->sync_mode != WB_SYNC_NONE)
-					folio_wait_writeback(folio);
-				else
-					goto continue_unlock;
-			}
-
-			BUG_ON(folio_test_writeback(folio));
-			if (!folio_clear_dirty_for_io(folio))
-				goto continue_unlock;
-
 			trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
+
 			error = writepage(folio, wbc, data);
 			wbc->nr_to_write -= folio_nr_pages(folio);
 
_

Patches currently in -mm which might be from willy@infradead.org are



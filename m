Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AE53C488
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708548686; cv=none; b=uvrvHBuo55FgLDve+/eBYGzDwXMti77oDwDcZ1yRVR411WBQkF4ff4O1r+xv3R5a45bmnSNORui9I4oapTHgDQNelhsrY8Fxau9qR7sZHiVuB25zIR4FrdgR00lYHvirZymWdh5pd2UiQ+n9T7PIfSzjHOWtJfKr03WerIJDVHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708548686; c=relaxed/simple;
	bh=Al1gwrlKg70mLrYeHJJ0iaQveA/64p2ruCbIXa2dky0=;
	h=Date:To:From:Subject:Message-Id; b=gQpCBlCXUCI7Vnaf2rch0lOa3eGTVaxwSacWhQ4LBJ92/E8xdKMkd5shEJ2LUKzYGU+hR2XCp7T7b6dtOMTAO9EgOxlBU5uPP62ceTKYDjasr4TSULz+RSR0k73xJnX5Tb9p44sAoMtQDHZ0U4Brs6Aep/7h3CqtkyV5BLxgYCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eRV5iihV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eRV5iihV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5142C433F1;
	Wed, 21 Feb 2024 20:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708548685;
	bh=Al1gwrlKg70mLrYeHJJ0iaQveA/64p2ruCbIXa2dky0=;
	h=Date:To:From:Subject:From;
	b=eRV5iihVwERaGocZrfiEP11aKkVUaPPbhk2SgST55EfzTEZA3Fy6vTGorymIj8SWI
	 l4VCDLOZstmPMPJnXuGpnW088WuHoJhjlU7FZb2EQE5CasGOLnV43j+rFxuudF+kDu
	 EHBp0lQeQRR6j8UfzHCZhIZaEPMD6P3VCmaPEOaY=
Date: Wed, 21 Feb 2024 12:51:25 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-only-update-writeback_index-for-range_cyclic-writeback.patch added to mm-unstable branch
Message-Id: <20240221205125.B5142C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: only update ->writeback_index for range_cyclic writeback
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-only-update-writeback_index-for-range_cyclic-writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-only-update-writeback_index-for-range_cyclic-writeback.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: writeback: only update ->writeback_index for range_cyclic writeback
Date: Thu, 15 Feb 2024 07:36:40 +0100

mapping->writeback_index is only [1] used as the starting point for
range_cyclic writeback, so there is no point in updating it for other
types of writeback.

[1] except for btrfs_defrag_file which does really odd things with
mapping->writeback_index.  But btrfs doesn't use write_cache_pages at all,
so this isn't relevant here.

Link: https://lkml.kernel.org/r/20240215063649.2164017-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/mm/page-writeback.c~writeback-only-update-writeback_index-for-range_cyclic-writeback
+++ a/mm/page-writeback.c
@@ -2403,7 +2403,6 @@ int write_cache_pages(struct address_spa
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	pgoff_t done_index;
-	int range_whole = 0;
 	xa_mark_t tag;
 
 	folio_batch_init(&fbatch);
@@ -2413,8 +2412,6 @@ int write_cache_pages(struct address_spa
 	} else {
 		index = wbc->range_start >> PAGE_SHIFT;
 		end = wbc->range_end >> PAGE_SHIFT;
-		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
-			range_whole = 1;
 	}
 	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages) {
 		tag_pages_for_writeback(mapping, index, end);
@@ -2518,14 +2515,21 @@ continue_unlock:
 	}
 
 	/*
-	 * If we hit the last page and there is more work to be done: wrap
-	 * back the index back to the start of the file for the next
-	 * time we are called.
+	 * For range cyclic writeback we need to remember where we stopped so
+	 * that we can continue there next time we are called.  If  we hit the
+	 * last page and there is more work to be done, wrap back to the start
+	 * of the file.
+	 *
+	 * For non-cyclic writeback we always start looking up at the beginning
+	 * of the file if we are called again, which can only happen due to
+	 * -ENOMEM from the file system.
 	 */
-	if (wbc->range_cyclic && !done)
-		done_index = 0;
-	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
-		mapping->writeback_index = done_index;
+	if (wbc->range_cyclic) {
+		if (done)
+			mapping->writeback_index = done_index;
+		else
+			mapping->writeback_index = 0;
+	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from hch@lst.de are

writeback-dont-call-mapping_set_error-on-aop_writepage_activate.patch
writeback-fix-done_index-when-hitting-the-wbc-nr_to_write.patch
writeback-also-update-wbc-nr_to_write-on-writeback-failure.patch
writeback-only-update-writeback_index-for-range_cyclic-writeback.patch
writeback-rework-the-loop-termination-condition-in-write_cache_pages.patch
writeback-add-a-writeback-iterator.patch


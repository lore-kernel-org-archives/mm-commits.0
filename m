Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32DFBA5E
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739461; cv=none; b=LnG4CKa2U8EFtP+rnR5Ddfr0+miLRKydzrHuv9J6bilzU7rbTGXdQaXjThiiJe8UzhWkKxnAwnU3iNYKUlj9qCpQXrPlg4m0Ef4SfmIc4ih0hvLY7xHoKh8ezNtBLXbio0YoqrKhfeNgepKOFidmvClDaQ2p9zOlwGTs6huc5xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739461; c=relaxed/simple;
	bh=SxhI8NMKNyMK/cc/e6YgcchCO56FAQmBqO/a8GAdAag=;
	h=Date:To:From:Subject:Message-Id; b=ArPScb91rMTeQPAtOel/7NxdmIT1Ee4wES1YZ3toynPPjFSe/2ngJ1cpUUogiAuYuo/hVFdLIP1fcNALi0xkR1GNB2mTl6dEY3gVlFU8pytSeoyiBjXVmSYQB/26mJdY5DZGxYf1HAPD3Y3jbI9gfQSbmTE5rQdpwH9gLHemzog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aPnPnJlM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aPnPnJlM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA994C433F1;
	Sat, 24 Feb 2024 01:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739460;
	bh=SxhI8NMKNyMK/cc/e6YgcchCO56FAQmBqO/a8GAdAag=;
	h=Date:To:From:Subject:From;
	b=aPnPnJlMF03x7qA4TSJQlPPe0s2lyrvVKIPz3N2ozHwhtlhSK0JHOnJ3rVqnzol3Q
	 RLfbbi0h5colDER4YwjW9LW5J4pHzD7kp5QjovlGrQfTM6JMD27wwy9w2ceM1efzff
	 Mzzpazso97cpFRXVNfnfD9NzMAzLpjOpdaOIf0eA=
Date: Fri, 23 Feb 2024 17:51:00 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-only-update-writeback_index-for-range_cyclic-writeback.patch removed from -mm tree
Message-Id: <20240224015100.AA994C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: only update ->writeback_index for range_cyclic writeback
has been removed from the -mm tree.  Its filename was
     writeback-only-update-writeback_index-for-range_cyclic-writeback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



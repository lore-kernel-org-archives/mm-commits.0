Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706F016FF37;
	Sun, 19 Apr 2026 06:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776579939; cv=none; b=q9909ep6S0OqKgIRY+wjDw/e0+Rbs0X08FsUdy0ykAD6Y/eZ0t7vn0dEOnyCvADWOa1Y3wpLIa0W0FEAEFzNgpUpSRNoE5ULx+znWZ7unvwawmKQTzCVl4rl9bBPXPtddWQ3PdvBVOAiB3pZ2PJvfb1js7By1BmaPMMEYF6wjCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776579939; c=relaxed/simple;
	bh=r5V8Qn2QN0vaeXwrmKAoosPRsUNMqUMy9zeo//SAbn8=;
	h=Date:To:From:Subject:Message-Id; b=d7T5WVzdfpDNp3PN34APed8ZHfHF1GVucuwfgVUJyc3B2ue+74SAST0BV0DI1/BV1Mo4pDycJZmheD+mFdyuZIR1rKT8+gRdqHDOoLQgJ2+zKvOb898jwuajSIAyxquOCkc0EXhtZSxnVsOwzFrRDJOzem7Ret9akD0kGFZXuEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b2kwTlCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b2kwTlCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0721C2BCAF;
	Sun, 19 Apr 2026 06:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776579939;
	bh=r5V8Qn2QN0vaeXwrmKAoosPRsUNMqUMy9zeo//SAbn8=;
	h=Date:To:From:Subject:From;
	b=b2kwTlCUPq7Q0k664iv31E0IuiYithOLJxxxo0lY3+A9ajPfH/hEKFGvpx+ip1T3i
	 vvaBKZu9jiNNeBvAs+ogmLkO5AvpyUJmGFh0rFbGbIRFnUGwyo1vznW+SvOLDzfgEo
	 G6WaQIUzF3E9ycre6DMnUl8vTq05GdJuvhzhIcJk=
Date: Sat, 18 Apr 2026 23:25:29 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jack@suse.cz,big-sleep-vuln-reports+bigsleep-501448199@google.com,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-call-free_folio-directly-in-folio_unmap_invalidate.patch removed from -mm tree
Message-Id: <20260419062537.F0721C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: call ->free_folio() directly in folio_unmap_invalidate()
has been removed from the -mm tree.  Its filename was
     mm-call-free_folio-directly-in-folio_unmap_invalidate.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: call ->free_folio() directly in folio_unmap_invalidate()
Date: Mon, 13 Apr 2026 19:43:11 +0100

We can only call filemap_free_folio() if we have a reference to (or hold a
lock on) the mapping.  Otherwise, we've already removed the folio from the
mapping so it no longer pins the mapping and the mapping can be removed,
causing a use-after-free when accessing mapping->a_ops.

Follow the same pattern as __remove_mapping() and load the free_folio
function pointer before dropping the lock on the mapping.  That lets us
make filemap_free_folio() static as this was the only caller outside
filemap.c.

Link: https://lore.kernel.org/20260413184314.3419945-1-willy@infradead.org
Fixes: fb7d3bc41493 ("mm/filemap: drop streaming/uncached pages when writeback completes")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Google Big Sleep <big-sleep-vuln-reports+bigsleep-501448199@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c  |    3 ++-
 mm/internal.h |    1 -
 mm/truncate.c |    6 +++++-
 3 files changed, 7 insertions(+), 3 deletions(-)

--- a/mm/filemap.c~mm-call-free_folio-directly-in-folio_unmap_invalidate
+++ a/mm/filemap.c
@@ -228,7 +228,8 @@ void __filemap_remove_folio(struct folio
 	page_cache_delete(mapping, folio, shadow);
 }
 
-void filemap_free_folio(struct address_space *mapping, struct folio *folio)
+static void filemap_free_folio(const struct address_space *mapping,
+		struct folio *folio)
 {
 	void (*free_folio)(struct folio *);
 
--- a/mm/internal.h~mm-call-free_folio-directly-in-folio_unmap_invalidate
+++ a/mm/internal.h
@@ -540,7 +540,6 @@ unsigned find_lock_entries(struct addres
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
 unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
-void filemap_free_folio(struct address_space *mapping, struct folio *folio);
 int truncate_inode_folio(struct address_space *mapping, struct folio *folio);
 bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
 		loff_t end);
--- a/mm/truncate.c~mm-call-free_folio-directly-in-folio_unmap_invalidate
+++ a/mm/truncate.c
@@ -622,6 +622,7 @@ static int folio_launder(struct address_
 int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
 			   gfp_t gfp)
 {
+	void (*free_folio)(struct folio *);
 	int ret;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -648,9 +649,12 @@ int folio_unmap_invalidate(struct addres
 	xa_unlock_irq(&mapping->i_pages);
 	if (mapping_shrinkable(mapping))
 		inode_lru_list_add(mapping->host);
+	free_folio = mapping->a_ops->free_folio;
 	spin_unlock(&mapping->host->i_lock);
 
-	filemap_free_folio(mapping, folio);
+	if (free_folio)
+		free_folio(folio);
+	folio_put_refs(folio, folio_nr_pages(folio));
 	return 1;
 failed:
 	xa_unlock_irq(&mapping->i_pages);
_

Patches currently in -mm which might be from willy@infradead.org are



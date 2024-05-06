Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7111A225CF
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957057; cv=none; b=WcqXfRdoXXfSH7HtEtHUVYHpy7mdyY7r0EiAWh32n0RSPvHdwRjJeG1OvP46A2mKHXyA+1C0YFrJ4G6f1JZ0L7qhRmlLWL2pq8NYedwHOxhrPP6R12O2Raaqpvyn9xaa/qiXcVH1UXb9nI4LOJ3NE6CX4a/wbKMW5MLo8KweH1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957057; c=relaxed/simple;
	bh=6Kupnrvr3A32+pQwJPr5nHHLiO+jD7/OZlkRogYXAxE=;
	h=Date:To:From:Subject:Message-Id; b=nboptN6Z1wLLqFeHMSPTzjpgA+67ol35hNlbcBy2OKo+H5iIgzGDQDEQ4dpctyJa5Nj3JtMYzDle74kpuUuQ5JAM5BHNdBIYCYkzTJXemE8R30ncneSbHF+wsrXZ2P99Z8XgTiXdjHtWvay18RgGnmrrhb+FN418kgqXP3+FJXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cOGf1n4a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cOGf1n4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01479C113CC;
	Mon,  6 May 2024 00:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957057;
	bh=6Kupnrvr3A32+pQwJPr5nHHLiO+jD7/OZlkRogYXAxE=;
	h=Date:To:From:Subject:From;
	b=cOGf1n4aK+mqMgYn/S4jkWIvm5ouSjs9hKs53w2xmOPGwuXOS3jYv2hauLZ6hg9Wb
	 AYnvKK0bJZ8ZIFu1K5oSdOnQHDDYYNFbZLxnZRN/+YBe1sT4OVEQbliH+r3XDM+zYv
	 PoG6Cok9TUgbw0vRe1mKmoFZwSgCZxiC/a4PCzGI=
Date: Sun, 05 May 2024 17:57:36 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,p.raghav@samsung.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-add-kernel-doc-for-block_dirty_folio.patch removed from -mm tree
Message-Id: <20240506005737.01479C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: buffer: add kernel-doc for block_dirty_folio()
has been removed from the -mm tree.  Its filename was
     buffer-add-kernel-doc-for-block_dirty_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: add kernel-doc for block_dirty_folio()
Date: Tue, 16 Apr 2024 04:17:46 +0100

Turn the excellent documentation for this function into kernel-doc. 
Replace 'page' with 'folio' and make a few other minor updates.

Link: https://lkml.kernel.org/r/20240416031754.4076917-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   49 ++++++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

--- a/fs/buffer.c~buffer-add-kernel-doc-for-block_dirty_folio
+++ a/fs/buffer.c
@@ -687,30 +687,37 @@ void mark_buffer_dirty_inode(struct buff
 }
 EXPORT_SYMBOL(mark_buffer_dirty_inode);
 
-/*
- * Add a page to the dirty page list.
+/**
+ * block_dirty_folio - Mark a folio as dirty.
+ * @mapping: The address space containing this folio.
+ * @folio: The folio to mark dirty.
  *
- * It is a sad fact of life that this function is called from several places
- * deeply under spinlocking.  It may not sleep.
+ * Filesystems which use buffer_heads can use this function as their
+ * ->dirty_folio implementation.  Some filesystems need to do a little
+ * work before calling this function.  Filesystems which do not use
+ * buffer_heads should call filemap_dirty_folio() instead.
  *
- * If the page has buffers, the uptodate buffers are set dirty, to preserve
- * dirty-state coherency between the page and the buffers.  It the page does
- * not have buffers then when they are later attached they will all be set
- * dirty.
- *
- * The buffers are dirtied before the page is dirtied.  There's a small race
- * window in which a writepage caller may see the page cleanness but not the
- * buffer dirtiness.  That's fine.  If this code were to set the page dirty
- * before the buffers, a concurrent writepage caller could clear the page dirty
- * bit, see a bunch of clean buffers and we'd end up with dirty buffers/clean
- * page on the dirty page list.
- *
- * We use i_private_lock to lock against try_to_free_buffers while using the
- * page's buffer list.  Also use this to protect against clean buffers being
- * added to the page after it was set dirty.
+ * If the folio has buffers, the uptodate buffers are set dirty, to
+ * preserve dirty-state coherency between the folio and the buffers.
+ * Buffers added to a dirty folio are created dirty.
  *
- * FIXME: may need to call ->reservepage here as well.  That's rather up to the
- * address_space though.
+ * The buffers are dirtied before the folio is dirtied.  There's a small
+ * race window in which writeback may see the folio cleanness but not the
+ * buffer dirtiness.  That's fine.  If this code were to set the folio
+ * dirty before the buffers, writeback could clear the folio dirty flag,
+ * see a bunch of clean buffers and we'd end up with dirty buffers/clean
+ * folio on the dirty folio list.
+ *
+ * We use i_private_lock to lock against try_to_free_buffers() while
+ * using the folio's buffer list.  This also prevents clean buffers
+ * being added to the folio after it was set dirty.
+ *
+ * Context: May only be called from process context.  Does not sleep.
+ * Caller must ensure that @folio cannot be truncated during this call,
+ * typically by holding the folio lock or having a page in the folio
+ * mapped and holding the page table lock.
+ *
+ * Return: True if the folio was dirtied; false if it was already dirtied.
  */
 bool block_dirty_folio(struct address_space *mapping, struct folio *folio)
 {
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch


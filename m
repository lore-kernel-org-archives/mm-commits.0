Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3613B2207A
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957060; cv=none; b=M9ageCWG6ET0KZlM0O4dIts2IHKHrOZ7rTAHGFwXznQ1lB3vefmVNVklNnox8RfSHk0VDnK7fY7tIybP0hOaufZpmTlFePCMVN+hrZuPpMXAZznuJ4msjkSeEsfLJrb8VtF6dKnc2lcguWh/R8hiA1fPIyzi9NrbVm2seqJ2OvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957060; c=relaxed/simple;
	bh=afaqK6ANBZ5qqk7JeF0rLoV/kNRZjLUxZi8x/tf6jK8=;
	h=Date:To:From:Subject:Message-Id; b=NFGAgz+xsb09W0SUQpIirsqXlYBNCF2lgapz8OTAPkaOUojjYfNaX4FGPUJ1UmwmC7mUI+IvU/LRQhOrvmkF9MNAs04MIxzMoVftcG5GqHZJ8dxZsRBHBg2UVl1BBrgA2MK13cZnCL2qw7ornqvjjO8rp2jThO2T3FqH06ETYLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ASrXZ5jX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ASrXZ5jX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFE7C4AF18;
	Mon,  6 May 2024 00:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957060;
	bh=afaqK6ANBZ5qqk7JeF0rLoV/kNRZjLUxZi8x/tf6jK8=;
	h=Date:To:From:Subject:From;
	b=ASrXZ5jXEvDBeMHUKFBuJsZ13PYH1dELyVUp0K9AFQ9Rs6rIJa40sw+olSur/QFFl
	 yvM58oALkI6VrLQfsXyKVeqvDp+tOlxCMIQaEV9EqdZlfHhXbULml/zS6HeyuQZpsr
	 DaXuahDqKST4GCHHx214jHQkO/uXvhblkCk6AsIs=
Date: Sun, 05 May 2024 17:57:39 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,p.raghav@samsung.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-add-kernel-doc-for-brelse-and-__brelse.patch removed from -mm tree
Message-Id: <20240506005740.0CFE7C4AF18@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: buffer: add kernel-doc for brelse() and __brelse()
has been removed from the -mm tree.  Its filename was
     buffer-add-kernel-doc-for-brelse-and-__brelse.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: add kernel-doc for brelse() and __brelse()
Date: Tue, 16 Apr 2024 04:17:49 +0100

Move the documentation for __brelse() to brelse(), format it as kernel-doc
and update it from talking about pages to folios.

Link: https://lkml.kernel.org/r/20240416031754.4076917-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   17 ++++++++---------
 include/linux/buffer_head.h |   16 ++++++++++++++++
 2 files changed, 24 insertions(+), 9 deletions(-)

--- a/fs/buffer.c~buffer-add-kernel-doc-for-brelse-and-__brelse
+++ a/fs/buffer.c
@@ -1226,17 +1226,16 @@ void mark_buffer_write_io_error(struct b
 }
 EXPORT_SYMBOL(mark_buffer_write_io_error);
 
-/*
- * Decrement a buffer_head's reference count.  If all buffers against a page
- * have zero reference count, are clean and unlocked, and if the page is clean
- * and unlocked then try_to_free_buffers() may strip the buffers from the page
- * in preparation for freeing it (sometimes, rarely, buffers are removed from
- * a page but it ends up not being freed, and buffers may later be reattached).
+/**
+ * __brelse - Release a buffer.
+ * @bh: The buffer to release.
+ *
+ * This variant of brelse() can be called if @bh is guaranteed to not be NULL.
  */
-void __brelse(struct buffer_head * buf)
+void __brelse(struct buffer_head *bh)
 {
-	if (atomic_read(&buf->b_count)) {
-		put_bh(buf);
+	if (atomic_read(&bh->b_count)) {
+		put_bh(bh);
 		return;
 	}
 	WARN(1, KERN_ERR "VFS: brelse: Trying to free free buffer\n");
--- a/include/linux/buffer_head.h~buffer-add-kernel-doc-for-brelse-and-__brelse
+++ a/include/linux/buffer_head.h
@@ -303,6 +303,22 @@ static inline void put_bh(struct buffer_
         atomic_dec(&bh->b_count);
 }
 
+/**
+ * brelse - Release a buffer.
+ * @bh: The buffer to release.
+ *
+ * Decrement a buffer_head's reference count.  If @bh is NULL, this
+ * function is a no-op.
+ *
+ * If all buffers on a folio have zero reference count, are clean
+ * and unlocked, and if the folio is unlocked and not under writeback
+ * then try_to_free_buffers() may strip the buffers from the folio in
+ * preparation for freeing it (sometimes, rarely, buffers are removed
+ * from a folio but it ends up not being freed, and buffers may later
+ * be reattached).
+ *
+ * Context: Any context.
+ */
 static inline void brelse(struct buffer_head *bh)
 {
 	if (bh)
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CA48BEC
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337151; cv=none; b=ZTtjwvQiEfw/Vivky3nhjl446xpJto+IMc4dgTBxiMLL1Pz6Hx2Qy8GcMLGVf3UPdK8h3iGoSKafxCR6e/oBx4sk1GY/5HFK58Lm/Sqg6HZPk4gI8aoj+MJSaoFyO9TGxHkpfXhJ8Aog6SEd8OoXy9gl4ZktC+u7DSqQyGT3xIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337151; c=relaxed/simple;
	bh=WxmirGPQQ1UWTRVFCFy8QJU1aBFNc8Hv65DAQWQvc1A=;
	h=Date:To:From:Subject:Message-Id; b=bx6Pm7t3PgNubH1jpStsui4UO1x8xYkIRKPESyemz482NEYJ4AXRoS+BQDNbQmseEE4oTBFuvSK0ZI6OLpFI6NtNOrcCH2gOjH+O2ICHpVpvrT5fJ2nJYEk2JCQ0IQedmRlicamhEVfToQ0mXSJcdBOMfid9BjTtbyR1NlPkpd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z2JJqmNm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z2JJqmNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B190C4CEE0;
	Mon, 20 Jan 2025 01:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337151;
	bh=WxmirGPQQ1UWTRVFCFy8QJU1aBFNc8Hv65DAQWQvc1A=;
	h=Date:To:From:Subject:From;
	b=Z2JJqmNmZbBM+VYqSMDrkFbTzEF7Z5DXYry3DL/GzqljELd+Qh18t3dmE3jO7pHvI
	 Y2hO/zk/BRdCfzXZxGPtb0X9P3NbCdXDcOP4ccgTHfubeeBy/A4TJqRj0OmAuH5/Ff
	 dzZ0mi1KF0OgYy9CoNQNgbtBgwSs1l3lPOrMaHmw=
Date: Sun, 19 Jan 2025 17:39:11 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-add-filemap_fdatawrite_range_kick-helper.patch removed from -mm tree
Message-Id: <20250120013911.8B190C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: add filemap_fdatawrite_range_kick() helper
has been removed from the -mm tree.  Its filename was
     mm-filemap-add-filemap_fdatawrite_range_kick-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jens Axboe <axboe@kernel.dk>
Subject: mm/filemap: add filemap_fdatawrite_range_kick() helper
Date: Fri, 20 Dec 2024 08:47:48 -0700

Works like filemap_fdatawrite_range(), except it's a non-integrity data
writeback and hence only starts writeback on the specified range.  Will
help facilitate generically starting uncached writeback from
generic_write_sync(), as header dependencies preclude doing this inline
from fs.h.

Link: https://lkml.kernel.org/r/20241220154831.1086649-11-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Chris Mason <clm@meta.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 ++
 mm/filemap.c       |   18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

--- a/include/linux/fs.h~mm-filemap-add-filemap_fdatawrite_range_kick-helper
+++ a/include/linux/fs.h
@@ -2878,6 +2878,8 @@ extern int __must_check file_fdatawait_r
 extern int __must_check file_check_and_advance_wb_err(struct file *file);
 extern int __must_check file_write_and_wait_range(struct file *file,
 						loff_t start, loff_t end);
+int filemap_fdatawrite_range_kick(struct address_space *mapping, loff_t start,
+		loff_t end);
 
 static inline int file_write_and_wait(struct file *file)
 {
--- a/mm/filemap.c~mm-filemap-add-filemap_fdatawrite_range_kick-helper
+++ a/mm/filemap.c
@@ -441,6 +441,24 @@ int filemap_fdatawrite_range(struct addr
 EXPORT_SYMBOL(filemap_fdatawrite_range);
 
 /**
+ * filemap_fdatawrite_range_kick - start writeback on a range
+ * @mapping:	target address_space
+ * @start:	index to start writeback on
+ * @end:	last (non-inclusive) index for writeback
+ *
+ * This is a non-integrity writeback helper, to start writing back folios
+ * for the indicated range.
+ *
+ * Return: %0 on success, negative error code otherwise.
+ */
+int filemap_fdatawrite_range_kick(struct address_space *mapping, loff_t start,
+				  loff_t end)
+{
+	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_NONE);
+}
+EXPORT_SYMBOL_GPL(filemap_fdatawrite_range_kick);
+
+/**
  * filemap_flush - mostly a non-blocking flush
  * @mapping:	target address_space
  *
_

Patches currently in -mm which might be from axboe@kernel.dk are



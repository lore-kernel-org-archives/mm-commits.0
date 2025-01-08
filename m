Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90B819D8AC
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736307369; cv=none; b=ExwvTzxB5EWEgIdxiMSJ2F3w6M/LC93W2eV1tcjU81H46q5nLJaALv6cVLOXwH2dJbOnxzD0yf+XkLRe4tqaJdGVaDbSnnS7XAlFl2mesY9R7wdJNIgUwq48MZfFTgDmRk0ZIaX3AuG4fTX46W6ucJ0+CL76yLQTQLKYx+XcJiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736307369; c=relaxed/simple;
	bh=X4gZi7/1U3Sunchp8uirIW1KTcBqPylLMLAjx8/RQX0=;
	h=Date:To:From:Subject:Message-Id; b=NsSAErVt49zAGsRkClenbnVv01kQIp9Q1AvyWYThAdoDCJhuNxqedfHZOP/+vEHk0XrN4NgE8Q8w/VME7VQrzHq2GwhcC0JJbCQkeyMXMHdzaoJW+2M3qNY60JcOFkd613xZroI2My9M5Oa9gdgn7XFEzh8OSc/KD91TgPX6V7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2shYhpFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2shYhpFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E78C4CED0;
	Wed,  8 Jan 2025 03:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736307369;
	bh=X4gZi7/1U3Sunchp8uirIW1KTcBqPylLMLAjx8/RQX0=;
	h=Date:To:From:Subject:From;
	b=2shYhpFUnVcacxTC+k5z7Fet+YlA9G9cfOkJ5u2e9rvyZpOFNlrEC0QpGMBiv94bi
	 jSexTZ+jX0vsNooQczzQi4fvfoRUNII+sv4NLCU27a2j0aAw2NzbaiUd5v25Uxo24F
	 NcG+sWFEMeyxIE+xhT3dzLlOuMYXZw1yweImilZ0=
Date: Tue, 07 Jan 2025 19:36:09 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-add-filemap_fdatawrite_range_kick-helper.patch added to mm-unstable branch
Message-Id: <20250108033609.91E78C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: add filemap_fdatawrite_range_kick() helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-add-filemap_fdatawrite_range_kick-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-add-filemap_fdatawrite_range_kick-helper.patch

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

mm-filemap-change-filemap_create_folio-to-take-a-struct-kiocb.patch
mm-filemap-use-page_cache_sync_ra-to-kick-off-read-ahead.patch
mm-readahead-add-folio-allocation-helper.patch
mm-add-pg_dropbehind-folio-flag.patch
mm-readahead-add-readahead_control-dropbehind-member.patch
mm-truncate-add-folio_unmap_invalidate-helper.patch
fs-add-rwf_dontcache-iocb-and-fop_dontcache-file_operations-flag.patch
mm-filemap-add-read-support-for-rwf_dontcache.patch
mm-filemap-drop-streaming-uncached-pages-when-writeback-completes.patch
mm-filemap-add-filemap_fdatawrite_range_kick-helper.patch
mm-call-filemap_fdatawrite_range_kick-after-iocb_dontcache-issue.patch
mm-add-fgp_dontcache-folio-creation-flag.patch


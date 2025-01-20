Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181A8C8CE
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337142; cv=none; b=hTWkmkd+8GlSWlg5MPuOh3P+rHaY0sKXfqr0QbBdxgILbQfubY0wkEoqkkfj2h4xXJ95Lv2lP+bUjCIHX16NhNDLx0MH/PEny7ADKHU4hkwLa8DNQ97XPu+uuJ0MSfEyuZEmL8Qko6pPfjiVc+RBZSQ7RcFcECoUUlM8v/K3AhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337142; c=relaxed/simple;
	bh=C1Y1taqRbBcwX9Euq2cCOBSdr/ZrIETNyQ6x93I6oWE=;
	h=Date:To:From:Subject:Message-Id; b=fWvDQQSAoZZYn5tE0nsqDFbKV05e7H896n1TQU/pIlMM4zMLycbM6LFP+jLPk/yjqWSXzIdtlrFwPMItOcIbwCvalaynDiueB/FeKREAXUsJ2j9gJ4Ci4QYYudF1qEl35ynVzC5OvYzyew1ToeoH0iqo6VhuMmDzlUW39UDzbn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wVO/oMZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wVO/oMZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C772C4CED6;
	Mon, 20 Jan 2025 01:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337141;
	bh=C1Y1taqRbBcwX9Euq2cCOBSdr/ZrIETNyQ6x93I6oWE=;
	h=Date:To:From:Subject:From;
	b=wVO/oMZ37KiMic2XMUxOPTItT3qYoswgATrki+XTWlAVhqlUKDea1d7Mhka8b3Zju
	 MGd/TA9ywlXdt86wVS1+Tnqgz2KPRtRjumwg0ZRz/WufR0k5xJclFFhS0BUA8ucYt1
	 HgEmxpwicEBhMY9HlPlvDZnWUTjixdtYq+r3uONo=
Date: Sun, 19 Jan 2025 17:39:00 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-use-page_cache_sync_ra-to-kick-off-read-ahead.patch removed from -mm tree
Message-Id: <20250120013901.7C772C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: use page_cache_sync_ra() to kick off read-ahead
has been removed from the -mm tree.  Its filename was
     mm-filemap-use-page_cache_sync_ra-to-kick-off-read-ahead.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jens Axboe <axboe@kernel.dk>
Subject: mm/filemap: use page_cache_sync_ra() to kick off read-ahead
Date: Fri, 20 Dec 2024 08:47:40 -0700

Rather than use the page_cache_sync_readahead() helper, define our own
ractl and use page_cache_sync_ra() directly.  In preparation for needing
to modify ractl inside filemap_get_pages().

No functional changes in this patch.

Link: https://lkml.kernel.org/r/20241220154831.1086649-3-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Chris Mason <clm@meta.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/filemap.c~mm-filemap-use-page_cache_sync_ra-to-kick-off-read-ahead
+++ a/mm/filemap.c
@@ -2499,7 +2499,6 @@ static int filemap_get_pages(struct kioc
 {
 	struct file *filp = iocb->ki_filp;
 	struct address_space *mapping = filp->f_mapping;
-	struct file_ra_state *ra = &filp->f_ra;
 	pgoff_t index = iocb->ki_pos >> PAGE_SHIFT;
 	pgoff_t last_index;
 	struct folio *folio;
@@ -2514,12 +2513,13 @@ retry:
 
 	filemap_get_read_batch(mapping, index, last_index - 1, fbatch);
 	if (!folio_batch_count(fbatch)) {
+		DEFINE_READAHEAD(ractl, filp, &filp->f_ra, mapping, index);
+
 		if (iocb->ki_flags & IOCB_NOIO)
 			return -EAGAIN;
 		if (iocb->ki_flags & IOCB_NOWAIT)
 			flags = memalloc_noio_save();
-		page_cache_sync_readahead(mapping, ra, filp, index,
-				last_index - index);
+		page_cache_sync_ra(&ractl, last_index - index);
 		if (iocb->ki_flags & IOCB_NOWAIT)
 			memalloc_noio_restore(flags);
 		filemap_get_read_batch(mapping, index, last_index - 1, fbatch);
_

Patches currently in -mm which might be from axboe@kernel.dk are



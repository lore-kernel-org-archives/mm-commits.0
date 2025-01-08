Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620C51802AB
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736307372; cv=none; b=KnIhngJ5FiCvbZoFTC1RrZd73fILjMRIXzEDRRkXlLQejBrqw1Cxb9BH5bGw/gr/ToFyfHXo4IlVI0GlLedk715xXy+Smma5rmVtFI2aOT7QC8aV7XAVTH6YWERaL/ERtWGhTzqnjYqvfWzb9ctLxliuX3SqQTnrCzar6kCPxpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736307372; c=relaxed/simple;
	bh=EpYiMrcVPIKPlznQTzLXJBLH/+PjLNTOSPHd3+MwBKU=;
	h=Date:To:From:Subject:Message-Id; b=sePYBUgyix6EqchoQ6tyDunU2PbVQD1k9ET1b0j2xNhsUcHNgHdle+4YF2HqJMhEkujL6OGnJnMMm0bESlPpit65g1cGJ7jSWd7ZPENDALxxebOgQ1MV3JmuS4b9/+bDHmDGh3qwD2M+FsRJrZ0j2nDSZniRJsZLJ8wq6UGcriI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ah1guW3f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ah1guW3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E505BC4CED0;
	Wed,  8 Jan 2025 03:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736307372;
	bh=EpYiMrcVPIKPlznQTzLXJBLH/+PjLNTOSPHd3+MwBKU=;
	h=Date:To:From:Subject:From;
	b=Ah1guW3fIyaLsbUgv+/dc1yES34HNjMX18ICoeSojFSNMeDOMTPZeDgoRWLaeSwCL
	 FG9/Z5/NHgGRlvTMtSQpX0+hHOQFi8GAAS+9eGyX/5gOQZbQTYdg75lf87AgYZLtrL
	 JS74lyi5VROj0Vz0KyIcmUTOhjmlEiwgG+xzzixs=
Date: Tue, 07 Jan 2025 19:36:11 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-call-filemap_fdatawrite_range_kick-after-iocb_dontcache-issue.patch added to mm-unstable branch
Message-Id: <20250108033611.E505BC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: call filemap_fdatawrite_range_kick() after IOCB_DONTCACHE issue
has been added to the -mm mm-unstable branch.  Its filename is
     mm-call-filemap_fdatawrite_range_kick-after-iocb_dontcache-issue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-call-filemap_fdatawrite_range_kick-after-iocb_dontcache-issue.patch

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
Subject: mm: call filemap_fdatawrite_range_kick() after IOCB_DONTCACHE issue
Date: Fri, 20 Dec 2024 08:47:49 -0700

When a buffered write submitted with IOCB_DONTCACHE has been successfully
submitted, call filemap_fdatawrite_range_kick() to kick off the IO.  File
systems call generic_write_sync() for any successful buffered write
submission, hence add the logic here rather than needing to modify the
file system.

Link: https://lkml.kernel.org/r/20241220154831.1086649-12-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Chris Mason <clm@meta.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/fs.h~mm-call-filemap_fdatawrite_range_kick-after-iocb_dontcache-issue
+++ a/include/linux/fs.h
@@ -2912,6 +2912,11 @@ static inline ssize_t generic_write_sync
 				(iocb->ki_flags & IOCB_SYNC) ? 0 : 1);
 		if (ret)
 			return ret;
+	} else if (iocb->ki_flags & IOCB_DONTCACHE) {
+		struct address_space *mapping = iocb->ki_filp->f_mapping;
+
+		filemap_fdatawrite_range_kick(mapping, iocb->ki_pos,
+					      iocb->ki_pos + count);
 	}
 
 	return count;
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


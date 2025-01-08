Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E633D17FAC2
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736307363; cv=none; b=Qv6PCgPqEAxdQr5g4Z0T9Pzhz+CL2qJ2Dsyx+6lJwmTmJKji4UnObahjULsta/nS9JtqhjF5fa1IIQGAioCU0rte6mmCVhOPVIcg9g81BRhAOcFdamhx1TeMZC5MFqs4w9tRwZ9MMGsMKdzgOimsWa4es26Olqx+axcwclGhfKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736307363; c=relaxed/simple;
	bh=bWHP4WrPFgwZ3GaGkDmuwYrf8uwzCm1XfLi7VjDcttU=;
	h=Date:To:From:Subject:Message-Id; b=XgrpnxhK7S4YXCmi6liaE3MYLzD7coI4A7UjqaWfr4ycaWWQx8jYdQkhaI9EuuoHqzvAoA/FBA170iPLhJrSy/H5WPziBoU+R3oeFpgTCp/1Kiz2NBAwnKq2YHgH7ox7TO9sZFVV3sda+9tG5UnV4RpoimtK+T/YghYGKiEGxFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tfgUWgS5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tfgUWgS5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D07C4CED0;
	Wed,  8 Jan 2025 03:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736307362;
	bh=bWHP4WrPFgwZ3GaGkDmuwYrf8uwzCm1XfLi7VjDcttU=;
	h=Date:To:From:Subject:From;
	b=tfgUWgS53xhyL3G1zTm9bxscfOeak4d0bKhiw0bdoe1PJhD7I27s3+omT8hlbUtfQ
	 j8A0j3p68hND/SyozsM/kCu5K8MEVid7FdNHQrgFxR0jrfsgIiH33IsCUuRXe380bt
	 BtOi9AId1WNRV4/pU3X4q5c60aJ6yPf8LPbkYrPo=
Date: Tue, 07 Jan 2025 19:36:02 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-add-rwf_dontcache-iocb-and-fop_dontcache-file_operations-flag.patch added to mm-unstable branch
Message-Id: <20250108033602.B3D07C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: add RWF_DONTCACHE iocb and FOP_DONTCACHE file_operations flag
has been added to the -mm mm-unstable branch.  Its filename is
     fs-add-rwf_dontcache-iocb-and-fop_dontcache-file_operations-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-add-rwf_dontcache-iocb-and-fop_dontcache-file_operations-flag.patch

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
Subject: fs: add RWF_DONTCACHE iocb and FOP_DONTCACHE file_operations flag
Date: Fri, 20 Dec 2024 08:47:45 -0700

If a file system supports uncached buffered IO, it may set FOP_DONTCACHE
and enable support for RWF_DONTCACHE.  If RWF_DONTCACHE is attempted
without the file system supporting it, it'll get errored with -EOPNOTSUPP.

Link: https://lkml.kernel.org/r/20241220154831.1086649-8-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Chris Mason <clm@meta.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h      |   14 +++++++++++++-
 include/uapi/linux/fs.h |    6 +++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/include/linux/fs.h~fs-add-rwf_dontcache-iocb-and-fop_dontcache-file_operations-flag
+++ a/include/linux/fs.h
@@ -322,6 +322,7 @@ struct readahead_control;
 #define IOCB_NOWAIT		(__force int) RWF_NOWAIT
 #define IOCB_APPEND		(__force int) RWF_APPEND
 #define IOCB_ATOMIC		(__force int) RWF_ATOMIC
+#define IOCB_DONTCACHE		(__force int) RWF_DONTCACHE
 
 /* non-RWF related bits - start at 16 */
 #define IOCB_EVENTFD		(1 << 16)
@@ -356,7 +357,8 @@ struct readahead_control;
 	{ IOCB_SYNC,		"SYNC" }, \
 	{ IOCB_NOWAIT,		"NOWAIT" }, \
 	{ IOCB_APPEND,		"APPEND" }, \
-	{ IOCB_ATOMIC,		"ATOMIC"}, \
+	{ IOCB_ATOMIC,		"ATOMIC" }, \
+	{ IOCB_DONTCACHE,	"DONTCACHE" }, \
 	{ IOCB_EVENTFD,		"EVENTFD"}, \
 	{ IOCB_DIRECT,		"DIRECT" }, \
 	{ IOCB_WRITE,		"WRITE" }, \
@@ -2127,6 +2129,8 @@ struct file_operations {
 #define FOP_UNSIGNED_OFFSET	((__force fop_flags_t)(1 << 5))
 /* Supports asynchronous lock callbacks */
 #define FOP_ASYNC_LOCK		((__force fop_flags_t)(1 << 6))
+/* File system supports uncached read/write buffered IO */
+#define FOP_DONTCACHE		((__force fop_flags_t)(1 << 7))
 
 /* Wrap a directory iterator that needs exclusive inode access */
 int wrap_directory_iterator(struct file *, struct dir_context *,
@@ -3614,6 +3618,14 @@ static inline int kiocb_set_rw_flags(str
 		if (!(ki->ki_filp->f_mode & FMODE_CAN_ATOMIC_WRITE))
 			return -EOPNOTSUPP;
 	}
+	if (flags & RWF_DONTCACHE) {
+		/* file system must support it */
+		if (!(ki->ki_filp->f_op->fop_flags & FOP_DONTCACHE))
+			return -EOPNOTSUPP;
+		/* DAX mappings not supported */
+		if (IS_DAX(ki->ki_filp->f_mapping->host))
+			return -EOPNOTSUPP;
+	}
 	kiocb_flags |= (__force int) (flags & RWF_SUPPORTED);
 	if (flags & RWF_SYNC)
 		kiocb_flags |= IOCB_DSYNC;
--- a/include/uapi/linux/fs.h~fs-add-rwf_dontcache-iocb-and-fop_dontcache-file_operations-flag
+++ a/include/uapi/linux/fs.h
@@ -332,9 +332,13 @@ typedef int __bitwise __kernel_rwf_t;
 /* Atomic Write */
 #define RWF_ATOMIC	((__force __kernel_rwf_t)0x00000040)
 
+/* buffered IO that drops the cache after reading or writing data */
+#define RWF_DONTCACHE	((__force __kernel_rwf_t)0x00000080)
+
 /* mask of flags supported by the kernel */
 #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
-			 RWF_APPEND | RWF_NOAPPEND | RWF_ATOMIC)
+			 RWF_APPEND | RWF_NOAPPEND | RWF_ATOMIC |\
+			 RWF_DONTCACHE)
 
 #define PROCFS_IOCTL_MAGIC 'f'
 
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


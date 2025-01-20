Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9E08BEC
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337148; cv=none; b=hhWClpolHsvWZpm1U7QNCUSSnY+ISElQoZKmM3OyeinRFbyAu4zHpq68LnS7ZeVXJxi5ju4Ah0O7TSKTN2QjjTgRb2dMa6cmgNhKywzZsiLjbL8FrCbRgTZhbJZ5FOTSEgfA8V1Fj5JnnxwXZq4OXYh2iBFp+IH8BQDRERBtVjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337148; c=relaxed/simple;
	bh=AJC22qQKeY8eSzxjjMmA01p64xIKKhDvCNcUUtmnDLw=;
	h=Date:To:From:Subject:Message-Id; b=o+oN0kvtknpwtbSklFu+rV1ifZ/icYNocCjse3BPX3fenIgmlyKHYtX2NJMz1ciYxo1NOgol+/9Vb6pqNenMvHnT/ZCVsTTw3meLh9NgDybIAfEtbNJOz+FB0dqubYCwMivw4Ll03+k2PMwnRToarLJbPIrMqvo7Zq6ovDTJcYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Eq8F8VCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Eq8F8VCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD914C4CEE4;
	Mon, 20 Jan 2025 01:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337147;
	bh=AJC22qQKeY8eSzxjjMmA01p64xIKKhDvCNcUUtmnDLw=;
	h=Date:To:From:Subject:From;
	b=Eq8F8VCElCXv6D3XRa9xjUBTt/yQjz2AmVy1990Ne5uUGORPVUBXKAV3njSFvpHPM
	 AGrD8TgexoFx6feK4igmsbMh9dlvAVA5t6T/9HSLIjn/23ul/Q4+Hi16A1BwKHTbEo
	 x5H9tjjwTLt9kiNpDAiPD3dNjSDu4FTEjpT5Qp4I=
Date: Sun, 19 Jan 2025 17:39:07 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-add-rwf_dontcache-iocb-and-fop_dontcache-file_operations-flag.patch removed from -mm tree
Message-Id: <20250120013907.CD914C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: add RWF_DONTCACHE iocb and FOP_DONTCACHE file_operations flag
has been removed from the -mm tree.  Its filename was
     fs-add-rwf_dontcache-iocb-and-fop_dontcache-file_operations-flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



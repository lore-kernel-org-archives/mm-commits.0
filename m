Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4027C1E50E
	for <mm-commits@vger.kernel.org>; Mon,  8 Sep 2025 23:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757372703; cv=none; b=uyI0uXuJq6WF+YeCGEDo9O57sVvD9fC2Sp9O5PecKoaNQUC0rTR6Vh5S3x3BzlDaZan9FZVzI1QLcum3U7ZwdDKZ8/4XucJz43UHGsCTwJ1+tfeLUSURQ9QkVVPnxDeW12L54sDgGl5SWlOcRKbdJfGOW+9s3Z1P6l18PStiOL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757372703; c=relaxed/simple;
	bh=pY+lSvbIYqMXl2mdNGzEXOxvTNWUkPneyKshFOGVXW0=;
	h=Date:To:From:Subject:Message-Id; b=pHki8V01Jmd0FdkxtSxgfdXN1XYKRBH1sC6XPbea3WRQ+PEilCVIeaP37XcqdvylD7GnlCZ9e8JyKClRBJPftn4FFXIvvMzRCmwMyK0byAU7D1SCKsLDaDLR3d4hM3HvEoB1Qgfvu9lx/c5dC6ga21k+vzt8/YRa6/A4fO6HpGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OcTtuLVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OcTtuLVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FBBC4CEF1;
	Mon,  8 Sep 2025 23:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757372702;
	bh=pY+lSvbIYqMXl2mdNGzEXOxvTNWUkPneyKshFOGVXW0=;
	h=Date:To:From:Subject:From;
	b=OcTtuLVEu4j5/1QpD9eIjJ6UcZyuQhbPO/ZEE2ayLC6rlZ6y8ip1AkIEIAQUzdKYU
	 fsj+oTv+Tdz1nTVH2AHFPjZNg7Fae8M3k5mHYX5wtDdijSpNYRhJpOxbEauzoF+E8u
	 Os/RP5mbTq8YJu3/BYYCw0TeHCSIfIs/cNRrf6t0=
Date: Mon, 08 Sep 2025 16:05:02 -0700
To: mm-commits@vger.kernel.org,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + readahead-add-trace-points.patch added to mm-new branch
Message-Id: <20250908230502.C0FBBC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: readahead: add trace points
has been added to the -mm mm-new branch.  Its filename is
     readahead-add-trace-points.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/readahead-add-trace-points.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Jan Kara <jack@suse.cz>
Subject: readahead: add trace points
Date: Mon, 8 Sep 2025 16:55:34 +0200

Add a couple of trace points to make debugging readahead logic easier.

Link: https://lkml.kernel.org/r/20250908145533.31528-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/readahead.h |  132 +++++++++++++++++++++++++++++
 mm/readahead.c                   |    7 +
 2 files changed, 139 insertions(+)

diff --git a/include/trace/events/readahead.h a/include/trace/events/readahead.h
new file mode 100644
--- /dev/null
+++ a/include/trace/events/readahead.h
@@ -0,0 +1,132 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM readahead
+
+#if !defined(_TRACE_FILEMAP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_READAHEAD_H
+
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/pagemap.h>
+
+TRACE_EVENT(do_page_cache_ra,
+	TP_PROTO(struct inode *inode, pgoff_t index, unsigned long nr_to_read,
+		 unsigned long lookahead_size),
+
+	TP_ARGS(inode, index, nr_to_read, lookahead_size),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, i_ino)
+		__field(dev_t, s_dev)
+		__field(pgoff_t, index)
+		__field(unsigned long, nr_to_read)
+		__field(unsigned long, lookahead_size)
+	),
+
+	TP_fast_assign(
+		__entry->i_ino = inode->i_ino;
+		__entry->s_dev = inode->i_sb->s_dev;
+		__entry->index = index;
+		__entry->nr_to_read = nr_to_read;
+		__entry->lookahead_size = lookahead_size;
+	),
+
+	TP_printk(
+		"dev=%d:%d ino=%lx index=%lu nr_to_read=%lu lookahead_size=%lu",
+		MAJOR(__entry->s_dev), MINOR(__entry->s_dev), __entry->i_ino,
+		__entry->index, __entry->nr_to_read, __entry->lookahead_size
+	)
+);
+
+TRACE_EVENT(page_cache_ra_order,
+	TP_PROTO(struct inode *inode, pgoff_t index, struct file_ra_state *ra),
+
+	TP_ARGS(inode, index, ra),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, i_ino)
+		__field(dev_t, s_dev)
+		__field(pgoff_t, index)
+		__field(unsigned int, order)
+		__field(unsigned int, size)
+		__field(unsigned int, async_size)
+		__field(unsigned int, ra_pages)
+	),
+
+	TP_fast_assign(
+		__entry->i_ino = inode->i_ino;
+		__entry->s_dev = inode->i_sb->s_dev;
+		__entry->index = index;
+		__entry->order = ra->order;
+		__entry->size = ra->size;
+		__entry->async_size = ra->async_size;
+		__entry->ra_pages = ra->ra_pages;
+	),
+
+	TP_printk(
+		"dev=%d:%d ino=%lx index=%lu order=%u size=%u async_size=%u ra_pages=%u",
+		MAJOR(__entry->s_dev), MINOR(__entry->s_dev), __entry->i_ino,
+		__entry->index, __entry->order, __entry->size,
+		__entry->async_size, __entry->ra_pages
+	)
+);
+
+DECLARE_EVENT_CLASS(page_cache_ra_op,
+	TP_PROTO(struct inode *inode, pgoff_t index, struct file_ra_state *ra,
+		 unsigned long req_count),
+
+	TP_ARGS(inode, index, ra, req_count),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, i_ino)
+		__field(dev_t, s_dev)
+		__field(pgoff_t, index)
+		__field(unsigned int, order)
+		__field(unsigned int, size)
+		__field(unsigned int, async_size)
+		__field(unsigned int, ra_pages)
+		__field(unsigned int, mmap_miss)
+		__field(loff_t, prev_pos)
+		__field(unsigned long, req_count)
+	),
+
+	TP_fast_assign(
+		__entry->i_ino = inode->i_ino;
+		__entry->s_dev = inode->i_sb->s_dev;
+		__entry->index = index;
+		__entry->order = ra->order;
+		__entry->size = ra->size;
+		__entry->async_size = ra->async_size;
+		__entry->ra_pages = ra->ra_pages;
+		__entry->mmap_miss = ra->mmap_miss;
+		__entry->prev_pos = ra->prev_pos;
+		__entry->req_count = req_count;
+	),
+
+	TP_printk(
+		"dev=%d:%d ino=%lx index=%lu req_count=%lu order=%u size=%u async_size=%u ra_pages=%u mmap_miss=%u prev_pos=%lld",
+		MAJOR(__entry->s_dev), MINOR(__entry->s_dev), __entry->i_ino,
+		__entry->index, __entry->req_count, __entry->order,
+		__entry->size, __entry->async_size, __entry->ra_pages,
+		__entry->mmap_miss, __entry->prev_pos
+	)
+);
+
+DEFINE_EVENT(page_cache_ra_op, page_cache_sync_ra,
+	TP_PROTO(struct inode *inode, pgoff_t index, struct file_ra_state *ra,
+		 unsigned long req_count),
+	TP_ARGS(inode, index, ra, req_count)
+);
+
+DEFINE_EVENT(page_cache_ra_op, page_cache_async_ra,
+	TP_PROTO(struct inode *inode, pgoff_t index, struct file_ra_state *ra,
+		 unsigned long req_count),
+	TP_ARGS(inode, index, ra, req_count)
+);
+
+#endif /* _TRACE_FILEMAP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
--- a/mm/readahead.c~readahead-add-trace-points
+++ a/mm/readahead.c
@@ -129,6 +129,9 @@
 #include <linux/fadvise.h>
 #include <linux/sched/mm.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/readahead.h>
+
 #include "internal.h"
 
 /*
@@ -314,6 +317,7 @@ static void do_page_cache_ra(struct read
 	loff_t isize = i_size_read(inode);
 	pgoff_t end_index;	/* The last page we want to read */
 
+	trace_do_page_cache_ra(inode, index, nr_to_read, lookahead_size);
 	if (isize == 0)
 		return;
 
@@ -470,6 +474,7 @@ void page_cache_ra_order(struct readahea
 	gfp_t gfp = readahead_gfp_mask(mapping);
 	unsigned int new_order = ra->order;
 
+	trace_page_cache_ra_order(mapping->host, start, ra);
 	if (!mapping_large_folio_support(mapping)) {
 		ra->order = 0;
 		goto fallback;
@@ -554,6 +559,7 @@ void page_cache_sync_ra(struct readahead
 	unsigned long max_pages, contig_count;
 	pgoff_t prev_index, miss;
 
+	trace_page_cache_sync_ra(ractl->mapping->host, index, ra, req_count);
 	/*
 	 * Even if readahead is disabled, issue this request as readahead
 	 * as we'll need it to satisfy the requested range. The forced
@@ -638,6 +644,7 @@ void page_cache_async_ra(struct readahea
 	if (folio_test_writeback(folio))
 		return;
 
+	trace_page_cache_async_ra(ractl->mapping->host, index, ra, req_count);
 	folio_clear_readahead(folio);
 
 	if (blk_cgroup_congested())
_

Patches currently in -mm which might be from jack@suse.cz are

readahead-add-trace-points.patch


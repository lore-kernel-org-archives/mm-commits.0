Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A137C21D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489965; cv=none; b=Q92A2qEnCTsMyZXvlroZy4vAjn9fQUaowK6zbhChALDeEdhFt5dao6tJmhv3KVncRn8UAra8k89fzjwZI5wW89G//LgHbP0k6gd1CRoNrd9dTfqqiCaYTYUD1UUoXVIrFf8JpZIRXgt7tRHgbvXXPVexAGj9kG8tNlWCpHDvn64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489965; c=relaxed/simple;
	bh=OERphrzPIxx0z++0BbtLfyHvKF6c9WmdJjZsnpjQsMA=;
	h=Date:To:From:Subject:Message-Id; b=Y9TBluLxFsJm2k5+kXzteOAnzWl2XDuSVaWMBiPfnwW2XDW3+dQ5/9dTatP5B55Fkk8jPV4Ys7gR99fHs6dQzHVR75b2zFkVI6zVBzw+wXFgxNQNNsj3dEmbKgIfy7RFOgzSmX88gc4zWAoQg8TnRfGrKYPbgPUDgPd/COeSV4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j+vBR5ao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j+vBR5ao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DABC4CEE7;
	Sun, 21 Sep 2025 21:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489965;
	bh=OERphrzPIxx0z++0BbtLfyHvKF6c9WmdJjZsnpjQsMA=;
	h=Date:To:From:Subject:From;
	b=j+vBR5aoXgEEWFC15Cs8RVOptArSGZR4PAOWq301zY/giA58T4DEI67nc3a3Z1Kas
	 iEov0a+TWsIjMtiRINg2nEXc/PHtxZBY2a2Ipn2TR2Y6FmkJgbnYM9g5Mo4iWJjjt/
	 tw7hQc27zuEmVypNwpbujHIsqNEgbNIcldV2lqhQ=
Date: Sun, 21 Sep 2025 14:26:04 -0700
To: mm-commits@vger.kernel.org,p.raghav@samsung.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] readahead-add-trace-points.patch removed from -mm tree
Message-Id: <20250921212605.78DABC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: readahead: add trace points
has been removed from the -mm tree.  Its filename was
     readahead-add-trace-points.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: readahead: add trace points
Date: Mon, 8 Sep 2025 16:55:34 +0200

Add a couple of trace points to make debugging readahead logic easier.

[jack@suse.cz: v2]
  Link: https://lkml.kernel.org/r/20250909145849.5090-2-jack@suse.cz
Link: https://lkml.kernel.org/r/20250908145533.31528-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Tested-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/readahead.h |  132 +++++++++++++++++++++++++++++
 mm/readahead.c                   |    8 +
 2 files changed, 140 insertions(+)

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
+TRACE_EVENT(page_cache_ra_unbounded,
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
@@ -225,6 +228,8 @@ void page_cache_ra_unbounded(struct read
 	 */
 	unsigned int nofs = memalloc_nofs_save();
 
+	trace_page_cache_ra_unbounded(mapping->host, index, nr_to_read,
+				      lookahead_size);
 	filemap_invalidate_lock_shared(mapping);
 	index = mapping_align_index(mapping, index);
 
@@ -470,6 +475,7 @@ void page_cache_ra_order(struct readahea
 	gfp_t gfp = readahead_gfp_mask(mapping);
 	unsigned int new_order = ra->order;
 
+	trace_page_cache_ra_order(mapping->host, start, ra);
 	if (!mapping_large_folio_support(mapping)) {
 		ra->order = 0;
 		goto fallback;
@@ -554,6 +560,7 @@ void page_cache_sync_ra(struct readahead
 	unsigned long max_pages, contig_count;
 	pgoff_t prev_index, miss;
 
+	trace_page_cache_sync_ra(ractl->mapping->host, index, ra, req_count);
 	/*
 	 * Even if readahead is disabled, issue this request as readahead
 	 * as we'll need it to satisfy the requested range. The forced
@@ -638,6 +645,7 @@ void page_cache_async_ra(struct readahea
 	if (folio_test_writeback(folio))
 		return;
 
+	trace_page_cache_async_ra(ractl->mapping->host, index, ra, req_count);
 	folio_clear_readahead(folio);
 
 	if (blk_cgroup_congested())
_

Patches currently in -mm which might be from jack@suse.cz are



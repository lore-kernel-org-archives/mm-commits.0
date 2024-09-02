Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B95E7DA73
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247804; cv=none; b=uwkge6QtgVgtZd1jFE5RAl3I72wBz8slD/KQbKzZSv049AhSlBrls0RHrm6t9hq+STd57cooqoyN5Wqk/KrnWWU1t7/+1Gw+LtfYN+/vPVJafLhpzcT+E9+losSrlIwEBKg3rZJ+GJvF1jJrCikgNh3Rgx3rTcy3EiN9fvmJSiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247804; c=relaxed/simple;
	bh=8a6e85MwUxNG6Hmn7jHx84KHKyNLvIaDVTGOkVqwaBQ=;
	h=Date:To:From:Subject:Message-Id; b=Ps/J83FgUDs20zuqAeUP19+YD6cxeJYWG7zDQgWLsP2A8qI7407MTwqtQddc/cSpwMHqNqQ+u8tB94jCm+7f5gxUpEUAErEadZg24OExA77HW753a4BJPikG5N/20FtSDGN43TFjuK9mTI8R1/74TiQd4NG97Vwxg/LT6XwAwM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MuigJYQ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MuigJYQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5128EC4CEC2;
	Mon,  2 Sep 2024 03:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247804;
	bh=8a6e85MwUxNG6Hmn7jHx84KHKyNLvIaDVTGOkVqwaBQ=;
	h=Date:To:From:Subject:From;
	b=MuigJYQ9dr3AyIPS62KxytsKvXTh62+uervtacmV1aQgeLNf9q1CAcovJRJBS+KaC
	 8td+np/dkC4ne5wpZ9TdeWHIi70QzF91bqCKAuw8TWlrBR2ZjFgOYez7F1JZE4Mrde
	 jdGcBiWZN1b84hUSqBQsB1ab7wPkDU6GrmvnaBQA=
Date: Sun, 01 Sep 2024 20:30:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,uekawa@chromium.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,takayas@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-add-trace-events-for-get_pages-map_pages-and-fault.patch removed from -mm tree
Message-Id: <20240902033004.5128EC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: filemap: add trace events for get_pages, map_pages, and fault
has been removed from the -mm tree.  Its filename was
     filemap-add-trace-events-for-get_pages-map_pages-and-fault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Takaya Saeki <takayas@chromium.org>
Subject: filemap: add trace events for get_pages, map_pages, and fault
Date: Tue, 13 Aug 2024 10:03:12 +0000

To allow precise tracking of page caches accessed, add new tracepoints
that trigger when a process actually accesses them.

The ureadahead program used by ChromeOS traces the disk access of programs
as they start up at boot up.  It uses mincore(2) or the
'mm_filemap_add_to_page_cache' trace event to accomplish this.  It stores
this information in a "pack" file and on subsequent boots, it will read
the pack file and call readahead(2) on the information so that disk
storage can be loaded into RAM before the applications actually need it.

A problem we see is that due to the kernel's readahead algorithm that can
aggressively pull in more data than needed (to try and accomplish the same
goal) and this data is also recorded.  The end result is that the pack
file contains a lot of pages on disk that are never actually used. 
Calling readahead(2) on these unused pages can slow down the system boot
up times.

To solve this, add 3 new trace events, get_pages, map_pages, and fault. 
These will be used to trace the pages are not only pulled in from disk,
but are actually used by the application.  Only those pages will be stored
in the pack file, and this helps out the performance of boot up.

With the combination of these 3 new trace events and
mm_filemap_add_to_page_cache, we observed a reduction in the pack file by
7.3% - 20% on ChromeOS varying by device.

Link: https://lkml.kernel.org/r/20240813100312.3930505-1-takayas@chromium.org
Signed-off-by: Takaya Saeki <takayas@chromium.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Junichi Uekawa <uekawa@chromium.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/filemap.h |   84 +++++++++++++++++++++++++++++++
 mm/filemap.c                   |    4 +
 2 files changed, 88 insertions(+)

--- a/include/trace/events/filemap.h~filemap-add-trace-events-for-get_pages-map_pages-and-fault
+++ a/include/trace/events/filemap.h
@@ -56,6 +56,90 @@ DEFINE_EVENT(mm_filemap_op_page_cache, m
 	TP_ARGS(folio)
 	);
 
+DECLARE_EVENT_CLASS(mm_filemap_op_page_cache_range,
+
+	TP_PROTO(
+		struct address_space *mapping,
+		pgoff_t index,
+		pgoff_t last_index
+	),
+
+	TP_ARGS(mapping, index, last_index),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, i_ino)
+		__field(dev_t, s_dev)
+		__field(unsigned long, index)
+		__field(unsigned long, last_index)
+	),
+
+	TP_fast_assign(
+		__entry->i_ino = mapping->host->i_ino;
+		if (mapping->host->i_sb)
+			__entry->s_dev =
+				mapping->host->i_sb->s_dev;
+		else
+			__entry->s_dev = mapping->host->i_rdev;
+		__entry->index = index;
+		__entry->last_index = last_index;
+	),
+
+	TP_printk(
+		"dev=%d:%d ino=%lx ofs=%lld-%lld",
+		MAJOR(__entry->s_dev),
+		MINOR(__entry->s_dev), __entry->i_ino,
+		((loff_t)__entry->index) << PAGE_SHIFT,
+		((((loff_t)__entry->last_index + 1) << PAGE_SHIFT) - 1)
+	)
+);
+
+DEFINE_EVENT(mm_filemap_op_page_cache_range, mm_filemap_get_pages,
+	TP_PROTO(
+		struct address_space *mapping,
+		pgoff_t index,
+		pgoff_t last_index
+	),
+	TP_ARGS(mapping, index, last_index)
+);
+
+DEFINE_EVENT(mm_filemap_op_page_cache_range, mm_filemap_map_pages,
+	TP_PROTO(
+		struct address_space *mapping,
+		pgoff_t index,
+		pgoff_t last_index
+	),
+	TP_ARGS(mapping, index, last_index)
+);
+
+TRACE_EVENT(mm_filemap_fault,
+	TP_PROTO(struct address_space *mapping, pgoff_t index),
+
+	TP_ARGS(mapping, index),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, i_ino)
+		__field(dev_t, s_dev)
+		__field(unsigned long, index)
+	),
+
+	TP_fast_assign(
+		__entry->i_ino = mapping->host->i_ino;
+		if (mapping->host->i_sb)
+			__entry->s_dev =
+				mapping->host->i_sb->s_dev;
+		else
+			__entry->s_dev = mapping->host->i_rdev;
+		__entry->index = index;
+	),
+
+	TP_printk(
+		"dev=%d:%d ino=%lx ofs=%lld",
+		MAJOR(__entry->s_dev),
+		MINOR(__entry->s_dev), __entry->i_ino,
+		((loff_t)__entry->index) << PAGE_SHIFT
+	)
+);
+
 TRACE_EVENT(filemap_set_wb_err,
 		TP_PROTO(struct address_space *mapping, errseq_t eseq),
 
--- a/mm/filemap.c~filemap-add-trace-events-for-get_pages-map_pages-and-fault
+++ a/mm/filemap.c
@@ -2548,6 +2548,7 @@ retry:
 			goto err;
 	}
 
+	trace_mm_filemap_get_pages(mapping, index, last_index);
 	return 0;
 err:
 	if (err < 0)
@@ -3279,6 +3280,8 @@ vm_fault_t filemap_fault(struct vm_fault
 	if (unlikely(index >= max_idx))
 		return VM_FAULT_SIGBUS;
 
+	trace_mm_filemap_fault(mapping, index);
+
 	/*
 	 * Do we have something in the page cache already?
 	 */
@@ -3645,6 +3648,7 @@ vm_fault_t filemap_map_pages(struct vm_f
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
 	add_mm_counter(vma->vm_mm, folio_type, rss);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	trace_mm_filemap_map_pages(mapping, start_pgoff, end_pgoff);
 out:
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from takayas@chromium.org are



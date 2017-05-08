From: akpm@linux-foundation.org
Subject: [patch 111/114] dax: add tracepoint to dax_writeback_one()
Date: Mon, 08 May 2017 16:00:13 -0700
Message-ID: <20170508230013.bV5FxK0gD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47754 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752016AbdEHXAO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 19:00:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, jack@suse.cz, mawilcox@microsoft.com, mingo@redhat.com, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, rostedt@goodmis.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: add tracepoint to dax_writeback_one()

Add a tracepoint to dax_writeback_one(), following the same logging
conventions as the rest of DAX.

Here is an example range writeback which ends up flushing one PMD and one
PTE:

test-1265  [003] ....   496.615250: dax_writeback_range: dev 259:0 ino 0x1003
pgoff 0x0-0x7ffffffffffff

test-1265  [003] ....   496.616263: dax_writeback_one: dev 259:0 ino 0x1003
pgoff 0x0 pglen 0x200

test-1265  [003] ....   496.616270: dax_writeback_one: dev 259:0 ino 0x1003
pgoff 0x305 pglen 0x1

test-1265  [003] ....   496.616272: dax_writeback_range_done: dev 259:0 ino
0x1003 pgoff 0x0-0x7ffffffffffff

[akpm@linux-foundation.org: struct blk_dax_ctl has disappeared]
Link: http://lkml.kernel.org/r/20170221195116.13278-6-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                      |    1 +
 include/trace/events/fs_dax.h |   24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff -puN fs/dax.c~dax-add-tracepoint-to-dax_writeback_one fs/dax.c
--- a/fs/dax.c~dax-add-tracepoint-to-dax_writeback_one
+++ a/fs/dax.c
@@ -823,6 +823,7 @@ static int dax_writeback_one(struct bloc
 	spin_lock_irq(&mapping->tree_lock);
 	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_DIRTY);
 	spin_unlock_irq(&mapping->tree_lock);
+	trace_dax_writeback_one(mapping->host, index, size >> PAGE_SHIFT);
  dax_unlock:
 	dax_read_unlock(id);
 	put_locked_mapping_entry(mapping, index, entry);
diff -puN include/trace/events/fs_dax.h~dax-add-tracepoint-to-dax_writeback_one include/trace/events/fs_dax.h
--- a/include/trace/events/fs_dax.h~dax-add-tracepoint-to-dax_writeback_one
+++ a/include/trace/events/fs_dax.h
@@ -226,6 +226,30 @@ DEFINE_EVENT(dax_writeback_range_class,
 DEFINE_WRITEBACK_RANGE_EVENT(dax_writeback_range);
 DEFINE_WRITEBACK_RANGE_EVENT(dax_writeback_range_done);
 
+TRACE_EVENT(dax_writeback_one,
+	TP_PROTO(struct inode *inode, pgoff_t pgoff, pgoff_t pglen),
+	TP_ARGS(inode, pgoff, pglen),
+	TP_STRUCT__entry(
+		__field(unsigned long, ino)
+		__field(pgoff_t, pgoff)
+		__field(pgoff_t, pglen)
+		__field(dev_t, dev)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->pgoff = pgoff;
+		__entry->pglen = pglen;
+	),
+	TP_printk("dev %d:%d ino %#lx pgoff %#lx pglen %#lx",
+		MAJOR(__entry->dev),
+		MINOR(__entry->dev),
+		__entry->ino,
+		__entry->pgoff,
+		__entry->pglen
+	)
+)
+
 #endif /* _TRACE_FS_DAX_H */
 
 /* This part must be outside protection */
_

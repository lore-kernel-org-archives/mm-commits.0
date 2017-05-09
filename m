From: akpm@linux-foundation.org
Subject: [merged]
 dax-add-tracepoints-to-dax_writeback_mapping_range.patch removed from -mm
 tree
Date: Tue, 09 May 2017 11:04:46 -0700
Message-ID: <20170509180446.ZrzSlmEWE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36198 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754076AbdEISEx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:04:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, jack@suse.cz, mawilcox@microsoft.com, mingo@redhat.com, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, rostedt@goodmis.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: dax: add tracepoints to dax_writeback_mapping_range()
has been removed from the -mm tree.  Its filename was
     dax-add-tracepoints-to-dax_writeback_mapping_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: add tracepoints to dax_writeback_mapping_range()

Add tracepoints to dax_writeback_mapping_range(), following the same
logging conventions as the rest of DAX.

Here is an example writeback call:

msync-1085  [006] ....   200.902565: dax_writeback_range: dev 259:0 ino
0x1003 pgoff 0x200-0x2ff

msync-1085  [006] ....   200.902579: dax_writeback_range_done: dev 259:0
ino 0x1003 pgoff 0x200-0x2ff

[ross.zwisler@linux.intel.com: fix regression in dax_writeback_mapping_range()]
  Link: http://lkml.kernel.org/r/20170314215358.31451-1-ross.zwisler@linux.intel.com
Link: http://lkml.kernel.org/r/20170221195116.13278-5-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                      |   12 +++++++-----
 include/trace/events/fs_dax.h |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 5 deletions(-)

diff -puN fs/dax.c~dax-add-tracepoints-to-dax_writeback_mapping_range fs/dax.c
--- a/fs/dax.c~dax-add-tracepoints-to-dax_writeback_mapping_range
+++ a/fs/dax.c
@@ -863,6 +863,8 @@ int dax_writeback_mapping_range(struct a
 	start_index = wbc->range_start >> PAGE_SHIFT;
 	end_index = wbc->range_end >> PAGE_SHIFT;
 
+	trace_dax_writeback_range(inode, start_index, end_index);
+
 	tag_pages_for_writeback(mapping, start_index, end_index);
 
 	pagevec_init(&pvec, 0);
@@ -882,14 +884,14 @@ int dax_writeback_mapping_range(struct a
 
 			ret = dax_writeback_one(bdev, dax_dev, mapping,
 					indices[i], pvec.pages[i]);
-			if (ret < 0) {
-				put_dax(dax_dev);
-				return ret;
-			}
+			if (ret < 0)
+				goto out;
 		}
 	}
+out:
 	put_dax(dax_dev);
-	return 0;
+	trace_dax_writeback_range_done(inode, start_index, end_index);
+	return (ret < 0 ? ret : 0);
 }
 EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
 
diff -puN include/trace/events/fs_dax.h~dax-add-tracepoints-to-dax_writeback_mapping_range include/trace/events/fs_dax.h
--- a/include/trace/events/fs_dax.h~dax-add-tracepoints-to-dax_writeback_mapping_range
+++ a/include/trace/events/fs_dax.h
@@ -194,6 +194,38 @@ DEFINE_PTE_FAULT_EVENT(dax_pfn_mkwrite_n
 DEFINE_PTE_FAULT_EVENT(dax_pfn_mkwrite);
 DEFINE_PTE_FAULT_EVENT(dax_load_hole);
 
+DECLARE_EVENT_CLASS(dax_writeback_range_class,
+	TP_PROTO(struct inode *inode, pgoff_t start_index, pgoff_t end_index),
+	TP_ARGS(inode, start_index, end_index),
+	TP_STRUCT__entry(
+		__field(unsigned long, ino)
+		__field(pgoff_t, start_index)
+		__field(pgoff_t, end_index)
+		__field(dev_t, dev)
+	),
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->start_index = start_index;
+		__entry->end_index = end_index;
+	),
+	TP_printk("dev %d:%d ino %#lx pgoff %#lx-%#lx",
+		MAJOR(__entry->dev),
+		MINOR(__entry->dev),
+		__entry->ino,
+		__entry->start_index,
+		__entry->end_index
+	)
+)
+
+#define DEFINE_WRITEBACK_RANGE_EVENT(name) \
+DEFINE_EVENT(dax_writeback_range_class, name, \
+	TP_PROTO(struct inode *inode, pgoff_t start_index, pgoff_t end_index),\
+	TP_ARGS(inode, start_index, end_index))
+
+DEFINE_WRITEBACK_RANGE_EVENT(dax_writeback_range);
+DEFINE_WRITEBACK_RANGE_EVENT(dax_writeback_range_done);
+
 #endif /* _TRACE_FS_DAX_H */
 
 /* This part must be outside protection */
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are



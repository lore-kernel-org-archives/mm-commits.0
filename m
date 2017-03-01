From: akpm@linux-foundation.org
Subject: + dax-add-tracepoints-to-dax_writeback_mapping_range.patch added
 to -mm tree
Date: Tue, 28 Feb 2017 17:01:58 -0800
Message-ID: <58b61d86.fj8DwwnRSQLKatVe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41790 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751518AbdCABMh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 20:12:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, jack@suse.cz, mawilcox@microsoft.com, mingo@redhat.com, rostedt@goodmis.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: add tracepoints to dax_writeback_mapping_range()
has been added to the -mm tree.  Its filename is
     dax-add-tracepoints-to-dax_writeback_mapping_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-add-tracepoints-to-dax_writeback_mapping_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-add-tracepoints-to-dax_writeback_mapping_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 fs/dax.c                      |    8 ++++++--
 include/trace/events/fs_dax.h |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 2 deletions(-)

diff -puN fs/dax.c~dax-add-tracepoints-to-dax_writeback_mapping_range fs/dax.c
--- a/fs/dax.c~dax-add-tracepoints-to-dax_writeback_mapping_range
+++ a/fs/dax.c
@@ -878,6 +878,8 @@ int dax_writeback_mapping_range(struct a
 	start_index = wbc->range_start >> PAGE_SHIFT;
 	end_index = wbc->range_end >> PAGE_SHIFT;
 
+	trace_dax_writeback_range(inode, start_index, end_index);
+
 	tag_pages_for_writeback(mapping, start_index, end_index);
 
 	pagevec_init(&pvec, 0);
@@ -898,10 +900,12 @@ int dax_writeback_mapping_range(struct a
 			ret = dax_writeback_one(bdev, mapping, indices[i],
 					pvec.pages[i]);
 			if (ret < 0)
-				return ret;
+				goto out;
 		}
 	}
-	return 0;
+out:
+	trace_dax_writeback_range_done(inode, start_index, end_index);
+	return ret;
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

dax-add-tracepoints-to-dax_iomap_pte_fault.patch
dax-add-tracepoints-to-dax_pfn_mkwrite.patch
dax-add-tracepoints-to-dax_load_hole.patch
dax-add-tracepoints-to-dax_writeback_mapping_range.patch
dax-add-tracepoint-to-dax_writeback_one.patch
dax-add-tracepoint-to-dax_insert_mapping.patch


From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-add-tracepoints-for-analyzing-reading-and-writing-metadata-files.patch removed from -mm tree
Date: Mon, 09 Nov 2015 12:13:16 -0800
Message-ID: <5640fe5c.90+OxO26IBZC4rzu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbKIUNQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mitake.hitoshi@lab.ntt.co.jp, TK.Kato@wdc.com, konishi.ryusuke@lab.ntt.co.jp, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: add tracepoints for analyzing reading and writing metadata files
has been removed from the -mm tree.  Its filename was
     nilfs2-add-tracepoints-for-analyzing-reading-and-writing-metadata-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Subject: nilfs2: add tracepoints for analyzing reading and writing metadata files

This patch adds tracepoints for analyzing requests of reading and writing
metadata files.  The tracepoints cover every in-place mdt files (cpfile,
sufile, and datfile).

Example of tracing mdt_insert_new_block():
              cp-14635 [000] ...1 30598.199309: nilfs2_mdt_insert_new_block: inode = ffff88022a8d0178 ino = 3 block = 155
              cp-14635 [000] ...1 30598.199520: nilfs2_mdt_insert_new_block: inode = ffff88022a8d0178 ino = 3 block = 5
              cp-14635 [000] ...1 30598.200828: nilfs2_mdt_insert_new_block: inode = ffff88022a8d0178 ino = 3 block = 253

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: TK Kato <TK.Kato@wdc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/mdt.c               |    6 +++
 include/trace/events/nilfs2.h |   54 ++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff -puN fs/nilfs2/mdt.c~nilfs2-add-tracepoints-for-analyzing-reading-and-writing-metadata-files fs/nilfs2/mdt.c
--- a/fs/nilfs2/mdt.c~nilfs2-add-tracepoints-for-analyzing-reading-and-writing-metadata-files
+++ a/fs/nilfs2/mdt.c
@@ -33,6 +33,7 @@
 #include "page.h"
 #include "mdt.h"
 
+#include <trace/events/nilfs2.h>
 
 #define NILFS_MDT_MAX_RA_BLOCKS		(16 - 1)
 
@@ -68,6 +69,9 @@ nilfs_mdt_insert_new_block(struct inode
 	set_buffer_uptodate(bh);
 	mark_buffer_dirty(bh);
 	nilfs_mdt_mark_dirty(inode);
+
+	trace_nilfs2_mdt_insert_new_block(inode, inode->i_ino, block);
+
 	return 0;
 }
 
@@ -158,6 +162,8 @@ nilfs_mdt_submit_block(struct inode *ino
 	get_bh(bh);
 	submit_bh(mode, bh);
 	ret = 0;
+
+	trace_nilfs2_mdt_submit_block(inode, inode->i_ino, blkoff, mode);
  out:
 	get_bh(bh);
 	*out_bh = bh;
diff -puN include/trace/events/nilfs2.h~nilfs2-add-tracepoints-for-analyzing-reading-and-writing-metadata-files include/trace/events/nilfs2.h
--- a/include/trace/events/nilfs2.h~nilfs2-add-tracepoints-for-analyzing-reading-and-writing-metadata-files
+++ a/include/trace/events/nilfs2.h
@@ -162,6 +162,60 @@ TRACE_EVENT(nilfs2_segment_usage_freed,
 		      __entry->segnum)
 );
 
+TRACE_EVENT(nilfs2_mdt_insert_new_block,
+	    TP_PROTO(struct inode *inode,
+		     unsigned long ino,
+		     unsigned long block),
+
+	    TP_ARGS(inode, ino, block),
+
+	    TP_STRUCT__entry(
+		    __field(struct inode *, inode)
+		    __field(unsigned long, ino)
+		    __field(unsigned long, block)
+	    ),
+
+	    TP_fast_assign(
+		    __entry->inode = inode;
+		    __entry->ino = ino;
+		    __entry->block = block;
+		    ),
+
+	    TP_printk("inode = %p ino = %lu block = %lu",
+		      __entry->inode,
+		      __entry->ino,
+		      __entry->block)
+);
+
+TRACE_EVENT(nilfs2_mdt_submit_block,
+	    TP_PROTO(struct inode *inode,
+		     unsigned long ino,
+		     unsigned long blkoff,
+		     int mode),
+
+	    TP_ARGS(inode, ino, blkoff, mode),
+
+	    TP_STRUCT__entry(
+		    __field(struct inode *, inode)
+		    __field(unsigned long, ino)
+		    __field(unsigned long, blkoff)
+		    __field(int, mode)
+	    ),
+
+	    TP_fast_assign(
+		    __entry->inode = inode;
+		    __entry->ino = ino;
+		    __entry->blkoff = blkoff;
+		    __entry->mode = mode;
+		    ),
+
+	    TP_printk("inode = %p ino = %lu blkoff = %lu mode = %x",
+		      __entry->inode,
+		      __entry->ino,
+		      __entry->blkoff,
+		      __entry->mode)
+);
+
 #endif /* _TRACE_NILFS2_H */
 
 /* This part must be outside protection */
_

Patches currently in -mm which might be from mitake.hitoshi@lab.ntt.co.jp are



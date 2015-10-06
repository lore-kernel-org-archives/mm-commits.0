From: akpm@linux-foundation.org
Subject: +
 nilfs2-add-tracepoints-for-analyzing-reading-and-writing-metadata-files.patch added to -mm tree
Date: Tue, 06 Oct 2015 13:03:39 -0700
Message-ID: <5614291b.LiL7VC+1PGGYL+5J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbbJFUDk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2015 16:03:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mitake.hitoshi@lab.ntt.co.jp, TK.Kato@wdc.com, konishi.ryusuke@lab.ntt.co.jp, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: add tracepoints for analyzing reading and writing metadata files
has been added to the -mm tree.  Its filename is
     nilfs2-add-tracepoints-for-analyzing-reading-and-writing-metadata-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-add-tracepoints-for-analyzing-reading-and-writing-metadata-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-add-tracepoints-for-analyzing-reading-and-writing-metadata-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

nilfs2-add-a-tracepoint-for-tracking-stage-transition-of-segment-construction.patch
nilfs2-add-a-tracepoint-for-transaction-events.patch
nilfs2-add-tracepoints-for-analyzing-sufile-manipulation.patch
nilfs2-add-tracepoints-for-analyzing-reading-and-writing-metadata-files.patch


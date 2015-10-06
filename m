From: akpm@linux-foundation.org
Subject: + nilfs2-add-tracepoints-for-analyzing-sufile-manipulation.patch
 added to -mm tree
Date: Tue, 06 Oct 2015 13:03:37 -0700
Message-ID: <56142919.Q4qXooszVFSRZTwV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbbJFUDi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2015 16:03:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mitake.hitoshi@lab.ntt.co.jp, TK.Kato@wdc.com, benixon.dhas@wdc.com, konishi.ryusuke@lab.ntt.co.jp, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: add tracepoints for analyzing sufile manipulation
has been added to the -mm tree.  Its filename is
     nilfs2-add-tracepoints-for-analyzing-sufile-manipulation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-add-tracepoints-for-analyzing-sufile-manipulation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-add-tracepoints-for-analyzing-sufile-manipulation.patch

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
Subject: nilfs2: add tracepoints for analyzing sufile manipulation

This patch adds tracepoints which would be useful for analyzing segment
usage from a perspective of high level sufile manipulation (check, alloc,
free).  sufile is an important in-place updated metadata file, so
analyzing the behavior would be useful for performance turning.

example of usage (a case of allocation):

$ sudo bin/tpoint nilfs2:nilfs2_segment_usage_allocated
Tracing nilfs2:nilfs2_segment_usage_allocated. Ctrl-C to end.
        segctord-17800 [002] ...1 10671.867294: nilfs2_segment_usage_allocated: sufile = ffff880054f908a8 segnum = 2
        segctord-17800 [002] ...1 10675.073477: nilfs2_segment_usage_allocated: sufile = ffff880054f908a8 segnum = 3

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Benixon Dhas <benixon.dhas@wdc.com>
Cc: TK Kato <TK.Kato@wdc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sufile.c            |    8 +++
 include/trace/events/nilfs2.h |   67 ++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff -puN fs/nilfs2/sufile.c~nilfs2-add-tracepoints-for-analyzing-sufile-manipulation fs/nilfs2/sufile.c
--- a/fs/nilfs2/sufile.c~nilfs2-add-tracepoints-for-analyzing-sufile-manipulation
+++ a/fs/nilfs2/sufile.c
@@ -30,6 +30,8 @@
 #include "mdt.h"
 #include "sufile.h"
 
+#include <trace/events/nilfs2.h>
+
 /**
  * struct nilfs_sufile_info - on-memory private data of sufile
  * @mi: on-memory private data of metadata file
@@ -358,6 +360,7 @@ int nilfs_sufile_alloc(struct inode *suf
 				break; /* never happens */
 			}
 		}
+		trace_nilfs2_segment_usage_check(sufile, segnum, cnt);
 		ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 1,
 							   &su_bh);
 		if (ret < 0)
@@ -388,6 +391,9 @@ int nilfs_sufile_alloc(struct inode *suf
 			nilfs_mdt_mark_dirty(sufile);
 			brelse(su_bh);
 			*segnump = segnum;
+
+			trace_nilfs2_segment_usage_allocated(sufile, segnum);
+
 			goto out_header;
 		}
 
@@ -490,6 +496,8 @@ void nilfs_sufile_do_free(struct inode *
 	NILFS_SUI(sufile)->ncleansegs++;
 
 	nilfs_mdt_mark_dirty(sufile);
+
+	trace_nilfs2_segment_usage_freed(sufile, segnum);
 }
 
 /**
diff -puN include/trace/events/nilfs2.h~nilfs2-add-tracepoints-for-analyzing-sufile-manipulation include/trace/events/nilfs2.h
--- a/include/trace/events/nilfs2.h~nilfs2-add-tracepoints-for-analyzing-sufile-manipulation
+++ a/include/trace/events/nilfs2.h
@@ -95,6 +95,73 @@ TRACE_EVENT(nilfs2_transaction_transitio
 		      show_transaction_state(__entry->state))
 );
 
+TRACE_EVENT(nilfs2_segment_usage_check,
+	    TP_PROTO(struct inode *sufile,
+		     __u64 segnum,
+		     unsigned long cnt),
+
+	    TP_ARGS(sufile, segnum, cnt),
+
+	    TP_STRUCT__entry(
+		    __field(struct inode *, sufile)
+		    __field(__u64, segnum)
+		    __field(unsigned long, cnt)
+	    ),
+
+	    TP_fast_assign(
+		    __entry->sufile = sufile;
+		    __entry->segnum = segnum;
+		    __entry->cnt = cnt;
+		    ),
+
+	    TP_printk("sufile = %p segnum = %llu cnt = %lu",
+		      __entry->sufile,
+		      __entry->segnum,
+		      __entry->cnt)
+);
+
+TRACE_EVENT(nilfs2_segment_usage_allocated,
+	    TP_PROTO(struct inode *sufile,
+		     __u64 segnum),
+
+	    TP_ARGS(sufile, segnum),
+
+	    TP_STRUCT__entry(
+		    __field(struct inode *, sufile)
+		    __field(__u64, segnum)
+	    ),
+
+	    TP_fast_assign(
+		    __entry->sufile = sufile;
+		    __entry->segnum = segnum;
+		    ),
+
+	    TP_printk("sufile = %p segnum = %llu",
+		      __entry->sufile,
+		      __entry->segnum)
+);
+
+TRACE_EVENT(nilfs2_segment_usage_freed,
+	    TP_PROTO(struct inode *sufile,
+		     __u64 segnum),
+
+	    TP_ARGS(sufile, segnum),
+
+	    TP_STRUCT__entry(
+		    __field(struct inode *, sufile)
+		    __field(__u64, segnum)
+	    ),
+
+	    TP_fast_assign(
+		    __entry->sufile = sufile;
+		    __entry->segnum = segnum;
+		    ),
+
+	    TP_printk("sufile = %p segnum = %llu",
+		      __entry->sufile,
+		      __entry->segnum)
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


From: akpm@linux-foundation.org
Subject: + nilfs2-add-a-tracepoint-for-transaction-events.patch added to
 -mm tree
Date: Tue, 06 Oct 2015 13:03:35 -0700
Message-ID: <56142917.7nJb2lYdYV9jq1Xa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbbJFUDg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2015 16:03:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mitake.hitoshi@lab.ntt.co.jp, konishi.ryusuke@lab.ntt.co.jp, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: add a tracepoint for transaction events
has been added to the -mm tree.  Its filename is
     nilfs2-add-a-tracepoint-for-transaction-events.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-add-a-tracepoint-for-transaction-events.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-add-a-tracepoint-for-transaction-events.patch

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
Subject: nilfs2: add a tracepoint for transaction events

This patch adds a tracepoint for transaction events of nilfs.  With the
tracepoint, these events can be tracked: begin, abort, commit, trylock,
lock, and unlock.  Basically, these events have corresponding functions
e.g.  begin event corresponds nilfs_transaction_begin().  The unlock event
is an exception.  It corresponds to the iteration in
nilfs_transaction_lock().

Only one tracepoint is introcued: nilfs2_transaction_transition.  The
above events are distinguished with newly introduced enum.  With this
tracepoint, we can analyse a critical section of segment constructoin.

Sample output by tpoint of perf-tools:
              cp-4457  [000] ...1    63.266220: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800bf5ccc58 count = 1 flags = 9 state = BEGIN
              cp-4457  [000] ...1    63.266221: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800bf5ccc58 count = 0 flags = 9 state = COMMIT
              cp-4457  [000] ...1    63.266221: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800bf5ccc58 count = 0 flags = 9 state = COMMIT
        segctord-4371  [001] ...1    68.261196: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 10 state = TRYLOCK
        segctord-4371  [001] ...1    68.261280: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 10 state = LOCK
        segctord-4371  [001] ...1    68.261877: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 1 flags = 10 state = BEGIN
        segctord-4371  [001] ...1    68.262116: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 18 state = COMMIT
        segctord-4371  [001] ...1    68.265032: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 18 state = UNLOCK
        segctord-4371  [001] ...1   132.376847: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 10 state = TRYLOCK

This patch also does trivial cleaning of comma usage in collection stage
transition event for consistent coding style.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c           |   33 +++++++++++++++++++
 include/trace/events/nilfs2.h |   53 ++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 1 deletion(-)

diff -puN fs/nilfs2/segment.c~nilfs2-add-a-tracepoint-for-transaction-events fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-add-a-tracepoint-for-transaction-events
+++ a/fs/nilfs2/segment.c
@@ -214,11 +214,18 @@ int nilfs_transaction_begin(struct super
 {
 	struct the_nilfs *nilfs;
 	int ret = nilfs_prepare_segment_lock(ti);
+	struct nilfs_transaction_info *trace_ti;
 
 	if (unlikely(ret < 0))
 		return ret;
-	if (ret > 0)
+	if (ret > 0) {
+		trace_ti = current->journal_info;
+
+		trace_nilfs2_transaction_transition(sb, trace_ti,
+				    trace_ti->ti_count, trace_ti->ti_flags,
+				    TRACE_NILFS2_TRANSACTION_BEGIN);
 		return 0;
+	}
 
 	sb_start_intwrite(sb);
 
@@ -229,6 +236,11 @@ int nilfs_transaction_begin(struct super
 		ret = -ENOSPC;
 		goto failed;
 	}
+
+	trace_ti = current->journal_info;
+	trace_nilfs2_transaction_transition(sb, trace_ti, trace_ti->ti_count,
+					    trace_ti->ti_flags,
+					    TRACE_NILFS2_TRANSACTION_BEGIN);
 	return 0;
 
  failed:
@@ -261,6 +273,8 @@ int nilfs_transaction_commit(struct supe
 	ti->ti_flags |= NILFS_TI_COMMIT;
 	if (ti->ti_count > 0) {
 		ti->ti_count--;
+		trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
+			    ti->ti_flags, TRACE_NILFS2_TRANSACTION_COMMIT);
 		return 0;
 	}
 	if (nilfs->ns_writer) {
@@ -272,6 +286,9 @@ int nilfs_transaction_commit(struct supe
 			nilfs_segctor_do_flush(sci, 0);
 	}
 	up_read(&nilfs->ns_segctor_sem);
+	trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
+			    ti->ti_flags, TRACE_NILFS2_TRANSACTION_COMMIT);
+
 	current->journal_info = ti->ti_save;
 
 	if (ti->ti_flags & NILFS_TI_SYNC)
@@ -290,10 +307,15 @@ void nilfs_transaction_abort(struct supe
 	BUG_ON(ti == NULL || ti->ti_magic != NILFS_TI_MAGIC);
 	if (ti->ti_count > 0) {
 		ti->ti_count--;
+		trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
+			    ti->ti_flags, TRACE_NILFS2_TRANSACTION_ABORT);
 		return;
 	}
 	up_read(&nilfs->ns_segctor_sem);
 
+	trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
+		    ti->ti_flags, TRACE_NILFS2_TRANSACTION_ABORT);
+
 	current->journal_info = ti->ti_save;
 	if (ti->ti_flags & NILFS_TI_DYNAMIC_ALLOC)
 		kmem_cache_free(nilfs_transaction_cachep, ti);
@@ -339,6 +361,9 @@ static void nilfs_transaction_lock(struc
 	current->journal_info = ti;
 
 	for (;;) {
+		trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
+			    ti->ti_flags, TRACE_NILFS2_TRANSACTION_TRYLOCK);
+
 		down_write(&nilfs->ns_segctor_sem);
 		if (!test_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags))
 			break;
@@ -350,6 +375,9 @@ static void nilfs_transaction_lock(struc
 	}
 	if (gcflag)
 		ti->ti_flags |= NILFS_TI_GC;
+
+	trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
+			    ti->ti_flags, TRACE_NILFS2_TRANSACTION_LOCK);
 }
 
 static void nilfs_transaction_unlock(struct super_block *sb)
@@ -362,6 +390,9 @@ static void nilfs_transaction_unlock(str
 
 	up_write(&nilfs->ns_segctor_sem);
 	current->journal_info = ti->ti_save;
+
+	trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
+			    ti->ti_flags, TRACE_NILFS2_TRANSACTION_UNLOCK);
 }
 
 static void *nilfs_segctor_map_segsum_entry(struct nilfs_sc_info *sci,
diff -puN include/trace/events/nilfs2.h~nilfs2-add-a-tracepoint-for-transaction-events include/trace/events/nilfs2.h
--- a/include/trace/events/nilfs2.h~nilfs2-add-a-tracepoint-for-transaction-events
+++ a/include/trace/events/nilfs2.h
@@ -42,6 +42,59 @@ TRACE_EVENT(nilfs2_collection_stage_tran
 		      show_collection_stage(__entry->stage))
 );
 
+#ifndef TRACE_HEADER_MULTI_READ
+enum nilfs2_transaction_transition_state {
+	TRACE_NILFS2_TRANSACTION_BEGIN,
+	TRACE_NILFS2_TRANSACTION_COMMIT,
+	TRACE_NILFS2_TRANSACTION_ABORT,
+	TRACE_NILFS2_TRANSACTION_TRYLOCK,
+	TRACE_NILFS2_TRANSACTION_LOCK,
+	TRACE_NILFS2_TRANSACTION_UNLOCK,
+};
+#endif
+
+#define show_transaction_state(type)					\
+	__print_symbolic(type,						\
+			 { TRACE_NILFS2_TRANSACTION_BEGIN, "BEGIN" },	\
+			 { TRACE_NILFS2_TRANSACTION_COMMIT, "COMMIT" },	\
+			 { TRACE_NILFS2_TRANSACTION_ABORT, "ABORT" },	\
+			 { TRACE_NILFS2_TRANSACTION_TRYLOCK, "TRYLOCK" }, \
+			 { TRACE_NILFS2_TRANSACTION_LOCK, "LOCK" },	\
+			 { TRACE_NILFS2_TRANSACTION_UNLOCK, "UNLOCK" })
+
+TRACE_EVENT(nilfs2_transaction_transition,
+	    TP_PROTO(struct super_block *sb,
+		     struct nilfs_transaction_info *ti,
+		     int count,
+		     unsigned int flags,
+		     enum nilfs2_transaction_transition_state state),
+
+	    TP_ARGS(sb, ti, count, flags, state),
+
+	    TP_STRUCT__entry(
+		    __field(void *, sb)
+		    __field(void *, ti)
+		    __field(int, count)
+		    __field(unsigned int, flags)
+		    __field(int, state)
+	    ),
+
+	    TP_fast_assign(
+		    __entry->sb = sb;
+		    __entry->ti = ti;
+		    __entry->count = count;
+		    __entry->flags = flags;
+		    __entry->state = state;
+		    ),
+
+	    TP_printk("sb = %p ti = %p count = %d flags = %x state = %s",
+		      __entry->sb,
+		      __entry->ti,
+		      __entry->count,
+		      __entry->flags,
+		      show_transaction_state(__entry->state))
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


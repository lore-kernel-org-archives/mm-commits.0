From: akpm@linux-foundation.org
Subject: [merged] wb-inode-writeback-list-tracking-tracepoints.patch
 removed from -mm tree
Date: Wed, 27 Jul 2016 11:59:13 -0700
Message-ID: <57990481.7Rsz9jPLCVKxb+5m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863AbcG0S7O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 14:59:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfoster@redhat.com, dchinner@redhat.com, holger.hoffstaette@applied-asynchrony.com, jack@suse.cz, jbacik@fb.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fs-writeback.c: inode writeback list tracking tracepoi=
nts
has been removed from the -mm tree.  Its filename was
     wb-inode-writeback-list-tracking-tracepoints.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Brian Foster <bfoster@redhat.com>
Subject: fs/fs-writeback.c: inode writeback list tracking tracepoints

The per-sb inode writeback list tracks inodes currently under writeback
to facilitate efficient sync processing. In particular, it ensures that
sync only needs to walk through a list of inodes that were cleaned by
the sync.

Add a couple tracepoints to help identify when inodes are added/removed
to and from the writeback lists. Piggyback off of the writeback lazytim=
e
tracepoint template as it already tracks the relevant inode information=
=2E

Link: http://lkml.kernel.org/r/1466594593-6757-3-git-send-email-bfoster=
@redhat.com
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <dchinner@redhat.com>
cc: Josef Bacik <jbacik@fb.com>
Cc: Holger Hoffst=E4tte <holger.hoffstaette@applied-asynchrony.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c                |    9 +++++++--
 include/trace/events/writeback.h |   22 ++++++++++++++++++----
 2 files changed, 25 insertions(+), 6 deletions(-)

diff -puN fs/fs-writeback.c~wb-inode-writeback-list-tracking-tracepoint=
s fs/fs-writeback.c
--- a/fs/fs-writeback.c~wb-inode-writeback-list-tracking-tracepoints
+++ a/fs/fs-writeback.c
@@ -990,8 +990,10 @@ void sb_mark_inode_writeback(struct inod
=20
 	if (list_empty(&inode->i_wb_list)) {
 		spin_lock_irqsave(&sb->s_inode_wblist_lock, flags);
-		if (list_empty(&inode->i_wb_list))
+		if (list_empty(&inode->i_wb_list)) {
 			list_add_tail(&inode->i_wb_list, &sb->s_inodes_wb);
+			trace_sb_mark_inode_writeback(inode);
+		}
 		spin_unlock_irqrestore(&sb->s_inode_wblist_lock, flags);
 	}
 }
@@ -1006,7 +1008,10 @@ void sb_clear_inode_writeback(struct ino
=20
 	if (!list_empty(&inode->i_wb_list)) {
 		spin_lock_irqsave(&sb->s_inode_wblist_lock, flags);
-		list_del_init(&inode->i_wb_list);
+		if (!list_empty(&inode->i_wb_list)) {
+			list_del_init(&inode->i_wb_list);
+			trace_sb_clear_inode_writeback(inode);
+		}
 		spin_unlock_irqrestore(&sb->s_inode_wblist_lock, flags);
 	}
 }
diff -puN include/trace/events/writeback.h~wb-inode-writeback-list-trac=
king-tracepoints include/trace/events/writeback.h
--- a/include/trace/events/writeback.h~wb-inode-writeback-list-tracking=
-tracepoints
+++ a/include/trace/events/writeback.h
@@ -696,7 +696,7 @@ DEFINE_EVENT(writeback_single_inode_temp
 	TP_ARGS(inode, wbc, nr_to_write)
 );
=20
-DECLARE_EVENT_CLASS(writeback_lazytime_template,
+DECLARE_EVENT_CLASS(writeback_inode_template,
 	TP_PROTO(struct inode *inode),
=20
 	TP_ARGS(inode),
@@ -723,25 +723,39 @@ DECLARE_EVENT_CLASS(writeback_lazytime_t
 		  show_inode_state(__entry->state), __entry->mode)
 );
=20
-DEFINE_EVENT(writeback_lazytime_template, writeback_lazytime,
+DEFINE_EVENT(writeback_inode_template, writeback_lazytime,
 	TP_PROTO(struct inode *inode),
=20
 	TP_ARGS(inode)
 );
=20
-DEFINE_EVENT(writeback_lazytime_template, writeback_lazytime_iput,
+DEFINE_EVENT(writeback_inode_template, writeback_lazytime_iput,
 	TP_PROTO(struct inode *inode),
=20
 	TP_ARGS(inode)
 );
=20
-DEFINE_EVENT(writeback_lazytime_template, writeback_dirty_inode_enqueu=
e,
+DEFINE_EVENT(writeback_inode_template, writeback_dirty_inode_enqueue,
=20
 	TP_PROTO(struct inode *inode),
=20
 	TP_ARGS(inode)
 );
=20
+/*
+ * Inode writeback list tracking.
+ */
+
+DEFINE_EVENT(writeback_inode_template, sb_mark_inode_writeback,
+	TP_PROTO(struct inode *inode),
+	TP_ARGS(inode)
+);
+
+DEFINE_EVENT(writeback_inode_template, sb_clear_inode_writeback,
+	TP_PROTO(struct inode *inode),
+	TP_ARGS(inode)
+);
+
 #endif /* _TRACE_WRITEBACK_H */
=20
 /* This part must be outside protection */
_

Patches currently in -mm which might be from bfoster@redhat.com are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

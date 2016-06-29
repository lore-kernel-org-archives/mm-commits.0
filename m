From: akpm@linux-foundation.org
Subject: [merged] ocfs2-disable-bug-assertions-in-reading-blocks.patch
 removed from -mm tree
Date: Tue, 28 Jun 2016 19:03:06 -0700
Message-ID: <57732c5a.nfxUg0gigZWovLpY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbcF2CF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2016 22:05:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: disable BUG assertions in reading blocks
has been removed from the -mm tree.  Its filename was
     ocfs2-disable-bug-assertions-in-reading-blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2: disable BUG assertions in reading blocks

According to some high-load testing, these two BUG assertions were
encountered, this led system panic.  Actually, there were some discussions
about removing these two BUG() assertions, it would not bring any side
effect.

Then, I did the the following changes,

1) use the existing macro CATCH_BH_JBD_RACES to wrap BUG() in the
   ocfs2_read_blocks_sync function like before.

2) disable the macro CATCH_BH_JBD_RACES in Makefile by default.

Link: http://lkml.kernel.org/r/1466574294-26863-1-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/Makefile         |    2 --
 fs/ocfs2/buffer_head_io.c |    5 +++++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/Makefile~ocfs2-disable-bug-assertions-in-reading-blocks fs/ocfs2/Makefile
--- a/fs/ocfs2/Makefile~ocfs2-disable-bug-assertions-in-reading-blocks
+++ a/fs/ocfs2/Makefile
@@ -1,7 +1,5 @@
 ccflags-y := -Ifs/ocfs2
 
-ccflags-y += -DCATCH_BH_JBD_RACES
-
 obj-$(CONFIG_OCFS2_FS) += 	\
 	ocfs2.o			\
 	ocfs2_stackglue.o
diff -puN fs/ocfs2/buffer_head_io.c~ocfs2-disable-bug-assertions-in-reading-blocks fs/ocfs2/buffer_head_io.c
--- a/fs/ocfs2/buffer_head_io.c~ocfs2-disable-bug-assertions-in-reading-blocks
+++ a/fs/ocfs2/buffer_head_io.c
@@ -139,11 +139,16 @@ int ocfs2_read_blocks_sync(struct ocfs2_
 
 		lock_buffer(bh);
 		if (buffer_jbd(bh)) {
+#ifdef CATCH_BH_JBD_RACES
 			mlog(ML_ERROR,
 			     "block %llu had the JBD bit set "
 			     "while I was in lock_buffer!",
 			     (unsigned long long)bh->b_blocknr);
 			BUG();
+#else
+			unlock_buffer(bh);
+			continue;
+#endif
 		}
 
 		clear_buffer_uptodate(bh);
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-insure-dlm-lockspace-is-created-by-kernel-module.patch


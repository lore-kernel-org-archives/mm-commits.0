From: akpm@linux-foundation.org
Subject: + ocfs2-disable-bug-assertions-in-reading-blocks.patch added to
 -mm tree
Date: Wed, 22 Jun 2016 15:05:58 -0700
Message-ID: <576b0bc6.7qHYKvWnDoY3VBVK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbcFVWF7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2016 18:05:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: disable BUG assertions in reading blocks
has been added to the -mm tree.  Its filename is
     ocfs2-disable-bug-assertions-in-reading-blocks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-disable-bug-assertions-in-reading-blocks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-disable-bug-assertions-in-reading-blocks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-disable-bug-assertions-in-reading-blocks.patch
ocfs2-insure-dlm-lockspace-is-created-by-kernel-module.patch


From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-do-not-bug-if-buffer-not-uptodate-in-__ocfs2_journal_access.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:02:02 -0700
Message-ID: <55ef229a.oAofDr57MDPpro2X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbbIHSCD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:02:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, zhang.guanghui@h3c.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not BUG if buffer not uptodate in __ocfs2_journal_access
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-bug-if-buffer-not-uptodate-in-__ocfs2_journal_access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: do not BUG if buffer not uptodate in __ocfs2_journal_access

When storage network is unstable, it may trigger the BUG in
__ocfs2_journal_access because of buffer not uptodate.  We can retry the
write in this case or return error instead of BUG.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reported-by: Zhangguanghui <zhang.guanghui@h3c.com>
Tested-by: Zhangguanghui <zhang.guanghui@h3c.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/journal.c~ocfs2-do-not-bug-if-buffer-not-uptodate-in-__ocfs2_journal_access fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-do-not-bug-if-buffer-not-uptodate-in-__ocfs2_journal_access
+++ a/fs/ocfs2/journal.c
@@ -668,7 +668,23 @@ static int __ocfs2_journal_access(handle
 		mlog(ML_ERROR, "giving me a buffer that's not uptodate!\n");
 		mlog(ML_ERROR, "b_blocknr=%llu\n",
 		     (unsigned long long)bh->b_blocknr);
-		BUG();
+
+		lock_buffer(bh);
+		/*
+		 * A previous attempt to write this buffer head failed.
+		 * Nothing we can do but to retry the write and hope for
+		 * the best.
+		 */
+		if (buffer_write_io_error(bh) && !buffer_uptodate(bh)) {
+			clear_buffer_write_io_error(bh);
+			set_buffer_uptodate(bh);
+		}
+
+		if (!buffer_uptodate(bh)) {
+			unlock_buffer(bh);
+			return -EIO;
+		}
+		unlock_buffer(bh);
 	}
 
 	/* Set the current transaction information on the ci so
_

Patches currently in -mm which might be from joseph.qi@huawei.com are



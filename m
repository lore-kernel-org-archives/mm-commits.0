From: akpm@linux-foundation.org
Subject: - ubifs-do-not-use-wb_sync_hold.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:35 -0800
Message-ID: <200901072214.n07MEZDi014483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761634AbZAGWOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Artem.Bityutskiy@nokia.com, npiggin@suse.de, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     UBIFS: do not use WB_SYNC_HOLD
has been removed from the -mm tree.  Its filename was
     ubifs-do-not-use-wb_sync_hold.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: UBIFS: do not use WB_SYNC_HOLD
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

WB_SYNC_HOLD is going to be zapped so we should not use it. Use
%WB_SYNC_NONE instead. Here is what akpm said:

"I think I'll just switch that to WB_SYNC_NONE.  The `wait==0' mode is
just an advisory thing to help the fs shove lots of data into the
queues.  If some gets missed then it'll be picked up on the second
->sync_fs call, with wait==1."

Thanks to Randy Dunlap for catching this.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ubifs/super.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/ubifs/super.c~ubifs-do-not-use-wb_sync_hold fs/ubifs/super.c
--- a/fs/ubifs/super.c~ubifs-do-not-use-wb_sync_hold
+++ a/fs/ubifs/super.c
@@ -432,12 +432,19 @@ static int ubifs_sync_fs(struct super_bl
 	int i, err;
 	struct ubifs_info *c = sb->s_fs_info;
 	struct writeback_control wbc = {
-		.sync_mode   = wait ? WB_SYNC_ALL : WB_SYNC_HOLD,
+		.sync_mode   = wait ? WB_SYNC_ALL : WB_SYNC_NONE,
 		.range_start = 0,
 		.range_end   = LLONG_MAX,
 		.nr_to_write = LONG_MAX,
 	};
 
+	/*
+	 * Note by akpm about WB_SYNC_NONE used above: zero @wait is just an
+	 * advisory thing to help the file system shove lots of data into the
+	 * queues. If some gets missed then it'll be picked up on the second
+	 * '->sync_fs()' call, with non-zero @wait.
+	 */
+
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
_

Patches currently in -mm which might be from Artem.Bityutskiy@nokia.com are

origin.patch
linux-next.patch
reiser4-vfs-add-super_operationssync_inodes-2.patch


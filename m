From: akpm@linux-foundation.org
Subject: + ubifs-do-not-use-wb_sync_hold.patch added to -mm tree
Date: Tue, 06 Jan 2009 09:13:05 -0800
Message-ID: <200901061713.n06HD5eB027121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbZAFRNr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 12:13:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Artem.Bityutskiy@nokia.com, npiggin@suse.de, randy.dunlap@oracle.com


The patch titled
     UBIFS: do not use WB_SYNC_HOLD
has been added to the -mm tree.  Its filename is
     ubifs-do-not-use-wb_sync_hold.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
ubifs-do-not-use-wb_sync_hold.patch
fs-remove-wb_sync_hold-fix.patch
reiser4-vfs-add-super_operationssync_inodes-2.patch


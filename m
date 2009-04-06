From: akpm@linux-foundation.org
Subject: [merged] xpc_sn2-fix-max-warning-about-pointers-of-different-types.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:37:47 -0700
Message-ID: <200904061937.n36JblMR013115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753264AbZDFUFs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:05:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     xpc_sn2: fix max() warning about pointers of different types
has been removed from the -mm tree.  Its filename was
     xpc_sn2-fix-max-warning-about-pointers-of-different-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xpc_sn2: fix max() warning about pointers of different types
From: Robin Holt <holt@sgi.com>

Fix a minor compile warning when building on ia64.

drivers/misc/sgi-xp/xpc_sn2.c: In function `xpc_clear_remote_msgqueue_flags_sn2':
drivers/misc/sgi-xp/xpc_sn2.c:1746: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_sn2.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc_sn2.c~xpc_sn2-fix-max-warning-about-pointers-of-different-types drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~xpc_sn2-fix-max-warning-about-pointers-of-different-types
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -1744,20 +1744,20 @@ xpc_clear_remote_msgqueue_flags_sn2(stru
 {
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
 	struct xpc_msg_sn2 *msg;
-	s64 put;
+	s64 put, remote_nentries = ch->remote_nentries;
 
 	/* flags are zeroed when the buffer is allocated */
-	if (ch_sn2->remote_GP.put < ch->remote_nentries)
+	if (ch_sn2->remote_GP.put < remote_nentries)
 		return;
 
-	put = max(ch_sn2->w_remote_GP.put, ch->remote_nentries);
+	put = max(ch_sn2->w_remote_GP.put, remote_nentries);
 	do {
 		msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->remote_msgqueue +
-					     (put % ch->remote_nentries) *
+					     (put % remote_nentries) *
 					     ch->entry_size);
 		DBUG_ON(!(msg->flags & XPC_M_SN2_READY));
 		DBUG_ON(!(msg->flags & XPC_M_SN2_DONE));
-		DBUG_ON(msg->number != put - ch->remote_nentries);
+		DBUG_ON(msg->number != put - remote_nentries);
 		msg->flags = 0;
 	} while (++put < ch_sn2->remote_GP.put);
 }
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch


From: akpm@linux-foundation.org
Subject: [nacked] reiser4-fixed-null-pointer-dereference.patch removed from -mm tree
Date: Wed, 03 Feb 2010 12:12:35 -0800
Message-ID: <201002032012.o13KCZdo016306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757837Ab0BCUM7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 15:12:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buchner.johannes@gmx.at, edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: fixed null pointer dereference
has been removed from the -mm tree.  Its filename was
     reiser4-fixed-null-pointer-dereference.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: fixed null pointer dereference
From: Johannes Buchner <buchner.johannes@gmx.at>

The parameter wbc=NULL caused a NULL pointer dereference in
reiser4_sync_inodes.  This issue was introduced in patch
reiser4-vfs-add-super_operationssync_inodes

Cc: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/super_ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiser4/super_ops.c~reiser4-fixed-null-pointer-dereference fs/reiser4/super_ops.c
--- a/fs/reiser4/super_ops.c~reiser4-fixed-null-pointer-dereference
+++ a/fs/reiser4/super_ops.c
@@ -395,7 +395,7 @@ static void reiser4_sync_inodes(struct s
 	reiser4_context *ctx;
 	long to_write;
 
-	if (wbc->for_kupdate)
+	if (wbc == NULL || wbc->for_kupdate)
 		/* reiser4 has its own means of periodical write-out */
 		return;
 
_

Patches currently in -mm which might be from buchner.johannes@gmx.at are

reiser4-some-changes-from-reiser4-2631-patch.patch
reiser4-some-comments-were-still-mentioning-pdflush.patch
reiser4-generic_sync_sb_inodes-doesnt-exist-anymore.patch
reiser4-fixed-null-pointer-dereference.patch


From: akpm@linux-foundation.org
Subject: + reiser4-fixed-null-pointer-dereference.patch added to -mm tree
Date: Tue, 01 Dec 2009 15:54:08 -0800
Message-ID: <200912012354.nB1Ns81O032448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754669AbZLAXyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 18:54:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: buchner.johannes@gmx.at, edward.shishkin@gmail.com


The patch titled
     reiser4: fixed null pointer dereference
has been added to the -mm tree.  Its filename is
     reiser4-fixed-null-pointer-dereference.patch

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


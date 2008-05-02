From: akpm@linux-foundation.org
Subject: - autofs4-check-for-invalid-dentry-in-getpath.patch removed from -mm tree
Date: Fri, 02 May 2008 12:43:10 -0700
Message-ID: <200805021943.m42JhAPw011265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932534AbYEBTtC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:49:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: check for invalid dentry in getpath
has been removed from the -mm tree.  Its filename was
     autofs4-check-for-invalid-dentry-in-getpath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: check for invalid dentry in getpath
From: Ian Kent <raven@themaw.net>

Catch invalid dentry when calculating its path.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/waitq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/autofs4/waitq.c~autofs4-check-for-invalid-dentry-in-getpath fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-check-for-invalid-dentry-in-getpath
+++ a/fs/autofs4/waitq.c
@@ -171,7 +171,7 @@ static int autofs4_getpath(struct autofs
 	for (tmp = dentry ; tmp != root ; tmp = tmp->d_parent)
 		len += tmp->d_name.len + 1;
 
-	if (--len > NAME_MAX) {
+	if (!len || --len > NAME_MAX) {
 		spin_unlock(&dcache_lock);
 		return 0;
 	}
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch


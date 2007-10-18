From: akpm@linux-foundation.org
Subject: - vfs-use-the-predefined-d_unhashed-inline-function-instead.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:01:08 -0700
Message-ID: <200710180701.l9I718i4031152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36860 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760398AbXJRHPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vfs: use the predefined d_unhashed inline function instead
has been removed from the -mm tree.  Its filename was
     vfs-use-the-predefined-d_unhashed-inline-function-instead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vfs: use the predefined d_unhashed inline function instead
From: Denis Cheng <crquan@gmail.com>

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dcache.c~vfs-use-the-predefined-d_unhashed-inline-function-instead fs/dcache.c
--- a/fs/dcache.c~vfs-use-the-predefined-d_unhashed-inline-function-instead
+++ a/fs/dcache.c
@@ -1542,7 +1542,7 @@ static void d_move_locked(struct dentry 
 	}
 
 	/* Move the dentry to the target hash queue, if on different bucket */
-	if (dentry->d_flags & DCACHE_UNHASHED)
+	if (d_unhashed(dentry))
 		goto already_unhashed;
 
 	hlist_del_rcu(&dentry->d_hash);
_

Patches currently in -mm which might be from crquan@gmail.com are

origin.patch

From: akpm@linux-foundation.org
Subject: - igrab-should-check-for-i_clear.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:50:58 -0800
Message-ID: <200702112250.l1BMowYJ015909@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60079 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750AbXBKWvL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:51:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, neilb@suse.de, vandana@novell.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     igrab() should check for I_CLEAR
has been removed from the -mm tree.  Its filename was
     igrab-should-check-for-i_clear.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: igrab() should check for I_CLEAR
From: Jan Blunck <jblunck@suse.de>

When igrab() is calling __iget() on an inode it should check if
clear_inode() has been called on the inode already.  Otherwise there is a
race window between clear_inode() and destroy_inode() where igrab() calls
__iget() which leads to already free inodes on the inode lists.

Signed-off-by: Vandana Rungta <vandana@novell.com>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/inode.c~igrab-should-check-for-i_clear fs/inode.c
--- a/fs/inode.c~igrab-should-check-for-i_clear
+++ a/fs/inode.c
@@ -709,7 +709,7 @@ EXPORT_SYMBOL(iunique);
 struct inode *igrab(struct inode *inode)
 {
 	spin_lock(&inode_lock);
-	if (!(inode->i_state & (I_FREEING|I_WILL_FREE)))
+	if (!(inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)))
 		__iget(inode);
 	else
 		/*
_

Patches currently in -mm which might be from jblunck@suse.de are

origin.patch

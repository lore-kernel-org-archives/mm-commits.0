From: akpm@osdl.org
Subject: + igrab-should-check-for-i_clear.patch added to -mm tree
Date: Tue, 19 Dec 2006 12:27:17 -0800
Message-ID: <200612192027.kBJKRHlt009390@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60448 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891AbWLSU10 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Dec 2006 15:27:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, neilb@suse.de, vandana@novell.com, viro@zeniv.linux.org.uk


The patch titled
     igrab() should check for I_CLEAR
has been added to the -mm tree.  Its filename is
     igrab-should-check-for-i_clear.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/inode.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

igrab-should-check-for-i_clear.patch


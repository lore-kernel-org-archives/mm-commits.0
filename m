From: akpm@linux-foundation.org
Subject: [merged] logfs-fix-kernel-bug-at-readwritec-1193.patch removed from -mm tree
Date: Thu, 23 Dec 2010 14:36:25 -0800
Message-ID: <201012232240.oBNMeDvd015431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751980Ab0LWWkh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Dec 2010 17:40:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prasadjoshi124@gmail.com, florian@mickler.org, joern@logfs.org, maciej.rutecki@gmail.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     logfs: fix "Kernel BUG at readwrite.c:1193"
has been removed from the -mm tree.  Its filename was
     logfs-fix-kernel-bug-at-readwritec-1193.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: logfs: fix "Kernel BUG at readwrite.c:1193"
From: Prasad Joshi <prasadjoshi124@gmail.com>

This happens when __logfs_create() tries to write a new inode to the disk
which is full.

__logfs_create() associates the transaction pointer with inode.  During
the logfs_write_inode() function call chain this transaction pointer is
moved from inode to page->private using function move_inode_to_page
(do_write_inode() -> inode_to_page() -> move_inode_to_page)

When the write inode fails, the transaction is aborted and iput is called
on the failed inode.  During delete_inode the same transaction pointer
associated with the page is getting used.  Thus causing kernel BUG.

The patch checks for error in write_inode() and restores the page->private
to NULL.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=20162

Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
Cc: Joern Engel <joern@logfs.org>
Cc: Florian Mickler <florian@mickler.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/logfs/readwrite.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/logfs/readwrite.c~logfs-fix-kernel-bug-at-readwritec-1193 fs/logfs/readwrite.c
--- a/fs/logfs/readwrite.c~logfs-fix-kernel-bug-at-readwritec-1193
+++ a/fs/logfs/readwrite.c
@@ -1994,6 +1994,9 @@ static int do_write_inode(struct inode *
 
 	/* FIXME: transaction is part of logfs_block now.  Is that enough? */
 	err = logfs_write_buf(master_inode, page, 0);
+	if (err)
+		move_page_to_inode(inode, page);
+
 	logfs_put_write_page(page);
 	return err;
 }
_

Patches currently in -mm which might be from prasadjoshi124@gmail.com are

origin.patch


From: akpm@linux-foundation.org
Subject: [merged] fs-make-struct-dentry-d_op-const.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:07:04 -0700
Message-ID: <200903301907.n2UJ74no019268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759356AbZC3TKA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:10:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@medozas.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs: make struct dentry->d_op const
has been removed from the -mm tree.  Its filename was
     fs-make-struct-dentry-d_op-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: make struct dentry->d_op const
From: Jan Engelhardt <jengelh@medozas.de>

This change will allow for tagging many dentry_operations const in the
source tree.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dcache.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/dcache.h~fs-make-struct-dentry-d_op-const include/linux/dcache.h
--- a/include/linux/dcache.h~fs-make-struct-dentry-d_op-const
+++ a/include/linux/dcache.h
@@ -112,7 +112,7 @@ struct dentry {
 	struct list_head d_subdirs;	/* our children */
 	struct list_head d_alias;	/* inode alias list */
 	unsigned long d_time;		/* used by d_revalidate */
-	struct dentry_operations *d_op;
+	const struct dentry_operations *d_op;
 	struct super_block *d_sb;	/* The root of the dentry tree */
 	void *d_fsdata;			/* fs-specific data */
 
_

Patches currently in -mm which might be from jengelh@medozas.de are

origin.patch
linux-next.patch


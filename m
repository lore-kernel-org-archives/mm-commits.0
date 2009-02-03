From: akpm@linux-foundation.org
Subject: + fs-make-struct-dentry-d_op-const.patch added to -mm tree
Date: Mon, 02 Feb 2009 23:40:44 -0800
Message-ID: <200902030740.n137eirl011752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbZBCHkw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 02:40:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@medozas.de, viro@zeniv.linux.org.uk


The patch titled
     fs: make struct dentry->d_op const
has been added to the -mm tree.  Its filename is
     fs-make-struct-dentry-d_op-const.patch

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
fs-make-struct-dentry-d_op-const.patch


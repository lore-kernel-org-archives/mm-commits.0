From: akpm@linux-foundation.org
Subject: - ext2-fix-a-comment-when-ext2_release_file-is-called.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:09 -0700
Message-ID: <200707162055.l6GKt9mE001888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59860 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756573AbXGPVLq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:11:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     ext2: fix a comment when ext2_release_file() is called
has been removed from the -mm tree.  Its filename was
     ext2-fix-a-comment-when-ext2_release_file-is-called.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext2: fix a comment when ext2_release_file() is called
From: Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/file.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ext2/file.c~ext2-fix-a-comment-when-ext2_release_file-is-called fs/ext2/file.c
--- a/fs/ext2/file.c~ext2-fix-a-comment-when-ext2_release_file-is-called
+++ a/fs/ext2/file.c
@@ -24,9 +24,9 @@
 #include "acl.h"
 
 /*
- * Called when an inode is released. Note that this is different
- * from ext2_open_file: open gets called at every open, but release
- * gets called only when /all/ the files are closed.
+ * Called when filp is released. This happens when all file descriptors
+ * for a single struct file are closed. Note that different open() calls
+ * for the same file yield different struct file structures.
  */
 static int ext2_release_file (struct inode * inode, struct file * filp)
 {
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch

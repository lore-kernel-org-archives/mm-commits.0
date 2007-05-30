From: akpm@linux-foundation.org
Subject: + ext2-fix-a-comment-when-ext2_release_file-is-called.patch added to -mm tree
Date: Tue, 29 May 2007 20:07:42 -0700
Message-ID: <200705300307.l4U37fRw018102@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbXE3DHw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 23:07:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, tytso@mit.edu


The patch titled
     ext2: fix a comment when ext2_release_file() is called
has been added to the -mm tree.  Its filename is
     ext2-fix-a-comment-when-ext2_release_file-is-called.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fix-possible-udf-data-corruption.patch
fix-possible-leakage-of-blocks-in-udf.patch
fix-possible-leakage-of-blocks-in-udf-tidy.patch
ext2-fix-a-comment-when-ext2_release_file-is-called.patch

From: akpm@linux-foundation.org
Subject: - ext3-fix-ext3_dx_readdir-hash-collision-handling.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:36:01 -0700
Message-ID: <200810202036.m9KKa1RL011274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753746AbYJTUgx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:36:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eugene@ibrix.com, msnitzer@ibrix.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     ext3: fix ext3_dx_readdir hash collision handling
has been removed from the -mm tree.  Its filename was
     ext3-fix-ext3_dx_readdir-hash-collision-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: fix ext3_dx_readdir hash collision handling
From: Eugene Dashevsky <eugene@ibrix.com>

This fixes a bug where readdir() would return a directory entry twice
if there was a hash collision in an hash tree indexed directory.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Eugene Dashevsky <eugene@ibrix.com>
Signed-off-by: Mike Snitzer <msnitzer@ibrix.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/dir.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN fs/ext3/dir.c~ext3-fix-ext3_dx_readdir-hash-collision-handling fs/ext3/dir.c
--- a/fs/ext3/dir.c~ext3-fix-ext3_dx_readdir-hash-collision-handling
+++ a/fs/ext3/dir.c
@@ -410,7 +410,7 @@ static int call_filldir(struct file * fi
 				get_dtype(sb, fname->file_type));
 		if (error) {
 			filp->f_pos = curr_pos;
-			info->extra_fname = fname->next;
+			info->extra_fname = fname;
 			return error;
 		}
 		fname = fname->next;
@@ -449,11 +449,21 @@ static int ext3_dx_readdir(struct file *
 	 * If there are any leftover names on the hash collision
 	 * chain, return them first.
 	 */
-	if (info->extra_fname &&
-	    call_filldir(filp, dirent, filldir, info->extra_fname))
-		goto finished;
+	if (info->extra_fname) {
+		if (call_filldir(filp, dirent, filldir, info->extra_fname))
+			goto finished;
 
-	if (!info->curr_node)
+		info->extra_fname = NULL;
+		info->curr_node = rb_next(info->curr_node);
+		if (!info->curr_node) {
+			if (info->next_hash == ~0) {
+				filp->f_pos = EXT3_HTREE_EOF;
+				goto finished;
+			}
+			info->curr_hash = info->next_hash;
+			info->curr_minor_hash = 0;
+		}
+	} else if (!info->curr_node)
 		info->curr_node = rb_first(&info->root);
 
 	while (1) {
_

Patches currently in -mm which might be from eugene@ibrix.com are

origin.patch


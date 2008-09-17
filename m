From: akpm@linux-foundation.org
Subject: + ext3-fix-ext3_dx_readdir-hash-collision-handling.patch added to -mm tree
Date: Wed, 17 Sep 2008 12:27:58 -0700
Message-ID: <200809171927.m8HJRwbk026705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752411AbYIQT2X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 15:28:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eugene@ibrix.com, msnitzer@ibrix.com, tytso@mit.edu


The patch titled
     ext3: fix ext3_dx_readdir hash collision handling
has been added to the -mm tree.  Its filename is
     ext3-fix-ext3_dx_readdir-hash-collision-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: fix ext3_dx_readdir hash collision handling

Cc: Eugene Dashevsky <eugene@ibrix.com>

This fixes a bug where readdir() would return a directory entry twice
if there was a hash collision in an hash tree indexed directory.

Signed-off-by: Eugene Dashevsky <eugene@ibrix.com>
Signed-off-by: Mike Snitzer <msnitzer@ibrix.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/dir.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

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
-
-	if (!info->curr_node)
+	if (info->extra_fname) {
+                if (call_filldir(filp, dirent, filldir, info->extra_fname))
+                        goto finished;
+
+                info->extra_fname = NULL;
+                info->curr_node = rb_next(info->curr_node);
+                if (!info->curr_node) {
+                        if (info->next_hash == ~0) {
+                                filp->f_pos = EXT3_HTREE_EOF;
+                                goto finished;
+                        }
+                        info->curr_hash = info->next_hash;
+                        info->curr_minor_hash = 0;
+                }
+        } else if (!info->curr_node)
 		info->curr_node = rb_first(&info->root);
 
 	while (1) {
_

Patches currently in -mm which might be from eugene@ibrix.com are

ext3-fix-ext3_dx_readdir-hash-collision-handling.patch


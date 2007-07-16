From: akpm@linux-foundation.org
Subject: - only-send-sigxfsz-when-exceeding-rlimits.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:25 -0700
Message-ID: <200707162054.l6GKsPdB001799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55393 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762090AbXGPVfy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:35:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: micah@cowan.name, alan@redhat.com, micahcowan@ubuntu.com, reiserfs-dev@namesys.com, mm-commits@vger.kernel.org


The patch titled
     Only send SIGXFSZ when exceeding rlimits.
has been removed from the -mm tree.  Its filename was
     only-send-sigxfsz-when-exceeding-rlimits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Only send SIGXFSZ when exceeding rlimits.
From: Micah Cowan <micah@cowan.name>

Some users have been having problems with utilities like cp or dd dumping
core when they try to copy a file that's too large for the destination
filesystem (typically, > 4gb).  Apparently, some defunct standards required
SIGXFSZ to be sent in such circumstances, but SUS only requires/allows it
for when a written file exceeds the process's resource limits.  I'd like to
limit SIGXFSZs to the bare minimum required by SUS.

Patch sent per http://lkml.org/lkml/2007/4/10/302

Signed-off-by: Micah Cowan <micahcowan@ubuntu.com>
Acked-by: Alan Cox <alan@redhat.com>
Cc: <reiserfs-dev@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/file.c    |    2 --
 fs/reiserfs/file.c |    1 -
 mm/filemap.c       |    2 --
 3 files changed, 5 deletions(-)

diff -puN fs/ncpfs/file.c~only-send-sigxfsz-when-exceeding-rlimits fs/ncpfs/file.c
--- a/fs/ncpfs/file.c~only-send-sigxfsz-when-exceeding-rlimits
+++ a/fs/ncpfs/file.c
@@ -203,7 +203,6 @@ ncp_file_write(struct file *file, const 
 
 	if (pos + count > MAX_NON_LFS && !(file->f_flags&O_LARGEFILE)) {
 		if (pos >= MAX_NON_LFS) {
-			send_sig(SIGXFSZ, current, 0);
 			return -EFBIG;
 		}
 		if (count > MAX_NON_LFS - (u32)pos) {
@@ -212,7 +211,6 @@ ncp_file_write(struct file *file, const 
 	}
 	if (pos >= inode->i_sb->s_maxbytes) {
 		if (count || pos > inode->i_sb->s_maxbytes) {
-			send_sig(SIGXFSZ, current, 0);
 			return -EFBIG;
 		}
 	}
diff -puN fs/reiserfs/file.c~only-send-sigxfsz-when-exceeding-rlimits fs/reiserfs/file.c
--- a/fs/reiserfs/file.c~only-send-sigxfsz-when-exceeding-rlimits
+++ a/fs/reiserfs/file.c
@@ -1305,7 +1305,6 @@ static ssize_t reiserfs_file_write(struc
 	if (get_inode_item_key_version (inode) == KEY_FORMAT_3_5 &&
 	    *ppos + count > MAX_NON_LFS) {
 		if (*ppos >= MAX_NON_LFS) {
-			send_sig(SIGXFSZ, current, 0);
 			return -EFBIG;
 		}
 		if (count > MAX_NON_LFS - (unsigned long)*ppos)
diff -puN mm/filemap.c~only-send-sigxfsz-when-exceeding-rlimits mm/filemap.c
--- a/mm/filemap.c~only-send-sigxfsz-when-exceeding-rlimits
+++ a/mm/filemap.c
@@ -1967,7 +1967,6 @@ inline int generic_write_checks(struct f
 	if (unlikely(*pos + *count > MAX_NON_LFS &&
 				!(file->f_flags & O_LARGEFILE))) {
 		if (*pos >= MAX_NON_LFS) {
-			send_sig(SIGXFSZ, current, 0);
 			return -EFBIG;
 		}
 		if (*count > MAX_NON_LFS - (unsigned long)*pos) {
@@ -1985,7 +1984,6 @@ inline int generic_write_checks(struct f
 	if (likely(!isblk)) {
 		if (unlikely(*pos >= inode->i_sb->s_maxbytes)) {
 			if (*count || *pos > inode->i_sb->s_maxbytes) {
-				send_sig(SIGXFSZ, current, 0);
 				return -EFBIG;
 			}
 			/* zero-length writes at ->s_maxbytes are OK */
_

Patches currently in -mm which might be from micah@cowan.name are

origin.patch

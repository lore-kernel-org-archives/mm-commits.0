From: akpm@linux-foundation.org
Subject: + sendfile-check-f_opsplice_write-rather-than-f_opsendpage.patch added to -mm tree
Date: Mon, 02 Nov 2009 23:48:36 -0800
Message-ID: <200911030748.nA37maIH032725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756282AbZKCHsi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 02:48:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaosuo@gmail.com, jens.axboe@oracle.com


The patch titled
     sendfile(): check f_op.splice_write() rather than f_op.sendpage()
has been added to the -mm tree.  Its filename is
     sendfile-check-f_opsplice_write-rather-than-f_opsendpage.patch

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
Subject: sendfile(): check f_op.splice_write() rather than f_op.sendpage()
From: Changli Gao <xiaosuo@gmail.com>

sendfile(2) was reworked with the splice infrastructure, but it still
checks f_op.sendpage() instead of f_op.splice_write() wrongly.  Although
if f_op.sendpage() exists, f_op.splice_write() always exists at the same
time currently, the assumption will be broken in future silently.  This
patch also brings a side effect: sendfile(2) can work with any output
file.  Some security checks related to f_op are added too.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c |    2 --
 fs/splice.c     |   24 +++++++++++++++---------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff -puN fs/read_write.c~sendfile-check-f_opsplice_write-rather-than-f_opsendpage fs/read_write.c
--- a/fs/read_write.c~sendfile-check-f_opsplice_write-rather-than-f_opsendpage
+++ a/fs/read_write.c
@@ -826,8 +826,6 @@ static ssize_t do_sendfile(int out_fd, i
 	if (!(out_file->f_mode & FMODE_WRITE))
 		goto fput_out;
 	retval = -EINVAL;
-	if (!out_file->f_op || !out_file->f_op->sendpage)
-		goto fput_out;
 	in_inode = in_file->f_path.dentry->d_inode;
 	out_inode = out_file->f_path.dentry->d_inode;
 	retval = rw_verify_area(WRITE, out_file, &out_file->f_pos, count);
diff -puN fs/splice.c~sendfile-check-f_opsplice_write-rather-than-f_opsendpage fs/splice.c
--- a/fs/splice.c~sendfile-check-f_opsplice_write-rather-than-f_opsendpage
+++ a/fs/splice.c
@@ -648,9 +648,11 @@ static int pipe_to_sendpage(struct pipe_
 	ret = buf->ops->confirm(pipe, buf);
 	if (!ret) {
 		more = (sd->flags & SPLICE_F_MORE) || sd->len < sd->total_len;
-
-		ret = file->f_op->sendpage(file, buf->page, buf->offset,
-					   sd->len, &pos, more);
+		if (file->f_op && file->f_op->sendpage)
+			ret = file->f_op->sendpage(file, buf->page, buf->offset,
+						   sd->len, &pos, more);
+		else
+			ret = -EINVAL;
 	}
 
 	return ret;
@@ -1068,8 +1070,9 @@ static long do_splice_from(struct pipe_i
 	if (unlikely(ret < 0))
 		return ret;
 
-	splice_write = out->f_op->splice_write;
-	if (!splice_write)
+	if (out->f_op && out->f_op->splice_write)
+		splice_write = out->f_op->splice_write;
+	else
 		splice_write = default_file_splice_write;
 
 	return splice_write(pipe, out, ppos, len, flags);
@@ -1093,8 +1096,9 @@ static long do_splice_to(struct file *in
 	if (unlikely(ret < 0))
 		return ret;
 
-	splice_read = in->f_op->splice_read;
-	if (!splice_read)
+	if (in->f_op && in->f_op->splice_read)
+		splice_read = in->f_op->splice_read;
+	else
 		splice_read = default_file_splice_read;
 
 	return splice_read(in, ppos, pipe, len, flags);
@@ -1316,7 +1320,8 @@ static long do_splice(struct file *in, l
 		if (off_in)
 			return -ESPIPE;
 		if (off_out) {
-			if (out->f_op->llseek == no_llseek)
+			if (!out->f_op || !out->f_op->llseek ||
+			    out->f_op->llseek == no_llseek)
 				return -EINVAL;
 			if (copy_from_user(&offset, off_out, sizeof(loff_t)))
 				return -EFAULT;
@@ -1336,7 +1341,8 @@ static long do_splice(struct file *in, l
 		if (off_out)
 			return -ESPIPE;
 		if (off_in) {
-			if (in->f_op->llseek == no_llseek)
+			if (!in->f_op || !in->f_op->llseek ||
+			    in->f_op->llseek == no_llseek)
 				return -EINVAL;
 			if (copy_from_user(&offset, off_in, sizeof(loff_t)))
 				return -EFAULT;
_

Patches currently in -mm which might be from xiaosuo@gmail.com are

sendfile-check-f_opsplice_write-rather-than-f_opsendpage.patch


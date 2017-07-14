From: akpm@linux-foundation.org
Subject: [to-be-updated]
 sendfile-do-not-update-file-offset-of-non-lseekable-objects.patch removed
 from -mm tree
Date: Fri, 14 Jul 2017 14:03:26 -0700
Message-ID: <5969319e.iIQo6IroCjUvHlBU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43162 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbdGNVD1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2017 17:03:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: sendfile: do not update file offset of non-lseek()able objects.
has been removed from the -mm tree.  Its filename was
     sendfile-do-not-update-file-offset-of-non-lseekable-objects.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: sendfile: do not update file offset of non-lseek()able objects.

I tried to sendfile() a file which is larger than 4GB to a pipe (which is
the stdout of Apache's CGI program), and noticed that sendfile() fails
with EFBIG after 2GB is copied to stdout pipe.  This is because sendfile()
is updating file offset of the file descriptor of the pipe.

sendfile() should not update file offset if the file descriptor refers to
an non-lseek()able object.

Link: http://lkml.kernel.org/r/1497262469-7536-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/read_write.c~sendfile-do-not-update-file-offset-of-non-lseekable-objects fs/read_write.c
--- a/fs/read_write.c~sendfile-do-not-update-file-offset-of-non-lseekable-objects
+++ a/fs/read_write.c
@@ -1417,7 +1417,8 @@ static ssize_t do_sendfile(int out_fd, i
 		add_wchar(current, retval);
 		fsnotify_access(in.file);
 		fsnotify_modify(out.file);
-		out.file->f_pos = out_pos;
+		if (out.file->f_op->llseek != no_llseek)
+			out.file->f_pos = out_pos;
 		if (ppos)
 			*ppos = pos;
 		else
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are



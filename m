From: akpm@linux-foundation.org
Subject: + pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch added to -mm tree
Date: Mon, 26 Jan 2009 19:39:07 -0800
Message-ID: <200901270339.n0R3d709006546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331AbZA0Dji (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 22:39:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, andi@firstfloor.org, corbet@lwn.net, stable@kernel.org, viro@ZenIV.linux.org.uk


The patch titled
     pipe_rdwr_fasync: fix the error handling to prevent the leak/crash
has been added to the -mm tree.  Its filename is
     pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch

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
Subject: pipe_rdwr_fasync: fix the error handling to prevent the leak/crash
From: Oleg Nesterov <oleg@redhat.com>

If the second fasync_helper() fails, pipe_rdwr_fasync() returns the error
but leaves the file on ->fasync_readers.

This was always wrong, but since 233e70f4228e78eb2f80dc6650f65d3ae3dbf17c
"saner FASYNC handling on file close" we have the new problem.  Because in
this case setfl() doesn't set FASYNC bit, __fput() will not do
->fasync(0), and we leak fasync_struct with ->fa_file pointing to the
freed file.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: <stable@kernel.org>		[2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/pipe.c~pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash fs/pipe.c
--- a/fs/pipe.c~pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash
+++ a/fs/pipe.c
@@ -699,12 +699,13 @@ pipe_rdwr_fasync(int fd, struct file *fi
 	int retval;
 
 	mutex_lock(&inode->i_mutex);
-
 	retval = fasync_helper(fd, filp, on, &pipe->fasync_readers);
 
-	if (retval >= 0)
+	if (retval >= 0) {
 		retval = fasync_helper(fd, filp, on, &pipe->fasync_writers);

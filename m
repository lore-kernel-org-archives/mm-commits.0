From: akpm@linux-foundation.org
Subject: + vfs-remove-redundant-checks-in-do_sendfile.patch added to -mm tree
Date: Mon, 17 Aug 2009 16:04:48 -0700
Message-ID: <200908172304.n7HN4muw007274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752497AbZHQXFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 19:05:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, hannes@cmpxchg.org, hch@lst.de, msb@google.com, rlove@google.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: remove redundant checks in do_sendfile
has been added to the -mm tree.  Its filename is
     vfs-remove-redundant-checks-in-do_sendfile.patch

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
Subject: vfs: remove redundant checks in do_sendfile
From: Jeff Layton <jlayton@redhat.com>

As Johannes Weiner pointed out, a couple of the range checks in
do_sendfile are redundant and are already checked in rw_verify_area.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Robert Love <rlove@google.com>
Cc: Mandeep Singh Baines <msb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN fs/read_write.c~vfs-remove-redundant-checks-in-do_sendfile fs/read_write.c
--- a/fs/read_write.c~vfs-remove-redundant-checks-in-do_sendfile
+++ a/fs/read_write.c
@@ -792,7 +792,6 @@ static ssize_t do_sendfile(int out_fd, i
 {
 	struct file * in_file, * out_file;
 	struct inode * in_inode, * out_inode;
-	loff_t pos;
 	ssize_t retval;
 	int fput_needed_in, fput_needed_out, fl;
 
@@ -838,17 +837,7 @@ static ssize_t do_sendfile(int out_fd, i
 	if (!max)
 		max = min(in_inode->i_sb->s_maxbytes, out_inode->i_sb->s_maxbytes);
 
-	pos = *ppos;
 	retval = -EINVAL;
-	if (unlikely(pos < 0))
-		goto fput_out;
-	if (unlikely(pos + count > max)) {
-		retval = -EOVERFLOW;
-		if (pos >= max)
-			goto fput_out;
-		count = max - pos;
-	}

From: akpm@linux-foundation.org
Subject: [to-be-updated] vfs-remove-redundant-checks-in-do_sendfile.patch removed from -mm tree
Date: Tue, 18 Aug 2009 02:34:03 -0700
Message-ID: <200908180934.n7I9Y3v3030716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757429AbZHRJgB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Aug 2009 05:36:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, hannes@cmpxchg.org, hch@lst.de, msb@google.com, rlove@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: remove redundant checks in do_sendfile
has been removed from the -mm tree.  Its filename was
     vfs-remove-redundant-checks-in-do_sendfile.patch

This patch was dropped because an updated version will be merged

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

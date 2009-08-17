From: akpm@linux-foundation.org
Subject: [to-be-updated] vfs-remove-redundant-position-check-in-do_sendfile.patch removed from -mm tree
Date: Mon, 17 Aug 2009 16:04:51 -0700
Message-ID: <200908172304.n7HN4p3J007280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbZHQXFp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 19:05:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, hannes@cmpxchg.org, hch@lst.de, msb@google.com, rlove@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: remove redundant position check in do_sendfile
has been removed from the -mm tree.  Its filename was
     vfs-remove-redundant-position-check-in-do_sendfile.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: remove redundant position check in do_sendfile
From: Jeff Layton <jlayton@redhat.com>

As Johannes Weiner pointed out, one of the range checks in do_sendfile
is redundant and is already checked in rw_verify_area.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Robert Love <rlove@google.com>
Cc: Mandeep Singh Baines <msb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/read_write.c~vfs-remove-redundant-position-check-in-do_sendfile fs/read_write.c
--- a/fs/read_write.c~vfs-remove-redundant-position-check-in-do_sendfile
+++ a/fs/read_write.c
@@ -839,9 +839,6 @@ static ssize_t do_sendfile(int out_fd, i
 		max = min(in_inode->i_sb->s_maxbytes, out_inode->i_sb->s_maxbytes);
 
 	pos = *ppos;
-	retval = -EINVAL;
-	if (unlikely(pos < 0))
-		goto fput_out;
 	if (unlikely(pos + count > max)) {
 		retval = -EOVERFLOW;
 		if (pos >= max)
_

Patches currently in -mm which might be from jlayton@redhat.com are

vfs-make-get_sb_pseudo-set-s_maxbytes-to-value-that-can-be-cast-to-signed.patch
vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
vfs-remove-redundant-checks-in-do_sendfile.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch


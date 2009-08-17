From: akpm@linux-foundation.org
Subject: [merged] splice-update-mtime-and-atime-on-files.patch removed from -mm tree
Date: Mon, 17 Aug 2009 13:04:57 -0700
Message-ID: <200908172004.n7HK4vEO017577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757726AbZHQUGF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 16:06:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     splice: update mtime and atime on files
has been removed from the -mm tree.  Its filename was
     splice-update-mtime-and-atime-on-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: splice: update mtime and atime on files
From: Miklos Szeredi <mszeredi@suse.cz>

Splice should update the modification and access times on regular files
just like read and write.  Not updating mtime will confuse backup tools,
etc...

This patch only adds the time updates for regular files.  For pipes and
other special files that splice touches the need for updating the times is
less clear.  Let's discuss and fix that separately.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/splice.c~splice-update-mtime-and-atime-on-files fs/splice.c
--- a/fs/splice.c~splice-update-mtime-and-atime-on-files
+++ a/fs/splice.c
@@ -502,8 +502,10 @@ ssize_t generic_file_splice_read(struct 
 		len = left;
 
 	ret = __generic_file_splice_read(in, ppos, pipe, len, flags);
-	if (ret > 0)
+	if (ret > 0) {
 		*ppos += ret;
+		file_accessed(in);
+	}
 
 	return ret;
 }
@@ -963,8 +965,10 @@ generic_file_splice_write(struct pipe_in
 
 		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
 		ret = file_remove_suid(out);
-		if (!ret)
+		if (!ret) {
+			file_update_time(out);
 			ret = splice_from_pipe_feed(pipe, &sd, pipe_to_file);
+		}
 		mutex_unlock(&inode->i_mutex);
 	} while (ret > 0);
 	splice_from_pipe_end(pipe, &sd);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch


From: akpm@linux-foundation.org
Subject: [merged] fs-pipec-skip-file_update_time-on-frozen-fs.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:03:06 -0800
Message-ID: <52e2b8ea.//R7IuI2irdljPqz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbaAXTDG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:03:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, dmonakhov@openvz.org

Subject: [merged] fs-pipec-skip-file_update_time-on-frozen-fs.patch removed from -mm tree
To: dmonakhov@openvz.org,jack@suse.cz,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:03:06 -0800


The patch titled
     Subject: fs/pipe.c: skip file_update_time on frozen fs
has been removed from the -mm tree.  Its filename was
     fs-pipec-skip-file_update_time-on-frozen-fs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: fs/pipe.c: skip file_update_time on frozen fs

Pipe has no data associated with fs so it is not good idea to block
pipe_write() if FS is frozen, but we can not update file's time on such
filesystem.  Let's use same idea as we use in touch_time().

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=65701

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/pipe.c~fs-pipec-skip-file_update_time-on-frozen-fs fs/pipe.c
--- a/fs/pipe.c~fs-pipec-skip-file_update_time-on-frozen-fs
+++ a/fs/pipe.c
@@ -663,10 +663,11 @@ out:
 		wake_up_interruptible_sync_poll(&pipe->wait, POLLIN | POLLRDNORM);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 	}
-	if (ret > 0) {
+	if (ret > 0 && sb_start_write_trylock(file_inode(filp)->i_sb)) {
 		int err = file_update_time(filp);
 		if (err)
 			ret = err;
+		sb_end_write(file_inode(filp)->i_sb);
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

origin.patch


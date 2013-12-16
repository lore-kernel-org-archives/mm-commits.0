From: akpm@linux-foundation.org
Subject: + fs-pipec-skip-file_update_time-on-frozen-fs.patch added to -mm
 tree
Date: Mon, 16 Dec 2013 11:55:56 -0800
Message-ID: <52af5acc.jyF05oPJBl82vDLF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3LPT4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 14:56:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, dmonakhov@openvz.org

Subject: + fs-pipec-skip-file_update_time-on-frozen-fs.patch added to -mm tree
To: dmonakhov@openvz.org,jack@suse.cz,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 11:55:56 -0800


The patch titled
     Subject: fs/pipe.c: skip file_update_time on frozen fs
has been added to the -mm tree.  Its filename is
     fs-pipec-skip-file_update_time-on-frozen-fs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-pipec-skip-file_update_time-on-frozen-fs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-pipec-skip-file_update_time-on-frozen-fs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-pipec-skip-file_update_time-on-frozen-fs.patch
linux-next.patch


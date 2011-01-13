From: akpm@linux-foundation.org
Subject: [merged] pipe-use-event-aware-wakeups.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:08:11 -0800
Message-ID: <201101132010.p0DKAqag030100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933611Ab1AMUYT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:24:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, axboe@kernel.dk, davem@davemloft.net, eric.dumazet@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pipe: use event aware wakeups
has been removed from the -mm tree.  Its filename was
     pipe-use-event-aware-wakeups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pipe: use event aware wakeups
From: Davide Libenzi <davidel@xmailserver.org>

Send the events the wakeup refers to, so that epoll, and even the new poll
code in fs/select.c can avoid wakeups if the events do not match the
requested set.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/pipe.c~pipe-use-event-aware-wakeups fs/pipe.c
--- a/fs/pipe.c~pipe-use-event-aware-wakeups
+++ a/fs/pipe.c
@@ -441,7 +441,7 @@ redo:
 			break;
 		}
 		if (do_wakeup) {
-			wake_up_interruptible_sync(&pipe->wait);
+			wake_up_interruptible_sync_poll(&pipe->wait, POLLOUT);
  			kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 		}
 		pipe_wait(pipe);
@@ -450,7 +450,7 @@ redo:
 
 	/* Signal writers asynchronously that there is more room. */
 	if (do_wakeup) {
-		wake_up_interruptible_sync(&pipe->wait);
+		wake_up_interruptible_sync_poll(&pipe->wait, POLLOUT);
 		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 	}
 	if (ret > 0)
@@ -612,7 +612,7 @@ redo2:
 			break;
 		}
 		if (do_wakeup) {
-			wake_up_interruptible_sync(&pipe->wait);
+			wake_up_interruptible_sync_poll(&pipe->wait, POLLIN);
 			kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 			do_wakeup = 0;
 		}
@@ -623,7 +623,7 @@ redo2:
 out:
 	mutex_unlock(&inode->i_mutex);
 	if (do_wakeup) {
-		wake_up_interruptible_sync(&pipe->wait);
+		wake_up_interruptible_sync_poll(&pipe->wait, POLLIN);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 	}
 	if (ret > 0)
@@ -715,7 +715,7 @@ pipe_release(struct inode *inode, int de
 	if (!pipe->readers && !pipe->writers) {
 		free_pipe_info(inode);
 	} else {
-		wake_up_interruptible_sync(&pipe->wait);
+		wake_up_interruptible_sync_poll(&pipe->wait, POLLIN | POLLOUT);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 	}
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch


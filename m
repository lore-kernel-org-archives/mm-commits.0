From: akpm@linux-foundation.org
Subject: + epoll-send-pollhup-on-release.patch added to -mm tree
Date: Wed, 03 Jun 2009 14:44:28 -0700
Message-ID: <200906032144.n53LiS2u016383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753779AbZFCVo2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 17:44:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, ghaskins@novell.com


The patch titled
     epoll: send POLLHUP on ->release
has been added to the -mm tree.  Its filename is
     epoll-send-pollhup-on-release.patch

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
Subject: epoll: send POLLHUP on ->release
From: Davide Libenzi <davidel@xmailserver.org>

Allow waiters to be notified about the eventfd file* going away, and give
them a change to unregister from the wait queue.  This is turn allows
eventfd users to use the eventfd file* w/out holding a live reference to
it.

After the eventfd user callbacks returns, any usage of the eventfd file*
should be dropped.  The eventfd user callback can acquire sleepy locks
since it is invoked lockless.

This is a feature, needed by KVM to avoid an awkward workaround when using
eventdf.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Tested-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventfd.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN fs/eventfd.c~epoll-send-pollhup-on-release fs/eventfd.c
--- a/fs/eventfd.c~epoll-send-pollhup-on-release
+++ a/fs/eventfd.c
@@ -61,7 +61,15 @@ EXPORT_SYMBOL_GPL(eventfd_signal);
 
 static int eventfd_release(struct inode *inode, struct file *file)
 {
-	kfree(file->private_data);
+	struct eventfd_ctx *ctx = file->private_data;
+
+	/*
+	 * No need to hold the lock here, since we are on the file cleanup
+	 * path and the ones still attached to the wait queue will be
+	 * serialized by wake_up_locked_poll().
+	 */
+	wake_up_locked_poll(&ctx->wqh, POLLHUP);
+	kfree(ctx);
 	return 0;
 }
 
_

Patches currently in -mm which might be from davidel@xmailserver.org are

epoll-send-pollhup-on-release.patch
linux-next.patch
poll-avoid-extra-wakeups-in-select-poll.patch


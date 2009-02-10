From: akpm@linux-foundation.org
Subject: + timerfd-add-flags-check.patch added to -mm tree
Date: Tue, 10 Feb 2009 14:37:32 -0800
Message-ID: <200902102237.n1AMbWEj010498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750823AbZBJWiB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 17:38:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, mtk.manpages@gmail.com, stable@kernel.org


The patch titled
     timerfd: add flags check
has been added to the -mm tree.  Its filename is
     timerfd-add-flags-check.patch

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
Subject: timerfd: add flags check
From: Davide Libenzi <davidel@xmailserver.org>

As requested by Michael, add a missing check for valid flags in
timerfd_settime(), and make it return EINVAL in case some extra bits are
set.

Michael said:
If this is to be any use to userland apps that want to check flag
support (perhaps it is too late already), then the sooner we get it
into the kernel the better: 2.6.29 would be good; earlier stables as
well would be even better.

Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: <stable@kernel.org>		[2.6.27.x, 2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/timerfd.c            |   12 ++++++------
 include/linux/timerfd.h |   17 ++++++++++++++---
 2 files changed, 20 insertions(+), 9 deletions(-)

diff -puN fs/timerfd.c~timerfd-add-flags-check fs/timerfd.c
--- a/fs/timerfd.c~timerfd-add-flags-check
+++ a/fs/timerfd.c
@@ -186,10 +186,9 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
 	BUILD_BUG_ON(TFD_CLOEXEC != O_CLOEXEC);
 	BUILD_BUG_ON(TFD_NONBLOCK != O_NONBLOCK);
 
-	if (flags & ~(TFD_CLOEXEC | TFD_NONBLOCK))
-		return -EINVAL;
-	if (clockid != CLOCK_MONOTONIC &&
-	    clockid != CLOCK_REALTIME)
+	if ((flags & ~TFD_CREATE_FLAGS) ||
+	    (clockid != CLOCK_MONOTONIC &&
+	     clockid != CLOCK_REALTIME))
 		return -EINVAL;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
@@ -201,7 +200,7 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
 	hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
 
 	ufd = anon_inode_getfd("[timerfd]", &timerfd_fops, ctx,
-			       flags & (O_CLOEXEC | O_NONBLOCK));
+			       flags & TFD_SHARED_FCNTL_FLAGS);
 	if (ufd < 0)
 		kfree(ctx);
 
@@ -219,7 +218,8 @@ SYSCALL_DEFINE4(timerfd_settime, int, uf
 	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
 		return -EFAULT;
 
-	if (!timespec_valid(&ktmr.it_value) ||
+	if ((flags & ~TFD_SETTIME_FLAGS) ||
+	    !timespec_valid(&ktmr.it_value) ||
 	    !timespec_valid(&ktmr.it_interval))
 		return -EINVAL;
 
diff -puN include/linux/timerfd.h~timerfd-add-flags-check include/linux/timerfd.h
--- a/include/linux/timerfd.h~timerfd-add-flags-check
+++ a/include/linux/timerfd.h
@@ -11,13 +11,24 @@
 /* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/fcntl.h>
 
-/* Flags for timerfd_settime.  */
+/*
+ * CAREFUL: Check include/asm-generic/fcntl.h when defining
+ * new flags, since they might collide with O_* ones. We want
+ * to re-use O_* flags that couldn't possibly have a meaning
+ * from eventfd, in order to leave a free define-space for
+ * shared O_* flags.
+ */
 #define TFD_TIMER_ABSTIME (1 << 0)
-
-/* Flags for timerfd_create.  */
 #define TFD_CLOEXEC O_CLOEXEC
 #define TFD_NONBLOCK O_NONBLOCK
 
+#define TFD_SHARED_FCNTL_FLAGS (TFD_CLOEXEC | TFD_NONBLOCK)
+/* Flags for timerfd_create.  */
+#define TFD_CREATE_FLAGS TFD_SHARED_FCNTL_FLAGS
+/* Flags for timerfd_settime.  */
+#define TFD_SETTIME_FLAGS TFD_TIMER_ABSTIME
+#define TFD_FLAGS_SET (TFD_SHARED_FCNTL_FLAGS | TFD_TIMER_ABSTIME)
+
 
 #endif /* _LINUX_TIMERFD_H */
 
_

Patches currently in -mm which might be from davidel@xmailserver.org are

linux-next.patch
timerfd-add-flags-check.patch
fasync-rename-struct-file-f_ep_lock.patch
epoll-fix-own-poll.patch
epoll-fix-epolls-own-poll-update.patch
epoll-remove-debugging-code.patch
eventfd-improve-support-for-semaphore-like-behavior.patch
epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key.patch
epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch
epoll-keyed-wakeups-v3-introduce-new-_poll-wakeup-macros.patch
epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-update.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-make-eventfd-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-make-tty-use-keyed-wakeups.patch


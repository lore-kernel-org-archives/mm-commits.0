From: akpm@linux-foundation.org
Subject: [-] signals-eventpoll-set-saved_sigmask-at-the-start.patch
 removed from -mm tree
Date: Fri, 13 Sep 2013 14:14:38 -0700
Message-ID: <5233803e.tWf1KZjypVfVOIEM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab3IMVOj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 17:14:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, normalperson@yhbt.net, jbaron@redhat.com, dvlasenk@redhat.com, oleg@redhat.com

Subject: [-] signals-eventpoll-set-saved_sigmask-at-the-start.patch removed from -mm tree
To: oleg@redhat.com,dvlasenk@redhat.com,jbaron@redhat.com,normalperson@yhbt.net,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 14:14:38 -0700


The patch titled
     Subject: signals: eventpoll: set ->saved_sigmask at the start
has been removed from the -mm tree.  Its filename was
     signals-eventpoll-set-saved_sigmask-at-the-start.patch

This patch was dropped because viro disliked it

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: signals: eventpoll: set ->saved_sigmask at the start

task_struct->saved_sigmask has no meaning unless we return with
set_restore_sigmask() and nobody except current can use it.

This means that sys_epoll_pwait() doesn't need to save ->blocked
into the local var and then memcopy it into ->saved_sigmask, we
can simply set ->saved_sigmask right before set_current_blocked().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Eric Wong <normalperson@yhbt.net>
Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff -puN fs/eventpoll.c~signals-eventpoll-set-saved_sigmask-at-the-start fs/eventpoll.c
--- a/fs/eventpoll.c~signals-eventpoll-set-saved_sigmask-at-the-start
+++ a/fs/eventpoll.c
@@ -1967,23 +1967,23 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 		size_t, sigsetsize)
 {
 	int error;
-	sigset_t ksigmask, sigsaved;
-
 	/*
 	 * If the caller wants a certain signal mask to be set during the wait,
 	 * we apply it here.
 	 */
 	if (sigmask) {
+		sigset_t ksigmask;
+
 		if (sigsetsize != sizeof(sigset_t))
 			return -EINVAL;
 		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
 			return -EFAULT;
-		sigsaved = current->blocked;
+
+		current->saved_sigmask = current->blocked;
 		set_current_blocked(&ksigmask);
 	}
 
 	error = sys_epoll_wait(epfd, events, maxevents, timeout);
-
 	/*
 	 * If we changed the signal mask, we need to restore the original one.
 	 * In case we've got a signal while waiting, we do not restore the
@@ -1991,12 +1991,10 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 	 * the way back to userspace, before the signal mask is restored.
 	 */
 	if (sigmask) {
-		if (error == -EINTR) {
-			memcpy(&current->saved_sigmask, &sigsaved,
-			       sizeof(sigsaved));
+		if (error == -EINTR)
 			set_restore_sigmask();
-		} else
-			set_current_blocked(&sigsaved);
+		else
+			__set_current_blocked(&current->saved_sigmask);
 	}
 
 	return error;
@@ -2010,25 +2008,25 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int,
 			compat_size_t, sigsetsize)
 {
 	long err;
-	compat_sigset_t csigmask;
-	sigset_t ksigmask, sigsaved;
-
 	/*
 	 * If the caller wants a certain signal mask to be set during the wait,
 	 * we apply it here.
 	 */
 	if (sigmask) {
+		compat_sigset_t csigmask;
+		sigset_t ksigmask;
+
 		if (sigsetsize != sizeof(compat_sigset_t))
 			return -EINVAL;
 		if (copy_from_user(&csigmask, sigmask, sizeof(csigmask)))
 			return -EFAULT;
 		sigset_from_compat(&ksigmask, &csigmask);
-		sigsaved = current->blocked;
+
+		current->saved_sigmask = current->blocked;
 		set_current_blocked(&ksigmask);
 	}
 
 	err = sys_epoll_wait(epfd, events, maxevents, timeout);
-
 	/*
 	 * If we changed the signal mask, we need to restore the original one.
 	 * In case we've got a signal while waiting, we do not restore the
@@ -2036,12 +2034,10 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int,
 	 * the way back to userspace, before the signal mask is restored.
 	 */
 	if (sigmask) {
-		if (err == -EINTR) {
-			memcpy(&current->saved_sigmask, &sigsaved,
-			       sizeof(sigsaved));
+		if (err == -EINTR)
 			set_restore_sigmask();
-		} else
-			set_current_blocked(&sigsaved);
+		else
+			__set_current_blocked(&current->saved_sigmask);
 	}
 
 	return err;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
anon_inodefs-forbid-open-via-proc.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch


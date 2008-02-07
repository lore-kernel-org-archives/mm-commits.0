From: akpm@linux-foundation.org
Subject: - fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:22:32 -0800
Message-ID: <200802070022.m170MDL6006407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57608 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935072AbYBGAow (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olsajiri@gmail.com, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     fs: remove dead config CONFIG_HAS_COMPAT_EPOLL_EVENT symbol
has been removed from the -mm tree.  Its filename was
     fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: remove dead config CONFIG_HAS_COMPAT_EPOLL_EVENT symbol
From: Jiri Olsa <olsajiri@gmail.com>

Remove dead config CONFIG_HAS_COMPAT_EPOLL_EVENT symbol.

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c            |   49 ---------------------------------------
 include/linux/compat.h |    8 ------
 2 files changed, 57 deletions(-)

diff -puN fs/compat.c~fs-remove-dead-config-config_has_compat_epoll_event-symbol fs/compat.c
--- a/fs/compat.c~fs-remove-dead-config-config_has_compat_epoll_event-symbol
+++ a/fs/compat.c
@@ -2083,51 +2083,6 @@ long asmlinkage compat_sys_nfsservctl(in
 
 #ifdef CONFIG_EPOLL
 
-#ifdef CONFIG_HAS_COMPAT_EPOLL_EVENT
-asmlinkage long compat_sys_epoll_ctl(int epfd, int op, int fd,
-			struct compat_epoll_event __user *event)
-{
-	long err = 0;
-	struct compat_epoll_event user;
-	struct epoll_event __user *kernel = NULL;
-
-	if (event) {
-		if (copy_from_user(&user, event, sizeof(user)))
-			return -EFAULT;
-		kernel = compat_alloc_user_space(sizeof(struct epoll_event));
-		err |= __put_user(user.events, &kernel->events);
-		err |= __put_user(user.data, &kernel->data);
-	}
-
-	return err ? err : sys_epoll_ctl(epfd, op, fd, kernel);
-}
-
-
-asmlinkage long compat_sys_epoll_wait(int epfd,
-			struct compat_epoll_event __user *events,
-			int maxevents, int timeout)
-{
-	long i, ret, err = 0;
-	struct epoll_event __user *kbuf;
-	struct epoll_event ev;
-
-	if ((maxevents <= 0) ||
-			(maxevents > (INT_MAX / sizeof(struct epoll_event))))
-		return -EINVAL;
-	kbuf = compat_alloc_user_space(sizeof(struct epoll_event) * maxevents);
-	ret = sys_epoll_wait(epfd, kbuf, maxevents, timeout);
-	for (i = 0; i < ret; i++) {
-		err |= __get_user(ev.events, &kbuf[i].events);
-		err |= __get_user(ev.data, &kbuf[i].data);
-		err |= __put_user(ev.events, &events->events);
-		err |= __put_user_unaligned(ev.data, &events->data);
-		events++;
-	}
-
-	return err ? -EFAULT: ret;
-}
-#endif	/* CONFIG_HAS_COMPAT_EPOLL_EVENT */
-
 #ifdef TIF_RESTORE_SIGMASK
 asmlinkage long compat_sys_epoll_pwait(int epfd,
 			struct compat_epoll_event __user *events,
@@ -2153,11 +2108,7 @@ asmlinkage long compat_sys_epoll_pwait(i
 		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
 	}
 
-#ifdef CONFIG_HAS_COMPAT_EPOLL_EVENT
-	err = compat_sys_epoll_wait(epfd, events, maxevents, timeout);
-#else
 	err = sys_epoll_wait(epfd, events, maxevents, timeout);
-#endif
 
 	/*
 	 * If we changed the signal mask, we need to restore the original one.
diff -puN include/linux/compat.h~fs-remove-dead-config-config_has_compat_epoll_event-symbol include/linux/compat.h
--- a/include/linux/compat.h~fs-remove-dead-config-config_has_compat_epoll_event-symbol
+++ a/include/linux/compat.h
@@ -257,16 +257,8 @@ asmlinkage long compat_sys_ptrace(compat
 /*
  * epoll (fs/eventpoll.c) compat bits follow ...
  */
-#ifndef CONFIG_HAS_COMPAT_EPOLL_EVENT
 struct epoll_event;
 #define compat_epoll_event	epoll_event
-#else
-asmlinkage long compat_sys_epoll_ctl(int epfd, int op, int fd,
-			struct compat_epoll_event __user *event);
-asmlinkage long compat_sys_epoll_wait(int epfd,
-			struct compat_epoll_event __user *events,
-			int maxevents, int timeout);
-#endif
 asmlinkage long compat_sys_epoll_pwait(int epfd,
 			struct compat_epoll_event __user *events,
 			int maxevents, int timeout,
_

Patches currently in -mm which might be from olsajiri@gmail.com are

origin.patch

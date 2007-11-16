From: akpm@linux-foundation.org
Subject: + fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch added to -mm tree
Date: Thu, 15 Nov 2007 19:08:14 -0800
Message-ID: <200711160308.lAG38EqP029402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55317 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbXKPDIT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 22:08:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olsajiri@gmail.com, davidel@xmailserver.org


The patch titled
     fs: remove dead config CONFIG_HAS_COMPAT_EPOLL_EVENT symbol
has been added to the -mm tree.  Its filename is
     fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2087,51 +2087,6 @@ long asmlinkage compat_sys_nfsservctl(in
 
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
@@ -2157,11 +2112,7 @@ asmlinkage long compat_sys_epoll_pwait(i
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
@@ -246,16 +246,8 @@ asmlinkage long compat_sys_migrate_pages
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
git-alsa.patch
arm-remove-dead-config-symbols-from-arm-code.patch
m32r-remove-dead-config-symbols-from-m32r-code.patch
mips-remove-dead-config-symbols-from-mips-code.patch
drivers-serial-s3c2410c-remove-dead-config-symbols.patch
frv-remove-dead-config-symbol-from-frv-code.patch
m68knomu-remove-dead-config-symbols-from-m68knomu-code.patch
fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch

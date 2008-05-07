From: akpm@linux-foundation.org
Subject: + flag-parameters-check-magic-constants.patch added to -mm tree
Date: Wed, 07 May 2008 15:06:15 -0700
Message-ID: <200805072206.m47M6FDj018893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762130AbYEGWGg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 18:06:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@redhat.com, davidel@xmailserver.org, mtk.manpages@googlemail.com


The patch titled
     flag parameters: check magic constants
has been added to the -mm tree.  Its filename is
     flag-parameters-check-magic-constants.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flag parameters: check magic constants
From: Ulrich Drepper <drepper@redhat.com>

This patch adds test that ensure the boundary conditions for the various
constants introduced in the previous patches is met.  No code is generated.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventfd.c      |    4 ++++
 fs/eventpoll.c    |    3 +++
 fs/inotify_user.c |    4 ++++
 fs/signalfd.c     |    4 ++++
 fs/timerfd.c      |    4 ++++
 net/socket.c      |    7 +++++++
 6 files changed, 26 insertions(+)

diff -puN fs/eventfd.c~flag-parameters-check-magic-constants fs/eventfd.c
--- a/fs/eventfd.c~flag-parameters-check-magic-constants
+++ a/fs/eventfd.c
@@ -203,6 +203,10 @@ asmlinkage long sys_eventfd2(unsigned in
 	int fd;
 	struct eventfd_ctx *ctx;
 
+	/* Check the EFD_* constants for consistency.  */
+	BUILD_BUG_ON(EFD_CLOEXEC != O_CLOEXEC);
+	BUILD_BUG_ON(EFD_NONBLOCK != O_NONBLOCK);
+
 	if (flags & ~(EFD_CLOEXEC | EFD_NONBLOCK))
 		return -EINVAL;
 
diff -puN fs/eventpoll.c~flag-parameters-check-magic-constants fs/eventpoll.c
--- a/fs/eventpoll.c~flag-parameters-check-magic-constants
+++ a/fs/eventpoll.c
@@ -1051,6 +1051,9 @@ asmlinkage long sys_epoll_create2(int si
 	int error, fd = -1;
 	struct eventpoll *ep;
 
+	/* Check the EPOLL_* constant for consistency.  */
+	BUILD_BUG_ON(EPOLL_CLOEXEC != O_CLOEXEC);
+
 	if (flags & ~EPOLL_CLOEXEC)
 		return -EINVAL;
 
diff -puN fs/inotify_user.c~flag-parameters-check-magic-constants fs/inotify_user.c
--- a/fs/inotify_user.c~flag-parameters-check-magic-constants
+++ a/fs/inotify_user.c
@@ -574,6 +574,10 @@ asmlinkage long sys_inotify_init1(int fl
 	struct file *filp;
 	int fd, ret;
 
+	/* Check the IN_* constants for consistency.  */
+	BUILD_BUG_ON(IN_CLOEXEC != O_CLOEXEC);
+	BUILD_BUG_ON(IN_NONBLOCK != O_NONBLOCK);
+
 	if (flags & ~(IN_CLOEXEC | IN_NONBLOCK))
 		return -EINVAL;
 
diff -puN fs/signalfd.c~flag-parameters-check-magic-constants fs/signalfd.c
--- a/fs/signalfd.c~flag-parameters-check-magic-constants
+++ a/fs/signalfd.c
@@ -211,6 +211,10 @@ asmlinkage long sys_signalfd4(int ufd, s
 	sigset_t sigmask;
 	struct signalfd_ctx *ctx;
 
+	/* Check the SFD_* constants for consistency.  */
+	BUILD_BUG_ON(SFD_CLOEXEC != O_CLOEXEC);
+	BUILD_BUG_ON(SFD_NONBLOCK != O_NONBLOCK);
+
 	if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK))
 		return -EINVAL;
 
diff -puN fs/timerfd.c~flag-parameters-check-magic-constants fs/timerfd.c
--- a/fs/timerfd.c~flag-parameters-check-magic-constants
+++ a/fs/timerfd.c
@@ -184,6 +184,10 @@ asmlinkage long sys_timerfd_create(int c
 	int ufd;
 	struct timerfd_ctx *ctx;
 
+	/* Check the TFD_* constants for consistency.  */
+	BUILD_BUG_ON(TFD_CLOEXEC != O_CLOEXEC);
+	BUILD_BUG_ON(TFD_NONBLOCK != O_NONBLOCK);
+
 	if (flags & ~(TFD_CLOEXEC | TFD_NONBLOCK))
 		return -EINVAL;
 	if (clockid != CLOCK_MONOTONIC &&
diff -puN net/socket.c~flag-parameters-check-magic-constants net/socket.c
--- a/net/socket.c~flag-parameters-check-magic-constants
+++ a/net/socket.c
@@ -1231,6 +1231,13 @@ asmlinkage long sys_socket(int family, i
 	struct socket *sock;
 	int flags;
 
+	/* Check the SOCK_* constants for consistency.  */
+	BUILD_BUG_ON(SOCK_CLOEXEC != O_CLOEXEC);
+	BUILD_BUG_ON(SOCK_NONBLOCK != O_NONBLOCK);
+	BUILD_BUG_ON((SOCK_MAX | SOCK_TYPE_MASK) != SOCK_TYPE_MASK);
+	BUILD_BUG_ON(SOCK_CLOEXEC & SOCK_TYPE_MASK);
+	BUILD_BUG_ON(SOCK_NONBLOCK & SOCK_TYPE_MASK);
+
 	flags = type & ~SOCK_TYPE_MASK;
 	if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
 		return -EINVAL;
_

Patches currently in -mm which might be from drepper@redhat.com are

origin.patch
sys_pipe-fix-file-descriptor-leaks.patch
execve-filename-document-and-export-via-auxiliary-vector.patch
flag-parameters-socket-and-socketpair.patch
flag-parameters-paccept.patch
flag-parameters-anon_inode_getfd-extension.patch
flag-parameters-signalfd.patch
flag-parameters-eventfd.patch
flag-parameters-timerfd_create.patch
flag-parameters-epoll_create.patch
flag-parameters-dup2.patch
flag-parameters-pipe.patch
flag-parameters-inotify_init.patch
flag-parametersi-nonblock-in-anon_inode_getfd.patch
flag-parameters-nonblock-in-socket-and-socketpair.patch
flag-parameters-nonblock-in-signalfd.patch
flag-parameters-nonblock-in-eventfd.patch
flag-parameters-nonblock-in-timerfd_create.patch
flag-parameters-nonblock-in-pipe.patch
flag-parameters-nonblock-in-inotify_init.patch
flag-parameters-check-magic-constants.patch
flag-parameters-add-on-remove-epoll_create-size-param.patch


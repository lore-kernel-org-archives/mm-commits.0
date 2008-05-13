From: akpm@linux-foundation.org
Subject: + flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock.patch added to -mm tree
Date: Mon, 12 May 2008 21:49:27 -0700
Message-ID: <200805130449.m4D4nRjI025508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754535AbYEMEuW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 00:50:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@redhat.com, davidel@xmailserver.org, mtk.manpages@googlemail.com, roland@redhat.com


The patch titled
     flag parameters: arch-specific SOCK_NONBLOCK
has been added to the -mm tree.  Its filename is
     flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock.patch

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
Subject: flag parameters: arch-specific SOCK_NONBLOCK
From: Ulrich Drepper <drepper@redhat.com>

The value of O_NONBLOCK clashes on Alpha dn PARISC with the bits used for
socket types.  Therefore we cannot define SOCK_NONBLOCK as O_NONBLOCK on
these platforms.  This patch adds support for an arch-specific
SOCK_NONBLOCK value which doesn't add costs for other architectures.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/socket.h  |    5 +++++
 include/asm-parisc/socket.h |    5 +++++
 net/socket.c                |    9 +++++++++
 3 files changed, 19 insertions(+)

diff -puN include/asm-alpha/socket.h~flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock include/asm-alpha/socket.h
--- a/include/asm-alpha/socket.h~flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock
+++ a/include/asm-alpha/socket.h
@@ -62,4 +62,9 @@
 
 #define SO_MARK			36
 
+/* O_NONBLOCK clashes with the bits used for socket types.  Therefore we
+ * have to define SOCK_NONBLOCK to a different value here.
+ */
+#define SOCK_NONBLOCK	0x40000000
+
 #endif /* _ASM_SOCKET_H */
diff -puN include/asm-parisc/socket.h~flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock include/asm-parisc/socket.h
--- a/include/asm-parisc/socket.h~flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock
+++ a/include/asm-parisc/socket.h
@@ -54,4 +54,9 @@
 
 #define SO_MARK			0x401f
 
+/* O_NONBLOCK clashes with the bits used for socket types.  Therefore we
+ * have to define SOCK_NONBLOCK to a different value here.
+ */
+#define SOCK_NONBLOCK   0x40000000
+
 #endif /* _ASM_SOCKET_H */
diff -puN include/linux/net.h~flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock include/linux/net.h
diff -puN net/socket.c~flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock net/socket.c
--- a/net/socket.c~flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock
+++ a/net/socket.c
@@ -1225,6 +1225,9 @@ asmlinkage long sys_socket(int family, i
 		return -EINVAL;
 	type &= SOCK_TYPE_MASK;
 
+	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
+		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
+
 	retval = sock_create(family, type, protocol, &sock);
 	if (retval < 0)
 		goto out;
@@ -1259,6 +1262,9 @@ asmlinkage long sys_socketpair(int famil
 		return -EINVAL;
 	type &= SOCK_TYPE_MASK;
 
+	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
+		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
+
 	/*
 	 * Obtain the first socket and check if the underlying protocol
 	 * supports the socketpair call.
@@ -1424,6 +1430,9 @@ long do_accept(int fd, struct sockaddr _
 	if (flags & ~SOCK_CLOEXEC)
 		return -EINVAL;
 
+	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
+		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
+
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
_

Patches currently in -mm which might be from drepper@redhat.com are

execve-filename-document-and-export-via-auxiliary-vector.patch
flag-parameters-socket-and-socketpair.patch
flag-parameters-paccept.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock.patch
flag-parameters-anon_inode_getfd-extension.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd.patch
flag-parameters-eventfd.patch
flag-parameters-timerfd_create.patch
flag-parameters-epoll_create.patch
flag-parameters-dup2.patch
flag-parameters-pipe.patch
flag-parameters-inotify_init.patch
flag-parameters-inotify_init-fix.patch
flag-parametersi-nonblock-in-anon_inode_getfd.patch
flag-parameters-nonblock-in-socket-and-socketpair.patch
flag-parameters-nonblock-in-signalfd.patch
flag-parameters-nonblock-in-eventfd.patch
flag-parameters-nonblock-in-timerfd_create.patch
flag-parameters-nonblock-in-pipe.patch
flag-parameters-nonblock-in-inotify_init.patch
flag-parameters-check-magic-constants.patch
flag-parameters-check-magic-constants-alpha-hack.patch
flag-parameters-add-on-remove-epoll_create-size-param.patch


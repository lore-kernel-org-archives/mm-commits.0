From: akpm@linux-foundation.org
Subject: + flag-parameters-paccept-flag-parameters-paccept-w-out-set_restore_sigmask.patch added to -mm tree
Date: Mon, 12 May 2008 22:30:45 -0700
Message-ID: <200805130530.m4D5UjNU026840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754596AbYEMFbw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 01:31:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@redhat.com, davidel@xmailserver.org, mtk.manpages@googlemail.com


The patch titled
     flag parameters: paccept w/out set_restore_sigmask
has been added to the -mm tree.  Its filename is
     flag-parameters-paccept-flag-parameters-paccept-w-out-set_restore_sigmask.patch

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
Subject: flag parameters: paccept w/out set_restore_sigmask
From: Ulrich Drepper <drepper@redhat.com>

Some platforms do not have support to restore the signal mask in the
return path from a syscall.  For those platforms syscalls like pselect are
not defined at all.  This is, I think, not a good choice for paccept()
since paccept() adds more value on top of accept() than just the signal
mask handling.

Therefore this patch defines a scaled down version of the sys_paccept
function for those platforms.  It returns -EINVAL in case the signal mask
is non-NULL but behaves the same otherwise.

Note that I explicitly included <linux/thread_info.h>.  I saw that it is
currently included but indirectly two levels down.  There is too much risk
in relying on this.  The header might change and then suddenly the
function definition would change without anyone immediately noticing.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/net.h |    3 +++
 net/socket.c        |   17 +++++++++++++++++
 2 files changed, 20 insertions(+)

diff -puN net/socket.c~flag-parameters-paccept-flag-parameters-paccept-w-out-set_restore_sigmask net/socket.c
--- a/net/socket.c~flag-parameters-paccept-flag-parameters-paccept-w-out-set_restore_sigmask
+++ a/net/socket.c
@@ -69,6 +69,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/mutex.h>
+#include <linux/thread_info.h>
 #include <linux/wanrouter.h>
 #include <linux/if_bridge.h>
 #include <linux/if_frad.h>
@@ -1503,6 +1504,7 @@ out_fd:
 	goto out_put;
 }
 
+#ifdef HAVE_SET_RESTORE_SIGMASK
 asmlinkage long sys_paccept(int fd, struct sockaddr __user *upeer_sockaddr,
 			    int __user *upeer_addrlen,
 			    const sigset_t __user *sigmask,
@@ -1540,6 +1542,21 @@ asmlinkage long sys_paccept(int fd, stru
 
 	return ret;
 }
+#else
+asmlinkage long sys_paccept(int fd, struct sockaddr __user *upeer_sockaddr,
+			    int __user *upeer_addrlen,
+			    const sigset_t __user *sigmask,
+			    size_t sigsetsize, int flags)
+{
+	/* The platform does not support restoring the signal mask in the
+	 * return path.  So we do not allow using paccept() with a signal
+	 * mask.  */
+	if (sigmask)
+		return -EINVAL;
+
+	return do_accept(fd, upeer_sockaddr, upeer_addrlen, flags);
+}
+#endif
 
 asmlinkage long sys_accept(int fd, struct sockaddr __user *upeer_sockaddr,
 			   int __user *upeer_addrlen)
diff -puN include/linux/net.h~flag-parameters-paccept-flag-parameters-paccept-w-out-set_restore_sigmask include/linux/net.h
--- a/include/linux/net.h~flag-parameters-paccept-flag-parameters-paccept-w-out-set_restore_sigmask
+++ a/include/linux/net.h
@@ -102,6 +102,9 @@ enum sock_type {
 
 /* Flags for socket, socketpair, paccept */
 #define SOCK_CLOEXEC	O_CLOEXEC
+#ifndef SOCK_NONBLOCK
+#define SOCK_NONBLOCK	O_NONBLOCK
+#endif
 
 #endif /* ARCH_HAS_SOCKET_TYPES */
 
_

Patches currently in -mm which might be from drepper@redhat.com are

execve-filename-document-and-export-via-auxiliary-vector.patch
flag-parameters-socket-and-socketpair.patch
flag-parameters-paccept.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock.patch
flag-parameters-paccept-flag-parameters-paccept-w-out-set_restore_sigmask.patch
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


From: akpm@linux-foundation.org
Subject: - flag-parameters-paccept-flag-parameters-paccept-w-out-set_restore_sigmask.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:27:13 -0700
Message-ID: <200807242327.m6ONRDdT011146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756678AbYGXX3G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@redhat.com, davidel@xmailserver.org, mtk.manpages@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     flag parameters: paccept w/out set_restore_sigmask
has been removed from the -mm tree.  Its filename was
     flag-parameters-paccept-flag-parameters-paccept-w-out-set_restore_sigmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1504,6 +1505,7 @@ out_fd:
 	goto out_put;
 }
 
+#ifdef HAVE_SET_RESTORE_SIGMASK
 asmlinkage long sys_paccept(int fd, struct sockaddr __user *upeer_sockaddr,
 			    int __user *upeer_addrlen,
 			    const sigset_t __user *sigmask,
@@ -1541,6 +1543,21 @@ asmlinkage long sys_paccept(int fd, stru
 
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
_

Patches currently in -mm which might be from drepper@redhat.com are

origin.patch
linux-next.patch


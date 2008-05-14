From: akpm@linux-foundation.org
Subject: + flag-parameters-socket-and-socketpair-mips-fix.patch added to -mm tree
Date: Tue, 13 May 2008 22:47:32 -0700
Message-ID: <200805140547.m4E5lWgn018851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752558AbYENFsG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 01:48:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@redhat.com, davem@davemloft.net, davidel@xmailserver.org, mtk.manpages@googlemail.com, ralf@linux-mips.org


The patch titled
     flag parameters: MIPS socket flags
has been added to the -mm tree.  Its filename is
     flag-parameters-socket-and-socketpair-mips-fix.patch

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
Subject: flag parameters: MIPS socket flags
From: Ulrich Drepper <drepper@redhat.com>

MIPS defines its own socket types.  So we have to define the new socket
flags and the type mask for MIPS as well.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/socket.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/asm-mips/socket.h~flag-parameters-socket-and-socketpair-mips-fix include/asm-mips/socket.h
--- a/include/asm-mips/socket.h~flag-parameters-socket-and-socketpair-mips-fix
+++ a/include/asm-mips/socket.h
@@ -102,6 +102,13 @@ enum sock_type {
 };
 
 #define SOCK_MAX (SOCK_PACKET + 1)
+/* Mask which covers at least up to SOCK_MASK-1.  The
+ *  * remaining bits are used as flags. */
+#define SOCK_TYPE_MASK 0xf
+
+/* Flags for socket, socketpair, paccept */
+#define SOCK_CLOEXEC	O_CLOEXEC
+#define SOCK_NONBLOCK	O_NONBLOCK
 
 #define ARCH_HAS_SOCKET_TYPES 1
 
_

Patches currently in -mm which might be from drepper@redhat.com are

execve-filename-document-and-export-via-auxiliary-vector.patch
flag-parameters-socket-and-socketpair.patch
flag-parameters-socket-and-socketpair-mips-fix.patch
flag-parameters-paccept.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock.patch
flag-parameters-paccept-flag-parameters-paccept-w-out-set_restore_sigmask.patch
flag-parameters-paccept-sys_ni.patch
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


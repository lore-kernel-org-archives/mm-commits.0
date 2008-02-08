From: akpm@linux-foundation.org
Subject: - tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls-x86-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:01:53 -0800
Message-ID: <200802080801.m1881Y2h013974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52441 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754864AbYBHICY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:02:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, alan@redhat.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     tty: fix tty network driver interactions with TCGET/TCSET calls (x86 fix)
has been removed from the -mm tree.  Its filename was
     tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls-x86-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty: fix tty network driver interactions with TCGET/TCSET calls (x86 fix)
From: Dave Miller <davem@davemloft.net>

And to go with it Dave's type checking x86 termios headers.  I've updated
these as the original sent by Dave had some wrong types in it.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/termios.h |   68 ++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 26 deletions(-)

diff -puN include/asm-x86/termios.h~tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls-x86-fix include/asm-x86/termios.h
--- a/include/asm-x86/termios.h~tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls-x86-fix
+++ a/include/asm-x86/termios.h
@@ -41,6 +41,8 @@ struct termio {
 
 #ifdef __KERNEL__
 
+#include <asm/uaccess.h>
+
 /*	intr=^C		quit=^\		erase=del	kill=^U
 	eof=^D		vtime=\0	vmin=\1		sxtc=\0
 	start=^Q	stop=^S		susp=^Z		eol=\0
@@ -58,39 +60,53 @@ struct termio {
 	*(unsigned short *) &(termios)->x = __tmp; \
 }
 
-#define user_termio_to_kernel_termios(termios, termio) \
-({ \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_iflag); \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_oflag); \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_cflag); \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_lflag); \
-	copy_from_user((termios)->c_cc, (termio)->c_cc, NCC); \
-})
+static inline int user_termio_to_kernel_termios(struct ktermios *termios,
+						struct termio __user *termio)
+{
+	SET_LOW_TERMIOS_BITS(termios, termio, c_iflag);
+	SET_LOW_TERMIOS_BITS(termios, termio, c_oflag);
+	SET_LOW_TERMIOS_BITS(termios, termio, c_cflag);
+	SET_LOW_TERMIOS_BITS(termios, termio, c_lflag);
+	return copy_from_user(termios->c_cc, termio->c_cc, NCC);
+}
 
 /*
  * Translate a "termios" structure into a "termio". Ugh.
  */
-#define kernel_termios_to_user_termio(termio, termios) \
-({ \
-	put_user((termios)->c_iflag, &(termio)->c_iflag); \
-	put_user((termios)->c_oflag, &(termio)->c_oflag); \
-	put_user((termios)->c_cflag, &(termio)->c_cflag); \
-	put_user((termios)->c_lflag, &(termio)->c_lflag); \
-	put_user((termios)->c_line,  &(termio)->c_line); \
-	copy_to_user((termio)->c_cc, (termios)->c_cc, NCC); \
-})
-
-#define user_termios_to_kernel_termios(k, u) \
-	copy_from_user(k, u, sizeof(struct termios2))
+static inline int kernel_termios_to_user_termio(struct termio __user *termio,
+					    struct ktermios *termios)
+{
+	put_user((termios)->c_iflag, &(termio)->c_iflag);
+	put_user((termios)->c_oflag, &(termio)->c_oflag);
+	put_user((termios)->c_cflag, &(termio)->c_cflag);
+	put_user((termios)->c_lflag, &(termio)->c_lflag);
+	put_user((termios)->c_line,  &(termio)->c_line);
+	return copy_to_user((termio)->c_cc, (termios)->c_cc, NCC);
+}
+
+static inline int user_termios_to_kernel_termios(struct ktermios *k,
+						 struct termios2 __user *u)
+{
+	return copy_from_user(k, u, sizeof(struct termios2));
+}
 
-#define kernel_termios_to_user_termios(u, k) \
-	copy_to_user(u, k, sizeof(struct termios2))
+static inline int kernel_termios_to_user_termios(struct termios2 __user *u,
+						 struct ktermios *k)
+{
+	return copy_to_user(u, k, sizeof(struct termios2));
+}
 
-#define user_termios_to_kernel_termios_1(k, u) \
-	copy_from_user(k, u, sizeof(struct termios))
+static inline int user_termios_to_kernel_termios_1(struct ktermios *k,
+						   struct termios __user *u)
+{
+	return copy_from_user(k, u, sizeof(struct termios));
+}
 
-#define kernel_termios_to_user_termios_1(u, k) \
-	copy_to_user(u, k, sizeof(struct termios))
+static inline int kernel_termios_to_user_termios_1(struct termios __user *u,
+						   struct ktermios *k)
+{
+	return copy_to_user(u, k, sizeof(struct termios));
+}
 
 #endif	/* __KERNEL__ */
 
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
smack-unlabeled-outgoing-ambient-packets.patch
git-net.patch
mark-net_ns-with-depends-on-namespaces.patch
pid-fix-solaris_procids.patch

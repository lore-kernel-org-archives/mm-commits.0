From: akpm@linux-foundation.org
Subject: - tty-let-architectures-override-the-user-kernel-macros.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:12:20 -0800
Message-ID: <200802082012.m18KC10X010167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41323 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758715AbYBHVEC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:04:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, hskinnemoen@atmel.com, paulus@samba.org, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     tty: let architectures override the user/kernel macros.
has been removed from the -mm tree.  Its filename was
     tty-let-architectures-override-the-user-kernel-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty: let architectures override the user/kernel macros.
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Give architectures that support the new termios2 the possibilty to overide the
user_termios_to_kernel_termios and kernel_termios_to_user_termios macros.  As
soon as all architectures that use the generic variant have been converted the
ifdefs can go away again.  Architectures in question are avr32, frv, powerpc
and s390.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paul Mackerras <paulus@samba.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/termios.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/asm-generic/termios.h~tty-let-architectures-override-the-user-kernel-macros include/asm-generic/termios.h
--- a/include/asm-generic/termios.h~tty-let-architectures-override-the-user-kernel-macros
+++ a/include/asm-generic/termios.h
@@ -61,8 +61,14 @@ static inline int kernel_termios_to_user
 	return 0;
 }
 
+#ifndef user_termios_to_kernel_termios
 #define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios))
+#endif
+
+#ifndef kernel_termios_to_user_termios
 #define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios))
+#endif
+
 #define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
 #define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
 
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
git-sched.patch
